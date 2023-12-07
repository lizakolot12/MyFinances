part of 'chart_bloc.dart';

@immutable
abstract class ChartState {}

class ChartInitial extends ChartState {}

class LoadedChart extends ChartState {
  late final List<TotalData> data;

  LoadedChart(this.data);
}

class TotalData {
  TotalData(this.categoryName, this.total);

  final String categoryName;
  final double total;
}