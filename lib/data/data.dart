import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';

class Transaction {
  final int _id;
  final String _name;
  final int _total;
  final List<String>? _tags;
  bool _isProgress = false;

  Transaction(this._id, this._name, this._total, this._tags);

  List<String>? get tags => _tags;

  int get total => _total;

  String get name => _name;

  int get id => _id;

  bool get isProgress => _isProgress;

  set isProgress(bool value) {
    _isProgress = value;
  }
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
    Transaction(4, "магазин", 2530, null),
    Transaction(5, "кіно", 2530, null),
    Transaction(6, "театр", 2150, null),
    Transaction(7, "фітнес", 2850, null),
  ];

  Future<List<Transaction>> getAll() async {
    await Future.delayed(const Duration(seconds: 1));
    return _transactions;
  }

  Future<void> remove(int index) async {
    _transactions[index].isProgress = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _transactions.removeAt(index);
    notifyListeners();
  }
}
