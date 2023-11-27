import 'dart:async';
import 'dart:ui';
import 'package:collection/src/iterable_extensions.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

import 'db/my_db.dart';

class Transaction {
  final int _id;
  final String _name;
  final double _total;
  final String _path;
  List<String> _tags;
  bool _isProgress = false;

  Transaction(this._id, this._name, this._total, this._path, this._tags);

  List<String> get tags => _tags;

  set tags(List<String> value) {
    _tags = value;
  }

  String? get path => _path;

  double get total => _total;

  String get name => _name;

  int get id => _id;

  bool get isProgress => _isProgress;

  set isProgress(bool value) {
    _isProgress = value;
  }
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
          (e) => Transaction(e.id, e.name, e.total, e.path, List.empty()),
        )
        .watch();
  }

  List<Transaction> _parse(List<TypedResult> rows) {
    final transactions = <Transaction>[];

    for (final row in rows) {
      var current = row.readTable(_database.transactionItems);

      var found =
          transactions.firstWhereOrNull((element) => element.id == current.id);
      var tag = row.readTableOrNull(_database.myTag)?.name;
      if (found != null) {
        if (tag != null) {
          found.tags.add(tag);
        }
      } else {
        final transaction = Transaction(
          row.readTable(_database.transactionItems).id,
          row.readTable(_database.transactionItems).name,
          row.readTable(_database.transactionItems).total,
          row.readTable(_database.transactionItems).path,
          [],
        );
        if (tag != null) {
          transaction.tags.add(tag);
        }
        transactions.add(transaction);
      }
    }
    return transactions;
  }

  Stream<List<Transaction>> getAll() {
    final controller = StreamController<List<Transaction>>();
    _database
        .select(_database.transactionItems)
        .join([
          leftOuterJoin(
              _database.myTag,
              _database.myTag.id_transaction
                  .equalsExp(_database.transactionItems.id)),
        ])
        .watch()
        .listen((rows) {
          final transactions = _parse(rows);
          controller.add(transactions);
        });

    return controller.stream;
  }

  Future<Transaction> getSimple(int id) async {
    var tran = await (_database.select(_database.transactionItems)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    return Transaction(tran.id, tran.name, tran.total, tran.path, List.empty());
  }

  Future<Transaction> get(int id) async {
    var res = await (_database.select(_database.transactionItems)
          ..where((t) => t.id.equals(id)))
        .join([
      leftOuterJoin(
          _database.myTag,
          _database.myTag.id_transaction
              .equalsExp(_database.transactionItems.id)),
    ]).get();

    return _parse(res)[0];
  }

  Future<void> remove(Transaction transaction) async {
    await (_database.delete(_database.transactionItems)
          ..where((t) => t.id.equals(transaction.id)))
        .go();
  }

  Future<void> edit(Transaction updatedTransaction) async {
    await _database.update(_database.transactionItems)
      ..where((t) => t.id.equals(updatedTransaction.id))
      ..write(
        TransactionItemsCompanion(
          id: Value(updatedTransaction.id),
          name: Value(updatedTransaction.name),
          total: Value(updatedTransaction.total),
        ),
      );
    await (_database.delete(_database.myTag)
          ..where((t) => t.id_transaction.equals(updatedTransaction.id)))
        .go();
    for (int i = 0; i < updatedTransaction.tags.length; i++) {
      await _database.into(_database.myTag).insert(MyTagCompanion(
          name: Value(updatedTransaction.tags[i]),
          id_transaction: Value(updatedTransaction.id)));
    }
  }

  Future<void> create(
      String name, double total, String path, List<String> selectedOptions) {
    return _database.transaction(() async {
      var id = await _database.into(_database.transactionItems).insert(
            TransactionItemsCompanion.insert(
                name: name, total: total, path: path),
          );

      for (int i = 0; i < selectedOptions.length; i++) {
        await _database.into(_database.myTag).insert(MyTagCompanion(
            name: Value(selectedOptions[i]), id_transaction: Value(id)));
      }
    });
  }
}
