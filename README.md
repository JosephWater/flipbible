# FlipBible

中文 | [English](#english)
![image](https://github.com/JosephWater/flipbible/blob/main/flipbible%E4%BB%8B%E7%BB%8D.jpg)




## 中文
FlipBible 是一个基于 Flutter 的圣经阅读应用，支持离线阅读、滑块一键目录跳转、最近阅读位置、单节经文的相似语义经文、多格式复制，以及基于经文向量索引的语义搜索。
### 软件使用说明
[Download APK](https://github.com/JosephWater/flipbible/releases/download/bible/flipbible-public-arm64.apk)
* 滑块：按住卷滑块上下滑动选择书卷，左滑选中后手指不离开屏幕继续上下滑动选择章
* 语义检索：由于现在的圣经向量库是用qwen的text-embedding-v4模型预构建打包进软件的，所以配置语义检索的时候也请用这个模型。

### 当前仓库说明

这个公开仓库只包含源码，不包含以下大体积二进制资源：

- `assets/bundled/builtin_content.sqlite`
- `assets/samples/*.flipbible`

这样做有两个原因：

- GitHub 对单文件大小有限制，`builtin_content.sqlite` 超过 100 MB。
- 公开仓库不直接分发内置语义搜索密钥或完整打包资源。

如果你只是想使用应用，请直接下载 Release 页面提供的 APK。[Download APK](https://github.com/JosephWater/flipbible/releases/download/bible/flipbible-public-arm64.apk)

如果想要自己构建并且需要builtin_content.sqlite，可以联系我。

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

### 构建 APK

构建时可以注入自己的API Key，例如：

```bash
flutter build apk --release \
  --dart-define=FLIPBIBLE_EMBEDDING_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1 \
  --dart-define=FLIPBIBLE_EMBEDDING_MODEL=text-embedding-v4 \
  --dart-define=FLIPBIBLE_EMBEDDING_API_KEY=你的_API_KEY
```

但是有泄露apikey风险，所以推荐在软件内手动输入配置信息。

### 资源生成

仓库中保留了构建和预处理脚本，便于你在本地重新生成数据资源：

- `tool/precompute_semantic_assets.py`
- `tool/build_sample_assets.py`

# 欢迎改进。

## English

FlipBible is a Flutter-based Bible reading app. It supports offline reading, one-click directory jumping via slider, reading history record, similar verse recommendation for single verses, multi-format text copying, and semantic search powered by verse vector indexing.

### User Guide

- Slider: Press and slide the book slider up/down to select a book. After selection, slide left without lifting your finger, then continue sliding up/down to select a chapter.
- Semantic Search: The pre-built Bible vector library bundled in the app is generated using Alibaba's text-embedding-v4 model. Please use this model when configuring semantic search.

### Repository Notes

This public repository contains only the source code and **does NOT include** the following large binary assets:

- `assets/bundled/builtin_content.sqlite`
- `assets/samples/*.flipbible`

This is for two reasons:

- GitHub enforces a 100MB file size limit, and `builtin_content.sqlite` exceeds this limit.
- The public repository does not directly distribute built-in semantic search API keys or fully packaged resources.

If you only want to use the app, please download the APK from the **Releases** page directly.

If you want to build from source and need the `builtin_content.sqlite` file, please contact me.

### Run from Source

1. Install Flutter and the development environment for your target platform.
2. Clone the repository and install dependencies:

运行

```
flutter pub get
```

1. Prepare the built-in content database:
   - Place your `builtin_content.sqlite` file in:

```
assets/bundled/builtin_content.sqlite
```

- If you need sample import packages, place `.flipbible` files in:

```
assets/samples/
```

1. Run the app:

```
flutter run
```

### Build APK

You can inject your own API Key during the build process:

```
flutter build apk --release \
  --dart-define=FLIPBIBLE_EMBEDDING_BASE_URL=https://dashscope.aliyuncs.com/compatible-mode/v1 \
  --dart-define=FLIPBIBLE_EMBEDDING_MODEL=text-embedding-v4 \
  --dart-define=FLIPBIBLE_EMBEDDING_API_KEY=YOUR_API_KEY
```

**Warning**: There is a risk of API Key leakage. It is **highly recommended** to manually enter the configuration inside the app.

### Asset Generation

The repository retains build and preprocessing scripts for regenerating data assets locally:

- `tool/precompute_semantic_assets.py`
- `tool/build_sample_assets.py`

# Welcome contributions.
