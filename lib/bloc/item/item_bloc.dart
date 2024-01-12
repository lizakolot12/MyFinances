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
        List<String> allTags = await _repository.getAllTags();
        emit(NewItem(allTags));
      },
    );

    on<EditTransaction>(
      (event, emit) async {
        emit(Loading());
        Future<Transaction> transactionFuture = _repository.get(event.id);
        Transaction transaction = await transactionFuture;
        List<String> allTags = await _repository.getAllTags();
        emit(EditedTransaction(transaction, allTags));
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
        final DateTime now = DateTime.now();
        if (name.isEmpty) {
          final DateFormat formatter = DateFormat('dd-MM-yy HH:mm');
          final String formatted = formatter.format(now);
          name = formatted;
        }
        _repository.create(
            name, now.millisecondsSinceEpoch, event.total, event.path, event.selectedOptions);
        emit(Saved());
      },
    );
  }
}
