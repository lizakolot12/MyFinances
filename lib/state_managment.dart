import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Settings extends ChangeNotifier {
  Locale _locale = Locale('en');
  bool _isLight = false;

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
