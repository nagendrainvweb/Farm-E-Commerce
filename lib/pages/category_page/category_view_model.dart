import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/pages/login_page/login_page.dart';
import 'package:lotus_farm/services/api_service.dart';
import '../../utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CategoryViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  List<Product> _productList;
  AppRepo _appRepo;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<Product> get productList => _productList;

  void initTrending(AppRepo appRepo, List<Product> list) {
    _appRepo = appRepo;
    _productList = list;
    notifyListeners();
  }

  void initData(AppRepo appRepo, bool isPreOrder) {
    _appRepo = appRepo;
    if (!isPreOrder) {
      if (_appRepo.productList == null) {
        fetchAllProducts();
      } else {
        _productList = _appRepo.productList;
        _loading = false;
        _hasError = false;
        notifyListeners();
      }
    } else {
      if (_appRepo.preOrderList == null) {
        fetchPreOrder();
      } else {
        _productList = _appRepo.preOrderList;
        _loading = false;
        _hasError = false;
        notifyListeners();
      }
    }
  }

  fetchPreOrder({bool loading = true}) async {
    if (loading) {
      _loading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final response = await _apiService.fetchPreOrderList();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _appRepo.setProductList(response.data);
        _productList = response.data;
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

  fetchAllProducts({bool loading = true}) async {
    if (loading) {
      _loading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final response = await _apiService.fetchAllProducts();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _appRepo.setProductList(response.data);
        _productList = response.data;
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

  void addToCart(Product product, int qty, {Function onError}) async {
    if (_appRepo.login) {
      try {
        showProgressDialogService("Please wait...");
        final response =
            await _apiService.addToCart(product.id, qty, product.sizes[0].id);
        hideProgressDialogService();
        if (response.status == Constants.SUCCESS) {
          _appRepo.setCartCount(response.cartCount);
          onError(response.message);
        } else {
          onError(response.message);
        }
      } catch (e) {
        hideProgressDialogService();
        myPrint(e.toString());
        onError(e.toString());
      }
    } else {
      _navigationService.navigateToView(LoginPage());
    }
  }
}
