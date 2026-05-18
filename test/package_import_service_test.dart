import 'dart:io';

import 'package:drift/native.dart';
import 'package:flip_bible/core/data/app_database.dart';
import 'package:flip_bible/core/data/package_import_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  _FakePathProviderPlatform(this.root);

  final Directory root;

  @override
  Future<String?> getApplicationSupportPath() async => root.path;

  @override
  Future<String?> getTemporaryPath() async => root.path;
}

void main() {
  late Directory tempDir;
  late AppDatabase database;
  late PackageImportService service;
  late PathProviderPlatform originalPlatform;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('flipbible_package_test');
    originalPlatform = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir);
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = PackageImportService(database);
  });

  tearDown(() async {
    PathProviderPlatform.instance = originalPlatform;
    await database.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('imports valid .flipbible package and lists it', () async {
    final bundle = File(
      p.join(
        Directory.current.path,
        'assets',
        'samples',
        'flipbible_demo_bundle.flipbible',
      ),
    );

    final manifest = await service.validateAndImport(bundle);

    expect(manifest.id, 'builtin_cn_demo');
    final installed = await service.listInstalledPackages();
    expect(installed.single.version, '1.1.0-cus');
  });

  test('re-import replaces package metadata for matching id', () async {
    final first = File(
      p.join(
        Directory.current.path,
        'assets',
        'samples',
        'flipbible_demo_bundle.flipbible',
      ),
    );
    final second = File(
      p.join(
        Directory.current.path,
        'assets',
        'samples',
        'flipbible_demo_bundle_v2.flipbible',
      ),
    );

    await service.validateAndImport(first);
    await service.validateAndImport(second);

    final installed = await service.listInstalledPackages();
    expect(installed.single.version, '2.0.0-cus');
  });
}
