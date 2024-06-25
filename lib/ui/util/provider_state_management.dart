import 'package:flutter/widgets.dart';

class Settings extends ChangeNotifier {
  Locale _locale = const Locale('en');
  bool _isLight = false;

  Settings(this._locale, this._isLight);

  Locale get locale => _locale;

  void toggleLanguage(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  bool get isLight => _isLight;

  void toggleLightness() {
    _isLight = !isLight;
    notifyListeners();
  }
}
