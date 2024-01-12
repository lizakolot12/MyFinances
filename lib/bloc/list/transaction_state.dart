part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class LoadingTransaction extends TransactionState {
  late final List<Transaction> transactions;
  final double total;

  LoadingTransaction(this.transactions, this.total);
}

class LoadedTransaction extends TransactionState {
  late final List<Transaction> transactions;
  final double total;

  LoadedTransaction(this.transactions, this.total);
}
