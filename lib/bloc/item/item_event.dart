import 'package:flutter/widgets.dart';

import 'package:my_study/data/data.dart';

@immutable
abstract class ItemEvent {}

class NewTransaction extends ItemEvent {}

class EditTransaction extends ItemEvent {
  late final int id;

  EditTransaction(this.id);
}

class SaveTransaction extends ItemEvent {
  late final Transaction transaction;

  SaveTransaction(this.transaction);
}

class CreateTransaction extends ItemEvent {
  late final String name;
  late final double total;
  late final String path;
  late final Set<String> selectedOptions;

  CreateTransaction(this.name, this.total, this.path, this.selectedOptions);
}
