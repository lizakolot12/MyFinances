import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_study/data/data.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionListBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  List<Transaction> saved = List.empty();
  double total = 0;

  TransactionListBloc({required TransactionRepository repository})
      : _repository = repository,
        super(TransactionInitial()) {
    on<GetAllTransactions>(
      (event, emit) async {
        emit(LoadingTransaction(List.empty(), 0));
        await for (final list in _repository.getAll()) {
          saved = list;
          total = 0;
          for (final element in list) {
            if (_isCurrentMonth(element.date)) {
              total += element.total;
            }
          }
          emit(LoadedTransaction(list, total));
        }
      },
    );

    on<RemoveTransaction>(
      (event, emit) async {
        emit(LoadingTransaction(saved, total));
        final Transaction transaction = event.transaction;
        saved = saved.map((item) {
          if (item.id == transaction.id) {
            item.isProgress = true;
            return item;
          } else {
            return item;
          }
        }).toList();
        if (_isCurrentMonth(transaction.date)) {
          total -= transaction.total;
        }

        await _repository.remove(transaction);
      },
    );
  }

  bool _isCurrentMonth(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}
