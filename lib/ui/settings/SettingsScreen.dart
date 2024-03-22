import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../data/data.dart';
import '../util/provider_state_managment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart' as provider;

class SettingsScreen extends StatelessWidget {
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
    return Center(
      child: Column(
        children: [
          const LanguageSelectionButton(),
          ExpandableList(tags),
        ],
      ),
    );
  }
}

class LanguageSelectionButton extends StatelessWidget {
  const LanguageSelectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>(); // Зчитуємо SettingsBloc з контексту

    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select Language'),
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
      child: const Text('Select Language'),
    );
  }
}


class ExpandableList extends StatefulWidget {
  final List<String> tags;

  ExpandableList(this.tags);

  @override
  _ExpandableListState createState() => _ExpandableListState(tags);
}

class _ExpandableListState extends State<ExpandableList> {
  bool _isExpanded = false;
  List<String> _tags;

  _ExpandableListState(this._tags);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(_isExpanded ? 'Hide List' : 'Show List'),
        ),
        if (_isExpanded)
          Center(
              child: ListView.builder(
            itemCount: _tags.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                _tags[index],
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: IconButton(
                disabledColor: Colors.black12,
                icon: const Icon(
                  Icons.delete,
                ),
                onPressed: () => context.read<SettingsBloc>().add(
                      DeleteTag(_tags[index]),
                    ),
              ),
            ),
          )),
      ],
    );
  }
}
