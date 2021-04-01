import 'package:stacked/stacked.dart';

class ProductDetailsViewModel extends BaseViewModel {
  int _tabPosition = 0;
  int get tabPosition => _tabPosition;

  setTabPosition(int value) {
    _tabPosition = value;
    notifyListeners();
  }
}
