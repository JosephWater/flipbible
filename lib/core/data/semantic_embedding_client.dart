import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/reader_settings.dart';
import 'semantic_search_defaults.dart';

enum SemanticSearchErrorType {
  missingConfiguration,
  unsupportedTranslation,
  unauthorized,
  rateLimited,
  requestRejected,
  network,
  timeout,
  invalidResponse,
}

class SemanticSearchException implements Exception {
  const SemanticSearchException(
    this.type, {
    this.message,
  });

  final SemanticSearchErrorType type;
  final String? message;

  @override
  String toString() => message ?? type.name;
}

class EmbeddingApiConfig {
  const EmbeddingApiConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.model,
  });

  final String baseUrl;
  final String apiKey;
  final String model;

  factory EmbeddingApiConfig.fromSettings(ReaderSettings settings) {
    final baseUrl = settings.embeddingBaseUrl.trim().isEmpty
        ? defaultEmbeddingBaseUrl.trim()
        : settings.embeddingBaseUrl.trim();
    final customApiKey = settings.embeddingApiKey.trim();
    final apiKey = hasManualEmbeddingApiKey(customApiKey)
        ? customApiKey
        : settings.defaultEmbeddingAccessUnlocked
            ? defaultEmbeddingApiKey.trim()
            : '';
    final model = settings.embeddingModel.trim().isEmpty
        ? defaultEmbeddingModel.trim()
        : settings.embeddingModel.trim();

    return EmbeddingApiConfig(
      baseUrl: baseUrl,
      apiKey: apiKey,
      model: model,
    );
  }
}

abstract class SemanticEmbeddingClient {
  Future<List<double>> createEmbedding({
    required EmbeddingApiConfig config,
    required String input,
  });
}

class OpenAiCompatibleEmbeddingClient implements SemanticEmbeddingClient {
  OpenAiCompatibleEmbeddingClient({
    HttpClient? httpClient,
    Duration? timeout,
  })  : _httpClient = httpClient ?? HttpClient(),
        _timeout = timeout ?? const Duration(seconds: 20);

  final HttpClient _httpClient;
  final Duration _timeout;

  @override
  Future<List<double>> createEmbedding({
    required EmbeddingApiConfig config,
    required String input,
  }) async {
    if (config.baseUrl.isEmpty || config.model.isEmpty || config.apiKey.isEmpty) {
      throw const SemanticSearchException(
        SemanticSearchErrorType.missingConfiguration,
        message: 'Semantic search is not configured.',
      );
    }

    final baseUri = Uri.tryParse(config.baseUrl);
    if (baseUri == null || !(baseUri.isScheme('http') || baseUri.isScheme('https'))) {
      throw const SemanticSearchException(
        SemanticSearchErrorType.missingConfiguration,
        message: 'Embedding base URL is invalid.',
      );
    }

    final endpoint = _buildEmbeddingUri(baseUri);

    try {
      final request = await _httpClient
          .postUrl(endpoint)
          .timeout(_timeout);
      request.headers.set(HttpHeaders.acceptHeader, ContentType.json.mimeType);
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer ${config.apiKey}');
      request.add(
        utf8.encode(
          jsonEncode({
            'model': config.model,
            'input': input,
          }),
        ),
      );

      final response = await request.close().timeout(_timeout);
      final payload = await utf8.decodeStream(response).timeout(_timeout);
      final apiMessage = _extractApiMessage(payload);

      if (response.statusCode == HttpStatus.unauthorized ||
          response.statusCode == HttpStatus.forbidden) {
        throw SemanticSearchException(
          SemanticSearchErrorType.unauthorized,
          message: apiMessage ?? 'Embedding API rejected the API key.',
        );
      }

      if (response.statusCode == HttpStatus.tooManyRequests) {
        throw SemanticSearchException(
          SemanticSearchErrorType.rateLimited,
          message: apiMessage ?? 'Embedding API rate limit reached.',
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw SemanticSearchException(
          response.statusCode >= 500
              ? SemanticSearchErrorType.network
              : SemanticSearchErrorType.requestRejected,
          message: apiMessage ??
              'Embedding API request failed with status ${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        throw const SemanticSearchException(
          SemanticSearchErrorType.invalidResponse,
          message: 'Embedding API returned invalid JSON.',
        );
      }

      final embedding = _readEmbedding(decoded);
      if (embedding == null || embedding.isEmpty) {
        throw const SemanticSearchException(
          SemanticSearchErrorType.invalidResponse,
          message: 'Embedding API response has no embedding data.',
        );
      }

      return embedding
          .map<double>((value) => (value as num).toDouble())
          .toList(growable: false);
    } on TimeoutException {
      throw const SemanticSearchException(
        SemanticSearchErrorType.timeout,
        message: 'Embedding API request timed out.',
      );
    } on SocketException {
      throw const SemanticSearchException(
        SemanticSearchErrorType.network,
        message: 'Unable to reach the embedding API.',
      );
    } on HandshakeException {
      throw const SemanticSearchException(
        SemanticSearchErrorType.network,
        message: 'Secure connection to the embedding API failed.',
      );
    } on FormatException {
      throw const SemanticSearchException(
        SemanticSearchErrorType.invalidResponse,
        message: 'Embedding API response could not be parsed.',
      );
    }
  }

  Uri _buildEmbeddingUri(Uri baseUri) {
    final rawPath = baseUri.path.trim();
    final normalizedPath = rawPath.endsWith('/')
        ? rawPath.substring(0, rawPath.length - 1)
        : rawPath;
    final path = normalizedPath.endsWith('/embeddings')
        ? normalizedPath
        : '$normalizedPath/embeddings';
    return baseUri.replace(path: path);
  }

  String? _extractApiMessage(String payload) {
    if (payload.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return _extractMessageFromMap(decoded);
    } on FormatException {
      return null;
    }
  }

  List<dynamic>? _readEmbedding(Map<String, dynamic> decoded) {
    final directData = decoded['data'];
    final directEmbedding = _firstEmbeddingFromNode(directData);
    if (directEmbedding != null) {
      return directEmbedding;
    }

    final output = decoded['output'];
    if (output is Map<String, dynamic>) {
      final outputEmbeddings = output['embeddings'];
      final nestedEmbedding = _firstEmbeddingFromNode(outputEmbeddings);
      if (nestedEmbedding != null) {
        return nestedEmbedding;
      }
    }

    return null;
  }

  List<dynamic>? _firstEmbeddingFromNode(Object? node) {
    if (node is! List || node.isEmpty) {
      return null;
    }

    final first = node.first;
    if (first is! Map<String, dynamic>) {
      return null;
    }

    final embedding = first['embedding'];
    return embedding is List ? embedding : null;
  }

  String? _extractMessageFromMap(Map<String, dynamic> map) {
    final directMessage = _firstNonEmptyString([
      map['message'],
      map['msg'],
      map['error_msg'],
      map['errorMessage'],
    ]);
    if (directMessage != null) {
      return directMessage;
    }

    final error = map['error'];
    if (error is Map<String, dynamic>) {
      final nestedMessage = _firstNonEmptyString([
        error['message'],
        error['msg'],
        error['error_msg'],
        error['errorMessage'],
        error['type'],
        error['code'],
      ]);
      if (nestedMessage != null) {
        return nestedMessage;
      }
    }

    return null;
  }

  String? _firstNonEmptyString(List<Object?> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }
}
