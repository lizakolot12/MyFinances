import 'package:drift/drift.dart';
import 'connection/connection.dart' as impl;

part 'my_db.g.dart';

class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  DateTimeColumn get date => dateTime()();

  RealColumn get total => real()();

  TextColumn get path => text()();
}

class MyTag extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get idTransaction => integer().references(TransactionItems, #id)();
}

@DriftDatabase(tables: [TransactionItems, MyTag])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;
}