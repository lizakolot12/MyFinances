import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_study/data/data.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'item_event.dart';
import 'item_state.dart';

class TransactionItemBloc extends Bloc<ItemEvent, ItemState> {
  static const String _folderForImage = 'my_receipts';
  final TransactionRepository _repository;

  TransactionItemBloc({required TransactionRepository repository})
      : _repository = repository,
        super(Initial()) {
    on<NewTransaction>(
      (event, emit) async {
        final Set<String> allTags = await _repository.getAllTags();
        emit(NewItem(allTags));
        clearFile();
      },
    );

    on<EditTransaction>(
      (event, emit) async {
        emit(Loading());
        final Future<Transaction> transactionFuture = _repository.get(event.id);
        final Transaction transaction = await transactionFuture;
        final Set<String> allTags = await _repository.getAllTags();
        emit(EditedTransaction(transaction, allTags));
      },
    );

    on<SaveTransaction>(
      (event, emit) async {
        emit(Saving());
        final Transaction old = event.transaction;
        final String? newPath = await saveFile(old.path);
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
        final String? newPath = await saveFile(event.path);
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
    if(!await image.exists()){
      return null;
    }
    final directory = await getApplicationDocumentsDirectory();
    final folderPath = join(directory.path, _folderForImage);

    if (!await Directory(folderPath).exists()) {
    await Directory(folderPath).create(recursive: true);
    }

    final newPath = join(folderPath, basename(path));

    await image.copy(newPath);
    await image.delete();

    return newPath;
  }

  Future<void> clearFile() async {
    List<String> currents = await _repository.getFileNames();
    currents = currents.map((e) {
      try {
        return File(e).path.split(Platform.pathSeparator).last;
      } catch (e) {
        return "";
      }
    }).toList();
    final systemPath = await getApplicationDocumentsDirectory();
    final folderPath = join(systemPath.path, _folderForImage);
    final directory = Directory(folderPath);
    if (await directory.exists()) {
      await for (final entity in directory.list()) {
        if (entity is File) {
          final fileName = entity.path.split(Platform.pathSeparator).last;
          if (!currents.contains(fileName)) {
            await entity.delete();
          }
        }
      }
    }
  }
}
