// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InstalledTranslationsTable extends InstalledTranslations
    with TableInfo<$InstalledTranslationsTable, InstalledTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstalledTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _copyrightMeta = const VerificationMeta(
    'copyright',
  );
  @override
  late final GeneratedColumn<String> copyright = GeneratedColumn<String>(
    'copyright',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBuiltinMeta = const VerificationMeta(
    'isBuiltin',
  );
  @override
  late final GeneratedColumn<bool> isBuiltin = GeneratedColumn<bool>(
    'is_builtin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_builtin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasSearchIndexMeta = const VerificationMeta(
    'hasSearchIndex',
  );
  @override
  late final GeneratedColumn<bool> hasSearchIndex = GeneratedColumn<bool>(
    'has_search_index',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_search_index" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasSemanticIndexMeta = const VerificationMeta(
    'hasSemanticIndex',
  );
  @override
  late final GeneratedColumn<bool> hasSemanticIndex = GeneratedColumn<bool>(
    'has_semantic_index',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_semantic_index" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _installedAtMeta = const VerificationMeta(
    'installedAt',
  );
  @override
  late final GeneratedColumn<DateTime> installedAt = GeneratedColumn<DateTime>(
    'installed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    language,
    version,
    copyright,
    filePath,
    isBuiltin,
    isActive,
    hasSearchIndex,
    hasSemanticIndex,
    installedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installed_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstalledTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('copyright')) {
      context.handle(
        _copyrightMeta,
        copyright.isAcceptableOrUnknown(data['copyright']!, _copyrightMeta),
      );
    } else if (isInserting) {
      context.missing(_copyrightMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('is_builtin')) {
      context.handle(
        _isBuiltinMeta,
        isBuiltin.isAcceptableOrUnknown(data['is_builtin']!, _isBuiltinMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('has_search_index')) {
      context.handle(
        _hasSearchIndexMeta,
        hasSearchIndex.isAcceptableOrUnknown(
          data['has_search_index']!,
          _hasSearchIndexMeta,
        ),
      );
    }
    if (data.containsKey('has_semantic_index')) {
      context.handle(
        _hasSemanticIndexMeta,
        hasSemanticIndex.isAcceptableOrUnknown(
          data['has_semantic_index']!,
          _hasSemanticIndexMeta,
        ),
      );
    }
    if (data.containsKey('installed_at')) {
      context.handle(
        _installedAtMeta,
        installedAt.isAcceptableOrUnknown(
          data['installed_at']!,
          _installedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstalledTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstalledTranslation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}version'],
      )!,
      copyright: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}copyright'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      isBuiltin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_builtin'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      hasSearchIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_search_index'],
      )!,
      hasSemanticIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_semantic_index'],
      )!,
      installedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}installed_at'],
      )!,
    );
  }

  @override
  $InstalledTranslationsTable createAlias(String alias) {
    return $InstalledTranslationsTable(attachedDatabase, alias);
  }
}

class InstalledTranslation extends DataClass
    implements Insertable<InstalledTranslation> {
  final String id;
  final String title;
  final String language;
  final String version;
  final String copyright;
  final String filePath;
  final bool isBuiltin;
  final bool isActive;
  final bool hasSearchIndex;
  final bool hasSemanticIndex;
  final DateTime installedAt;
  const InstalledTranslation({
    required this.id,
    required this.title,
    required this.language,
    required this.version,
    required this.copyright,
    required this.filePath,
    required this.isBuiltin,
    required this.isActive,
    required this.hasSearchIndex,
    required this.hasSemanticIndex,
    required this.installedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['language'] = Variable<String>(language);
    map['version'] = Variable<String>(version);
    map['copyright'] = Variable<String>(copyright);
    map['file_path'] = Variable<String>(filePath);
    map['is_builtin'] = Variable<bool>(isBuiltin);
    map['is_active'] = Variable<bool>(isActive);
    map['has_search_index'] = Variable<bool>(hasSearchIndex);
    map['has_semantic_index'] = Variable<bool>(hasSemanticIndex);
    map['installed_at'] = Variable<DateTime>(installedAt);
    return map;
  }

  InstalledTranslationsCompanion toCompanion(bool nullToAbsent) {
    return InstalledTranslationsCompanion(
      id: Value(id),
      title: Value(title),
      language: Value(language),
      version: Value(version),
      copyright: Value(copyright),
      filePath: Value(filePath),
      isBuiltin: Value(isBuiltin),
      isActive: Value(isActive),
      hasSearchIndex: Value(hasSearchIndex),
      hasSemanticIndex: Value(hasSemanticIndex),
      installedAt: Value(installedAt),
    );
  }

  factory InstalledTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstalledTranslation(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      language: serializer.fromJson<String>(json['language']),
      version: serializer.fromJson<String>(json['version']),
      copyright: serializer.fromJson<String>(json['copyright']),
      filePath: serializer.fromJson<String>(json['filePath']),
      isBuiltin: serializer.fromJson<bool>(json['isBuiltin']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      hasSearchIndex: serializer.fromJson<bool>(json['hasSearchIndex']),
      hasSemanticIndex: serializer.fromJson<bool>(json['hasSemanticIndex']),
      installedAt: serializer.fromJson<DateTime>(json['installedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'language': serializer.toJson<String>(language),
      'version': serializer.toJson<String>(version),
      'copyright': serializer.toJson<String>(copyright),
      'filePath': serializer.toJson<String>(filePath),
      'isBuiltin': serializer.toJson<bool>(isBuiltin),
      'isActive': serializer.toJson<bool>(isActive),
      'hasSearchIndex': serializer.toJson<bool>(hasSearchIndex),
      'hasSemanticIndex': serializer.toJson<bool>(hasSemanticIndex),
      'installedAt': serializer.toJson<DateTime>(installedAt),
    };
  }

  InstalledTranslation copyWith({
    String? id,
    String? title,
    String? language,
    String? version,
    String? copyright,
    String? filePath,
    bool? isBuiltin,
    bool? isActive,
    bool? hasSearchIndex,
    bool? hasSemanticIndex,
    DateTime? installedAt,
  }) => InstalledTranslation(
    id: id ?? this.id,
    title: title ?? this.title,
    language: language ?? this.language,
    version: version ?? this.version,
    copyright: copyright ?? this.copyright,
    filePath: filePath ?? this.filePath,
    isBuiltin: isBuiltin ?? this.isBuiltin,
    isActive: isActive ?? this.isActive,
    hasSearchIndex: hasSearchIndex ?? this.hasSearchIndex,
    hasSemanticIndex: hasSemanticIndex ?? this.hasSemanticIndex,
    installedAt: installedAt ?? this.installedAt,
  );
  InstalledTranslation copyWithCompanion(InstalledTranslationsCompanion data) {
    return InstalledTranslation(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      language: data.language.present ? data.language.value : this.language,
      version: data.version.present ? data.version.value : this.version,
      copyright: data.copyright.present ? data.copyright.value : this.copyright,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      isBuiltin: data.isBuiltin.present ? data.isBuiltin.value : this.isBuiltin,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      hasSearchIndex: data.hasSearchIndex.present
          ? data.hasSearchIndex.value
          : this.hasSearchIndex,
      hasSemanticIndex: data.hasSemanticIndex.present
          ? data.hasSemanticIndex.value
          : this.hasSemanticIndex,
      installedAt: data.installedAt.present
          ? data.installedAt.value
          : this.installedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstalledTranslation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('version: $version, ')
          ..write('copyright: $copyright, ')
          ..write('filePath: $filePath, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('isActive: $isActive, ')
          ..write('hasSearchIndex: $hasSearchIndex, ')
          ..write('hasSemanticIndex: $hasSemanticIndex, ')
          ..write('installedAt: $installedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    language,
    version,
    copyright,
    filePath,
    isBuiltin,
    isActive,
    hasSearchIndex,
    hasSemanticIndex,
    installedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstalledTranslation &&
          other.id == this.id &&
          other.title == this.title &&
          other.language == this.language &&
          other.version == this.version &&
          other.copyright == this.copyright &&
          other.filePath == this.filePath &&
          other.isBuiltin == this.isBuiltin &&
          other.isActive == this.isActive &&
          other.hasSearchIndex == this.hasSearchIndex &&
          other.hasSemanticIndex == this.hasSemanticIndex &&
          other.installedAt == this.installedAt);
}

class InstalledTranslationsCompanion
    extends UpdateCompanion<InstalledTranslation> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> language;
  final Value<String> version;
  final Value<String> copyright;
  final Value<String> filePath;
  final Value<bool> isBuiltin;
  final Value<bool> isActive;
  final Value<bool> hasSearchIndex;
  final Value<bool> hasSemanticIndex;
  final Value<DateTime> installedAt;
  final Value<int> rowid;
  const InstalledTranslationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.language = const Value.absent(),
    this.version = const Value.absent(),
    this.copyright = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isBuiltin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hasSearchIndex = const Value.absent(),
    this.hasSemanticIndex = const Value.absent(),
    this.installedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstalledTranslationsCompanion.insert({
    required String id,
    required String title,
    required String language,
    required String version,
    required String copyright,
    required String filePath,
    this.isBuiltin = const Value.absent(),
    this.isActive = const Value.absent(),
    this.hasSearchIndex = const Value.absent(),
    this.hasSemanticIndex = const Value.absent(),
    required DateTime installedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       language = Value(language),
       version = Value(version),
       copyright = Value(copyright),
       filePath = Value(filePath),
       installedAt = Value(installedAt);
  static Insertable<InstalledTranslation> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? language,
    Expression<String>? version,
    Expression<String>? copyright,
    Expression<String>? filePath,
    Expression<bool>? isBuiltin,
    Expression<bool>? isActive,
    Expression<bool>? hasSearchIndex,
    Expression<bool>? hasSemanticIndex,
    Expression<DateTime>? installedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (language != null) 'language': language,
      if (version != null) 'version': version,
      if (copyright != null) 'copyright': copyright,
      if (filePath != null) 'file_path': filePath,
      if (isBuiltin != null) 'is_builtin': isBuiltin,
      if (isActive != null) 'is_active': isActive,
      if (hasSearchIndex != null) 'has_search_index': hasSearchIndex,
      if (hasSemanticIndex != null) 'has_semantic_index': hasSemanticIndex,
      if (installedAt != null) 'installed_at': installedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstalledTranslationsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? language,
    Value<String>? version,
    Value<String>? copyright,
    Value<String>? filePath,
    Value<bool>? isBuiltin,
    Value<bool>? isActive,
    Value<bool>? hasSearchIndex,
    Value<bool>? hasSemanticIndex,
    Value<DateTime>? installedAt,
    Value<int>? rowid,
  }) {
    return InstalledTranslationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      version: version ?? this.version,
      copyright: copyright ?? this.copyright,
      filePath: filePath ?? this.filePath,
      isBuiltin: isBuiltin ?? this.isBuiltin,
      isActive: isActive ?? this.isActive,
      hasSearchIndex: hasSearchIndex ?? this.hasSearchIndex,
      hasSemanticIndex: hasSemanticIndex ?? this.hasSemanticIndex,
      installedAt: installedAt ?? this.installedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (copyright.present) {
      map['copyright'] = Variable<String>(copyright.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (isBuiltin.present) {
      map['is_builtin'] = Variable<bool>(isBuiltin.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (hasSearchIndex.present) {
      map['has_search_index'] = Variable<bool>(hasSearchIndex.value);
    }
    if (hasSemanticIndex.present) {
      map['has_semantic_index'] = Variable<bool>(hasSemanticIndex.value);
    }
    if (installedAt.present) {
      map['installed_at'] = Variable<DateTime>(installedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstalledTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('version: $version, ')
          ..write('copyright: $copyright, ')
          ..write('filePath: $filePath, ')
          ..write('isBuiltin: $isBuiltin, ')
          ..write('isActive: $isActive, ')
          ..write('hasSearchIndex: $hasSearchIndex, ')
          ..write('hasSemanticIndex: $hasSemanticIndex, ')
          ..write('installedAt: $installedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecentLocationsTable extends RecentLocations
    with TableInfo<$RecentLocationsTable, RecentLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationIdMeta = const VerificationMeta(
    'translationId',
  );
  @override
  late final GeneratedColumn<String> translationId = GeneratedColumn<String>(
    'translation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseStartMeta = const VerificationMeta(
    'verseStart',
  );
  @override
  late final GeneratedColumn<int> verseStart = GeneratedColumn<int>(
    'verse_start',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verseEndMeta = const VerificationMeta(
    'verseEnd',
  );
  @override
  late final GeneratedColumn<int> verseEnd = GeneratedColumn<int>(
    'verse_end',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    translationId,
    bookId,
    chapter,
    verseStart,
    verseEnd,
    source,
    createdAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recent_locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecentLocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('translation_id')) {
      context.handle(
        _translationIdMeta,
        translationId.isAcceptableOrUnknown(
          data['translation_id']!,
          _translationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse_start')) {
      context.handle(
        _verseStartMeta,
        verseStart.isAcceptableOrUnknown(data['verse_start']!, _verseStartMeta),
      );
    }
    if (data.containsKey('verse_end')) {
      context.handle(
        _verseEndMeta,
        verseEnd.isAcceptableOrUnknown(data['verse_end']!, _verseEndMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecentLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecentLocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      translationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verseStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_start'],
      ),
      verseEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_end'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $RecentLocationsTable createAlias(String alias) {
    return $RecentLocationsTable(attachedDatabase, alias);
  }
}

class RecentLocation extends DataClass implements Insertable<RecentLocation> {
  final String id;
  final String translationId;
  final int bookId;
  final int chapter;
  final int? verseStart;
  final int? verseEnd;
  final String source;
  final DateTime createdAt;
  final DateTime? archivedAt;
  const RecentLocation({
    required this.id,
    required this.translationId,
    required this.bookId,
    required this.chapter,
    this.verseStart,
    this.verseEnd,
    required this.source,
    required this.createdAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    if (!nullToAbsent || verseStart != null) {
      map['verse_start'] = Variable<int>(verseStart);
    }
    if (!nullToAbsent || verseEnd != null) {
      map['verse_end'] = Variable<int>(verseEnd);
    }
    map['source'] = Variable<String>(source);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  RecentLocationsCompanion toCompanion(bool nullToAbsent) {
    return RecentLocationsCompanion(
      id: Value(id),
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verseStart: verseStart == null && nullToAbsent
          ? const Value.absent()
          : Value(verseStart),
      verseEnd: verseEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(verseEnd),
      source: Value(source),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory RecentLocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecentLocation(
      id: serializer.fromJson<String>(json['id']),
      translationId: serializer.fromJson<String>(json['translationId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verseStart: serializer.fromJson<int?>(json['verseStart']),
      verseEnd: serializer.fromJson<int?>(json['verseEnd']),
      source: serializer.fromJson<String>(json['source']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'translationId': serializer.toJson<String>(translationId),
      'bookId': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verseStart': serializer.toJson<int?>(verseStart),
      'verseEnd': serializer.toJson<int?>(verseEnd),
      'source': serializer.toJson<String>(source),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  RecentLocation copyWith({
    String? id,
    String? translationId,
    int? bookId,
    int? chapter,
    Value<int?> verseStart = const Value.absent(),
    Value<int?> verseEnd = const Value.absent(),
    String? source,
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => RecentLocation(
    id: id ?? this.id,
    translationId: translationId ?? this.translationId,
    bookId: bookId ?? this.bookId,
    chapter: chapter ?? this.chapter,
    verseStart: verseStart.present ? verseStart.value : this.verseStart,
    verseEnd: verseEnd.present ? verseEnd.value : this.verseEnd,
    source: source ?? this.source,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  RecentLocation copyWithCompanion(RecentLocationsCompanion data) {
    return RecentLocation(
      id: data.id.present ? data.id.value : this.id,
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verseStart: data.verseStart.present
          ? data.verseStart.value
          : this.verseStart,
      verseEnd: data.verseEnd.present ? data.verseEnd.value : this.verseEnd,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecentLocation(')
          ..write('id: $id, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verseStart: $verseStart, ')
          ..write('verseEnd: $verseEnd, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    translationId,
    bookId,
    chapter,
    verseStart,
    verseEnd,
    source,
    createdAt,
    archivedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentLocation &&
          other.id == this.id &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verseStart == this.verseStart &&
          other.verseEnd == this.verseEnd &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class RecentLocationsCompanion extends UpdateCompanion<RecentLocation> {
  final Value<String> id;
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int?> verseStart;
  final Value<int?> verseEnd;
  final Value<String> source;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const RecentLocationsCompanion({
    this.id = const Value.absent(),
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verseStart = const Value.absent(),
    this.verseEnd = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentLocationsCompanion.insert({
    required String id,
    required String translationId,
    required int bookId,
    required int chapter,
    this.verseStart = const Value.absent(),
    this.verseEnd = const Value.absent(),
    required String source,
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       translationId = Value(translationId),
       bookId = Value(bookId),
       chapter = Value(chapter),
       source = Value(source),
       createdAt = Value(createdAt);
  static Insertable<RecentLocation> custom({
    Expression<String>? id,
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verseStart,
    Expression<int>? verseEnd,
    Expression<String>? source,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verseStart != null) 'verse_start': verseStart,
      if (verseEnd != null) 'verse_end': verseEnd,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentLocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int?>? verseStart,
    Value<int?>? verseEnd,
    Value<String>? source,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return RecentLocationsCompanion(
      id: id ?? this.id,
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verseStart: verseStart ?? this.verseStart,
      verseEnd: verseEnd ?? this.verseEnd,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verseStart.present) {
      map['verse_start'] = Variable<int>(verseStart.value);
    }
    if (verseEnd.present) {
      map['verse_end'] = Variable<int>(verseEnd.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentLocationsCompanion(')
          ..write('id: $id, ')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verseStart: $verseStart, ')
          ..write('verseEnd: $verseEnd, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReaderPreferencesTable extends ReaderPreferences
    with TableInfo<$ReaderPreferencesTable, ReaderPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReaderPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('light'),
  );
  static const VerificationMeta _fontScaleMeta = const VerificationMeta(
    'fontScale',
  );
  @override
  late final GeneratedColumn<double> fontScale = GeneratedColumn<double>(
    'font_scale',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _lineHeightMeta = const VerificationMeta(
    'lineHeight',
  );
  @override
  late final GeneratedColumn<double> lineHeight = GeneratedColumn<double>(
    'line_height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.75),
  );
  static const VerificationMeta _verseSpacingMeta = const VerificationMeta(
    'verseSpacing',
  );
  @override
  late final GeneratedColumn<double> verseSpacing = GeneratedColumn<double>(
    'verse_spacing',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(10.0),
  );
  static const VerificationMeta _pageHorizontalPaddingMeta =
      const VerificationMeta('pageHorizontalPadding');
  @override
  late final GeneratedColumn<double> pageHorizontalPadding =
      GeneratedColumn<double>(
        'page_horizontal_padding',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(18.0),
      );
  static const VerificationMeta _backgroundColorValueMeta =
      const VerificationMeta('backgroundColorValue');
  @override
  late final GeneratedColumn<int> backgroundColorValue = GeneratedColumn<int>(
    'background_color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFFFBF7EF),
  );
  static const VerificationMeta _sliderSideMeta = const VerificationMeta(
    'sliderSide',
  );
  @override
  late final GeneratedColumn<String> sliderSide = GeneratedColumn<String>(
    'slider_side',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('right'),
  );
  static const VerificationMeta _lastTranslationIdMeta = const VerificationMeta(
    'lastTranslationId',
  );
  @override
  late final GeneratedColumn<String> lastTranslationId =
      GeneratedColumn<String>(
        'last_translation_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastBookIdMeta = const VerificationMeta(
    'lastBookId',
  );
  @override
  late final GeneratedColumn<int> lastBookId = GeneratedColumn<int>(
    'last_book_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastChapterMeta = const VerificationMeta(
    'lastChapter',
  );
  @override
  late final GeneratedColumn<int> lastChapter = GeneratedColumn<int>(
    'last_chapter',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastVerseMeta = const VerificationMeta(
    'lastVerse',
  );
  @override
  late final GeneratedColumn<int> lastVerse = GeneratedColumn<int>(
    'last_verse',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _embeddingBaseUrlMeta = const VerificationMeta(
    'embeddingBaseUrl',
  );
  @override
  late final GeneratedColumn<String> embeddingBaseUrl = GeneratedColumn<String>(
    'embedding_base_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _embeddingApiKeyMeta = const VerificationMeta(
    'embeddingApiKey',
  );
  @override
  late final GeneratedColumn<String> embeddingApiKey = GeneratedColumn<String>(
    'embedding_api_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _embeddingModelMeta = const VerificationMeta(
    'embeddingModel',
  );
  @override
  late final GeneratedColumn<String> embeddingModel = GeneratedColumn<String>(
    'embedding_model',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _defaultEmbeddingAccessUnlockedMeta =
      const VerificationMeta('defaultEmbeddingAccessUnlocked');
  @override
  late final GeneratedColumn<bool> defaultEmbeddingAccessUnlocked =
      GeneratedColumn<bool>(
        'default_embedding_access_unlocked',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("default_embedding_access_unlocked" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    fontScale,
    lineHeight,
    verseSpacing,
    pageHorizontalPadding,
    backgroundColorValue,
    sliderSide,
    lastTranslationId,
    lastBookId,
    lastChapter,
    lastVerse,
    embeddingBaseUrl,
    embeddingApiKey,
    embeddingModel,
    defaultEmbeddingAccessUnlocked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reader_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReaderPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('font_scale')) {
      context.handle(
        _fontScaleMeta,
        fontScale.isAcceptableOrUnknown(data['font_scale']!, _fontScaleMeta),
      );
    }
    if (data.containsKey('line_height')) {
      context.handle(
        _lineHeightMeta,
        lineHeight.isAcceptableOrUnknown(data['line_height']!, _lineHeightMeta),
      );
    }
    if (data.containsKey('verse_spacing')) {
      context.handle(
        _verseSpacingMeta,
        verseSpacing.isAcceptableOrUnknown(
          data['verse_spacing']!,
          _verseSpacingMeta,
        ),
      );
    }
    if (data.containsKey('page_horizontal_padding')) {
      context.handle(
        _pageHorizontalPaddingMeta,
        pageHorizontalPadding.isAcceptableOrUnknown(
          data['page_horizontal_padding']!,
          _pageHorizontalPaddingMeta,
        ),
      );
    }
    if (data.containsKey('background_color_value')) {
      context.handle(
        _backgroundColorValueMeta,
        backgroundColorValue.isAcceptableOrUnknown(
          data['background_color_value']!,
          _backgroundColorValueMeta,
        ),
      );
    }
    if (data.containsKey('slider_side')) {
      context.handle(
        _sliderSideMeta,
        sliderSide.isAcceptableOrUnknown(data['slider_side']!, _sliderSideMeta),
      );
    }
    if (data.containsKey('last_translation_id')) {
      context.handle(
        _lastTranslationIdMeta,
        lastTranslationId.isAcceptableOrUnknown(
          data['last_translation_id']!,
          _lastTranslationIdMeta,
        ),
      );
    }
    if (data.containsKey('last_book_id')) {
      context.handle(
        _lastBookIdMeta,
        lastBookId.isAcceptableOrUnknown(
          data['last_book_id']!,
          _lastBookIdMeta,
        ),
      );
    }
    if (data.containsKey('last_chapter')) {
      context.handle(
        _lastChapterMeta,
        lastChapter.isAcceptableOrUnknown(
          data['last_chapter']!,
          _lastChapterMeta,
        ),
      );
    }
    if (data.containsKey('last_verse')) {
      context.handle(
        _lastVerseMeta,
        lastVerse.isAcceptableOrUnknown(data['last_verse']!, _lastVerseMeta),
      );
    }
    if (data.containsKey('embedding_base_url')) {
      context.handle(
        _embeddingBaseUrlMeta,
        embeddingBaseUrl.isAcceptableOrUnknown(
          data['embedding_base_url']!,
          _embeddingBaseUrlMeta,
        ),
      );
    }
    if (data.containsKey('embedding_api_key')) {
      context.handle(
        _embeddingApiKeyMeta,
        embeddingApiKey.isAcceptableOrUnknown(
          data['embedding_api_key']!,
          _embeddingApiKeyMeta,
        ),
      );
    }
    if (data.containsKey('embedding_model')) {
      context.handle(
        _embeddingModelMeta,
        embeddingModel.isAcceptableOrUnknown(
          data['embedding_model']!,
          _embeddingModelMeta,
        ),
      );
    }
    if (data.containsKey('default_embedding_access_unlocked')) {
      context.handle(
        _defaultEmbeddingAccessUnlockedMeta,
        defaultEmbeddingAccessUnlocked.isAcceptableOrUnknown(
          data['default_embedding_access_unlocked']!,
          _defaultEmbeddingAccessUnlockedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReaderPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReaderPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      fontScale: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}font_scale'],
      )!,
      lineHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}line_height'],
      )!,
      verseSpacing: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}verse_spacing'],
      )!,
      pageHorizontalPadding: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}page_horizontal_padding'],
      )!,
      backgroundColorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}background_color_value'],
      )!,
      sliderSide: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slider_side'],
      )!,
      lastTranslationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_translation_id'],
      ),
      lastBookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_book_id'],
      ),
      lastChapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_chapter'],
      ),
      lastVerse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_verse'],
      ),
      embeddingBaseUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}embedding_base_url'],
      )!,
      embeddingApiKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}embedding_api_key'],
      )!,
      embeddingModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}embedding_model'],
      )!,
      defaultEmbeddingAccessUnlocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}default_embedding_access_unlocked'],
      )!,
    );
  }

  @override
  $ReaderPreferencesTable createAlias(String alias) {
    return $ReaderPreferencesTable(attachedDatabase, alias);
  }
}

class ReaderPreference extends DataClass
    implements Insertable<ReaderPreference> {
  final int id;
  final String themeMode;
  final double fontScale;
  final double lineHeight;
  final double verseSpacing;
  final double pageHorizontalPadding;
  final int backgroundColorValue;
  final String sliderSide;
  final String? lastTranslationId;
  final int? lastBookId;
  final int? lastChapter;
  final int? lastVerse;
  final String embeddingBaseUrl;
  final String embeddingApiKey;
  final String embeddingModel;
  final bool defaultEmbeddingAccessUnlocked;
  const ReaderPreference({
    required this.id,
    required this.themeMode,
    required this.fontScale,
    required this.lineHeight,
    required this.verseSpacing,
    required this.pageHorizontalPadding,
    required this.backgroundColorValue,
    required this.sliderSide,
    this.lastTranslationId,
    this.lastBookId,
    this.lastChapter,
    this.lastVerse,
    required this.embeddingBaseUrl,
    required this.embeddingApiKey,
    required this.embeddingModel,
    required this.defaultEmbeddingAccessUnlocked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['font_scale'] = Variable<double>(fontScale);
    map['line_height'] = Variable<double>(lineHeight);
    map['verse_spacing'] = Variable<double>(verseSpacing);
    map['page_horizontal_padding'] = Variable<double>(pageHorizontalPadding);
    map['background_color_value'] = Variable<int>(backgroundColorValue);
    map['slider_side'] = Variable<String>(sliderSide);
    if (!nullToAbsent || lastTranslationId != null) {
      map['last_translation_id'] = Variable<String>(lastTranslationId);
    }
    if (!nullToAbsent || lastBookId != null) {
      map['last_book_id'] = Variable<int>(lastBookId);
    }
    if (!nullToAbsent || lastChapter != null) {
      map['last_chapter'] = Variable<int>(lastChapter);
    }
    if (!nullToAbsent || lastVerse != null) {
      map['last_verse'] = Variable<int>(lastVerse);
    }
    map['embedding_base_url'] = Variable<String>(embeddingBaseUrl);
    map['embedding_api_key'] = Variable<String>(embeddingApiKey);
    map['embedding_model'] = Variable<String>(embeddingModel);
    map['default_embedding_access_unlocked'] = Variable<bool>(
      defaultEmbeddingAccessUnlocked,
    );
    return map;
  }

  ReaderPreferencesCompanion toCompanion(bool nullToAbsent) {
    return ReaderPreferencesCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      fontScale: Value(fontScale),
      lineHeight: Value(lineHeight),
      verseSpacing: Value(verseSpacing),
      pageHorizontalPadding: Value(pageHorizontalPadding),
      backgroundColorValue: Value(backgroundColorValue),
      sliderSide: Value(sliderSide),
      lastTranslationId: lastTranslationId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTranslationId),
      lastBookId: lastBookId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBookId),
      lastChapter: lastChapter == null && nullToAbsent
          ? const Value.absent()
          : Value(lastChapter),
      lastVerse: lastVerse == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVerse),
      embeddingBaseUrl: Value(embeddingBaseUrl),
      embeddingApiKey: Value(embeddingApiKey),
      embeddingModel: Value(embeddingModel),
      defaultEmbeddingAccessUnlocked: Value(defaultEmbeddingAccessUnlocked),
    );
  }

  factory ReaderPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReaderPreference(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      fontScale: serializer.fromJson<double>(json['fontScale']),
      lineHeight: serializer.fromJson<double>(json['lineHeight']),
      verseSpacing: serializer.fromJson<double>(json['verseSpacing']),
      pageHorizontalPadding: serializer.fromJson<double>(
        json['pageHorizontalPadding'],
      ),
      backgroundColorValue: serializer.fromJson<int>(
        json['backgroundColorValue'],
      ),
      sliderSide: serializer.fromJson<String>(json['sliderSide']),
      lastTranslationId: serializer.fromJson<String?>(
        json['lastTranslationId'],
      ),
      lastBookId: serializer.fromJson<int?>(json['lastBookId']),
      lastChapter: serializer.fromJson<int?>(json['lastChapter']),
      lastVerse: serializer.fromJson<int?>(json['lastVerse']),
      embeddingBaseUrl: serializer.fromJson<String>(json['embeddingBaseUrl']),
      embeddingApiKey: serializer.fromJson<String>(json['embeddingApiKey']),
      embeddingModel: serializer.fromJson<String>(json['embeddingModel']),
      defaultEmbeddingAccessUnlocked: serializer.fromJson<bool>(
        json['defaultEmbeddingAccessUnlocked'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'fontScale': serializer.toJson<double>(fontScale),
      'lineHeight': serializer.toJson<double>(lineHeight),
      'verseSpacing': serializer.toJson<double>(verseSpacing),
      'pageHorizontalPadding': serializer.toJson<double>(pageHorizontalPadding),
      'backgroundColorValue': serializer.toJson<int>(backgroundColorValue),
      'sliderSide': serializer.toJson<String>(sliderSide),
      'lastTranslationId': serializer.toJson<String?>(lastTranslationId),
      'lastBookId': serializer.toJson<int?>(lastBookId),
      'lastChapter': serializer.toJson<int?>(lastChapter),
      'lastVerse': serializer.toJson<int?>(lastVerse),
      'embeddingBaseUrl': serializer.toJson<String>(embeddingBaseUrl),
      'embeddingApiKey': serializer.toJson<String>(embeddingApiKey),
      'embeddingModel': serializer.toJson<String>(embeddingModel),
      'defaultEmbeddingAccessUnlocked': serializer.toJson<bool>(
        defaultEmbeddingAccessUnlocked,
      ),
    };
  }

  ReaderPreference copyWith({
    int? id,
    String? themeMode,
    double? fontScale,
    double? lineHeight,
    double? verseSpacing,
    double? pageHorizontalPadding,
    int? backgroundColorValue,
    String? sliderSide,
    Value<String?> lastTranslationId = const Value.absent(),
    Value<int?> lastBookId = const Value.absent(),
    Value<int?> lastChapter = const Value.absent(),
    Value<int?> lastVerse = const Value.absent(),
    String? embeddingBaseUrl,
    String? embeddingApiKey,
    String? embeddingModel,
    bool? defaultEmbeddingAccessUnlocked,
  }) => ReaderPreference(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    fontScale: fontScale ?? this.fontScale,
    lineHeight: lineHeight ?? this.lineHeight,
    verseSpacing: verseSpacing ?? this.verseSpacing,
    pageHorizontalPadding: pageHorizontalPadding ?? this.pageHorizontalPadding,
    backgroundColorValue: backgroundColorValue ?? this.backgroundColorValue,
    sliderSide: sliderSide ?? this.sliderSide,
    lastTranslationId: lastTranslationId.present
        ? lastTranslationId.value
        : this.lastTranslationId,
    lastBookId: lastBookId.present ? lastBookId.value : this.lastBookId,
    lastChapter: lastChapter.present ? lastChapter.value : this.lastChapter,
    lastVerse: lastVerse.present ? lastVerse.value : this.lastVerse,
    embeddingBaseUrl: embeddingBaseUrl ?? this.embeddingBaseUrl,
    embeddingApiKey: embeddingApiKey ?? this.embeddingApiKey,
    embeddingModel: embeddingModel ?? this.embeddingModel,
    defaultEmbeddingAccessUnlocked:
        defaultEmbeddingAccessUnlocked ?? this.defaultEmbeddingAccessUnlocked,
  );
  ReaderPreference copyWithCompanion(ReaderPreferencesCompanion data) {
    return ReaderPreference(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      fontScale: data.fontScale.present ? data.fontScale.value : this.fontScale,
      lineHeight: data.lineHeight.present
          ? data.lineHeight.value
          : this.lineHeight,
      verseSpacing: data.verseSpacing.present
          ? data.verseSpacing.value
          : this.verseSpacing,
      pageHorizontalPadding: data.pageHorizontalPadding.present
          ? data.pageHorizontalPadding.value
          : this.pageHorizontalPadding,
      backgroundColorValue: data.backgroundColorValue.present
          ? data.backgroundColorValue.value
          : this.backgroundColorValue,
      sliderSide: data.sliderSide.present
          ? data.sliderSide.value
          : this.sliderSide,
      lastTranslationId: data.lastTranslationId.present
          ? data.lastTranslationId.value
          : this.lastTranslationId,
      lastBookId: data.lastBookId.present
          ? data.lastBookId.value
          : this.lastBookId,
      lastChapter: data.lastChapter.present
          ? data.lastChapter.value
          : this.lastChapter,
      lastVerse: data.lastVerse.present ? data.lastVerse.value : this.lastVerse,
      embeddingBaseUrl: data.embeddingBaseUrl.present
          ? data.embeddingBaseUrl.value
          : this.embeddingBaseUrl,
      embeddingApiKey: data.embeddingApiKey.present
          ? data.embeddingApiKey.value
          : this.embeddingApiKey,
      embeddingModel: data.embeddingModel.present
          ? data.embeddingModel.value
          : this.embeddingModel,
      defaultEmbeddingAccessUnlocked:
          data.defaultEmbeddingAccessUnlocked.present
          ? data.defaultEmbeddingAccessUnlocked.value
          : this.defaultEmbeddingAccessUnlocked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReaderPreference(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('fontScale: $fontScale, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('verseSpacing: $verseSpacing, ')
          ..write('pageHorizontalPadding: $pageHorizontalPadding, ')
          ..write('backgroundColorValue: $backgroundColorValue, ')
          ..write('sliderSide: $sliderSide, ')
          ..write('lastTranslationId: $lastTranslationId, ')
          ..write('lastBookId: $lastBookId, ')
          ..write('lastChapter: $lastChapter, ')
          ..write('lastVerse: $lastVerse, ')
          ..write('embeddingBaseUrl: $embeddingBaseUrl, ')
          ..write('embeddingApiKey: $embeddingApiKey, ')
          ..write('embeddingModel: $embeddingModel, ')
          ..write(
            'defaultEmbeddingAccessUnlocked: $defaultEmbeddingAccessUnlocked',
          )
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    fontScale,
    lineHeight,
    verseSpacing,
    pageHorizontalPadding,
    backgroundColorValue,
    sliderSide,
    lastTranslationId,
    lastBookId,
    lastChapter,
    lastVerse,
    embeddingBaseUrl,
    embeddingApiKey,
    embeddingModel,
    defaultEmbeddingAccessUnlocked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReaderPreference &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.fontScale == this.fontScale &&
          other.lineHeight == this.lineHeight &&
          other.verseSpacing == this.verseSpacing &&
          other.pageHorizontalPadding == this.pageHorizontalPadding &&
          other.backgroundColorValue == this.backgroundColorValue &&
          other.sliderSide == this.sliderSide &&
          other.lastTranslationId == this.lastTranslationId &&
          other.lastBookId == this.lastBookId &&
          other.lastChapter == this.lastChapter &&
          other.lastVerse == this.lastVerse &&
          other.embeddingBaseUrl == this.embeddingBaseUrl &&
          other.embeddingApiKey == this.embeddingApiKey &&
          other.embeddingModel == this.embeddingModel &&
          other.defaultEmbeddingAccessUnlocked ==
              this.defaultEmbeddingAccessUnlocked);
}

class ReaderPreferencesCompanion extends UpdateCompanion<ReaderPreference> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<double> fontScale;
  final Value<double> lineHeight;
  final Value<double> verseSpacing;
  final Value<double> pageHorizontalPadding;
  final Value<int> backgroundColorValue;
  final Value<String> sliderSide;
  final Value<String?> lastTranslationId;
  final Value<int?> lastBookId;
  final Value<int?> lastChapter;
  final Value<int?> lastVerse;
  final Value<String> embeddingBaseUrl;
  final Value<String> embeddingApiKey;
  final Value<String> embeddingModel;
  final Value<bool> defaultEmbeddingAccessUnlocked;
  const ReaderPreferencesCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.fontScale = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.verseSpacing = const Value.absent(),
    this.pageHorizontalPadding = const Value.absent(),
    this.backgroundColorValue = const Value.absent(),
    this.sliderSide = const Value.absent(),
    this.lastTranslationId = const Value.absent(),
    this.lastBookId = const Value.absent(),
    this.lastChapter = const Value.absent(),
    this.lastVerse = const Value.absent(),
    this.embeddingBaseUrl = const Value.absent(),
    this.embeddingApiKey = const Value.absent(),
    this.embeddingModel = const Value.absent(),
    this.defaultEmbeddingAccessUnlocked = const Value.absent(),
  });
  ReaderPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.fontScale = const Value.absent(),
    this.lineHeight = const Value.absent(),
    this.verseSpacing = const Value.absent(),
    this.pageHorizontalPadding = const Value.absent(),
    this.backgroundColorValue = const Value.absent(),
    this.sliderSide = const Value.absent(),
    this.lastTranslationId = const Value.absent(),
    this.lastBookId = const Value.absent(),
    this.lastChapter = const Value.absent(),
    this.lastVerse = const Value.absent(),
    this.embeddingBaseUrl = const Value.absent(),
    this.embeddingApiKey = const Value.absent(),
    this.embeddingModel = const Value.absent(),
    this.defaultEmbeddingAccessUnlocked = const Value.absent(),
  });
  static Insertable<ReaderPreference> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<double>? fontScale,
    Expression<double>? lineHeight,
    Expression<double>? verseSpacing,
    Expression<double>? pageHorizontalPadding,
    Expression<int>? backgroundColorValue,
    Expression<String>? sliderSide,
    Expression<String>? lastTranslationId,
    Expression<int>? lastBookId,
    Expression<int>? lastChapter,
    Expression<int>? lastVerse,
    Expression<String>? embeddingBaseUrl,
    Expression<String>? embeddingApiKey,
    Expression<String>? embeddingModel,
    Expression<bool>? defaultEmbeddingAccessUnlocked,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (fontScale != null) 'font_scale': fontScale,
      if (lineHeight != null) 'line_height': lineHeight,
      if (verseSpacing != null) 'verse_spacing': verseSpacing,
      if (pageHorizontalPadding != null)
        'page_horizontal_padding': pageHorizontalPadding,
      if (backgroundColorValue != null)
        'background_color_value': backgroundColorValue,
      if (sliderSide != null) 'slider_side': sliderSide,
      if (lastTranslationId != null) 'last_translation_id': lastTranslationId,
      if (lastBookId != null) 'last_book_id': lastBookId,
      if (lastChapter != null) 'last_chapter': lastChapter,
      if (lastVerse != null) 'last_verse': lastVerse,
      if (embeddingBaseUrl != null) 'embedding_base_url': embeddingBaseUrl,
      if (embeddingApiKey != null) 'embedding_api_key': embeddingApiKey,
      if (embeddingModel != null) 'embedding_model': embeddingModel,
      if (defaultEmbeddingAccessUnlocked != null)
        'default_embedding_access_unlocked': defaultEmbeddingAccessUnlocked,
    });
  }

  ReaderPreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<double>? fontScale,
    Value<double>? lineHeight,
    Value<double>? verseSpacing,
    Value<double>? pageHorizontalPadding,
    Value<int>? backgroundColorValue,
    Value<String>? sliderSide,
    Value<String?>? lastTranslationId,
    Value<int?>? lastBookId,
    Value<int?>? lastChapter,
    Value<int?>? lastVerse,
    Value<String>? embeddingBaseUrl,
    Value<String>? embeddingApiKey,
    Value<String>? embeddingModel,
    Value<bool>? defaultEmbeddingAccessUnlocked,
  }) {
    return ReaderPreferencesCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      lineHeight: lineHeight ?? this.lineHeight,
      verseSpacing: verseSpacing ?? this.verseSpacing,
      pageHorizontalPadding:
          pageHorizontalPadding ?? this.pageHorizontalPadding,
      backgroundColorValue: backgroundColorValue ?? this.backgroundColorValue,
      sliderSide: sliderSide ?? this.sliderSide,
      lastTranslationId: lastTranslationId ?? this.lastTranslationId,
      lastBookId: lastBookId ?? this.lastBookId,
      lastChapter: lastChapter ?? this.lastChapter,
      lastVerse: lastVerse ?? this.lastVerse,
      embeddingBaseUrl: embeddingBaseUrl ?? this.embeddingBaseUrl,
      embeddingApiKey: embeddingApiKey ?? this.embeddingApiKey,
      embeddingModel: embeddingModel ?? this.embeddingModel,
      defaultEmbeddingAccessUnlocked:
          defaultEmbeddingAccessUnlocked ?? this.defaultEmbeddingAccessUnlocked,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (fontScale.present) {
      map['font_scale'] = Variable<double>(fontScale.value);
    }
    if (lineHeight.present) {
      map['line_height'] = Variable<double>(lineHeight.value);
    }
    if (verseSpacing.present) {
      map['verse_spacing'] = Variable<double>(verseSpacing.value);
    }
    if (pageHorizontalPadding.present) {
      map['page_horizontal_padding'] = Variable<double>(
        pageHorizontalPadding.value,
      );
    }
    if (backgroundColorValue.present) {
      map['background_color_value'] = Variable<int>(backgroundColorValue.value);
    }
    if (sliderSide.present) {
      map['slider_side'] = Variable<String>(sliderSide.value);
    }
    if (lastTranslationId.present) {
      map['last_translation_id'] = Variable<String>(lastTranslationId.value);
    }
    if (lastBookId.present) {
      map['last_book_id'] = Variable<int>(lastBookId.value);
    }
    if (lastChapter.present) {
      map['last_chapter'] = Variable<int>(lastChapter.value);
    }
    if (lastVerse.present) {
      map['last_verse'] = Variable<int>(lastVerse.value);
    }
    if (embeddingBaseUrl.present) {
      map['embedding_base_url'] = Variable<String>(embeddingBaseUrl.value);
    }
    if (embeddingApiKey.present) {
      map['embedding_api_key'] = Variable<String>(embeddingApiKey.value);
    }
    if (embeddingModel.present) {
      map['embedding_model'] = Variable<String>(embeddingModel.value);
    }
    if (defaultEmbeddingAccessUnlocked.present) {
      map['default_embedding_access_unlocked'] = Variable<bool>(
        defaultEmbeddingAccessUnlocked.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReaderPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('fontScale: $fontScale, ')
          ..write('lineHeight: $lineHeight, ')
          ..write('verseSpacing: $verseSpacing, ')
          ..write('pageHorizontalPadding: $pageHorizontalPadding, ')
          ..write('backgroundColorValue: $backgroundColorValue, ')
          ..write('sliderSide: $sliderSide, ')
          ..write('lastTranslationId: $lastTranslationId, ')
          ..write('lastBookId: $lastBookId, ')
          ..write('lastChapter: $lastChapter, ')
          ..write('lastVerse: $lastVerse, ')
          ..write('embeddingBaseUrl: $embeddingBaseUrl, ')
          ..write('embeddingApiKey: $embeddingApiKey, ')
          ..write('embeddingModel: $embeddingModel, ')
          ..write(
            'defaultEmbeddingAccessUnlocked: $defaultEmbeddingAccessUnlocked',
          )
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InstalledTranslationsTable installedTranslations =
      $InstalledTranslationsTable(this);
  late final $RecentLocationsTable recentLocations = $RecentLocationsTable(
    this,
  );
  late final $ReaderPreferencesTable readerPreferences =
      $ReaderPreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    installedTranslations,
    recentLocations,
    readerPreferences,
  ];
}

typedef $$InstalledTranslationsTableCreateCompanionBuilder =
    InstalledTranslationsCompanion Function({
      required String id,
      required String title,
      required String language,
      required String version,
      required String copyright,
      required String filePath,
      Value<bool> isBuiltin,
      Value<bool> isActive,
      Value<bool> hasSearchIndex,
      Value<bool> hasSemanticIndex,
      required DateTime installedAt,
      Value<int> rowid,
    });
typedef $$InstalledTranslationsTableUpdateCompanionBuilder =
    InstalledTranslationsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> language,
      Value<String> version,
      Value<String> copyright,
      Value<String> filePath,
      Value<bool> isBuiltin,
      Value<bool> isActive,
      Value<bool> hasSearchIndex,
      Value<bool> hasSemanticIndex,
      Value<DateTime> installedAt,
      Value<int> rowid,
    });

class $$InstalledTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $InstalledTranslationsTable> {
  $$InstalledTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get copyright => $composableBuilder(
    column: $table.copyright,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSearchIndex => $composableBuilder(
    column: $table.hasSearchIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSemanticIndex => $composableBuilder(
    column: $table.hasSemanticIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstalledTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $InstalledTranslationsTable> {
  $$InstalledTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get copyright => $composableBuilder(
    column: $table.copyright,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltin => $composableBuilder(
    column: $table.isBuiltin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSearchIndex => $composableBuilder(
    column: $table.hasSearchIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSemanticIndex => $composableBuilder(
    column: $table.hasSemanticIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstalledTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstalledTranslationsTable> {
  $$InstalledTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get copyright =>
      $composableBuilder(column: $table.copyright, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltin =>
      $composableBuilder(column: $table.isBuiltin, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get hasSearchIndex => $composableBuilder(
    column: $table.hasSearchIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasSemanticIndex => $composableBuilder(
    column: $table.hasSemanticIndex,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get installedAt => $composableBuilder(
    column: $table.installedAt,
    builder: (column) => column,
  );
}

class $$InstalledTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstalledTranslationsTable,
          InstalledTranslation,
          $$InstalledTranslationsTableFilterComposer,
          $$InstalledTranslationsTableOrderingComposer,
          $$InstalledTranslationsTableAnnotationComposer,
          $$InstalledTranslationsTableCreateCompanionBuilder,
          $$InstalledTranslationsTableUpdateCompanionBuilder,
          (
            InstalledTranslation,
            BaseReferences<
              _$AppDatabase,
              $InstalledTranslationsTable,
              InstalledTranslation
            >,
          ),
          InstalledTranslation,
          PrefetchHooks Function()
        > {
  $$InstalledTranslationsTableTableManager(
    _$AppDatabase db,
    $InstalledTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstalledTranslationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$InstalledTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InstalledTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> version = const Value.absent(),
                Value<String> copyright = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<bool> isBuiltin = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> hasSearchIndex = const Value.absent(),
                Value<bool> hasSemanticIndex = const Value.absent(),
                Value<DateTime> installedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstalledTranslationsCompanion(
                id: id,
                title: title,
                language: language,
                version: version,
                copyright: copyright,
                filePath: filePath,
                isBuiltin: isBuiltin,
                isActive: isActive,
                hasSearchIndex: hasSearchIndex,
                hasSemanticIndex: hasSemanticIndex,
                installedAt: installedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String language,
                required String version,
                required String copyright,
                required String filePath,
                Value<bool> isBuiltin = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> hasSearchIndex = const Value.absent(),
                Value<bool> hasSemanticIndex = const Value.absent(),
                required DateTime installedAt,
                Value<int> rowid = const Value.absent(),
              }) => InstalledTranslationsCompanion.insert(
                id: id,
                title: title,
                language: language,
                version: version,
                copyright: copyright,
                filePath: filePath,
                isBuiltin: isBuiltin,
                isActive: isActive,
                hasSearchIndex: hasSearchIndex,
                hasSemanticIndex: hasSemanticIndex,
                installedAt: installedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstalledTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstalledTranslationsTable,
      InstalledTranslation,
      $$InstalledTranslationsTableFilterComposer,
      $$InstalledTranslationsTableOrderingComposer,
      $$InstalledTranslationsTableAnnotationComposer,
      $$InstalledTranslationsTableCreateCompanionBuilder,
      $$InstalledTranslationsTableUpdateCompanionBuilder,
      (
        InstalledTranslation,
        BaseReferences<
          _$AppDatabase,
          $InstalledTranslationsTable,
          InstalledTranslation
        >,
      ),
      InstalledTranslation,
      PrefetchHooks Function()
    >;
typedef $$RecentLocationsTableCreateCompanionBuilder =
    RecentLocationsCompanion Function({
      required String id,
      required String translationId,
      required int bookId,
      required int chapter,
      Value<int?> verseStart,
      Value<int?> verseEnd,
      required String source,
      required DateTime createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$RecentLocationsTableUpdateCompanionBuilder =
    RecentLocationsCompanion Function({
      Value<String> id,
      Value<String> translationId,
      Value<int> bookId,
      Value<int> chapter,
      Value<int?> verseStart,
      Value<int?> verseEnd,
      Value<String> source,
      Value<DateTime> createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

class $$RecentLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $RecentLocationsTable> {
  $$RecentLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseStart => $composableBuilder(
    column: $table.verseStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseEnd => $composableBuilder(
    column: $table.verseEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecentLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecentLocationsTable> {
  $$RecentLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bookId => $composableBuilder(
    column: $table.bookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseStart => $composableBuilder(
    column: $table.verseStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseEnd => $composableBuilder(
    column: $table.verseEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecentLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecentLocationsTable> {
  $$RecentLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verseStart => $composableBuilder(
    column: $table.verseStart,
    builder: (column) => column,
  );

  GeneratedColumn<int> get verseEnd =>
      $composableBuilder(column: $table.verseEnd, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );
}

class $$RecentLocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecentLocationsTable,
          RecentLocation,
          $$RecentLocationsTableFilterComposer,
          $$RecentLocationsTableOrderingComposer,
          $$RecentLocationsTableAnnotationComposer,
          $$RecentLocationsTableCreateCompanionBuilder,
          $$RecentLocationsTableUpdateCompanionBuilder,
          (
            RecentLocation,
            BaseReferences<
              _$AppDatabase,
              $RecentLocationsTable,
              RecentLocation
            >,
          ),
          RecentLocation,
          PrefetchHooks Function()
        > {
  $$RecentLocationsTableTableManager(
    _$AppDatabase db,
    $RecentLocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecentLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecentLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecentLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> translationId = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int?> verseStart = const Value.absent(),
                Value<int?> verseEnd = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentLocationsCompanion(
                id: id,
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verseStart: verseStart,
                verseEnd: verseEnd,
                source: source,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String translationId,
                required int bookId,
                required int chapter,
                Value<int?> verseStart = const Value.absent(),
                Value<int?> verseEnd = const Value.absent(),
                required String source,
                required DateTime createdAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecentLocationsCompanion.insert(
                id: id,
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verseStart: verseStart,
                verseEnd: verseEnd,
                source: source,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecentLocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecentLocationsTable,
      RecentLocation,
      $$RecentLocationsTableFilterComposer,
      $$RecentLocationsTableOrderingComposer,
      $$RecentLocationsTableAnnotationComposer,
      $$RecentLocationsTableCreateCompanionBuilder,
      $$RecentLocationsTableUpdateCompanionBuilder,
      (
        RecentLocation,
        BaseReferences<_$AppDatabase, $RecentLocationsTable, RecentLocation>,
      ),
      RecentLocation,
      PrefetchHooks Function()
    >;
typedef $$ReaderPreferencesTableCreateCompanionBuilder =
    ReaderPreferencesCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<double> fontScale,
      Value<double> lineHeight,
      Value<double> verseSpacing,
      Value<double> pageHorizontalPadding,
      Value<int> backgroundColorValue,
      Value<String> sliderSide,
      Value<String?> lastTranslationId,
      Value<int?> lastBookId,
      Value<int?> lastChapter,
      Value<int?> lastVerse,
      Value<String> embeddingBaseUrl,
      Value<String> embeddingApiKey,
      Value<String> embeddingModel,
      Value<bool> defaultEmbeddingAccessUnlocked,
    });
typedef $$ReaderPreferencesTableUpdateCompanionBuilder =
    ReaderPreferencesCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<double> fontScale,
      Value<double> lineHeight,
      Value<double> verseSpacing,
      Value<double> pageHorizontalPadding,
      Value<int> backgroundColorValue,
      Value<String> sliderSide,
      Value<String?> lastTranslationId,
      Value<int?> lastBookId,
      Value<int?> lastChapter,
      Value<int?> lastVerse,
      Value<String> embeddingBaseUrl,
      Value<String> embeddingApiKey,
      Value<String> embeddingModel,
      Value<bool> defaultEmbeddingAccessUnlocked,
    });

class $$ReaderPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fontScale => $composableBuilder(
    column: $table.fontScale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get verseSpacing => $composableBuilder(
    column: $table.verseSpacing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pageHorizontalPadding => $composableBuilder(
    column: $table.pageHorizontalPadding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get backgroundColorValue => $composableBuilder(
    column: $table.backgroundColorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sliderSide => $composableBuilder(
    column: $table.sliderSide,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastTranslationId => $composableBuilder(
    column: $table.lastTranslationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastBookId => $composableBuilder(
    column: $table.lastBookId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastVerse => $composableBuilder(
    column: $table.lastVerse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get embeddingBaseUrl => $composableBuilder(
    column: $table.embeddingBaseUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get embeddingApiKey => $composableBuilder(
    column: $table.embeddingApiKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get embeddingModel => $composableBuilder(
    column: $table.embeddingModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get defaultEmbeddingAccessUnlocked => $composableBuilder(
    column: $table.defaultEmbeddingAccessUnlocked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReaderPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fontScale => $composableBuilder(
    column: $table.fontScale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get verseSpacing => $composableBuilder(
    column: $table.verseSpacing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pageHorizontalPadding => $composableBuilder(
    column: $table.pageHorizontalPadding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get backgroundColorValue => $composableBuilder(
    column: $table.backgroundColorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sliderSide => $composableBuilder(
    column: $table.sliderSide,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastTranslationId => $composableBuilder(
    column: $table.lastTranslationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastBookId => $composableBuilder(
    column: $table.lastBookId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastVerse => $composableBuilder(
    column: $table.lastVerse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embeddingBaseUrl => $composableBuilder(
    column: $table.embeddingBaseUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embeddingApiKey => $composableBuilder(
    column: $table.embeddingApiKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embeddingModel => $composableBuilder(
    column: $table.embeddingModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get defaultEmbeddingAccessUnlocked =>
      $composableBuilder(
        column: $table.defaultEmbeddingAccessUnlocked,
        builder: (column) => ColumnOrderings(column),
      );
}

class $$ReaderPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReaderPreferencesTable> {
  $$ReaderPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<double> get fontScale =>
      $composableBuilder(column: $table.fontScale, builder: (column) => column);

  GeneratedColumn<double> get lineHeight => $composableBuilder(
    column: $table.lineHeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get verseSpacing => $composableBuilder(
    column: $table.verseSpacing,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pageHorizontalPadding => $composableBuilder(
    column: $table.pageHorizontalPadding,
    builder: (column) => column,
  );

  GeneratedColumn<int> get backgroundColorValue => $composableBuilder(
    column: $table.backgroundColorValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sliderSide => $composableBuilder(
    column: $table.sliderSide,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastTranslationId => $composableBuilder(
    column: $table.lastTranslationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastBookId => $composableBuilder(
    column: $table.lastBookId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastVerse =>
      $composableBuilder(column: $table.lastVerse, builder: (column) => column);

  GeneratedColumn<String> get embeddingBaseUrl => $composableBuilder(
    column: $table.embeddingBaseUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get embeddingApiKey => $composableBuilder(
    column: $table.embeddingApiKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get embeddingModel => $composableBuilder(
    column: $table.embeddingModel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get defaultEmbeddingAccessUnlocked =>
      $composableBuilder(
        column: $table.defaultEmbeddingAccessUnlocked,
        builder: (column) => column,
      );
}

class $$ReaderPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReaderPreferencesTable,
          ReaderPreference,
          $$ReaderPreferencesTableFilterComposer,
          $$ReaderPreferencesTableOrderingComposer,
          $$ReaderPreferencesTableAnnotationComposer,
          $$ReaderPreferencesTableCreateCompanionBuilder,
          $$ReaderPreferencesTableUpdateCompanionBuilder,
          (
            ReaderPreference,
            BaseReferences<
              _$AppDatabase,
              $ReaderPreferencesTable,
              ReaderPreference
            >,
          ),
          ReaderPreference,
          PrefetchHooks Function()
        > {
  $$ReaderPreferencesTableTableManager(
    _$AppDatabase db,
    $ReaderPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReaderPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReaderPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReaderPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<double> fontScale = const Value.absent(),
                Value<double> lineHeight = const Value.absent(),
                Value<double> verseSpacing = const Value.absent(),
                Value<double> pageHorizontalPadding = const Value.absent(),
                Value<int> backgroundColorValue = const Value.absent(),
                Value<String> sliderSide = const Value.absent(),
                Value<String?> lastTranslationId = const Value.absent(),
                Value<int?> lastBookId = const Value.absent(),
                Value<int?> lastChapter = const Value.absent(),
                Value<int?> lastVerse = const Value.absent(),
                Value<String> embeddingBaseUrl = const Value.absent(),
                Value<String> embeddingApiKey = const Value.absent(),
                Value<String> embeddingModel = const Value.absent(),
                Value<bool> defaultEmbeddingAccessUnlocked =
                    const Value.absent(),
              }) => ReaderPreferencesCompanion(
                id: id,
                themeMode: themeMode,
                fontScale: fontScale,
                lineHeight: lineHeight,
                verseSpacing: verseSpacing,
                pageHorizontalPadding: pageHorizontalPadding,
                backgroundColorValue: backgroundColorValue,
                sliderSide: sliderSide,
                lastTranslationId: lastTranslationId,
                lastBookId: lastBookId,
                lastChapter: lastChapter,
                lastVerse: lastVerse,
                embeddingBaseUrl: embeddingBaseUrl,
                embeddingApiKey: embeddingApiKey,
                embeddingModel: embeddingModel,
                defaultEmbeddingAccessUnlocked: defaultEmbeddingAccessUnlocked,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<double> fontScale = const Value.absent(),
                Value<double> lineHeight = const Value.absent(),
                Value<double> verseSpacing = const Value.absent(),
                Value<double> pageHorizontalPadding = const Value.absent(),
                Value<int> backgroundColorValue = const Value.absent(),
                Value<String> sliderSide = const Value.absent(),
                Value<String?> lastTranslationId = const Value.absent(),
                Value<int?> lastBookId = const Value.absent(),
                Value<int?> lastChapter = const Value.absent(),
                Value<int?> lastVerse = const Value.absent(),
                Value<String> embeddingBaseUrl = const Value.absent(),
                Value<String> embeddingApiKey = const Value.absent(),
                Value<String> embeddingModel = const Value.absent(),
                Value<bool> defaultEmbeddingAccessUnlocked =
                    const Value.absent(),
              }) => ReaderPreferencesCompanion.insert(
                id: id,
                themeMode: themeMode,
                fontScale: fontScale,
                lineHeight: lineHeight,
                verseSpacing: verseSpacing,
                pageHorizontalPadding: pageHorizontalPadding,
                backgroundColorValue: backgroundColorValue,
                sliderSide: sliderSide,
                lastTranslationId: lastTranslationId,
                lastBookId: lastBookId,
                lastChapter: lastChapter,
                lastVerse: lastVerse,
                embeddingBaseUrl: embeddingBaseUrl,
                embeddingApiKey: embeddingApiKey,
                embeddingModel: embeddingModel,
                defaultEmbeddingAccessUnlocked: defaultEmbeddingAccessUnlocked,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReaderPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReaderPreferencesTable,
      ReaderPreference,
      $$ReaderPreferencesTableFilterComposer,
      $$ReaderPreferencesTableOrderingComposer,
      $$ReaderPreferencesTableAnnotationComposer,
      $$ReaderPreferencesTableCreateCompanionBuilder,
      $$ReaderPreferencesTableUpdateCompanionBuilder,
      (
        ReaderPreference,
        BaseReferences<
          _$AppDatabase,
          $ReaderPreferencesTable,
          ReaderPreference
        >,
      ),
      ReaderPreference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InstalledTranslationsTableTableManager get installedTranslations =>
      $$InstalledTranslationsTableTableManager(_db, _db.installedTranslations);
  $$RecentLocationsTableTableManager get recentLocations =>
      $$RecentLocationsTableTableManager(_db, _db.recentLocations);
  $$ReaderPreferencesTableTableManager get readerPreferences =>
      $$ReaderPreferencesTableTableManager(_db, _db.readerPreferences);
}
