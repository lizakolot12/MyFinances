part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class GetAll extends TransactionEvent {}

class Remove extends TransactionEvent {
  late final Transaction transaction;

  Remove(this.transaction);
}
