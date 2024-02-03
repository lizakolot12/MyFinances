part of 'chart_bloc.dart';

@immutable
abstract class ChartEvent {}

class GetAll extends ChartEvent {}

class GetFilteredByTags extends ChartEvent {

  late final List<String> tagsAdded;

  GetFilteredByTags(this.tagsAdded);
}

class GetFilteredByDateRange extends ChartEvent {

  late final DateTime? start;
  late final DateTime? end;

  GetFilteredByDateRange(this.start, this.end);
}

