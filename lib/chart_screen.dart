import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'data/chart_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(builder: (context, state) {
      if (state is ChartInitial) {
        context.read<ChartBloc>().add(
              GetAll(),
            );
        return progress();
      } else if (state is LoadedChart) {
        List<TotalData> list = state.data;
        return createChart(context, list);
      } else {
        return progress();
      }
    });
  }

  Widget createChart(BuildContext context, List<TotalData> list) {
    if (list.isEmpty) {
       Center(child: Text(AppLocalizations.of(context)!.empty_chart));
    }
    return SfCircularChart(legend: const Legend(isVisible: true),
        series: <PieSeries<TotalData, String>>[
      PieSeries<TotalData, String>(
          explode: true,
          explodeIndex: 0,
          dataSource: list,
          xValueMapper: (TotalData data, _) => data.categoryName,
          yValueMapper: (TotalData data, _) => data.total,
          dataLabelMapper: (TotalData data, _) => data.total.toString(),
          dataLabelSettings: const DataLabelSettings(isVisible: true)),
    ]);
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
