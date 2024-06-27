import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ChipInputWidget extends StatefulWidget {
  final Set<String> allOptions;
  final Function(Set<String>) onSelectedOptionsChanged;
  final Set<String> selectedOptions;

  const ChipInputWidget({
    super.key,
    required this.allOptions,
    required this.onSelectedOptionsChanged,
    required this.selectedOptions,
  });

  @override
  State<ChipInputWidget> createState() => _ChipInputWidgetState();
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
            ),
          ),
        ),
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
            return widget.allOptions.where(
              (option) =>
                  pattern.isNotEmpty &&
                  option.toLowerCase().contains(
                        pattern.toLowerCase(),
                      ),
            );
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
              child: Text(AppLocalizations.of(context)!.create_new_tags),
            ),
          ),
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
        widget.allOptions.add(value);
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
