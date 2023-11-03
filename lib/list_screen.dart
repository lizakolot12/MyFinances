import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'data/data.dart';
import 'data/transaction_bloc.dart';

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
        return buildList(list);
      } else if (state is LoadingTransaction) {
        List<Transaction> list = state.transactions;
        return Stack(
          children: [
            buildList(list),
            progress(),
          ],
        );
      } else {
        return progress();
      }
    });
  }

  Widget buildList(List<Transaction> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => ListTile(
          title: Text(
            list[index].name,
            style: Theme.of(context).textTheme.titleMedium,
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
          onTap: () => goToDetail(context, list[index].id)),
    );
  }

  void goToDetail(BuildContext context, int id) {
    if (id == 3) {
      GoRouter.of(context).go("/some");
    } else {
      GoRouter.of(context).go("/edit/$id");
    }
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
