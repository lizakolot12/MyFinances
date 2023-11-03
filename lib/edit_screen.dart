import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_study/item_screen.dart';
import 'package:my_study/provider_state_managment.dart';
import 'package:provider/provider.dart';
import 'data/data.dart';
import 'data/item_bloc.dart';
import 'data/item_event.dart';
import 'data/item_state.dart';
import 'data/transaction_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditScreen extends StatelessWidget {
  final int? transactionId;

  const EditScreen({super.key, this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return Localizations.override(
          context: context,
          locale: settings.locale,
          child: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.edit_title),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<TransactionItemBloc, ItemState>(
                    builder: (context, state) {
                      if (state is Initial) {
                        if (transactionId == null) {
                          {
                            context.read<TransactionItemBloc>().add(
                                  NewTransaction(),
                                );
                            return progress();
                          }
                        } else {
                          context.read<TransactionItemBloc>().add(
                                EditTransaction(transactionId ?? 0),
                              );
                          return progress();
                        }
                      } else if (state is NewItem) {
                        return const EditForm(transaction: null);
                      } else if (state is EditedTransaction) {
                        return EditForm(transaction: state.transaction);
                      } else if (state is Saved) {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            GoRouter.of(context).pop();
                          },
                        );
                        return const Text("");
                      } else {
                        return progress();
                      }
                    },
                  ),
                ),
              );
            },
          ),
        );
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
    return const Center(child: CircularProgressIndicator());
  }
}

class EditForm extends StatefulWidget {
  final Transaction? transaction;

  const EditForm({super.key, required this.transaction});

  @override
  EditFormState createState() => EditFormState();
}

class EditFormState extends State<EditForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.transaction?.name ?? "";
    amountController.text = widget.transaction?.total.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.label_name),
        ),
        TextFormField(
          controller: amountController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.label_total),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: () {
            String name = nameController.text;
            double amount = double.tryParse(amountController.text) ?? 0;
            context.read<TransactionItemBloc>().add(
                  CreateTransaction(name, amount),
                );
          },
          child: Text(AppLocalizations.of(context)!.label_save),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
