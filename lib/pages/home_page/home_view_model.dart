import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/pages/login_page/login_page.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  int _currentBottomIndex = 0;
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _snackService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();
  int get currentBottomIndex => _currentBottomIndex;

  void onBottomButtonClicked(int value) async {
    if (value == 2 || value == 3) {
      final login = await Prefs.login;
      if (login) {
        _currentBottomIndex = value;
        notifyListeners();
      } else {
        _navigationService.navigateToView(LoginPage());
      }
    } else {
      _currentBottomIndex = value;
      notifyListeners();
    }
  }

  void retryClicked() {}

  void initData(int position) {
    onBottomButtonClicked(position);
  }
}
