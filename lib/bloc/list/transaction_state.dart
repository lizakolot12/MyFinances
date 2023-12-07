part of 'transaction_bloc.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class LoadingTransaction extends TransactionState {
  late final List<Transaction> transactions;

  LoadingTransaction(this.transactions);
}

class LoadedTransaction extends TransactionState {
  late final List<Transaction> transactions;

  LoadedTransaction(this.transactions);
}
