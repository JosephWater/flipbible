import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/app_providers.dart';
import '../../../core/data/semantic_search_defaults.dart';
import '../../../core/models/book_summary.dart';
import '../../../core/models/chapter_content.dart';
import '../../../core/models/copy_settings.dart';
import '../../../core/models/translation_summary.dart';
import '../../reader/application/verse_copy_formatter.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider);
    final copySettings = ref.watch(copySettingsProvider);
    final settingsRepository = ref.read(settingsRepositoryProvider);
    final copyRepository = ref.read(copySettingsRepositoryProvider);

    if (settings.isLoading || copySettings.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (settings.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('阅读设置')),
        body: Center(
          child: Text('阅读设置加载失败：${settings.error}'),
        ),
      );
    }

    if (copySettings.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('阅读设置')),
        body: Center(
          child: Text('复制设置加载失败：${copySettings.error}'),
        ),
      );
    }

    final value = settings.requireValue;
    final copyValue = copySettings.requireValue;
    final hasCustomBaseUrl = value.embeddingBaseUrl.trim().isNotEmpty;
    final hasCustomModel = value.embeddingModel.trim().isNotEmpty;
    final hasCustomApiKey = hasManualEmbeddingApiKey(value.embeddingApiKey);
    final builtInAccessUnlocked = value.defaultEmbeddingAccessUnlocked;
    final builtInKeyAvailable =
        builtInAccessUnlocked && defaultEmbeddingApiKey.isNotEmpty;
    final displayedBaseUrl = hasCustomBaseUrl
        ? value.embeddingBaseUrl.trim()
        : builtInAccessUnlocked
            ? defaultEmbeddingBaseUrl
            : '未设置';
    final displayedModel = hasCustomModel
        ? value.embeddingModel.trim()
        : builtInAccessUnlocked
            ? defaultEmbeddingModel
            : '未设置';

    return Scaffold(
      appBar: AppBar(title: const Text('阅读设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '主题',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    selected: {value.themeMode},
                    onSelectionChanged: (selection) {
                      settingsRepository.updateThemeMode(selection.first);
                    },
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('浅色'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('深色'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('跟随系统'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '正文排版',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '字号',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    min: 0.72,
                    max: 1.7,
                    divisions: 49,
                    value: value.fontScale,
                    label: value.fontScale.toStringAsFixed(2),
                    onChanged: settingsRepository.updateFontScale,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '行距',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    min: 1.15,
                    max: 2.35,
                    divisions: 48,
                    value: value.lineHeight,
                    label: value.lineHeight.toStringAsFixed(2),
                    onChanged: settingsRepository.updateLineHeight,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '节间距',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    min: -4,
                    max: 40,
                    divisions: 44,
                    value: value.verseSpacing,
                    label: value.verseSpacing.toStringAsFixed(0),
                    onChanged: settingsRepository.updateVerseSpacing,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '页边距',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    min: 0,
                    max: 28,
                    divisions: 28,
                    value: value.pageHorizontalPadding,
                    label: value.pageHorizontalPadding.toStringAsFixed(0),
                    onChanged: settingsRepository.updatePageHorizontalPadding,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: value.backgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.18),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '浅色阅读背景',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '自定义浅色模式下的纸张背景。默认会比当前版本更亮一些。',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.72),
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                TextButton(
                                  onPressed: () => settingsRepository
                                      .updateBackgroundColorValue(0xFFFBF7EF),
                                  child: const Text('恢复默认'),
                                ),
                                FilledButton.tonal(
                                  onPressed: () async {
                                    final picked =
                                        await _showBackgroundColorDialog(
                                      context,
                                      initialColor: value.backgroundColor,
                                    );
                                    if (picked == null) {
                                      return;
                                    }
                                    await settingsRepository
                                        .updateBackgroundColorValue(
                                      picked.toARGB32(),
                                    );
                                  },
                                  child: const Text('自定义'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '复制格式',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '长按经文进入多选后，复制时会使用这里设置的输出格式。',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.72),
                        ),
                  ),
                  const SizedBox(height: 16),
                  _CopyFormatTile(
                    title: '格式一',
                    preview: _copyPreview(
                      copyValue.copyWith(format: CopyFormat.format1),
                    ),
                    groupValue: copyValue.format,
                    value: CopyFormat.format1,
                    onChanged: copyRepository.updateFormat,
                  ),
                  _CopyFormatTile(
                    title: '格式二',
                    preview: _copyPreview(
                      copyValue.copyWith(format: CopyFormat.format2),
                    ),
                    groupValue: copyValue.format,
                    value: CopyFormat.format2,
                    onChanged: copyRepository.updateFormat,
                  ),
                  _CopyFormatTile(
                    title: '格式三',
                    preview: _copyPreview(
                      copyValue.copyWith(format: CopyFormat.format3),
                    ),
                    groupValue: copyValue.format,
                    value: CopyFormat.format3,
                    onChanged: copyRepository.updateFormat,
                  ),
                  const Divider(height: 28),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: copyValue.showVerseNumbers,
                    title: const Text('复制时显示节号'),
                    subtitle: const Text('关闭后复制结果只保留正文，不附带节号。'),
                    onChanged: copyRepository.updateShowVerseNumbers,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '语义搜索授权',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  _SettingsValueTile(
                    title: '内置授权状态',
                    value: builtInAccessUnlocked ? '已授权' : '未授权',
                    caption: builtInAccessUnlocked
                        ? '当前设备已启用内置语义搜索配置。'
                        : '点击输入邀请码以启用内置语义搜索配置。',
                    onTap: () async {
                      final nextValue = await _showTextSettingDialog(
                        context,
                        title: '输入邀请码',
                        initialValue: '',
                        hintText: '请输入邀请码',
                        obscureText: true,
                      );
                      if (nextValue == null) {
                        return;
                      }

                      final inviteCode = nextValue.trim();
                      if (inviteCode.isEmpty) {
                        await settingsRepository.disableDefaultSemanticAccess();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('已取消内置语义搜索授权。'),
                            ),
                          );
                        }
                        return;
                      }

                      if (!matchesDefaultEmbeddingInviteCode(inviteCode)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('邀请码无效。'),
                            ),
                          );
                        }
                        return;
                      }

                      await settingsRepository.enableDefaultSemanticAccess();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('已启用内置语义搜索配置。'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '语义搜索服务',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '这里可以填写自定义服务配置。若未填写自定义 API Key，授权后会自动使用内置密钥。',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.72),
                        ),
                  ),
                  const SizedBox(height: 12),
                  _SettingsValueTile(
                    title: 'Base URL',
                    value: displayedBaseUrl,
                    caption: hasCustomBaseUrl
                        ? '当前使用自定义地址。'
                        : builtInAccessUnlocked
                            ? '当前使用内置地址。'
                            : '未显示内置地址，可手动填写自定义地址。',
                    onTap: () async {
                      final nextValue = await _showTextSettingDialog(
                        context,
                        title: '语义搜索 Base URL',
                        initialValue: value.embeddingBaseUrl,
                        hintText: 'https://your-service.example/v1',
                        helperText: builtInAccessUnlocked
                            ? '留空会继续使用内置地址。'
                            : '留空后不会保存自定义地址。',
                      );
                      if (nextValue == null) {
                        return;
                      }
                      await settingsRepository.updateEmbeddingBaseUrl(nextValue);
                    },
                  ),
                  _SettingsValueTile(
                    title: '模型',
                    value: displayedModel,
                    caption: hasCustomModel
                        ? '当前使用自定义模型。'
                        : builtInAccessUnlocked
                            ? '当前使用内置模型。'
                            : '未显示内置模型，可手动填写自定义模型。',
                    onTap: () async {
                      final nextValue = await _showTextSettingDialog(
                        context,
                        title: '语义搜索模型',
                        initialValue: value.embeddingModel,
                        hintText: 'text-embedding-v4',
                        helperText: builtInAccessUnlocked
                            ? '留空会继续使用内置模型。'
                            : '留空后不会保存自定义模型。',
                      );
                      if (nextValue == null) {
                        return;
                      }
                      await settingsRepository.updateEmbeddingModel(nextValue);
                    },
                  ),
                  _SettingsValueTile(
                    title: 'API Key',
                    value: _apiKeyStatusLabel(
                      hasCustomApiKey: hasCustomApiKey,
                      builtInKeyAvailable: builtInKeyAvailable,
                    ),
                    caption: hasCustomApiKey
                        ? '当前优先使用你手动填写的 API Key。'
                        : builtInKeyAvailable
                            ? '当前使用已授权的内置 API Key。'
                            : '当前没有可用 API Key，请先授权或填写自定义 API Key。',
                    onTap: () async {
                      final nextValue = await _showTextSettingDialog(
                        context,
                        title: '填写 API Key',
                        initialValue: hasCustomApiKey ? value.embeddingApiKey : '',
                        hintText: '请输入 API Key',
                        helperText: builtInAccessUnlocked
                            ? '留空可移除自定义 API Key，并继续使用已授权的内置密钥。'
                            : '留空可移除自定义 API Key。',
                        obscureText: true,
                      );
                      if (nextValue == null) {
                        return;
                      }
                      await settingsRepository.updateEmbeddingApiKey(nextValue);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              title: Text('翻阅滑块位置'),
              subtitle: Text('当前版本固定在右侧，后续版本会开放左右切换。'),
              trailing: Chip(label: Text('右侧')),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyFormatTile extends StatelessWidget {
  const _CopyFormatTile({
    required this.title,
    required this.preview,
    required this.groupValue,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String preview;
  final CopyFormat groupValue;
  final CopyFormat value;
  final ValueChanged<CopyFormat> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = groupValue == value;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.08)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.42)
                  : theme.colorScheme.outline.withValues(alpha: 0.16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SelectableText(
                preview,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsValueTile extends StatelessWidget {
  const _SettingsValueTile({
    required this.title,
    required this.value,
    required this.caption,
    required this.onTap,
  });

  final String title;
  final String value;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(
        caption,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
        ),
      ),
      trailing: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200),
        child: Text(
          value,
          textAlign: TextAlign.end,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

Future<String?> _showTextSettingDialog(
  BuildContext context, {
  required String title,
  required String initialValue,
  required String hintText,
  String? helperText,
  bool obscureText = false,
}) async {
  final controller = TextEditingController(text: initialValue);
  try {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            obscureText: obscureText,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hintText,
              helperText: helperText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  } finally {
    controller.dispose();
  }
}

Future<Color?> _showBackgroundColorDialog(
  BuildContext context, {
  required Color initialColor,
}) async {
  var red = (initialColor.r * 255.0).round().clamp(0, 255).toDouble();
  var green = (initialColor.g * 255.0).round().clamp(0, 255).toDouble();
  var blue = (initialColor.b * 255.0).round().clamp(0, 255).toDouble();

  Color currentColor() {
    return Color.fromARGB(
      0xFF,
      red.round().clamp(0, 255),
      green.round().clamp(0, 255),
      blue.round().clamp(0, 255),
    );
  }

  return showDialog<Color>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          final preview = currentColor();
          return AlertDialog(
            title: const Text('自定义浅色背景'),
            content: SizedBox(
              width: 360,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 72,
                    decoration: BoxDecoration(
                      color: preview,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ColorSliderRow(
                    label: 'R',
                    value: red,
                    activeColor: const Color(0xFFC76A52),
                    onChanged: (value) => setState(() => red = value),
                  ),
                  _ColorSliderRow(
                    label: 'G',
                    value: green,
                    activeColor: const Color(0xFF8E9A5B),
                    onChanged: (value) => setState(() => green = value),
                  ),
                  _ColorSliderRow(
                    label: 'B',
                    value: blue,
                    activeColor: const Color(0xFF8A9BC9),
                    onChanged: (value) => setState(() => blue = value),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    red = 0xFB.toDouble();
                    green = 0xF7.toDouble();
                    blue = 0xEF.toDouble();
                  });
                },
                child: const Text('默认'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(preview),
                child: const Text('应用'),
              ),
            ],
          );
        },
      );
    },
  );
}

String _apiKeyStatusLabel({
  required bool hasCustomApiKey,
  required bool builtInKeyAvailable,
}) {
  if (hasCustomApiKey) {
    return '已填写';
  }
  if (builtInKeyAvailable) {
    return '内置已启用';
  }
  return '未配置';
}

class _ColorSliderRow extends StatelessWidget {
  const _ColorSliderRow({
    required this.label,
    required this.value,
    required this.activeColor,
    required this.onChanged,
  });

  final String label;
  final double value;
  final Color activeColor;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeColor,
              thumbColor: activeColor,
              overlayColor: activeColor.withValues(alpha: 0.12),
            ),
            child: Slider(
              min: 0,
              max: 255,
              divisions: 255,
              value: value,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 32,
          child: Text(
            value.round().toString(),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

String _copyPreview(CopySettings settings) {
  return formatSelectedVersesForCopy(
    chapter: _sampleChapter,
    selectedVerses: const [15, 16, 17],
    settings: settings,
  );
}

const _sampleChapter = ChapterContent(
  translation: TranslationSummary(
    id: 'sample',
    title: '和合本示例',
    language: 'zh-CN',
    version: 'sample',
    copyright: '',
    filePath: '',
    isBuiltin: true,
    isActive: true,
    hasSearchIndex: true,
    hasSemanticIndex: true,
  ),
  book: BookSummary(
    id: 43,
    abbreviation: '约',
    name: '约翰福音',
    testament: 'new',
    sortOrder: 43,
    chapterCount: 21,
  ),
  chapter: 3,
  verses: [
    VerseContent(
      verse: 15,
      text: '叫一切信他的，不致灭亡，反得永生。',
    ),
    VerseContent(
      verse: 16,
      text: '神爱世人，甚至将他的独生子赐给他们，叫一切信他的，不致灭亡，反得永生。',
    ),
    VerseContent(
      verse: 17,
      text: '因为神差他的儿子降世，不是要定世人的罪，乃是要叫世人因他得救。',
    ),
  ],
);
