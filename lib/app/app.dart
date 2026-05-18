import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/data/app_providers.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class FlipBibleApp extends ConsumerWidget {
  const FlipBibleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readerSettingsProvider).asData?.value;

    return MaterialApp.router(
      title: 'FlipBible',
      debugShowCheckedModeBanner: false,
      routerConfig: ref.watch(appRouterProvider),
      theme: AppTheme.lightTheme(
        settings?.fontScale ?? 1,
        backgroundColor: settings?.backgroundColor,
      ),
      darkTheme: AppTheme.darkTheme(settings?.fontScale ?? 1),
      themeMode: settings?.themeMode ?? ThemeMode.light,
    );
  }
}
