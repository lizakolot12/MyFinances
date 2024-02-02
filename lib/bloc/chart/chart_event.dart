part of 'chart_bloc.dart';

@immutable
abstract class ChartEvent {}

class GetAll extends ChartEvent {}

class GetFiltered extends ChartEvent {

  late final List<String> tagsAdded;

  GetFiltered(this.tagsAdded);
}

