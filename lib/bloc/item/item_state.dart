import 'package:flutter/widgets.dart';

import '../../data/data.dart';

@immutable
abstract class ItemState {}

class Initial extends ItemState {}
class NewItem extends ItemState {}

class EditedTransaction extends ItemState {
  late final Transaction transaction;

  EditedTransaction(this.transaction);
}
class Loading extends ItemState {

}

class Saving extends ItemState {

}

class Saved extends ItemState {

}
