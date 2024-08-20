import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_study/data/data.dart';

part 'chart_event.dart';

part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  static const String other = "Інше";
  final TransactionRepository _repository;
  List<String>? _savedTags;
  DateTime? _start;
  DateTime? _end;

  ChartBloc({required TransactionRepository repository})
      : _repository = repository,
        super(ChartInitial()) {
    on<GetAll>(
      (event, emit) async {
        emit(ChartInitial());
        await for (final list in _repository.getAll()) {
          final List<TotalData> result = List.empty(growable: true);
          final Map<String, double> map = {};
          map[other] = 0;
          for (final Transaction tr in list) {
            if (tr.tags.isEmpty) {
              map[other] = (map[other] ?? 0) + tr.total;
            } else {
              for (final String tg in tr.tags) {
                map[tg] = (map[tg] ?? 0) + tr.total;
              }
            }
          }
          map.forEach((k, v) => result.add(TotalData(k, v)));
          emit(LoadedChart(result, map.keys.toList()));
        }
      },
    );

    on<GetFilteredByTags>(
      (event, emit) async {
        _savedTags = event.tagsAdded;
        await for (final list in _repository.getAll(start: _start, end: _end)) {
          final List<TotalData> result = List.empty(growable: true);
          final Map<String, double> map = {};
          map[other] = 0;
          for (final Transaction tr in list) {
            if (tr.tags.isEmpty) {
              map[other] = (map[other] ?? 0) + tr.total;
            } else {
              for (final String tg in tr.tags) {
                map[tg] = (map[tg] ?? 0) + tr.total;
              }
            }
          }
          final allTags = map.keys.toList();
          map.removeWhere((key, value) => !event.tagsAdded.contains(key) && event.tagsAdded.isNotEmpty );
          map.forEach((k, v) => result.add(TotalData(k, v)));
          emit(LoadedChart(result, allTags));
        }
      },
    );

    on<GetFilteredByDateRange>(
      (event, emit) async {
        _start = event.start;
        _end = event.end;
        await for (final list in _repository.getAll(start: _start, end: _end)) {
          final List<TotalData> result = List.empty(growable: true);
          final Map<String, double> map = {};
          map[other] = 0;
          for (final Transaction tr in list) {
            if (tr.tags.isEmpty) {
              map[other] = (map[other] ?? 0) + tr.total;
            } else {
              for (final String tg in tr.tags) {
                map[tg] = (map[tg] ?? 0) + tr.total;
              }
            }
          }
          final allTags = map.keys.toList();
          if (_savedTags?.isNotEmpty ?? false) {
            map.removeWhere((key, value) => !_savedTags!.contains(key));
          }

          map.forEach((k, v) => result.add(TotalData(k, v)));
          emit(LoadedChart(result, allTags));
        }
      },
    );
  }
}
