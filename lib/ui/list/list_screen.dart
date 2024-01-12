import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_study/ui/list/transactions_view.dart';
import 'package:provider/provider.dart';
import '../../data/data.dart';
import '../../bloc/list/transaction_bloc.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionListBloc, TransactionState>(
        builder: (context, state) {
      if (state is TransactionInitial) {
        context.read<TransactionListBloc>().add(
              GetAllTransactions(),
            );
        return progress();
      } else if (state is LoadedTransaction) {
        List<Transaction> list = state.transactions;
        return AllTransactionView(
            total: state.total,
            list: list,
            onItemChose: (id) => {goToDetail(context, id)});
      } else if (state is LoadingTransaction) {
        List<Transaction> list = state.transactions;
        return Stack(
          children: [
            AllTransactionView(
                total: state.total,
                list: list,
                onItemChose: (id) => {goToDetail(context, id)}),
            progress(),
          ],
        );
      } else {
        return progress();
      }
    });
  }

  void goToDetail(BuildContext context, int id) {
    GoRouter.of(context).go("/edit/$id");
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
