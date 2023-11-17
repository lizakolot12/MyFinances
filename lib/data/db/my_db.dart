import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'my_db.g.dart';

class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  RealColumn get total => real()();
}

class MyTag extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get id_transaction => integer().references(TransactionItems, #id)();
}

@DriftDatabase(tables: [TransactionItems, MyTag])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
