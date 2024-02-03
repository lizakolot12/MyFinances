import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../bloc/chart/chart_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(builder: (context, state) {
      if (state is ChartInitial) {
        context.read<ChartBloc>().add(GetAll());
        return progress();
      } else if (state is LoadedChart) {
        print("new loaded chart " + state.data.length.toString());
        return Data(list: state.data, tags: state.tags);
      } else {
        return progress();
      }
    });
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class Data extends StatelessWidget {
  final List<TotalData> list;
  final List<String> tags;

  const Data({super.key, required this.list, required this.tags});

  void _onSelectionChanged(BuildContext context, Object? args) {
    print("!!!!!!!!!!!!");
    print(args);
    if (args is PickerDateRange) {
      final DateTime? rangeStartDate = args.startDate;
      final DateTime? rangeEndDate = args.endDate;
      context.read<ChartBloc>().add(
            GetFilteredByDateRange(rangeStartDate, rangeEndDate),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("create chart " + list.length.toString());
    return Column(
      children: [
        SfDateRangePicker(
          selectionMode: DateRangePickerSelectionMode.range,
          showActionButtons: true,
          onSubmit: (args) {
            _onSelectionChanged(context, args);
          },
        ),
        MultiSelectBottomSheetField(
          initialChildSize: 0.4,
          listType: MultiSelectListType.CHIP,
          searchable: true,
          buttonText: Text(AppLocalizations.of(context)!.tags_labels),
          title: Text(AppLocalizations.of(context)!.tags),
          items: tags.map((e) => MultiSelectItem<String>(e, e)).toList(),
          onConfirm: (values) {
            context.read<ChartBloc>().add(
                  GetFilteredByTags(values.map((e) => e.toString()).toList()),
                );
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (value) {
              /*  setState(() {
                _selectedAnimals2.remove(value);
              });*/
            },
          ),
        ),
        if (list.isEmpty)
          Center(child: Text(AppLocalizations.of(context)!.empty_chart))
        else
          SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            legend: const Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <LineSeries<TotalData, String>>[
              LineSeries<TotalData, String>(
                dataSource: list,
                xValueMapper: (TotalData data, _) => data.categoryName,
                yValueMapper: (TotalData data, _) => data.total,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
      ],
    );
  }
}
