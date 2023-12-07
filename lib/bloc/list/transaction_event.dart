part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class GetAllTransactions extends TransactionEvent {}

class RemoveTransaction extends TransactionEvent {
  late final Transaction transaction;

  RemoveTransaction(this.transaction);
}
