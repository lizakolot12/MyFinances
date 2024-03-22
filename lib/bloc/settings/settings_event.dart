part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class GetAll extends SettingsEvent {}

class DeleteTag extends SettingsEvent {

  late final String tag;

  DeleteTag(this.tag);
}

class SwitchLanguage extends SettingsEvent {
  late final String locale;
  SwitchLanguage(this.locale);
}

