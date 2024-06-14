import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChipInputWidget extends StatefulWidget {
  final List<String> allOptions;
  final Function(List<String>) onSelectedOptionsChanged;
  final List<String> selectedOptions;

  ChipInputWidget(
      {required this.allOptions,
      required this.onSelectedOptionsChanged,
      required this.selectedOptions});

  @override
  _ChipInputWidgetState createState() => _ChipInputWidgetState();
}

class _ChipInputWidgetState extends State<ChipInputWidget> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 10, maxHeight: 120),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  spacing: 8,
                  children: widget.selectedOptions.map<Widget>((option) {
                    return Chip(
                      label: Text(option),
                      onDeleted: () {
                        _handleDeleted(option);
                      },
                    );
                  }).toList(),
                ))),
        TypeAheadField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.category_label,
            ),
            onSubmitted: (value) {
              _handleSubmitted(value);
            },
          ),
          suggestionsCallback: (pattern) {
            return widget.allOptions.where((option) =>
                option.toLowerCase().contains(pattern.toLowerCase()));
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          noItemsFoundBuilder: (context) => SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    _handleSubmitted(textEditingController.text);
                  },
                  child:
                 /* Align(
                      alignment: Alignment.topLeft,
                      child:*/
                      Text(
                          AppLocalizations.of(context)!.create_new_tags))),
          onSuggestionSelected: (suggestion) {
            _handleSubmitted(suggestion);
          },
        ),
      ],
    );
  }

  void _handleSubmitted(String value) {
    if (value.isNotEmpty) {
      setState(() {
        widget.selectedOptions.add(value);
        textEditingController.clear();
        widget.onSelectedOptionsChanged(widget.selectedOptions);
      });
    }
  }

  void _handleDeleted(String option) {
    setState(() {
      widget.selectedOptions.remove(option);
      widget.onSelectedOptionsChanged(widget.selectedOptions);
    });
  }
}
