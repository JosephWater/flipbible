# FlipBible

中文 | [English](#english)

FlipBible 是一个基于 Flutter 的圣经阅读应用，支持离线阅读、目录跳转、最近阅读位置、长按多选复制，以及基于经文向量索引的语义搜索。

## 中文

### 当前仓库说明

这个公开仓库只包含源码，不包含以下大体积二进制资源：

- `assets/bundled/builtin_content.sqlite`
- `assets/samples/*.flipbible`

这样做有两个原因：

- GitHub 对单文件大小有限制，`builtin_content.sqlite` 超过 100 MB。
- 公开仓库不直接分发内置语义搜索密钥或完整打包资源。

如果你只是想使用应用，请直接下载 Release 页面提供的 APK。

### 从源码运行

1. 安装 Flutter 与对应平台开发环境。
2. 拉取仓库并安装依赖：

```bash
flutter pub get
```

3. 准备内置内容数据库：

- 将你自己的 `builtin_content.sqlite` 放到：

```text
assets/bundled/builtin_content.sqlite
```

- 如果你还需要示例导入包，可将 `.flipbible` 文件放到：

```text
assets/samples/
```

4. 运行应用：

```bash
flutter run
```

### 构建公开版 APK

公开版构建时不要注入任何第三方 API Key，例如：

```bash
flutter build apk --release \
  --dart-define=FLIPBIBLE_EMBEDDING_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1 \
  --dart-define=FLIPBIBLE_EMBEDDING_MODEL=text-embedding-v4
```

这类公开版 APK 不会内置语义搜索密钥。用户需要：

- 手动填写自己的 API Key，或
- 使用你后续提供的服务端代理方案

### 资源生成

仓库中保留了构建和预处理脚本，便于你在本地重新生成数据资源：

- `tool/precompute_semantic_assets.py`
- `tool/build_sample_assets.py`

### 开源注意事项

- 不要把 `builtin_content.sqlite`、`.flipbible`、APK、AAB、ZIP 等大文件直接提交到 Git。
- 不要把真实 API Key、签名文件、`.env`、`android/key.properties` 提交到仓库。
- 如果某个密钥已经进入过公开 APK 或 Git 历史，应当视为已泄露并立即轮换。

## English

FlipBible is a Flutter-based Bible reader with offline reading, directory navigation, recent locations, long-press multi-select copy, and semantic search powered by precomputed verse vectors.

### Public repository policy

This public repository contains source code only. The following large binary assets are intentionally excluded:

- `assets/bundled/builtin_content.sqlite`
- `assets/samples/*.flipbible`

Reasons:

- GitHub rejects files larger than 100 MB, and `builtin_content.sqlite` exceeds that limit.
- The public repository should not directly ship private semantic-search credentials or full packaged assets.

If you only want to use the app, download the APK from the Releases page.

### Run from source

1. Install Flutter and the required platform toolchains.
2. Fetch dependencies:

```bash
flutter pub get
```

3. Provide the bundled content database:

- Put your own `builtin_content.sqlite` at:

```text
assets/bundled/builtin_content.sqlite
```

- If you also want sample import bundles, place `.flipbible` files in:

```text
assets/samples/
```

4. Run the app:

```bash
flutter run
```

### Build a public APK

Do not inject any third-party API key when building a public APK. Example:

```bash
flutter build apk --release \
  --dart-define=FLIPBIBLE_EMBEDDING_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1 \
  --dart-define=FLIPBIBLE_EMBEDDING_MODEL=text-embedding-v4
```

With this public build, semantic search will not include a bundled key. End users must either:

- provide their own API key, or
- use a future server-side proxy provided by you

### Asset generation

The repository still includes local scripts for rebuilding data assets:

- `tool/precompute_semantic_assets.py`
- `tool/build_sample_assets.py`

### Open-source safety notes

- Do not commit `builtin_content.sqlite`, `.flipbible`, APK, AAB, or ZIP artifacts into Git.
- Do not commit real API keys, signing files, `.env`, or `android/key.properties`.
- If a secret was ever included in a public APK or Git history, treat it as compromised and rotate it immediately.
