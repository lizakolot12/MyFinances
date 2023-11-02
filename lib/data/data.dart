import 'dart:math';

class Transaction {
  final int _id;
  final String _name;
  final double _total;
  final List<String>? _tags;
  bool _isProgress = false;

  Transaction(this._id, this._name, this._total, this._tags);

  List<String>? get tags => _tags;

  double get total => _total;

  String get name => _name;

  int get id => _id;

  bool get isProgress => _isProgress;

  set isProgress(bool value) {
    _isProgress = value;
  }
}

class TransactionRepository {
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
  Future<Transaction> getById(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    return _transactions.firstWhere((element) => element.id == id);
  }

  Future<List<Transaction>> getAll() async {
    await Future.delayed(const Duration(seconds: 1));
    return _transactions;
  }

  Future<void> remove(Transaction transaction) async {
    await Future.delayed(const Duration(seconds: 1));
    _transactions.removeWhere((item) => item.id == transaction.id);
    return;
  }

  Future<Transaction> get(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    return _transactions.firstWhere((item) => item.id == id);
  }

  Future<void> edit(Transaction transaction) async {
    await Future.delayed(const Duration(seconds: 1));
    _transactions.removeWhere((item) => item.id == transaction.id);
    _transactions.add(transaction);
  }

  Future<void> create(String name, double total) async {
    await Future.delayed(const Duration(seconds: 1));
    _transactions.add(Transaction(Random().nextInt(1000), name, total, List.empty()));
  }
}
