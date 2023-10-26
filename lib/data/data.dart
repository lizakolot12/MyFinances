import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';

class Transaction {
  final int _id;
  final String _name;
  final int _total;
  final List<String>? _tags;

  Transaction(this._id, this._name, this._total, this._tags);

  List<String>? get tags => _tags;

  int get total => _total;

  String get name => _name;

  int get id => _id;
}

final repositoryProvider = ChangeNotifierProvider<TransactionRepository>((ref) {
  return TransactionRepository();
});

class TransactionRepository extends ChangeNotifier {
  static final List<Transaction> _transactions = [
    Transaction(
        1, "магазин", 200, ["солодощі", "овочі", "госп.товари", "канцелярія"]),
    Transaction(2, "комуналка", 2000, null),
    Transaction(3, "оренда", 3000, null),
    Transaction(4, "продукти", 2530, null),
    Transaction(5, "продукти", 2530, null),
    Transaction(6, "продукти", 2150, null),
    Transaction(7, "продукти", 2850, null),
    Transaction(8, "продукти", 2530, null),
    Transaction(9, "продукти", 2520, null),
  ];

  List<Transaction> getAll() {
    return _transactions;
  }

  void remove(Transaction transaction) {
    _transactions.remove(transaction);
    notifyListeners();
  }
}
