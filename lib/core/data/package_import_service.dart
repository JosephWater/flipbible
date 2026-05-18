import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/imported_package_manifest.dart';
import 'app_database.dart';
import 'bible_content_database.dart';

class PackageImportService {
  PackageImportService(this._appDatabase);

  static const builtinManifestAsset = 'assets/bundled/builtin_manifest.json';
  static const builtinDatabaseAsset = 'assets/bundled/builtin_content.sqlite';

  final AppDatabase _appDatabase;

  Future<void> bootstrapBundledTranslation() async {
    final manifest = ImportedPackageManifest.fromJson(
      jsonDecode(await rootBundle.loadString(builtinManifestAsset))
          as Map<String, dynamic>,
    );

    final existing = await (_appDatabase.select(_appDatabase.installedTranslations)
          ..where((table) => table.id.equals(manifest.id)))
        .getSingleOrNull();

    final appSupport = await getApplicationSupportDirectory();
    final libraryDir = Directory(p.join(appSupport.path, 'packages'));
    await libraryDir.create(recursive: true);
    final dbFile = File(p.join(libraryDir.path, '${manifest.id}.sqlite'));
    final shouldRefreshBuiltin = existing == null ||
        existing.version != manifest.version ||
        existing.filePath != dbFile.path ||
        !await dbFile.exists();
    if (shouldRefreshBuiltin) {
      final bytes = await rootBundle.load(builtinDatabaseAsset);
      await dbFile.writeAsBytes(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        flush: true,
      );
    }

    final activeTranslation = await (_appDatabase.select(
      _appDatabase.installedTranslations,
    )..where((table) => table.isActive.equals(true)))
        .getSingleOrNull();

    await _upsertTranslation(
      manifest,
      filePath: dbFile.path,
      isBuiltin: true,
      makeActive: existing?.isActive ?? activeTranslation == null,
      installedAt: existing?.installedAt,
    );
  }

  Future<ImportedPackageManifest> validateAndImport(File file) async {
    if (p.extension(file.path).toLowerCase() != '.flipbible') {
      throw const FormatException('Only .flipbible packages are supported.');
    }

    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final manifestFile = archive.files.firstWhere(
      (entry) => entry.name == 'manifest.json',
      orElse: () => throw const FormatException('manifest.json is missing.'),
    );
    final contentFile = archive.files.firstWhere(
      (entry) => entry.name == 'content.sqlite',
      orElse: () => throw const FormatException('content.sqlite is missing.'),
    );

    final manifestJson = jsonDecode(
      utf8.decode(manifestFile.content as List<int>),
    ) as Map<String, dynamic>;
    final manifest = ImportedPackageManifest.fromJson(manifestJson);

    final tempDir = await getTemporaryDirectory();
    final validationFile =
        File(p.join(tempDir.path, '${manifest.id}_validation.sqlite'));
    await validationFile.writeAsBytes(contentFile.content as List<int>);
    await _validateContentDatabase(validationFile.path, manifest.id);

    final appSupport = await getApplicationSupportDirectory();
    final libraryDir = Directory(p.join(appSupport.path, 'packages'));
    await libraryDir.create(recursive: true);

    final targetFile = File(p.join(libraryDir.path, '${manifest.id}.sqlite'));
    await targetFile.writeAsBytes(contentFile.content as List<int>, flush: true);
    try {
      if (await validationFile.exists()) {
        await validationFile.delete();
      }
    } catch (_) {
      // Best-effort cleanup for temporary validation files.
    }

    final currentActive = await (_appDatabase.select(
      _appDatabase.installedTranslations,
    )..where((table) => table.isActive.equals(true)))
        .getSingleOrNull();

    await _upsertTranslation(
      manifest,
      filePath: targetFile.path,
      isBuiltin: false,
      makeActive: currentActive == null,
    );
    return manifest;
  }

  Future<List<ImportedPackageManifest>> listInstalledPackages() async {
    final items = await (_appDatabase.select(_appDatabase.installedTranslations)
          ..orderBy([
            (table) => OrderingTerm(expression: table.installedAt),
          ]))
        .get();

    return items
        .map(
          (row) => ImportedPackageManifest(
            id: row.id,
            title: row.title,
            language: row.language,
            version: row.version,
            copyright: row.copyright,
            hasSearchIndex: row.hasSearchIndex,
            hasSemanticIndex: row.hasSemanticIndex,
          ),
        )
        .toList();
  }

  Future<void> _validateContentDatabase(
    String filePath,
    String expectedTranslationId,
  ) async {
    final database = BibleContentDatabase(filePath);
    try {
      final translationColumns = await database.customSelect(
        'PRAGMA table_info(translations)',
      ).get();
      final hasSemanticIndexColumn = translationColumns.any(
        (row) => row.read<String>('name') == 'has_semantic_index',
      );
      final semanticIndexProjection = hasSemanticIndexColumn
          ? 'COALESCE(has_semantic_index, 0) AS has_semantic_index'
          : '0 AS has_semantic_index';
      final translationRows = await database.customSelect(
        '''
        SELECT id, title, language, version, copyright,
               COALESCE(has_search_index, 0) AS has_search_index,
               $semanticIndexProjection
        FROM translations
        ''',
      ).get();
      if (translationRows.isEmpty) {
        throw const FormatException('translations table is empty.');
      }

      final translationId = translationRows.first.read<String>('id');
      if (translationId != expectedTranslationId) {
        throw const FormatException(
          'manifest id does not match translations.id in content.sqlite.',
        );
      }

      final books = await database.select(database.books).get();
      final chapters = await database.select(database.chapters).get();
      final verses = await database.select(database.verses).get();
      if (books.isEmpty || chapters.isEmpty || verses.isEmpty) {
        throw const FormatException(
          'books, chapters, and verses tables must all contain data.',
        );
      }
    } finally {
      await database.close();
    }
  }

  Future<void> _upsertTranslation(
    ImportedPackageManifest manifest, {
    required String filePath,
    required bool isBuiltin,
    required bool makeActive,
    DateTime? installedAt,
  }) async {
    await _appDatabase.into(_appDatabase.installedTranslations).insertOnConflictUpdate(
          InstalledTranslationsCompanion.insert(
            id: manifest.id,
            title: manifest.title,
            language: manifest.language,
            version: manifest.version,
            copyright: manifest.copyright,
            filePath: filePath,
            isBuiltin: Value(isBuiltin),
            isActive: Value(makeActive),
            hasSearchIndex: Value(manifest.hasSearchIndex),
            hasSemanticIndex: Value(manifest.hasSemanticIndex),
            installedAt: installedAt ?? DateTime.now(),
          ),
        );
  }
}
