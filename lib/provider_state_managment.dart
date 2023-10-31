import 'package:flutter/widgets.dart';

class Settings extends ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _isLight = false;
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  Settings(this._locale, this._isLight);

  Locale get locale => _locale;

  void toggleLanguage() {
    Locale current = _locale;
    if (current == const Locale('en')) {
      _locale = const Locale('uk');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  bool get isLight => _isLight;

  void toggleLightness() {
    _isLight = !isLight;
    notifyListeners();
  }
}
