import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_study/data/data.dart';

import 'package:my_study/ui/util/provider_state_management.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final TransactionRepository _repository;
  final Settings _settings;
  Set<String> _allTags = {};

  SettingsBloc({
    required TransactionRepository repository,
    required Settings settings,
  })  : _repository = repository,
        _settings = settings,
        super(SettingsInitial()) {
    on<GetAll>((event, emit) async {
      _allTags = await _repository.getAllTags();
      emit(LoadedSettings(_allTags));
    });

    on<SwitchLanguage>(
      (event, emit) async {
        _settings.toggleLanguage(Locale(event.locale));
      },
    );

    on<DeleteTag>(
      (event, emit) async {
        await _repository.removeTag(event.tag);
        _allTags = await _repository.getAllTags();
        emit(LoadedSettings(_allTags));
      },
    );
  }
}
