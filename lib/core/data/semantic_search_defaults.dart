const defaultEmbeddingBaseUrl = String.fromEnvironment(
  'FLIPBIBLE_EMBEDDING_BASE_URL',
  defaultValue: 'https://dashscope.aliyuncs.com/compatible-mode/v1',
);

const defaultEmbeddingApiKey = String.fromEnvironment(
  'FLIPBIBLE_EMBEDDING_API_KEY',
  defaultValue: '',
);

const builtinEmbeddingApiKeyPlaceholder = '__flipbible_builtin__';

const defaultEmbeddingModel = String.fromEnvironment(
  'FLIPBIBLE_EMBEDDING_MODEL',
  defaultValue: 'text-embedding-v4',
);

const _defaultEmbeddingInviteCodeHash = 2252943354;

bool matchesDefaultEmbeddingInviteCode(String value) {
  return _fnv1a32(value.trim()) == _defaultEmbeddingInviteCodeHash;
}

bool isBuiltinEmbeddingApiKeyPlaceholder(String value) {
  return value.trim() == builtinEmbeddingApiKeyPlaceholder;
}

bool hasManualEmbeddingApiKey(String value) {
  final trimmed = value.trim();
  return trimmed.isNotEmpty && !isBuiltinEmbeddingApiKeyPlaceholder(trimmed);
}

int _fnv1a32(String value) {
  var hash = 0x811C9DC5;
  for (final codeUnit in value.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 0x01000193) & 0xFFFFFFFF;
  }
  return hash;
}
