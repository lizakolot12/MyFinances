import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_study/data/data.dart';

part 'chart_event.dart';

part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final TransactionRepository _repository;

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
            print(tr.total);
            if (tr.tags.isEmpty) {
              map["Інше"] = (map["Інше"] ?? 0) + tr.total;
            } else {
              for (String tg in tr.tags) {
                map[tg] =(map[tg] ?? 0) + tr.total;
              }
            }
          }
          map.forEach((k,v) => result.add(TotalData(k, v)));
          print(map);
          print(result);
          emit(LoadedChart(result));
        }
      },
    );
  }
}
