import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_study/ui/util/provider_state_managment.dart';
import 'package:my_study/ui/util/widgets.dart';
import 'package:provider/provider.dart';
import '../../data/data.dart';
import '../../bloc/item/item_bloc.dart';
import '../../bloc/item/item_event.dart';
import '../../bloc/item/item_state.dart';
import '../../bloc/list/transaction_bloc.dart';
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
                        return EditForm(
                            transaction: null, allOptions: state.possibleTags);
                      } else if (state is EditedTransaction) {
                        return EditForm(
                            transaction: state.transaction,
                            allOptions: state.possibleTags);
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
  final Set<String> allOptions;

  const EditForm(
      {super.key, required this.transaction, required this.allOptions});

  @override
  EditFormState createState() => EditFormState();
}

class EditFormState extends State<EditForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  Set<String> savedSelectedOptions =  {};
  String path = "";
  File? image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        path = pickedFile.path;
        print("!!!!!!!!!!!!!!!result = $path");
      });
    }
  }

  void _openImage(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FullScreenDialog(imagePath: path);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.transaction?.name ?? "";
    _amountController.text = widget.transaction?.total.toString() ?? "";
    savedSelectedOptions = widget.transaction?.tags ??  {};
    path = widget.transaction?.path ?? "";
    print("path $path");
    image = File(path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        child: SizedBox(
          height: 1240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.label_name),
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.label_total),
                keyboardType: TextInputType.number,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ChipInputWidget(
                  allOptions: widget.allOptions,
                  onSelectedOptionsChanged: (selectedOptions) {
                    savedSelectedOptions = selectedOptions;
                  },
                  selectedOptions: savedSelectedOptions,
                ),
              ),
              InkWell(
                onTap: _openImage,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          path == "" || image == null || !image!.existsSync()
                              ? const Text('')
                              : Image.file(
                                  image??File(""),
                                  width: 200,
                                  height: 200,
                                ),
                          OutlinedButton(
                            onPressed: _pickImage,
                            child: Row(
                              children: [
                                const Icon(Icons.upload_rounded),
                                Text(AppLocalizations.of(context)!.take_photo)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
          bottom: 16.0,
          right: 16.0,
          child: ElevatedButton(
            onPressed: () {
              String name = _nameController.text;
              double amount = double.tryParse(_amountController.text) ?? 0;
              if (widget.transaction == null) {
                context.read<TransactionItemBloc>().add(
                      CreateTransaction(
                          name, amount, path, savedSelectedOptions),
                    );
              } else {
                Transaction transaction = Transaction(
                    widget.transaction?.id ?? 0,
                    name,
                    widget.transaction!.date,
                    amount,
                    path,
                    savedSelectedOptions);
                context.read<TransactionItemBloc>().add(
                      SaveTransaction(transaction),
                    );
              }
            },
            child: Text(AppLocalizations.of(context)!.label_save),
          )),
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
class FullScreenDialog extends StatelessWidget {
  final String imagePath;

  const FullScreenDialog({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.file(
              File(imagePath),
              /*fit: BoxFit.none,*/
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}