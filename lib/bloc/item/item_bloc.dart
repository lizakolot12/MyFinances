import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_study/data/data.dart';

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
        Future<Transaction> transactionFuture = _repository.get(event.id);
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
        String name = event.name;
        if(name.isEmpty){
          final DateTime now = DateTime.now();
          final DateFormat formatter = DateFormat('dd-MM-yy HH:mm');
          final String formatted = formatter.format(now);
          name = formatted;
        }
        _repository.create(
            name, event.total, event.path, event.selectedOptions);
        emit(Saved());
      },
    );
  }
}
