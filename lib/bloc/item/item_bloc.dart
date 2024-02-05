import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_study/data/data.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
        Transaction old = event.transaction;
        String? newPath = await saveFile(old.path);
        _repository.edit(Transaction(old.id, old.name, old.date, old.total, newPath ?? "", old.tags));

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
        String? newPath = await saveFile(event.path);
        _repository.create(
            name, now, event.total, newPath ?? "", event.selectedOptions);
        emit(Saved());
      },
    );
  }

  Future<String?> saveFile(String? path) async {
    if(path == null) {
      return null;
    }
    final image = File(path);
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = join(directory.path, 'my_recipts');

    if (!await Directory(folderPath).exists()) {
    await Directory(folderPath).create(recursive: true);
    }

    final newPath = join(folderPath, basename(path));

    await image.copy(newPath);
    await image.delete();

    print("Файл був скопійований до $newPath");
    return newPath;
  }
}
