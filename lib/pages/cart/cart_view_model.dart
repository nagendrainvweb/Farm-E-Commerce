import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/pages/check_out/check_out_page.dart';
import 'package:lotus_farm/services/api_service.dart';
import '../../utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CartViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  List<Product> _cartList;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<Product> get cartList => _cartList;

  AppRepo _appRepo;

  initData(AppRepo repo) {
    _appRepo = repo;
  }

  fetchCartList({bool loading = true}) async {
    if (loading) {
      _loading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final response = await _apiService.fetchCartDetails();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _cartList = response.data;
        _appRepo.setCartCount(_cartList.length);
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

  void removeFromCart(Product product, {Function onMessage}) async {
    showProgressDialogService("Please wait...");
    try {
      final response =
          await _apiService.removeFromCart(product.id, product.size_id);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        _cartList.remove(product);
        _appRepo.setCartCount(response.cartCount);
        notifyListeners();
        onMessage(response.message);
      } else {
        onMessage(response.message);
      }
    } catch (e) {
      hideProgressDialogService();
      onMessage(e.toString());
    }
  }

  void checkOutClicked({Function onMessage, Function onCallback}) async {
    showProgressDialogService("Please wait...");
    try {
      int totalAmount = 0;
      for (Product product in _cartList) {
        totalAmount = totalAmount + product.amount;
      }
      final response =
          await _apiService.updateCart(cartList, "", totalAmount.toString());
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        final value = await _navigationService.navigateToView(CheckoutPage(
          totalAmount: response.data.totalAmount,
          payingAmount: response.data.payingAmount.toString(),
          discountAmount: "0",
        ));
        onCallback();
      } else {
        onMessage(response.message);
      }
    } catch (e) {
      hideProgressDialogService();
      myPrint(e.toString());
      onMessage(e.toString());
    }
  }
}
