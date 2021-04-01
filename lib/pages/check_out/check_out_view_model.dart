import 'package:stacked/stacked.dart';

class CheckOutViewModel extends BaseViewModel {
  int _paymentMethodRadio = 1;

  int get paymentMethodRadio => _paymentMethodRadio;
  void onRadioValueChanged(int value) {
    _paymentMethodRadio = value;
    notifyListeners();
  }
}
