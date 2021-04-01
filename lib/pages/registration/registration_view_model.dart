import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/pages/home_page/home_page.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegistrationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _snackService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  onChanged(String value) {}

  void submitClicked() {
    _navigationService.navigateToView(HomePage());
  }
}
