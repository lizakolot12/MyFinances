import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_study/data/data.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository = TransactionRepository();
  List<Transaction> saved = List.empty();

  TransactionBloc() : super(TransactionInitial()) {
    on<GetAll>(
      (event, emit) async {
        List<Transaction> list = await _repository.getAll();
        saved = list;
        emit(LoadedTransaction(list));
      },
    );

    on<Remove>(
      (event, emit) async {
        Transaction transaction = event.transaction;
        saved = saved.map((item) {
          if (item.id == transaction.id) {
            item.isProgress = true;
            return item;
          } else {
            return item;
          }
        }).toList();
        emit(LoadingTransaction(saved));
        await _repository.remove(transaction);
        saved = await _repository.getAll();
        emit(LoadedTransaction(saved));
      },
    );
  }
}
