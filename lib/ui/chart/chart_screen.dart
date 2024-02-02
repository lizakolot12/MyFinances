import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../../bloc/chart/chart_bloc.dart';
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
        return createChart(context, list, state.tags);
      } else {
        return progress();
      }
    });
  }

  Widget createChart(BuildContext context, List<TotalData> list, List<String> tags) {
    if (list.isEmpty) {
      Center(child: Text(AppLocalizations.of(context)!.empty_chart));
    }
    return Column(children:[
        MultiSelectBottomSheetField(
        initialChildSize: 0.4,
        listType: MultiSelectListType.CHIP,
        searchable: true,
        buttonText: Text(AppLocalizations.of(context)!.tags_labels),
        title: Text(AppLocalizations.of(context)!.tags),
        items: tags.map((e) => MultiSelectItem<String>(e, e)).toList(),
        onConfirm: (values) {
          context.read<ChartBloc>().add(
            GetFiltered(values.map((e) => e.toString()).toList()),
          );
        },
        chipDisplay: MultiSelectChipDisplay(
          onTap: (value) {
          /*  setState(() {
              _selectedAnimals2.remove(value);
            });*/
          },
        )),
      SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        legend: const Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <LineSeries<TotalData, String>>[
          LineSeries<TotalData, String>(
              dataSource: list,
              xValueMapper: (TotalData data, _) => data.categoryName,
              yValueMapper: (TotalData data, _) => data.total,
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ])]);
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
