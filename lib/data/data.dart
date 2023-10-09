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

class TransactionRepository {
  final List<Transaction> _transactions = [];

  List<Transaction> getAll() {
    return _transactions;
  }

  TransactionRepository() {
    _transactions.add(Transaction(1, "магазин", 200, ["солодощі", "овочі", "госп.товари", "канцелярія"]));
    _transactions.add(Transaction(2, "комуналка", 2000, null));
    _transactions.add(Transaction(3, "оренда", 3000, null));
    _transactions.add(Transaction(4, "продукти", 2530, null));
    _transactions.add(Transaction(5, "продукти", 2530, null));
    _transactions.add(Transaction(6, "продукти", 2150, null));
    _transactions.add(Transaction(7, "продукти", 2850, null));
    _transactions.add(Transaction(8, "продукти", 2530, null));
    _transactions.add(Transaction(9, "продукти", 2520, null));
  }
}
