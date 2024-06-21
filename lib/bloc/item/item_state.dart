import 'package:flutter/widgets.dart';

import '../../data/data.dart';

@immutable
abstract class ItemState {}

class Initial extends ItemState {}
class NewItem extends ItemState {
  late final Set<String> possibleTags;
  NewItem(this.possibleTags);
}

class EditedTransaction extends ItemState {
  late final Transaction transaction;
  late final Set<String> possibleTags;

  EditedTransaction(this.transaction, this.possibleTags);
}
class Loading extends ItemState {

}

class Saving extends ItemState {

}

class Saved extends ItemState {

}
