import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  String _name="";

  String get name => _name;
  void initData() async {
    final firstName = await Prefs.name;
    final lastName = await Prefs.surName;
    _name = firstName + " " + lastName;
    notifyListeners();
  }
}
