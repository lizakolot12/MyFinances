import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_study/bloc/settings/settings_bloc.dart';
import 'package:my_study/data/data.dart';
import 'package:my_study/ui/util/provider_state_management.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        print("first " + settings.hashCode.toString());
        return BlocProvider.value(
          value: SettingsBloc(
            repository: RepositoryProvider.of<TransactionRepository>(context),
            settings: settings,
          ),
          child: const AllSettingsScreen(),
        );
      },
    );
  }
}

class AllSettingsScreen extends StatelessWidget {
  const AllSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        print("settins" + settings.hashCode.toString() + "  " + settings.locale.toString());
        return Localizations.override(
          context: context,
          locale: settings.locale,
          child: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.settings_title),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      if (state is SettingsInitial) {
                        context.read<SettingsBloc>().add(GetAll());
                        return progress();
                      } else if (state is LoadedSettings) {
                        return AllComponents(state.tags);
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

  Widget progress() {
    return const Center(child: CircularProgressIndicator());
  }
}

class AllComponents extends StatelessWidget {
  final Set<String> tags;

  const AllComponents(this.tags, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LanguageSelectionButton(),
          ExpandableList(tags),
        ],
      ),
    );
  }
}

class LanguageSelectionButton extends StatelessWidget {
  const LanguageSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return Card(
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.select_language),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        GestureDetector(
                          onTap: () {
                            settingsBloc.add(SwitchLanguage('en'));
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('English'),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            settingsBloc.add(SwitchLanguage('uk'));
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Українська'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text(AppLocalizations.of(context)!.select_language),
        ),
      ),
    );
  }
}

class ExpandableList extends StatefulWidget {
  final Set<String> _tags;

  const ExpandableList(this._tags, {super.key});

  @override
  State<ExpandableList> createState() => _ExpandableListState();
}

class _ExpandableListState extends State<ExpandableList> {
  late Set<String> _categories;

  @override
  void initState() {
    _categories = widget._tags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return _DeleteTagsDialog(
                  categories: _categories,
                  onTagDeleted: (String tag) {
                    settingsBloc.add(DeleteTag(tag));
                    setState(() {
                      _categories.remove(tag);
                    });
                  },
                );
              },
            );
          },
          child: Text(AppLocalizations.of(context)!.delete_tags),
        ),
      ),
    );
  }
}

class _DeleteTagsDialog extends StatefulWidget {
  final Set<String> categories;
  final Function(String) onTagDeleted;

  const _DeleteTagsDialog({
    super.key,
    required this.categories,
    required this.onTagDeleted,
  });

  @override
  State<_DeleteTagsDialog> createState() => _DeleteTagsDialogState();
}

class _DeleteTagsDialogState extends State<_DeleteTagsDialog> {
  late Set<String> _categories;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories.toSet(); // Create a copy to modify locally
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.delete_tags),
      content: _categories.isNotEmpty
          ? SingleChildScrollView(
              child: ListBody(
                children: List.generate(_categories.length, (index) {
                  final tag = _categories.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _categories.remove(tag);
                        widget.onTagDeleted(tag);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(tag),
                    ),
                  );
                }),
              ),
            )
          : Text(AppLocalizations.of(context)!.not_categories),
    );
  }
}
