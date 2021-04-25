import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/model/pastOrderData.dart';
import 'package:lotus_farm/services/api_service.dart';
import '../../utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderViewModel extends BaseViewModel{

  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  List<PastOrderData> _orderList;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<PastOrderData> get orderList => _orderList;

    fetchOrderList({bool loading=true}) async {
    if (loading) {
      _loading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final response = await _apiService.fetchPastOrders();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _orderList = response.data;
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
}