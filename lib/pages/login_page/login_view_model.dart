import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/pages/otp_page/otp_page.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();

  void loginClicked() {
    _navigationService.navigateToView(OtpPage());
  }
}
