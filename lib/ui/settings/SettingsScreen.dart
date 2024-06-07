import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../data/data.dart';
import '../util/provider_state_managment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart' as provider;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(builder: (context, settings, child) {
      return BlocProvider.value(
        value: SettingsBloc(
          repository: RepositoryProvider.of<TransactionRepository>(context),
          settings: settings,
        ),
        child: AllSettingsScreen(),
      );
    });
  }
}

class AllSettingsScreen extends StatelessWidget {
  const AllSettingsScreen({super.key});

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
                  title: Text(AppLocalizations.of(context)!.settings_title),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                      print("NEW STATE " + state.toString());
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
  final List<String> tags;

  const AllComponents(this.tags, {super.key});

  @override
  Widget build(BuildContext context) {
    print("new list " + tags.toString());
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

class ExpandableList extends StatelessWidget {
  final _tags;

  const ExpandableList(this._tags, {super.key});

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
                  title: Text(AppLocalizations.of(context)!.delete_tags),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: List.generate(_tags.length,(index){
                        return GestureDetector(
                          onTap: () {
                            settingsBloc.add(DeleteTag(_tags[index]));
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(_tags[index]),
                          ),
                        );
                      }),
                    ),
                  ),
                );

              },
            );
          },
          child: Text(AppLocalizations.of(context)!.delete_tags),
        ),
      ),
    );
    ;
  }
}
