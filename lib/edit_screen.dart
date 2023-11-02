import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_study/item_screen.dart';
import 'package:provider/provider.dart';
import 'data/data.dart';
import 'data/item_bloc.dart';
import 'data/item_event.dart';
import 'data/item_state.dart';
import 'data/transaction_bloc.dart';

class EditScreen extends StatelessWidget {
  final Transaction? transaction;

  const EditScreen({super.key, this.transaction});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionItemBloc, ItemState>(
      builder: (context, state) {
        if (state is Initial) {
          if (transaction == null) {
            {
              context.read<TransactionItemBloc>().add(
                    NewTransaction(),
                  );
              return progress();
            }
          } else {
            context.read<TransactionItemBloc>().add(
                  EditTransaction(transaction?.id??0),
                );
            return progress();
          }
        } else if (state is NewItem) {
          return EditForm(transaction: null);
        } else if (state is EditedTransaction) {
          return EditForm(transaction: state.transaction);
        } else {
          return progress();
        }
      },
    );
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
      ),
    );
  }

  Widget progress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
