import 'package:flutter/widgets.dart';

class MyAppSettings extends InheritedWidget {
  final ValueNotifier<Locale> _localeNotifier;

  MyAppSettings({
    super.key,
    required Widget child,
    required Locale locale,
  })  : _localeNotifier = ValueNotifier<Locale>(locale),
        super(child: child);

  static MyAppSettings of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppSettings>()!;
  }

  @override
  bool updateShouldNotify(covariant MyAppSettings oldWidget) {
    return oldWidget._localeNotifier.value != _localeNotifier.value;
  }

  void toggleLanguage() {
    Locale current = _localeNotifier.value;
    if (current == const Locale('en')) {
      _localeNotifier.value = const Locale('uk');
    } else {
      _localeNotifier.value = const Locale('en');
    }
  }

  Locale locale() => _localeNotifier.value;
}
