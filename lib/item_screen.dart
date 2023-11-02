import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/data.dart';

class EditForm extends StatefulWidget {
  final Transaction? transaction;

  const EditForm({super.key, required this.transaction});

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.edit_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                String amount = amountController.text;
                // Ваша логіка збереження даних

                nameController.clear();
                amountController.clear();
              },
              child: Text(AppLocalizations.of(context)!.label_save),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
