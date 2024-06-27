import 'dart:async';
import 'package:collection/src/iterable_extensions.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:my_study/data/db/my_db.dart';

class Transaction {
  final int _id;
  final String _name;
  final DateTime _date;
  final double _total;
  final String _path;
  Set<String> tags;
  bool isProgress = false;

  Transaction(
      this._id, this._name, this._date, this._total, this._path, this.tags,);

  String? get path => _path;

  double get total => _total;

  String get name => _name;

  int get id => _id;

  DateTime get date => _date;
}

class TransactionRepository {
  final _database = AppDatabase();

  TransactionRepository() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Stream<List<Transaction>> getAllSimple() {
    return _database
        .select(_database.transactionItems)
        .map(
          (e) => Transaction(e.id, e.name, e.date, e.total, e.path, {}),
        )
        .watch();
  }

  Future<List<String>> getFileNames() {
    return _database
        .select(_database.transactionItems)
        .map((e) => e.path)
        .get();
  }

  List<Transaction> _parse(List<TypedResult> rows) {
    final transactions = <Transaction>[];

    for (final row in rows) {
      final current = row.readTable(_database.transactionItems);

      final found =
          transactions.firstWhereOrNull((element) => element.id == current.id);
      final tag = row.readTableOrNull(_database.myTag)?.name;
      if (found != null) {
        if (tag != null) {
          found.tags.add(tag);
        }
      } else {
        final transaction = Transaction(
          row.readTable(_database.transactionItems).id,
          row.readTable(_database.transactionItems).name,
          row.readTable(_database.transactionItems).date,
          row.readTable(_database.transactionItems).total,
          row.readTable(_database.transactionItems).path,
          {},
        );
        if (tag != null) {
          transaction.tags.add(tag);
        }
        transactions.add(transaction);
      }
    }
    return transactions;
  }

  Stream<List<Transaction>> getAll(
      {DateTime? start, DateTime? end,}) {
    final from = start ?? DateTime(0);
    final until = end ?? DateTime.now();
    final controller = StreamController<List<Transaction>>();
    _database
        .select(_database.transactionItems)
        .join([
          leftOuterJoin(
              _database.myTag,
              _database.myTag.idTransaction
                  .equalsExp(_database.transactionItems.id),),
        ])
        .watch()
        .listen((rows) {
          final initial = _parse(rows);
          List<Transaction>? transactions;
          if (start != null && end != null) {
            transactions = initial
                .where((element) =>
                    element.date.isAfter(from) && element.date.isBefore(until),)
                .toList();
          } else {
            transactions = initial;
          }
          transactions.sort((b, a) => a.date.compareTo(b.date));
          controller.add(transactions);
        });

    return controller.stream;
  }

  Future<Transaction> getSimple(int id) async {
    final tran = await (_database.select(_database.transactionItems)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return Transaction(
        tran.id, tran.name, tran.date, tran.total, tran.path, {},);
  }

  Future<Set<String>> getAllTags() async {
    final list = await _database.select(_database.myTag).get();
    final Set<String> result = {};
    for (int i = 0; i < list.length; i++) {
      if (!result.contains(list[i].name)) {
        result.add(list[i].name);
      }
    }
    return result;
  }

  Future<Transaction> get(int id) async {
    final res = await (_database.select(_database.transactionItems)
          ..where((t) => t.id.equals(id)))
        .join([
      leftOuterJoin(
          _database.myTag,
          _database.myTag.idTransaction
              .equalsExp(_database.transactionItems.id),),
    ]).get();

    return _parse(res)[0];
  }

  Future<void> remove(Transaction transaction) async {
    await (_database.delete(_database.transactionItems)
          ..where((t) => t.id.equals(transaction.id)))
        .go();
  }

  Future<void> removeTag(String tag) async {
    await (_database.delete(_database.myTag)..where((t) => t.name.equals(tag)))
        .go();
  }

  Future<void> edit(Transaction updatedTransaction) async {
    String name = updatedTransaction.name;

    if (name.isEmpty) {
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd-MM-yy HH:mm');
      final String formatted = formatter.format(now);
      name = formatted;
    }
    _database.update(_database.transactionItems)
      ..where((t) => t.id.equals(updatedTransaction.id))
      ..write(
        TransactionItemsCompanion(
            id: Value(updatedTransaction.id),
            name: Value(name),
            date: Value(updatedTransaction.date),
            total: Value(updatedTransaction.total),
            path: Value(updatedTransaction.path ?? ""),),
      );
    await (_database.delete(_database.myTag)
          ..where((t) => t.idTransaction.equals(updatedTransaction.id)))
        .go();
    for (int i = 0; i < updatedTransaction.tags.length; i++) {
      await _database.into(_database.myTag).insert(MyTagCompanion(
          name: Value(updatedTransaction.tags.elementAt(i)),
          id_transaction: Value(updatedTransaction.id),),);
    }
  }

  Future<void> create(String name, DateTime date, double total, String path,
      Set<String> selectedOptions,) {
    return _database.transaction(() async {
      final id = await _database.into(_database.transactionItems).insert(
            TransactionItemsCompanion.insert(
                name: name, date: date, total: total, path: path,),
          );

      for (int i = 0; i < selectedOptions.length; i++) {
        await _database.into(_database.myTag).insert(MyTagCompanion(
            name: Value(selectedOptions.elementAt(i)),
            id_transaction: Value(id),),);
      }
    });
  }
}
