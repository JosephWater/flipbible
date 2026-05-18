import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/copy_settings.dart';

class CopySettingsRepository {
  CopySettingsRepository();

  final StreamController<CopySettings> _controller =
      StreamController<CopySettings>.broadcast();
  CopySettings? _cachedSettings;

  Stream<CopySettings> watchSettings() async* {
    yield await getSettings();
    yield* _controller.stream;
  }

  Future<CopySettings> getSettings() async {
    if (_cachedSettings != null) {
      return _cachedSettings!;
    }

    final file = await _settingsFile();
    if (!await file.exists()) {
      _cachedSettings = const CopySettings.defaults();
      return _cachedSettings!;
    }

    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is Map<String, Object?>) {
        _cachedSettings = CopySettings.fromJson(decoded);
        return _cachedSettings!;
      }
    } catch (_) {
      // Fall back to defaults when the stored file is missing or malformed.
    }

    _cachedSettings = const CopySettings.defaults();
    return _cachedSettings!;
  }

  Future<void> updateFormat(CopyFormat format) async {
    final next = (await getSettings()).copyWith(format: format);
    await _persist(next);
  }

  Future<void> updateShowVerseNumbers(bool value) async {
    final next = (await getSettings()).copyWith(showVerseNumbers: value);
    await _persist(next);
  }

  Future<void> _persist(CopySettings settings) async {
    final file = await _settingsFile();
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(settings.toJson()));
    _cachedSettings = settings;
    if (!_controller.isClosed) {
      _controller.add(settings);
    }
  }

  Future<File> _settingsFile() async {
    final appDirectory = await getApplicationSupportDirectory();
    return File(p.join(appDirectory.path, 'copy_settings.json'));
  }

  void dispose() {
    _controller.close();
  }
}
