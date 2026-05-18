import 'dart:convert';
import 'dart:io';

import 'package:flip_bible/core/data/semantic_embedding_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OpenAiCompatibleEmbeddingClient', () {
    test('accepts a full embeddings endpoint without duplicating the path', () async {
      late HttpServer server;
      String? receivedPath;

      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        receivedPath = request.uri.path;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'data': [
              {
                'embedding': [0.1, 0.2, 0.3],
              },
            ],
          }),
        );
        await request.response.close();
      });

      final client = OpenAiCompatibleEmbeddingClient(
        timeout: const Duration(seconds: 5),
      );

      addTearDown(() async {
        await server.close(force: true);
      });

      final result = await client.createEmbedding(
        config: EmbeddingApiConfig(
          baseUrl: 'http://127.0.0.1:${server.port}/compatible-mode/v1/embeddings',
          apiKey: 'test-key',
          model: 'test-model',
        ),
        input: 'grace',
      );

      expect(receivedPath, '/compatible-mode/v1/embeddings');
      expect(result, [0.1, 0.2, 0.3]);
    });

    test('maps forbidden responses to unauthorized instead of network errors', () async {
      late HttpServer server;

      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      server.listen((request) async {
        request.response.statusCode = HttpStatus.forbidden;
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode({
            'error': {
              'message': 'model access denied',
            },
          }),
        );
        await request.response.close();
      });

      final client = OpenAiCompatibleEmbeddingClient(
        timeout: const Duration(seconds: 5),
      );

      addTearDown(() async {
        await server.close(force: true);
      });

      expect(
        () => client.createEmbedding(
          config: EmbeddingApiConfig(
            baseUrl: 'http://127.0.0.1:${server.port}/compatible-mode/v1',
            apiKey: 'test-key',
            model: 'test-model',
          ),
          input: 'hope',
        ),
        throwsA(
          isA<SemanticSearchException>()
              .having(
                (error) => error.type,
                'type',
                SemanticSearchErrorType.unauthorized,
              )
              .having(
                (error) => error.message,
                'message',
                contains('model access denied'),
              ),
        ),
      );
    });
  });
}
