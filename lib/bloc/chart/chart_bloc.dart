import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_study/data/data.dart';

part 'chart_event.dart';

part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
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
        List<TotalData> result = List.empty(growable: true);
        Map<String, double> map = {};
        map["Інше"] = 0;
        await for (var list in _repository.getAll()) {
          for (Transaction tr in list) {
            if (tr.tags.isEmpty) {
              map["Інше"] = (map["Інше"] ?? 0) + tr.total;
            } else {
              for (String tg in tr.tags) {
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
        List<TotalData> result = List.empty(growable: true);
        Map<String, double> map = {};
        map["Інше"] = 0;
        await for (var list in _repository.getAll(start: _start, end: _end)) {
          for (Transaction tr in list) {
            if (tr.tags.isEmpty) {
              map["Інше"] = (map["Інше"] ?? 0) + tr.total;
            } else {
              for (String tg in tr.tags) {
                map[tg] = (map[tg] ?? 0) + tr.total;
              }
            }
          }
          var allTags = map.keys.toList();
          map.removeWhere((key, value) => !event.tagsAdded.contains(key));
          map.forEach((k, v) => result.add(TotalData(k, v)));
          emit(LoadedChart(result, allTags));
        }
      },
    );

    on<GetFilteredByDateRange>(
      (event, emit) async {
        _start = event.start;
        _end = event.end;
        List<TotalData> result = List.empty(growable: true);
        Map<String, double> map = {};
        map["Інше"] = 0;
        print("!!!!!!!!!!!!!!!!!!1" + _start.toString());
        await for (var list in _repository.getAll(start: _start, end: _end)) {
          for (Transaction tr in list) {
            if (tr.tags.isEmpty) {
              map["Інше"] = (map["Інше"] ?? 0) + tr.total;
            } else {
              for (String tg in tr.tags) {
                map[tg] = (map[tg] ?? 0) + tr.total;
              }
            }
          }
          var allTags = map.keys.toList();
          if (_savedTags?.isNotEmpty ?? false) {
            map.removeWhere((key, value) => !_savedTags!.contains(key));
          }


          map.forEach((k, v) => result.add(TotalData(k, v)));
          print("!!!!!!!" + "must be new chart" + result.length.toString());
          emit(LoadedChart(result, allTags));
        }
      },
    );
  }
}
