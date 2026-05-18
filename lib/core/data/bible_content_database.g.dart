// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_content_database.dart';

// ignore_for_file: type=lint
class $ContentTranslationsTable extends ContentTranslations
    with TableInfo<$ContentTranslationsTable, ContentTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentTranslationsTable(this.attachedDatabase, [this._alias]);
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    language,
    version,
    copyright,
    hasSearchIndex,
    hasSemanticIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentTranslation> instance, {
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentTranslation(
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
      hasSearchIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_search_index'],
      )!,
      hasSemanticIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_semantic_index'],
      )!,
    );
  }

  @override
  $ContentTranslationsTable createAlias(String alias) {
    return $ContentTranslationsTable(attachedDatabase, alias);
  }
}

class ContentTranslation extends DataClass
    implements Insertable<ContentTranslation> {
  final String id;
  final String title;
  final String language;
  final String version;
  final String copyright;
  final bool hasSearchIndex;
  final bool hasSemanticIndex;
  const ContentTranslation({
    required this.id,
    required this.title,
    required this.language,
    required this.version,
    required this.copyright,
    required this.hasSearchIndex,
    required this.hasSemanticIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['language'] = Variable<String>(language);
    map['version'] = Variable<String>(version);
    map['copyright'] = Variable<String>(copyright);
    map['has_search_index'] = Variable<bool>(hasSearchIndex);
    map['has_semantic_index'] = Variable<bool>(hasSemanticIndex);
    return map;
  }

  ContentTranslationsCompanion toCompanion(bool nullToAbsent) {
    return ContentTranslationsCompanion(
      id: Value(id),
      title: Value(title),
      language: Value(language),
      version: Value(version),
      copyright: Value(copyright),
      hasSearchIndex: Value(hasSearchIndex),
      hasSemanticIndex: Value(hasSemanticIndex),
    );
  }

  factory ContentTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentTranslation(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      language: serializer.fromJson<String>(json['language']),
      version: serializer.fromJson<String>(json['version']),
      copyright: serializer.fromJson<String>(json['copyright']),
      hasSearchIndex: serializer.fromJson<bool>(json['hasSearchIndex']),
      hasSemanticIndex: serializer.fromJson<bool>(json['hasSemanticIndex']),
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
      'hasSearchIndex': serializer.toJson<bool>(hasSearchIndex),
      'hasSemanticIndex': serializer.toJson<bool>(hasSemanticIndex),
    };
  }

  ContentTranslation copyWith({
    String? id,
    String? title,
    String? language,
    String? version,
    String? copyright,
    bool? hasSearchIndex,
    bool? hasSemanticIndex,
  }) => ContentTranslation(
    id: id ?? this.id,
    title: title ?? this.title,
    language: language ?? this.language,
    version: version ?? this.version,
    copyright: copyright ?? this.copyright,
    hasSearchIndex: hasSearchIndex ?? this.hasSearchIndex,
    hasSemanticIndex: hasSemanticIndex ?? this.hasSemanticIndex,
  );
  ContentTranslation copyWithCompanion(ContentTranslationsCompanion data) {
    return ContentTranslation(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      language: data.language.present ? data.language.value : this.language,
      version: data.version.present ? data.version.value : this.version,
      copyright: data.copyright.present ? data.copyright.value : this.copyright,
      hasSearchIndex: data.hasSearchIndex.present
          ? data.hasSearchIndex.value
          : this.hasSearchIndex,
      hasSemanticIndex: data.hasSemanticIndex.present
          ? data.hasSemanticIndex.value
          : this.hasSemanticIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentTranslation(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('version: $version, ')
          ..write('copyright: $copyright, ')
          ..write('hasSearchIndex: $hasSearchIndex, ')
          ..write('hasSemanticIndex: $hasSemanticIndex')
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
    hasSearchIndex,
    hasSemanticIndex,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentTranslation &&
          other.id == this.id &&
          other.title == this.title &&
          other.language == this.language &&
          other.version == this.version &&
          other.copyright == this.copyright &&
          other.hasSearchIndex == this.hasSearchIndex &&
          other.hasSemanticIndex == this.hasSemanticIndex);
}

class ContentTranslationsCompanion extends UpdateCompanion<ContentTranslation> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> language;
  final Value<String> version;
  final Value<String> copyright;
  final Value<bool> hasSearchIndex;
  final Value<bool> hasSemanticIndex;
  final Value<int> rowid;
  const ContentTranslationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.language = const Value.absent(),
    this.version = const Value.absent(),
    this.copyright = const Value.absent(),
    this.hasSearchIndex = const Value.absent(),
    this.hasSemanticIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentTranslationsCompanion.insert({
    required String id,
    required String title,
    required String language,
    required String version,
    required String copyright,
    this.hasSearchIndex = const Value.absent(),
    this.hasSemanticIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       language = Value(language),
       version = Value(version),
       copyright = Value(copyright);
  static Insertable<ContentTranslation> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? language,
    Expression<String>? version,
    Expression<String>? copyright,
    Expression<bool>? hasSearchIndex,
    Expression<bool>? hasSemanticIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (language != null) 'language': language,
      if (version != null) 'version': version,
      if (copyright != null) 'copyright': copyright,
      if (hasSearchIndex != null) 'has_search_index': hasSearchIndex,
      if (hasSemanticIndex != null) 'has_semantic_index': hasSemanticIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentTranslationsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? language,
    Value<String>? version,
    Value<String>? copyright,
    Value<bool>? hasSearchIndex,
    Value<bool>? hasSemanticIndex,
    Value<int>? rowid,
  }) {
    return ContentTranslationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      language: language ?? this.language,
      version: version ?? this.version,
      copyright: copyright ?? this.copyright,
      hasSearchIndex: hasSearchIndex ?? this.hasSearchIndex,
      hasSemanticIndex: hasSemanticIndex ?? this.hasSemanticIndex,
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
    if (hasSearchIndex.present) {
      map['has_search_index'] = Variable<bool>(hasSearchIndex.value);
    }
    if (hasSemanticIndex.present) {
      map['has_semantic_index'] = Variable<bool>(hasSemanticIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('version: $version, ')
          ..write('copyright: $copyright, ')
          ..write('hasSearchIndex: $hasSearchIndex, ')
          ..write('hasSemanticIndex: $hasSemanticIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _abbreviationMeta = const VerificationMeta(
    'abbreviation',
  );
  @override
  late final GeneratedColumn<String> abbreviation = GeneratedColumn<String>(
    'abbreviation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _testamentMeta = const VerificationMeta(
    'testament',
  );
  @override
  late final GeneratedColumn<String> testament = GeneratedColumn<String>(
    'testament',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterCountMeta = const VerificationMeta(
    'chapterCount',
  );
  @override
  late final GeneratedColumn<int> chapterCount = GeneratedColumn<int>(
    'chapter_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    abbreviation,
    name,
    testament,
    sortOrder,
    chapterCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('abbreviation')) {
      context.handle(
        _abbreviationMeta,
        abbreviation.isAcceptableOrUnknown(
          data['abbreviation']!,
          _abbreviationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_abbreviationMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('testament')) {
      context.handle(
        _testamentMeta,
        testament.isAcceptableOrUnknown(data['testament']!, _testamentMeta),
      );
    } else if (isInserting) {
      context.missing(_testamentMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('chapter_count')) {
      context.handle(
        _chapterCountMeta,
        chapterCount.isAcceptableOrUnknown(
          data['chapter_count']!,
          _chapterCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chapterCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      abbreviation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}abbreviation'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      testament: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}testament'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      chapterCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_count'],
      )!,
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final int id;
  final String abbreviation;
  final String name;
  final String testament;
  final int sortOrder;
  final int chapterCount;
  const Book({
    required this.id,
    required this.abbreviation,
    required this.name,
    required this.testament,
    required this.sortOrder,
    required this.chapterCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['abbreviation'] = Variable<String>(abbreviation);
    map['name'] = Variable<String>(name);
    map['testament'] = Variable<String>(testament);
    map['sort_order'] = Variable<int>(sortOrder);
    map['chapter_count'] = Variable<int>(chapterCount);
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      abbreviation: Value(abbreviation),
      name: Value(name),
      testament: Value(testament),
      sortOrder: Value(sortOrder),
      chapterCount: Value(chapterCount),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int>(json['id']),
      abbreviation: serializer.fromJson<String>(json['abbreviation']),
      name: serializer.fromJson<String>(json['name']),
      testament: serializer.fromJson<String>(json['testament']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      chapterCount: serializer.fromJson<int>(json['chapterCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'abbreviation': serializer.toJson<String>(abbreviation),
      'name': serializer.toJson<String>(name),
      'testament': serializer.toJson<String>(testament),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'chapterCount': serializer.toJson<int>(chapterCount),
    };
  }

  Book copyWith({
    int? id,
    String? abbreviation,
    String? name,
    String? testament,
    int? sortOrder,
    int? chapterCount,
  }) => Book(
    id: id ?? this.id,
    abbreviation: abbreviation ?? this.abbreviation,
    name: name ?? this.name,
    testament: testament ?? this.testament,
    sortOrder: sortOrder ?? this.sortOrder,
    chapterCount: chapterCount ?? this.chapterCount,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      abbreviation: data.abbreviation.present
          ? data.abbreviation.value
          : this.abbreviation,
      name: data.name.present ? data.name.value : this.name,
      testament: data.testament.present ? data.testament.value : this.testament,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      chapterCount: data.chapterCount.present
          ? data.chapterCount.value
          : this.chapterCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('name: $name, ')
          ..write('testament: $testament, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('chapterCount: $chapterCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, abbreviation, name, testament, sortOrder, chapterCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.abbreviation == this.abbreviation &&
          other.name == this.name &&
          other.testament == this.testament &&
          other.sortOrder == this.sortOrder &&
          other.chapterCount == this.chapterCount);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<String> abbreviation;
  final Value<String> name;
  final Value<String> testament;
  final Value<int> sortOrder;
  final Value<int> chapterCount;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.abbreviation = const Value.absent(),
    this.name = const Value.absent(),
    this.testament = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.chapterCount = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required String abbreviation,
    required String name,
    required String testament,
    required int sortOrder,
    required int chapterCount,
  }) : abbreviation = Value(abbreviation),
       name = Value(name),
       testament = Value(testament),
       sortOrder = Value(sortOrder),
       chapterCount = Value(chapterCount);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<String>? abbreviation,
    Expression<String>? name,
    Expression<String>? testament,
    Expression<int>? sortOrder,
    Expression<int>? chapterCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (abbreviation != null) 'abbreviation': abbreviation,
      if (name != null) 'name': name,
      if (testament != null) 'testament': testament,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (chapterCount != null) 'chapter_count': chapterCount,
    });
  }

  BooksCompanion copyWith({
    Value<int>? id,
    Value<String>? abbreviation,
    Value<String>? name,
    Value<String>? testament,
    Value<int>? sortOrder,
    Value<int>? chapterCount,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      abbreviation: abbreviation ?? this.abbreviation,
      name: name ?? this.name,
      testament: testament ?? this.testament,
      sortOrder: sortOrder ?? this.sortOrder,
      chapterCount: chapterCount ?? this.chapterCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (abbreviation.present) {
      map['abbreviation'] = Variable<String>(abbreviation.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (testament.present) {
      map['testament'] = Variable<String>(testament.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (chapterCount.present) {
      map['chapter_count'] = Variable<int>(chapterCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('abbreviation: $abbreviation, ')
          ..write('name: $name, ')
          ..write('testament: $testament, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('chapterCount: $chapterCount')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _verseCountMeta = const VerificationMeta(
    'verseCount',
  );
  @override
  late final GeneratedColumn<int> verseCount = GeneratedColumn<int>(
    'verse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    translationId,
    bookId,
    chapter,
    verseCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('verse_count')) {
      context.handle(
        _verseCountMeta,
        verseCount.isAcceptableOrUnknown(data['verse_count']!, _verseCountMeta),
      );
    } else if (isInserting) {
      context.missing(_verseCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {translationId, bookId, chapter};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
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
      verseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_count'],
      )!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String translationId;
  final int bookId;
  final int chapter;
  final int verseCount;
  const Chapter({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verseCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse_count'] = Variable<int>(verseCount);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verseCount: Value(verseCount),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      translationId: serializer.fromJson<String>(json['translationId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verseCount: serializer.fromJson<int>(json['verseCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'translationId': serializer.toJson<String>(translationId),
      'bookId': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verseCount': serializer.toJson<int>(verseCount),
    };
  }

  Chapter copyWith({
    String? translationId,
    int? bookId,
    int? chapter,
    int? verseCount,
  }) => Chapter(
    translationId: translationId ?? this.translationId,
    bookId: bookId ?? this.bookId,
    chapter: chapter ?? this.chapter,
    verseCount: verseCount ?? this.verseCount,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verseCount: data.verseCount.present
          ? data.verseCount.value
          : this.verseCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verseCount: $verseCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(translationId, bookId, chapter, verseCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verseCount == this.verseCount);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verseCount;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verseCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String translationId,
    required int bookId,
    required int chapter,
    required int verseCount,
    this.rowid = const Value.absent(),
  }) : translationId = Value(translationId),
       bookId = Value(bookId),
       chapter = Value(chapter),
       verseCount = Value(verseCount);
  static Insertable<Chapter> custom({
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verseCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verseCount != null) 'verse_count': verseCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verseCount,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verseCount: verseCount ?? this.verseCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verseCount.present) {
      map['verse_count'] = Variable<int>(verseCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verseCount: $verseCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VersesTable extends Verses with TableInfo<$VersesTable, Verse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VersesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseIndexMeta = const VerificationMeta(
    'verseIndex',
  );
  @override
  late final GeneratedColumn<int> verseIndex = GeneratedColumn<int>(
    'verse_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    translationId,
    bookId,
    chapter,
    verse,
    content,
    verseIndex,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['text']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('verse_index')) {
      context.handle(
        _verseIndexMeta,
        verseIndex.isAcceptableOrUnknown(data['verse_index']!, _verseIndexMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    translationId,
    bookId,
    chapter,
    verse,
  };
  @override
  Verse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verse(
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
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      verseIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_index'],
      ),
    );
  }

  @override
  $VersesTable createAlias(String alias) {
    return $VersesTable(attachedDatabase, alias);
  }
}

class Verse extends DataClass implements Insertable<Verse> {
  final String translationId;
  final int bookId;
  final int chapter;
  final int verse;
  final String content;
  final int? verseIndex;
  const Verse({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.verse,
    required this.content,
    this.verseIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['translation_id'] = Variable<String>(translationId);
    map['book_id'] = Variable<int>(bookId);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['text'] = Variable<String>(content);
    if (!nullToAbsent || verseIndex != null) {
      map['verse_index'] = Variable<int>(verseIndex);
    }
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      translationId: Value(translationId),
      bookId: Value(bookId),
      chapter: Value(chapter),
      verse: Value(verse),
      content: Value(content),
      verseIndex: verseIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(verseIndex),
    );
  }

  factory Verse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verse(
      translationId: serializer.fromJson<String>(json['translationId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      content: serializer.fromJson<String>(json['content']),
      verseIndex: serializer.fromJson<int?>(json['verseIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'translationId': serializer.toJson<String>(translationId),
      'bookId': serializer.toJson<int>(bookId),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'content': serializer.toJson<String>(content),
      'verseIndex': serializer.toJson<int?>(verseIndex),
    };
  }

  Verse copyWith({
    String? translationId,
    int? bookId,
    int? chapter,
    int? verse,
    String? content,
    Value<int?> verseIndex = const Value.absent(),
  }) => Verse(
    translationId: translationId ?? this.translationId,
    bookId: bookId ?? this.bookId,
    chapter: chapter ?? this.chapter,
    verse: verse ?? this.verse,
    content: content ?? this.content,
    verseIndex: verseIndex.present ? verseIndex.value : this.verseIndex,
  );
  Verse copyWithCompanion(VersesCompanion data) {
    return Verse(
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      content: data.content.present ? data.content.value : this.content,
      verseIndex: data.verseIndex.present
          ? data.verseIndex.value
          : this.verseIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verse(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('content: $content, ')
          ..write('verseIndex: $verseIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(translationId, bookId, chapter, verse, content, verseIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verse &&
          other.translationId == this.translationId &&
          other.bookId == this.bookId &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.content == this.content &&
          other.verseIndex == this.verseIndex);
}

class VersesCompanion extends UpdateCompanion<Verse> {
  final Value<String> translationId;
  final Value<int> bookId;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> content;
  final Value<int?> verseIndex;
  final Value<int> rowid;
  const VersesCompanion({
    this.translationId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.content = const Value.absent(),
    this.verseIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VersesCompanion.insert({
    required String translationId,
    required int bookId,
    required int chapter,
    required int verse,
    required String content,
    this.verseIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : translationId = Value(translationId),
       bookId = Value(bookId),
       chapter = Value(chapter),
       verse = Value(verse),
       content = Value(content);
  static Insertable<Verse> custom({
    Expression<String>? translationId,
    Expression<int>? bookId,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? content,
    Expression<int>? verseIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (translationId != null) 'translation_id': translationId,
      if (bookId != null) 'book_id': bookId,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (content != null) 'text': content,
      if (verseIndex != null) 'verse_index': verseIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VersesCompanion copyWith({
    Value<String>? translationId,
    Value<int>? bookId,
    Value<int>? chapter,
    Value<int>? verse,
    Value<String>? content,
    Value<int?>? verseIndex,
    Value<int>? rowid,
  }) {
    return VersesCompanion(
      translationId: translationId ?? this.translationId,
      bookId: bookId ?? this.bookId,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      content: content ?? this.content,
      verseIndex: verseIndex ?? this.verseIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (content.present) {
      map['text'] = Variable<String>(content.value);
    }
    if (verseIndex.present) {
      map['verse_index'] = Variable<int>(verseIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('translationId: $translationId, ')
          ..write('bookId: $bookId, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('content: $content, ')
          ..write('verseIndex: $verseIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VerseEmbeddingsTable extends VerseEmbeddings
    with TableInfo<$VerseEmbeddingsTable, VerseEmbedding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerseEmbeddingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _verseIndexMeta = const VerificationMeta(
    'verseIndex',
  );
  @override
  late final GeneratedColumn<int> verseIndex = GeneratedColumn<int>(
    'verse_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dimMeta = const VerificationMeta('dim');
  @override
  late final GeneratedColumn<int> dim = GeneratedColumn<int>(
    'dim',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vectorEncodingMeta = const VerificationMeta(
    'vectorEncoding',
  );
  @override
  late final GeneratedColumn<String> vectorEncoding = GeneratedColumn<String>(
    'vector_encoding',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('f32'),
  );
  static const VerificationMeta _vectorBlobMeta = const VerificationMeta(
    'vectorBlob',
  );
  @override
  late final GeneratedColumn<Uint8List> vectorBlob = GeneratedColumn<Uint8List>(
    'vector_blob',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    translationId,
    verseIndex,
    dim,
    vectorEncoding,
    vectorBlob,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verse_embeddings';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerseEmbedding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('verse_index')) {
      context.handle(
        _verseIndexMeta,
        verseIndex.isAcceptableOrUnknown(data['verse_index']!, _verseIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_verseIndexMeta);
    }
    if (data.containsKey('dim')) {
      context.handle(
        _dimMeta,
        dim.isAcceptableOrUnknown(data['dim']!, _dimMeta),
      );
    } else if (isInserting) {
      context.missing(_dimMeta);
    }
    if (data.containsKey('vector_encoding')) {
      context.handle(
        _vectorEncodingMeta,
        vectorEncoding.isAcceptableOrUnknown(
          data['vector_encoding']!,
          _vectorEncodingMeta,
        ),
      );
    }
    if (data.containsKey('vector_blob')) {
      context.handle(
        _vectorBlobMeta,
        vectorBlob.isAcceptableOrUnknown(data['vector_blob']!, _vectorBlobMeta),
      );
    } else if (isInserting) {
      context.missing(_vectorBlobMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {translationId, verseIndex};
  @override
  VerseEmbedding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseEmbedding(
      translationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_id'],
      )!,
      verseIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_index'],
      )!,
      dim: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dim'],
      )!,
      vectorEncoding: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vector_encoding'],
      )!,
      vectorBlob: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}vector_blob'],
      )!,
    );
  }

  @override
  $VerseEmbeddingsTable createAlias(String alias) {
    return $VerseEmbeddingsTable(attachedDatabase, alias);
  }
}

class VerseEmbedding extends DataClass implements Insertable<VerseEmbedding> {
  final String translationId;
  final int verseIndex;
  final int dim;
  final String vectorEncoding;
  final Uint8List vectorBlob;
  const VerseEmbedding({
    required this.translationId,
    required this.verseIndex,
    required this.dim,
    required this.vectorEncoding,
    required this.vectorBlob,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['translation_id'] = Variable<String>(translationId);
    map['verse_index'] = Variable<int>(verseIndex);
    map['dim'] = Variable<int>(dim);
    map['vector_encoding'] = Variable<String>(vectorEncoding);
    map['vector_blob'] = Variable<Uint8List>(vectorBlob);
    return map;
  }

  VerseEmbeddingsCompanion toCompanion(bool nullToAbsent) {
    return VerseEmbeddingsCompanion(
      translationId: Value(translationId),
      verseIndex: Value(verseIndex),
      dim: Value(dim),
      vectorEncoding: Value(vectorEncoding),
      vectorBlob: Value(vectorBlob),
    );
  }

  factory VerseEmbedding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseEmbedding(
      translationId: serializer.fromJson<String>(json['translationId']),
      verseIndex: serializer.fromJson<int>(json['verseIndex']),
      dim: serializer.fromJson<int>(json['dim']),
      vectorEncoding: serializer.fromJson<String>(json['vectorEncoding']),
      vectorBlob: serializer.fromJson<Uint8List>(json['vectorBlob']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'translationId': serializer.toJson<String>(translationId),
      'verseIndex': serializer.toJson<int>(verseIndex),
      'dim': serializer.toJson<int>(dim),
      'vectorEncoding': serializer.toJson<String>(vectorEncoding),
      'vectorBlob': serializer.toJson<Uint8List>(vectorBlob),
    };
  }

  VerseEmbedding copyWith({
    String? translationId,
    int? verseIndex,
    int? dim,
    String? vectorEncoding,
    Uint8List? vectorBlob,
  }) => VerseEmbedding(
    translationId: translationId ?? this.translationId,
    verseIndex: verseIndex ?? this.verseIndex,
    dim: dim ?? this.dim,
    vectorEncoding: vectorEncoding ?? this.vectorEncoding,
    vectorBlob: vectorBlob ?? this.vectorBlob,
  );
  VerseEmbedding copyWithCompanion(VerseEmbeddingsCompanion data) {
    return VerseEmbedding(
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      verseIndex: data.verseIndex.present
          ? data.verseIndex.value
          : this.verseIndex,
      dim: data.dim.present ? data.dim.value : this.dim,
      vectorEncoding: data.vectorEncoding.present
          ? data.vectorEncoding.value
          : this.vectorEncoding,
      vectorBlob: data.vectorBlob.present
          ? data.vectorBlob.value
          : this.vectorBlob,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseEmbedding(')
          ..write('translationId: $translationId, ')
          ..write('verseIndex: $verseIndex, ')
          ..write('dim: $dim, ')
          ..write('vectorEncoding: $vectorEncoding, ')
          ..write('vectorBlob: $vectorBlob')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    translationId,
    verseIndex,
    dim,
    vectorEncoding,
    $driftBlobEquality.hash(vectorBlob),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseEmbedding &&
          other.translationId == this.translationId &&
          other.verseIndex == this.verseIndex &&
          other.dim == this.dim &&
          other.vectorEncoding == this.vectorEncoding &&
          $driftBlobEquality.equals(other.vectorBlob, this.vectorBlob));
}

class VerseEmbeddingsCompanion extends UpdateCompanion<VerseEmbedding> {
  final Value<String> translationId;
  final Value<int> verseIndex;
  final Value<int> dim;
  final Value<String> vectorEncoding;
  final Value<Uint8List> vectorBlob;
  final Value<int> rowid;
  const VerseEmbeddingsCompanion({
    this.translationId = const Value.absent(),
    this.verseIndex = const Value.absent(),
    this.dim = const Value.absent(),
    this.vectorEncoding = const Value.absent(),
    this.vectorBlob = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VerseEmbeddingsCompanion.insert({
    required String translationId,
    required int verseIndex,
    required int dim,
    this.vectorEncoding = const Value.absent(),
    required Uint8List vectorBlob,
    this.rowid = const Value.absent(),
  }) : translationId = Value(translationId),
       verseIndex = Value(verseIndex),
       dim = Value(dim),
       vectorBlob = Value(vectorBlob);
  static Insertable<VerseEmbedding> custom({
    Expression<String>? translationId,
    Expression<int>? verseIndex,
    Expression<int>? dim,
    Expression<String>? vectorEncoding,
    Expression<Uint8List>? vectorBlob,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (translationId != null) 'translation_id': translationId,
      if (verseIndex != null) 'verse_index': verseIndex,
      if (dim != null) 'dim': dim,
      if (vectorEncoding != null) 'vector_encoding': vectorEncoding,
      if (vectorBlob != null) 'vector_blob': vectorBlob,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VerseEmbeddingsCompanion copyWith({
    Value<String>? translationId,
    Value<int>? verseIndex,
    Value<int>? dim,
    Value<String>? vectorEncoding,
    Value<Uint8List>? vectorBlob,
    Value<int>? rowid,
  }) {
    return VerseEmbeddingsCompanion(
      translationId: translationId ?? this.translationId,
      verseIndex: verseIndex ?? this.verseIndex,
      dim: dim ?? this.dim,
      vectorEncoding: vectorEncoding ?? this.vectorEncoding,
      vectorBlob: vectorBlob ?? this.vectorBlob,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (verseIndex.present) {
      map['verse_index'] = Variable<int>(verseIndex.value);
    }
    if (dim.present) {
      map['dim'] = Variable<int>(dim.value);
    }
    if (vectorEncoding.present) {
      map['vector_encoding'] = Variable<String>(vectorEncoding.value);
    }
    if (vectorBlob.present) {
      map['vector_blob'] = Variable<Uint8List>(vectorBlob.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseEmbeddingsCompanion(')
          ..write('translationId: $translationId, ')
          ..write('verseIndex: $verseIndex, ')
          ..write('dim: $dim, ')
          ..write('vectorEncoding: $vectorEncoding, ')
          ..write('vectorBlob: $vectorBlob, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VerseSemanticNeighborsTable extends VerseSemanticNeighbors
    with TableInfo<$VerseSemanticNeighborsTable, VerseSemanticNeighbor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VerseSemanticNeighborsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sourceVerseIndexMeta = const VerificationMeta(
    'sourceVerseIndex',
  );
  @override
  late final GeneratedColumn<int> sourceVerseIndex = GeneratedColumn<int>(
    'source_verse_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _neighborIndicesBlobMeta =
      const VerificationMeta('neighborIndicesBlob');
  @override
  late final GeneratedColumn<Uint8List> neighborIndicesBlob =
      GeneratedColumn<Uint8List>(
        'neighbor_indices_blob',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    translationId,
    sourceVerseIndex,
    neighborIndicesBlob,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verse_semantic_neighbors';
  @override
  VerificationContext validateIntegrity(
    Insertable<VerseSemanticNeighbor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('source_verse_index')) {
      context.handle(
        _sourceVerseIndexMeta,
        sourceVerseIndex.isAcceptableOrUnknown(
          data['source_verse_index']!,
          _sourceVerseIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceVerseIndexMeta);
    }
    if (data.containsKey('neighbor_indices_blob')) {
      context.handle(
        _neighborIndicesBlobMeta,
        neighborIndicesBlob.isAcceptableOrUnknown(
          data['neighbor_indices_blob']!,
          _neighborIndicesBlobMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_neighborIndicesBlobMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {translationId, sourceVerseIndex};
  @override
  VerseSemanticNeighbor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VerseSemanticNeighbor(
      translationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation_id'],
      )!,
      sourceVerseIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_verse_index'],
      )!,
      neighborIndicesBlob: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}neighbor_indices_blob'],
      )!,
    );
  }

  @override
  $VerseSemanticNeighborsTable createAlias(String alias) {
    return $VerseSemanticNeighborsTable(attachedDatabase, alias);
  }
}

class VerseSemanticNeighbor extends DataClass
    implements Insertable<VerseSemanticNeighbor> {
  final String translationId;
  final int sourceVerseIndex;
  final Uint8List neighborIndicesBlob;
  const VerseSemanticNeighbor({
    required this.translationId,
    required this.sourceVerseIndex,
    required this.neighborIndicesBlob,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['translation_id'] = Variable<String>(translationId);
    map['source_verse_index'] = Variable<int>(sourceVerseIndex);
    map['neighbor_indices_blob'] = Variable<Uint8List>(neighborIndicesBlob);
    return map;
  }

  VerseSemanticNeighborsCompanion toCompanion(bool nullToAbsent) {
    return VerseSemanticNeighborsCompanion(
      translationId: Value(translationId),
      sourceVerseIndex: Value(sourceVerseIndex),
      neighborIndicesBlob: Value(neighborIndicesBlob),
    );
  }

  factory VerseSemanticNeighbor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VerseSemanticNeighbor(
      translationId: serializer.fromJson<String>(json['translationId']),
      sourceVerseIndex: serializer.fromJson<int>(json['sourceVerseIndex']),
      neighborIndicesBlob: serializer.fromJson<Uint8List>(
        json['neighborIndicesBlob'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'translationId': serializer.toJson<String>(translationId),
      'sourceVerseIndex': serializer.toJson<int>(sourceVerseIndex),
      'neighborIndicesBlob': serializer.toJson<Uint8List>(neighborIndicesBlob),
    };
  }

  VerseSemanticNeighbor copyWith({
    String? translationId,
    int? sourceVerseIndex,
    Uint8List? neighborIndicesBlob,
  }) => VerseSemanticNeighbor(
    translationId: translationId ?? this.translationId,
    sourceVerseIndex: sourceVerseIndex ?? this.sourceVerseIndex,
    neighborIndicesBlob: neighborIndicesBlob ?? this.neighborIndicesBlob,
  );
  VerseSemanticNeighbor copyWithCompanion(
    VerseSemanticNeighborsCompanion data,
  ) {
    return VerseSemanticNeighbor(
      translationId: data.translationId.present
          ? data.translationId.value
          : this.translationId,
      sourceVerseIndex: data.sourceVerseIndex.present
          ? data.sourceVerseIndex.value
          : this.sourceVerseIndex,
      neighborIndicesBlob: data.neighborIndicesBlob.present
          ? data.neighborIndicesBlob.value
          : this.neighborIndicesBlob,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VerseSemanticNeighbor(')
          ..write('translationId: $translationId, ')
          ..write('sourceVerseIndex: $sourceVerseIndex, ')
          ..write('neighborIndicesBlob: $neighborIndicesBlob')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    translationId,
    sourceVerseIndex,
    $driftBlobEquality.hash(neighborIndicesBlob),
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VerseSemanticNeighbor &&
          other.translationId == this.translationId &&
          other.sourceVerseIndex == this.sourceVerseIndex &&
          $driftBlobEquality.equals(
            other.neighborIndicesBlob,
            this.neighborIndicesBlob,
          ));
}

class VerseSemanticNeighborsCompanion
    extends UpdateCompanion<VerseSemanticNeighbor> {
  final Value<String> translationId;
  final Value<int> sourceVerseIndex;
  final Value<Uint8List> neighborIndicesBlob;
  final Value<int> rowid;
  const VerseSemanticNeighborsCompanion({
    this.translationId = const Value.absent(),
    this.sourceVerseIndex = const Value.absent(),
    this.neighborIndicesBlob = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VerseSemanticNeighborsCompanion.insert({
    required String translationId,
    required int sourceVerseIndex,
    required Uint8List neighborIndicesBlob,
    this.rowid = const Value.absent(),
  }) : translationId = Value(translationId),
       sourceVerseIndex = Value(sourceVerseIndex),
       neighborIndicesBlob = Value(neighborIndicesBlob);
  static Insertable<VerseSemanticNeighbor> custom({
    Expression<String>? translationId,
    Expression<int>? sourceVerseIndex,
    Expression<Uint8List>? neighborIndicesBlob,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (translationId != null) 'translation_id': translationId,
      if (sourceVerseIndex != null) 'source_verse_index': sourceVerseIndex,
      if (neighborIndicesBlob != null)
        'neighbor_indices_blob': neighborIndicesBlob,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VerseSemanticNeighborsCompanion copyWith({
    Value<String>? translationId,
    Value<int>? sourceVerseIndex,
    Value<Uint8List>? neighborIndicesBlob,
    Value<int>? rowid,
  }) {
    return VerseSemanticNeighborsCompanion(
      translationId: translationId ?? this.translationId,
      sourceVerseIndex: sourceVerseIndex ?? this.sourceVerseIndex,
      neighborIndicesBlob: neighborIndicesBlob ?? this.neighborIndicesBlob,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (translationId.present) {
      map['translation_id'] = Variable<String>(translationId.value);
    }
    if (sourceVerseIndex.present) {
      map['source_verse_index'] = Variable<int>(sourceVerseIndex.value);
    }
    if (neighborIndicesBlob.present) {
      map['neighbor_indices_blob'] = Variable<Uint8List>(
        neighborIndicesBlob.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VerseSemanticNeighborsCompanion(')
          ..write('translationId: $translationId, ')
          ..write('sourceVerseIndex: $sourceVerseIndex, ')
          ..write('neighborIndicesBlob: $neighborIndicesBlob, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$BibleContentDatabase extends GeneratedDatabase {
  _$BibleContentDatabase(QueryExecutor e) : super(e);
  $BibleContentDatabaseManager get managers =>
      $BibleContentDatabaseManager(this);
  late final $ContentTranslationsTable contentTranslations =
      $ContentTranslationsTable(this);
  late final $BooksTable books = $BooksTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $VersesTable verses = $VersesTable(this);
  late final $VerseEmbeddingsTable verseEmbeddings = $VerseEmbeddingsTable(
    this,
  );
  late final $VerseSemanticNeighborsTable verseSemanticNeighbors =
      $VerseSemanticNeighborsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    contentTranslations,
    books,
    chapters,
    verses,
    verseEmbeddings,
    verseSemanticNeighbors,
  ];
}

typedef $$ContentTranslationsTableCreateCompanionBuilder =
    ContentTranslationsCompanion Function({
      required String id,
      required String title,
      required String language,
      required String version,
      required String copyright,
      Value<bool> hasSearchIndex,
      Value<bool> hasSemanticIndex,
      Value<int> rowid,
    });
typedef $$ContentTranslationsTableUpdateCompanionBuilder =
    ContentTranslationsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> language,
      Value<String> version,
      Value<String> copyright,
      Value<bool> hasSearchIndex,
      Value<bool> hasSemanticIndex,
      Value<int> rowid,
    });

class $$ContentTranslationsTableFilterComposer
    extends Composer<_$BibleContentDatabase, $ContentTranslationsTable> {
  $$ContentTranslationsTableFilterComposer({
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

  ColumnFilters<bool> get hasSearchIndex => $composableBuilder(
    column: $table.hasSearchIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSemanticIndex => $composableBuilder(
    column: $table.hasSemanticIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentTranslationsTableOrderingComposer
    extends Composer<_$BibleContentDatabase, $ContentTranslationsTable> {
  $$ContentTranslationsTableOrderingComposer({
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

  ColumnOrderings<bool> get hasSearchIndex => $composableBuilder(
    column: $table.hasSearchIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSemanticIndex => $composableBuilder(
    column: $table.hasSemanticIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentTranslationsTableAnnotationComposer
    extends Composer<_$BibleContentDatabase, $ContentTranslationsTable> {
  $$ContentTranslationsTableAnnotationComposer({
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

  GeneratedColumn<bool> get hasSearchIndex => $composableBuilder(
    column: $table.hasSearchIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasSemanticIndex => $composableBuilder(
    column: $table.hasSemanticIndex,
    builder: (column) => column,
  );
}

class $$ContentTranslationsTableTableManager
    extends
        RootTableManager<
          _$BibleContentDatabase,
          $ContentTranslationsTable,
          ContentTranslation,
          $$ContentTranslationsTableFilterComposer,
          $$ContentTranslationsTableOrderingComposer,
          $$ContentTranslationsTableAnnotationComposer,
          $$ContentTranslationsTableCreateCompanionBuilder,
          $$ContentTranslationsTableUpdateCompanionBuilder,
          (
            ContentTranslation,
            BaseReferences<
              _$BibleContentDatabase,
              $ContentTranslationsTable,
              ContentTranslation
            >,
          ),
          ContentTranslation,
          PrefetchHooks Function()
        > {
  $$ContentTranslationsTableTableManager(
    _$BibleContentDatabase db,
    $ContentTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentTranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ContentTranslationsTableAnnotationComposer(
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
                Value<bool> hasSearchIndex = const Value.absent(),
                Value<bool> hasSemanticIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentTranslationsCompanion(
                id: id,
                title: title,
                language: language,
                version: version,
                copyright: copyright,
                hasSearchIndex: hasSearchIndex,
                hasSemanticIndex: hasSemanticIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String language,
                required String version,
                required String copyright,
                Value<bool> hasSearchIndex = const Value.absent(),
                Value<bool> hasSemanticIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentTranslationsCompanion.insert(
                id: id,
                title: title,
                language: language,
                version: version,
                copyright: copyright,
                hasSearchIndex: hasSearchIndex,
                hasSemanticIndex: hasSemanticIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$BibleContentDatabase,
      $ContentTranslationsTable,
      ContentTranslation,
      $$ContentTranslationsTableFilterComposer,
      $$ContentTranslationsTableOrderingComposer,
      $$ContentTranslationsTableAnnotationComposer,
      $$ContentTranslationsTableCreateCompanionBuilder,
      $$ContentTranslationsTableUpdateCompanionBuilder,
      (
        ContentTranslation,
        BaseReferences<
          _$BibleContentDatabase,
          $ContentTranslationsTable,
          ContentTranslation
        >,
      ),
      ContentTranslation,
      PrefetchHooks Function()
    >;
typedef $$BooksTableCreateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      required String abbreviation,
      required String name,
      required String testament,
      required int sortOrder,
      required int chapterCount,
    });
typedef $$BooksTableUpdateCompanionBuilder =
    BooksCompanion Function({
      Value<int> id,
      Value<String> abbreviation,
      Value<String> name,
      Value<String> testament,
      Value<int> sortOrder,
      Value<int> chapterCount,
    });

class $$BooksTableFilterComposer
    extends Composer<_$BibleContentDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
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

  ColumnFilters<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get testament => $composableBuilder(
    column: $table.testament,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BooksTableOrderingComposer
    extends Composer<_$BibleContentDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
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

  ColumnOrderings<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get testament => $composableBuilder(
    column: $table.testament,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$BibleContentDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get abbreviation => $composableBuilder(
    column: $table.abbreviation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get testament =>
      $composableBuilder(column: $table.testament, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get chapterCount => $composableBuilder(
    column: $table.chapterCount,
    builder: (column) => column,
  );
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$BibleContentDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, BaseReferences<_$BibleContentDatabase, $BooksTable, Book>),
          Book,
          PrefetchHooks Function()
        > {
  $$BooksTableTableManager(_$BibleContentDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> abbreviation = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> testament = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> chapterCount = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                abbreviation: abbreviation,
                name: name,
                testament: testament,
                sortOrder: sortOrder,
                chapterCount: chapterCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String abbreviation,
                required String name,
                required String testament,
                required int sortOrder,
                required int chapterCount,
              }) => BooksCompanion.insert(
                id: id,
                abbreviation: abbreviation,
                name: name,
                testament: testament,
                sortOrder: sortOrder,
                chapterCount: chapterCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$BibleContentDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, BaseReferences<_$BibleContentDatabase, $BooksTable, Book>),
      Book,
      PrefetchHooks Function()
    >;
typedef $$ChaptersTableCreateCompanionBuilder =
    ChaptersCompanion Function({
      required String translationId,
      required int bookId,
      required int chapter,
      required int verseCount,
      Value<int> rowid,
    });
typedef $$ChaptersTableUpdateCompanionBuilder =
    ChaptersCompanion Function({
      Value<String> translationId,
      Value<int> bookId,
      Value<int> chapter,
      Value<int> verseCount,
      Value<int> rowid,
    });

class $$ChaptersTableFilterComposer
    extends Composer<_$BibleContentDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  ColumnFilters<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$BibleContentDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  ColumnOrderings<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$BibleContentDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => column,
  );
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$BibleContentDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (
            Chapter,
            BaseReferences<_$BibleContentDatabase, $ChaptersTable, Chapter>,
          ),
          Chapter,
          PrefetchHooks Function()
        > {
  $$ChaptersTableTableManager(_$BibleContentDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> translationId = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verseCount: verseCount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String translationId,
                required int bookId,
                required int chapter,
                required int verseCount,
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verseCount: verseCount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$BibleContentDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (
        Chapter,
        BaseReferences<_$BibleContentDatabase, $ChaptersTable, Chapter>,
      ),
      Chapter,
      PrefetchHooks Function()
    >;
typedef $$VersesTableCreateCompanionBuilder =
    VersesCompanion Function({
      required String translationId,
      required int bookId,
      required int chapter,
      required int verse,
      required String content,
      Value<int?> verseIndex,
      Value<int> rowid,
    });
typedef $$VersesTableUpdateCompanionBuilder =
    VersesCompanion Function({
      Value<String> translationId,
      Value<int> bookId,
      Value<int> chapter,
      Value<int> verse,
      Value<String> content,
      Value<int?> verseIndex,
      Value<int> rowid,
    });

class $$VersesTableFilterComposer
    extends Composer<_$BibleContentDatabase, $VersesTable> {
  $$VersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseIndex => $composableBuilder(
    column: $table.verseIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VersesTableOrderingComposer
    extends Composer<_$BibleContentDatabase, $VersesTable> {
  $$VersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
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

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseIndex => $composableBuilder(
    column: $table.verseIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VersesTableAnnotationComposer
    extends Composer<_$BibleContentDatabase, $VersesTable> {
  $$VersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get verseIndex => $composableBuilder(
    column: $table.verseIndex,
    builder: (column) => column,
  );
}

class $$VersesTableTableManager
    extends
        RootTableManager<
          _$BibleContentDatabase,
          $VersesTable,
          Verse,
          $$VersesTableFilterComposer,
          $$VersesTableOrderingComposer,
          $$VersesTableAnnotationComposer,
          $$VersesTableCreateCompanionBuilder,
          $$VersesTableUpdateCompanionBuilder,
          (Verse, BaseReferences<_$BibleContentDatabase, $VersesTable, Verse>),
          Verse,
          PrefetchHooks Function()
        > {
  $$VersesTableTableManager(_$BibleContentDatabase db, $VersesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> translationId = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> verse = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int?> verseIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VersesCompanion(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verse: verse,
                content: content,
                verseIndex: verseIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String translationId,
                required int bookId,
                required int chapter,
                required int verse,
                required String content,
                Value<int?> verseIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VersesCompanion.insert(
                translationId: translationId,
                bookId: bookId,
                chapter: chapter,
                verse: verse,
                content: content,
                verseIndex: verseIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VersesTableProcessedTableManager =
    ProcessedTableManager<
      _$BibleContentDatabase,
      $VersesTable,
      Verse,
      $$VersesTableFilterComposer,
      $$VersesTableOrderingComposer,
      $$VersesTableAnnotationComposer,
      $$VersesTableCreateCompanionBuilder,
      $$VersesTableUpdateCompanionBuilder,
      (Verse, BaseReferences<_$BibleContentDatabase, $VersesTable, Verse>),
      Verse,
      PrefetchHooks Function()
    >;
typedef $$VerseEmbeddingsTableCreateCompanionBuilder =
    VerseEmbeddingsCompanion Function({
      required String translationId,
      required int verseIndex,
      required int dim,
      Value<String> vectorEncoding,
      required Uint8List vectorBlob,
      Value<int> rowid,
    });
typedef $$VerseEmbeddingsTableUpdateCompanionBuilder =
    VerseEmbeddingsCompanion Function({
      Value<String> translationId,
      Value<int> verseIndex,
      Value<int> dim,
      Value<String> vectorEncoding,
      Value<Uint8List> vectorBlob,
      Value<int> rowid,
    });

class $$VerseEmbeddingsTableFilterComposer
    extends Composer<_$BibleContentDatabase, $VerseEmbeddingsTable> {
  $$VerseEmbeddingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseIndex => $composableBuilder(
    column: $table.verseIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dim => $composableBuilder(
    column: $table.dim,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vectorEncoding => $composableBuilder(
    column: $table.vectorEncoding,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get vectorBlob => $composableBuilder(
    column: $table.vectorBlob,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VerseEmbeddingsTableOrderingComposer
    extends Composer<_$BibleContentDatabase, $VerseEmbeddingsTable> {
  $$VerseEmbeddingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseIndex => $composableBuilder(
    column: $table.verseIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dim => $composableBuilder(
    column: $table.dim,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vectorEncoding => $composableBuilder(
    column: $table.vectorEncoding,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get vectorBlob => $composableBuilder(
    column: $table.vectorBlob,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VerseEmbeddingsTableAnnotationComposer
    extends Composer<_$BibleContentDatabase, $VerseEmbeddingsTable> {
  $$VerseEmbeddingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get verseIndex => $composableBuilder(
    column: $table.verseIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dim =>
      $composableBuilder(column: $table.dim, builder: (column) => column);

  GeneratedColumn<String> get vectorEncoding => $composableBuilder(
    column: $table.vectorEncoding,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get vectorBlob => $composableBuilder(
    column: $table.vectorBlob,
    builder: (column) => column,
  );
}

class $$VerseEmbeddingsTableTableManager
    extends
        RootTableManager<
          _$BibleContentDatabase,
          $VerseEmbeddingsTable,
          VerseEmbedding,
          $$VerseEmbeddingsTableFilterComposer,
          $$VerseEmbeddingsTableOrderingComposer,
          $$VerseEmbeddingsTableAnnotationComposer,
          $$VerseEmbeddingsTableCreateCompanionBuilder,
          $$VerseEmbeddingsTableUpdateCompanionBuilder,
          (
            VerseEmbedding,
            BaseReferences<
              _$BibleContentDatabase,
              $VerseEmbeddingsTable,
              VerseEmbedding
            >,
          ),
          VerseEmbedding,
          PrefetchHooks Function()
        > {
  $$VerseEmbeddingsTableTableManager(
    _$BibleContentDatabase db,
    $VerseEmbeddingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerseEmbeddingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VerseEmbeddingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VerseEmbeddingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> translationId = const Value.absent(),
                Value<int> verseIndex = const Value.absent(),
                Value<int> dim = const Value.absent(),
                Value<String> vectorEncoding = const Value.absent(),
                Value<Uint8List> vectorBlob = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VerseEmbeddingsCompanion(
                translationId: translationId,
                verseIndex: verseIndex,
                dim: dim,
                vectorEncoding: vectorEncoding,
                vectorBlob: vectorBlob,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String translationId,
                required int verseIndex,
                required int dim,
                Value<String> vectorEncoding = const Value.absent(),
                required Uint8List vectorBlob,
                Value<int> rowid = const Value.absent(),
              }) => VerseEmbeddingsCompanion.insert(
                translationId: translationId,
                verseIndex: verseIndex,
                dim: dim,
                vectorEncoding: vectorEncoding,
                vectorBlob: vectorBlob,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VerseEmbeddingsTableProcessedTableManager =
    ProcessedTableManager<
      _$BibleContentDatabase,
      $VerseEmbeddingsTable,
      VerseEmbedding,
      $$VerseEmbeddingsTableFilterComposer,
      $$VerseEmbeddingsTableOrderingComposer,
      $$VerseEmbeddingsTableAnnotationComposer,
      $$VerseEmbeddingsTableCreateCompanionBuilder,
      $$VerseEmbeddingsTableUpdateCompanionBuilder,
      (
        VerseEmbedding,
        BaseReferences<
          _$BibleContentDatabase,
          $VerseEmbeddingsTable,
          VerseEmbedding
        >,
      ),
      VerseEmbedding,
      PrefetchHooks Function()
    >;
typedef $$VerseSemanticNeighborsTableCreateCompanionBuilder =
    VerseSemanticNeighborsCompanion Function({
      required String translationId,
      required int sourceVerseIndex,
      required Uint8List neighborIndicesBlob,
      Value<int> rowid,
    });
typedef $$VerseSemanticNeighborsTableUpdateCompanionBuilder =
    VerseSemanticNeighborsCompanion Function({
      Value<String> translationId,
      Value<int> sourceVerseIndex,
      Value<Uint8List> neighborIndicesBlob,
      Value<int> rowid,
    });

class $$VerseSemanticNeighborsTableFilterComposer
    extends Composer<_$BibleContentDatabase, $VerseSemanticNeighborsTable> {
  $$VerseSemanticNeighborsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceVerseIndex => $composableBuilder(
    column: $table.sourceVerseIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get neighborIndicesBlob => $composableBuilder(
    column: $table.neighborIndicesBlob,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VerseSemanticNeighborsTableOrderingComposer
    extends Composer<_$BibleContentDatabase, $VerseSemanticNeighborsTable> {
  $$VerseSemanticNeighborsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceVerseIndex => $composableBuilder(
    column: $table.sourceVerseIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get neighborIndicesBlob => $composableBuilder(
    column: $table.neighborIndicesBlob,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VerseSemanticNeighborsTableAnnotationComposer
    extends Composer<_$BibleContentDatabase, $VerseSemanticNeighborsTable> {
  $$VerseSemanticNeighborsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get translationId => $composableBuilder(
    column: $table.translationId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceVerseIndex => $composableBuilder(
    column: $table.sourceVerseIndex,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get neighborIndicesBlob => $composableBuilder(
    column: $table.neighborIndicesBlob,
    builder: (column) => column,
  );
}

class $$VerseSemanticNeighborsTableTableManager
    extends
        RootTableManager<
          _$BibleContentDatabase,
          $VerseSemanticNeighborsTable,
          VerseSemanticNeighbor,
          $$VerseSemanticNeighborsTableFilterComposer,
          $$VerseSemanticNeighborsTableOrderingComposer,
          $$VerseSemanticNeighborsTableAnnotationComposer,
          $$VerseSemanticNeighborsTableCreateCompanionBuilder,
          $$VerseSemanticNeighborsTableUpdateCompanionBuilder,
          (
            VerseSemanticNeighbor,
            BaseReferences<
              _$BibleContentDatabase,
              $VerseSemanticNeighborsTable,
              VerseSemanticNeighbor
            >,
          ),
          VerseSemanticNeighbor,
          PrefetchHooks Function()
        > {
  $$VerseSemanticNeighborsTableTableManager(
    _$BibleContentDatabase db,
    $VerseSemanticNeighborsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VerseSemanticNeighborsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$VerseSemanticNeighborsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$VerseSemanticNeighborsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> translationId = const Value.absent(),
                Value<int> sourceVerseIndex = const Value.absent(),
                Value<Uint8List> neighborIndicesBlob = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VerseSemanticNeighborsCompanion(
                translationId: translationId,
                sourceVerseIndex: sourceVerseIndex,
                neighborIndicesBlob: neighborIndicesBlob,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String translationId,
                required int sourceVerseIndex,
                required Uint8List neighborIndicesBlob,
                Value<int> rowid = const Value.absent(),
              }) => VerseSemanticNeighborsCompanion.insert(
                translationId: translationId,
                sourceVerseIndex: sourceVerseIndex,
                neighborIndicesBlob: neighborIndicesBlob,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VerseSemanticNeighborsTableProcessedTableManager =
    ProcessedTableManager<
      _$BibleContentDatabase,
      $VerseSemanticNeighborsTable,
      VerseSemanticNeighbor,
      $$VerseSemanticNeighborsTableFilterComposer,
      $$VerseSemanticNeighborsTableOrderingComposer,
      $$VerseSemanticNeighborsTableAnnotationComposer,
      $$VerseSemanticNeighborsTableCreateCompanionBuilder,
      $$VerseSemanticNeighborsTableUpdateCompanionBuilder,
      (
        VerseSemanticNeighbor,
        BaseReferences<
          _$BibleContentDatabase,
          $VerseSemanticNeighborsTable,
          VerseSemanticNeighbor
        >,
      ),
      VerseSemanticNeighbor,
      PrefetchHooks Function()
    >;

class $BibleContentDatabaseManager {
  final _$BibleContentDatabase _db;
  $BibleContentDatabaseManager(this._db);
  $$ContentTranslationsTableTableManager get contentTranslations =>
      $$ContentTranslationsTableTableManager(_db, _db.contentTranslations);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$VersesTableTableManager get verses =>
      $$VersesTableTableManager(_db, _db.verses);
  $$VerseEmbeddingsTableTableManager get verseEmbeddings =>
      $$VerseEmbeddingsTableTableManager(_db, _db.verseEmbeddings);
  $$VerseSemanticNeighborsTableTableManager get verseSemanticNeighbors =>
      $$VerseSemanticNeighborsTableTableManager(
        _db,
        _db.verseSemanticNeighbors,
      );
}
