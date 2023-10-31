import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_study/data/data.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionListBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  List<Transaction> saved = List.empty();

  TransactionListBloc({required TransactionRepository repository})
      : _repository = repository,
        super(TransactionInitial()) {
    on<GetAllTransactions>(
      (event, emit) async {
        emit(LoadingTransaction(saved));
        List<Transaction> list = await _repository.getAll();
        saved = list;
        emit(LoadedTransaction(list));
      },
    );

    on<RemoveTransaction>(
      (event, emit) async {
        emit(LoadingTransaction(saved));
        Transaction transaction = event.transaction;
        saved = saved.map((item) {
          if (item.id == transaction.id) {
            item.isProgress = true;
            return item;
          } else {
            return item;
          }
        }).toList();
        await _repository.remove(transaction);
        saved = await _repository.getAll();
        emit(LoadedTransaction(saved));
      },
    );
  }
}
