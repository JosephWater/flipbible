import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flip_bible/core/data/app_database.dart';
import 'package:flip_bible/core/data/package_import_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

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
    final bundle = await _createBundle(
      tempDir,
      version: '1.1.0-cus',
    );

    final manifest = await service.validateAndImport(bundle);

    expect(manifest.id, 'builtin_cn_demo');
    final installed = await service.listInstalledPackages();
    expect(installed.single.version, '1.1.0-cus');
  });

  test('re-import replaces package metadata for matching id', () async {
    final first = await _createBundle(
      tempDir,
      version: '1.1.0-cus',
    );
    final second = await _createBundle(
      tempDir,
      version: '2.0.0-cus',
      suffix: 'v2',
    );

    await service.validateAndImport(first);
    await service.validateAndImport(second);

    final installed = await service.listInstalledPackages();
    expect(installed.single.version, '2.0.0-cus');
  });
}

Future<File> _createBundle(
  Directory root, {
  required String version,
  String suffix = 'v1',
}) async {
  final dbFile = File(p.join(root.path, 'content_$suffix.sqlite'));
  _createContentDatabase(dbFile);

  final manifest = <String, dynamic>{
    'id': 'builtin_cn_demo',
    'title': 'Test Bible',
    'language': 'zh-CN',
    'version': version,
    'copyright': '',
    'hasSearchIndex': false,
    'hasSemanticIndex': true,
  };

  final archive = Archive()
    ..addFile(
      ArchiveFile.string(
        'manifest.json',
        jsonEncode(manifest),
      ),
    )
    ..addFile(
      ArchiveFile(
        'content.sqlite',
        await dbFile.length(),
        await dbFile.readAsBytes(),
      ),
    );

  final bundle = File(p.join(root.path, 'flipbible_$suffix.flipbible'));
  await bundle.writeAsBytes(ZipEncoder().encode(archive)!);
  return bundle;
}

void _createContentDatabase(File file) {
  final database = sqlite.sqlite3.open(file.path);
  try {
    database.execute(
      '''
      CREATE TABLE translations (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        language TEXT NOT NULL,
        version TEXT NOT NULL,
        copyright TEXT NOT NULL,
        has_search_index INTEGER NOT NULL DEFAULT 0,
        has_semantic_index INTEGER NOT NULL DEFAULT 1
      );
      CREATE TABLE books (
        id INTEGER PRIMARY KEY,
        abbreviation TEXT NOT NULL,
        name TEXT NOT NULL,
        testament TEXT NOT NULL,
        sort_order INTEGER NOT NULL,
        chapter_count INTEGER NOT NULL
      );
      CREATE TABLE chapters (
        translation_id TEXT NOT NULL,
        book_id INTEGER NOT NULL,
        chapter INTEGER NOT NULL,
        verse_count INTEGER NOT NULL,
        PRIMARY KEY (translation_id, book_id, chapter)
      );
      CREATE TABLE verses (
        translation_id TEXT NOT NULL,
        book_id INTEGER NOT NULL,
        chapter INTEGER NOT NULL,
        verse INTEGER NOT NULL,
        text TEXT NOT NULL,
        verse_index INTEGER,
        PRIMARY KEY (translation_id, book_id, chapter, verse)
      );
      ''',
    );

    database.execute(
      '''
      INSERT INTO translations (
        id, title, language, version, copyright, has_search_index, has_semantic_index
      ) VALUES ('builtin_cn_demo', 'Test Bible', 'zh-CN', '1', '', 0, 1);
      INSERT INTO books (id, abbreviation, name, testament, sort_order, chapter_count)
      VALUES (43, '约', '约翰福音', 'NT', 43, 21);
      INSERT INTO chapters (translation_id, book_id, chapter, verse_count)
      VALUES ('builtin_cn_demo', 43, 3, 2);
      INSERT INTO verses (translation_id, book_id, chapter, verse, text, verse_index)
      VALUES
        ('builtin_cn_demo', 43, 3, 16, '神爱世人。', 1),
        ('builtin_cn_demo', 43, 3, 17, '叫世人得救。', 2);
      ''',
    );
  } finally {
    database.dispose();
  }
}
