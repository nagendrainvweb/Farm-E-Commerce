import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/Constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddressViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  List<AddressData> _addressList;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<AddressData> get addressList => _addressList;

  fetchAddressList({bool loading = true}) async {
    if (loading) {
      _loading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final response = await _apiService.fetchAddress();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _addressList = response.data;
      } else {
        _hasError = true;
      }
      notifyListeners();
    } catch (e) {
      myPrint(e.toString());
      if (loading) {
        _loading = false;
        _hasError = true;
        notifyListeners();
      }
    }
  }

  void deleteAddress(int index, {Function onMessage}) async {
    showProgressDialogService("Please wait...");
    try {
      final response =
          await _apiService.deleteAddress(addressList[index].addressId);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        _addressList.removeAt(index);
      }
      notifyListeners();
      onMessage(response.message);
    } catch (e) {
      hideProgressDialogService();
      onMessage(e.toString());
    }
  }
}
