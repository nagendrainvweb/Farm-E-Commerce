
import 'package:lotus_farm/prefrence_util/PreferencesHelper.dart';
import 'package:lotus_farm/utils/constants.dart';

class Prefs {
  static Future setLogin(bool value) =>
      PreferencesHelper.setBool(Constants.IS_LOGIN, value);

  static Future<bool> login() => PreferencesHelper.getBool(Constants.IS_LOGIN);

  static void clear() {}
}
