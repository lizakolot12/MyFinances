part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class LoadedSettings extends SettingsState {
  late final Set<String> tags;

  LoadedSettings(this.tags);
}
