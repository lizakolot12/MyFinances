import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_study/data/data.dart';
import 'package:my_study/data/transaction_bloc.dart';

import 'item_event.dart';
import 'item_state.dart';

class TransactionItemBloc extends Bloc<ItemEvent, ItemState> {
  final TransactionRepository _repository;

  TransactionItemBloc({required TransactionRepository repository})
      : _repository = repository,
        super(Initial()) {
    on<NewTransaction>(
      (event, emit) async {
        emit(NewItem());
      },
    );

    on<EditTransaction>(
      (event, emit) async {
        emit(Loading());
        Future<Transaction> transactionFuture = _repository.getById(event.id);
        Transaction transaction = await transactionFuture;
        emit(EditedTransaction(transaction));
      },
    );

    on<SaveTransaction>(
      (event, emit) async {
        emit(Saving());
        _repository.edit(event.transaction);
        emit(Saved());
      },
    );
    on<CreateTransaction>(
      (event, emit) async {
        emit(Saving());
        _repository.create(event.name, event.total);
        emit(Saved());
      },
    );
  }
}
