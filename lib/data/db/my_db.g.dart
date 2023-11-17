// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_db.dart';

// ignore_for_file: type=lint
class $TransactionItemsTable extends TransactionItems
    with TableInfo<$TransactionItemsTable, TransactionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, total];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_items';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
    );
  }

  @override
  $TransactionItemsTable createAlias(String alias) {
    return $TransactionItemsTable(attachedDatabase, alias);
  }
}

class TransactionItem extends DataClass implements Insertable<TransactionItem> {
  final int id;
  final String name;
  final double total;
  const TransactionItem(
      {required this.id, required this.name, required this.total});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['total'] = Variable<double>(total);
    return map;
  }

  TransactionItemsCompanion toCompanion(bool nullToAbsent) {
    return TransactionItemsCompanion(
      id: Value(id),
      name: Value(name),
      total: Value(total),
    );
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      total: serializer.fromJson<double>(json['total']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'total': serializer.toJson<double>(total),
    };
  }

  TransactionItem copyWith({int? id, String? name, double? total}) =>
      TransactionItem(
        id: id ?? this.id,
        name: name ?? this.name,
        total: total ?? this.total,
      );
  @override
  String toString() {
    return (StringBuffer('TransactionItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, total);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.total == this.total);
}

class TransactionItemsCompanion extends UpdateCompanion<TransactionItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> total;
  const TransactionItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.total = const Value.absent(),
  });
  TransactionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double total,
  })  : name = Value(name),
        total = Value(total);
  static Insertable<TransactionItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? total,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (total != null) 'total': total,
    });
  }

  TransactionItemsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<double>? total}) {
    return TransactionItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      total: total ?? this.total,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('total: $total')
          ..write(')'))
        .toString();
  }
}

class $MyTagTable extends MyTag with TableInfo<$MyTagTable, MyTagData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MyTagTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _id_transactionMeta =
      const VerificationMeta('id_transaction');
  @override
  late final GeneratedColumn<int> id_transaction = GeneratedColumn<int>(
      'id_transaction', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES transaction_items (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, name, id_transaction];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'my_tag';
  @override
  VerificationContext validateIntegrity(Insertable<MyTagData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('id_transaction')) {
      context.handle(
          _id_transactionMeta,
          id_transaction.isAcceptableOrUnknown(
              data['id_transaction']!, _id_transactionMeta));
    } else if (isInserting) {
      context.missing(_id_transactionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MyTagData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MyTagData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      id_transaction: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id_transaction'])!,
    );
  }

  @override
  $MyTagTable createAlias(String alias) {
    return $MyTagTable(attachedDatabase, alias);
  }
}

class MyTagData extends DataClass implements Insertable<MyTagData> {
  final int id;
  final String name;
  final int id_transaction;
  const MyTagData(
      {required this.id, required this.name, required this.id_transaction});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['id_transaction'] = Variable<int>(id_transaction);
    return map;
  }

  MyTagCompanion toCompanion(bool nullToAbsent) {
    return MyTagCompanion(
      id: Value(id),
      name: Value(name),
      id_transaction: Value(id_transaction),
    );
  }

  factory MyTagData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MyTagData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      id_transaction: serializer.fromJson<int>(json['id_transaction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'id_transaction': serializer.toJson<int>(id_transaction),
    };
  }

  MyTagData copyWith({int? id, String? name, int? id_transaction}) => MyTagData(
        id: id ?? this.id,
        name: name ?? this.name,
        id_transaction: id_transaction ?? this.id_transaction,
      );
  @override
  String toString() {
    return (StringBuffer('MyTagData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('id_transaction: $id_transaction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, id_transaction);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyTagData &&
          other.id == this.id &&
          other.name == this.name &&
          other.id_transaction == this.id_transaction);
}

class MyTagCompanion extends UpdateCompanion<MyTagData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> id_transaction;
  const MyTagCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.id_transaction = const Value.absent(),
  });
  MyTagCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int id_transaction,
  })  : name = Value(name),
        id_transaction = Value(id_transaction);
  static Insertable<MyTagData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? id_transaction,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (id_transaction != null) 'id_transaction': id_transaction,
    });
  }

  MyTagCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? id_transaction}) {
    return MyTagCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      id_transaction: id_transaction ?? this.id_transaction,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (id_transaction.present) {
      map['id_transaction'] = Variable<int>(id_transaction.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MyTagCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('id_transaction: $id_transaction')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $TransactionItemsTable transactionItems =
      $TransactionItemsTable(this);
  late final $MyTagTable myTag = $MyTagTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [transactionItems, myTag];
}
