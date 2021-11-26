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

class ProductListViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  bool _loadMore = false;
  bool _hasNext = false;
  List<Product> _productList = [];
  int currentPage = 1;
  AppRepo _appRepo;

  bool get loading => _loading;
  bool get hasError => _hasError;
  bool get loadMore => _loadMore;
  bool get hasNext => _hasNext;

  List<Product> get productList => _productList;

  void setPage(int value) {
    currentPage = value;
    notifyListeners();
  }

  void setLoadMore(bool value) {
    _loadMore = value;
    notifyListeners();
  }

  void initTrending(AppRepo appRepo, List<Product> list) {
    _appRepo = appRepo;
    _productList = list;
    notifyListeners();
  }

  void initData(AppRepo appRepo, bool isPreOrder, String categoryId) {
    _appRepo = appRepo;
    if (!isPreOrder) {
     // if (_appRepo.productList == null) {
        fetchProductList(categoryId);
      // } else {
      //   _productList = _appRepo.productList;
      //   _loading = false;
      //   _hasError = false;
      //   notifyListeners();
      // }
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

  setProductList(List<Product> list) {
    _productList = list;
  }

  loadMoreList(String categoryId) async {
    try {
      final response = await _apiService.fetchProductList(
          currentPage.toString(), categoryId);
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _productList.addAll(response.data);
        if (response.links.isNext) {
          currentPage = response.links.next;
        }
        //_productList.removeWhere((element) => (element.id == _data.id));
      }
      notifyListeners();
    } catch (e) {
      if (loading) {
        _loading = false;
        _hasError = true;
        notifyListeners();
      }
    }
  }

  fetchProductList(String categoryId, {bool loading = false}) async {
    if (loading) {
      currentPage = 1;
      _loading = true;
      _hasError = false;
    } else {
      _loadMore = true;
    }
    notifyListeners();
    try {
      final response = await _apiService.fetchProductList(
          currentPage.toString(), categoryId);
      _loading = false;
      _loadMore = false;
      if (response.status == Constants.SUCCESS) {
        _productList.addAll(response.data);
        _hasNext = response.links.isNext;
        currentPage = response.links.next;
        //_productList.removeWhere((element) => (element.id == _data.id));
      }
      notifyListeners();
    } catch (e) {
      myPrint(e.toString());
      // if (loading) {
      _loading = false;
      _hasError = true;
      _loadMore = false;
      notifyListeners();
      //}
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
        _appRepo.setPreOrderList(response.data);
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

  // fetchAllProducts({bool loading = true}) async {
  //   if (loading) {
  //     _loading = true;
  //     _hasError = false;
  //     notifyListeners();
  //   }
  //   try {
  //     final response = await _apiService.fetchAllProducts();
  //     _loading = false;
  //     if (response.status == Constants.SUCCESS) {
  //       _appRepo.setProductList(response.data);
  //       _productList = response.data;
  //     } else {
  //       _hasError = true;
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     myPrint(e.toString());
  //     if (loading) {
  //       _loading = false;
  //       _hasError = true;
  //       notifyListeners();
  //     }
  //   }
  // }

  void addToCart(Product product, int qty, {Function onError}) async {
    if (_appRepo.login) {
      try {
        showProgressDialogService("Please wait...");
        final response = await _apiService.addToCart(product.id, qty, "");
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
