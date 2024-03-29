import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/data.dart';
import '../../bloc/list/transaction_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AllTransactionView extends StatelessWidget {
  final List<Transaction> list;
  final Function onItemChose;
  final double total;

  const AllTransactionView(
      {super.key,
      required this.list,
      required this.onItemChose,
      required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Text(
              AppLocalizations.of(context)!.month_total,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  total.toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ))
          ]),
        ),
        Expanded(
          child: buildList(),
        ),
      ],
    );
  }

  Widget buildList() {
    final DateFormat formatter = DateFormat('dd-MM-yy');
    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.only(bottom: 70.0),
      itemBuilder: (context, index) => ListTile(
          title: Row(
            children: [
              Text(
                list[index].name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    formatter.format(
                      list[index].date,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ))
            ],
          ),
          subtitle: Text(
            list[index].total.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: IconButton(
            disabledColor: Colors.black12,
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: list[index].isProgress
                ? null
                : () => context.read<TransactionListBloc>().add(
                      RemoveTransaction(list[index]),
                    ),
          ),
          onTap: () => onItemChose.call(list[index].id)),
    );
  }
}
