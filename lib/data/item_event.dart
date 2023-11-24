import 'package:flutter/widgets.dart';

import 'data.dart';

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
  late final List<String> selectedOptions;

  CreateTransaction(this.name, this.total, this.selectedOptions);
}
