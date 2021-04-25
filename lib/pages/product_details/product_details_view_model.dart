import 'package:carousel_slider/carousel_options.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/model/product_details_data.dart';
import 'package:lotus_farm/pages/login_page/login_page.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/Constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductDetailsViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  int _currentPosition = 0;
  int _totalAmount = 0;
  AppRepo _appRepo;

  ProductDetailsData _data;
  List<Product> _similarList = [];
  List<String> _benifitImages = [
    ImageAsset.leaf,
    ImageAsset.quality,
    ImageAsset.chckien_feed,
    ImageAsset.hand_leaf,
    ImageAsset.hanad_shake,
    ImageAsset.chemical_not_allowed,
  ];
  List<String> _benifitText = [
    "Fresh with nutrition intact",
    "Chilled Water Preservation Technique",
    "Precision Nutrision",
    "Open Farming",
    "Traceable Transparent and Trusted",
    "No Preservatives & No Antibiotics"
  ];

  int _tabPosition = 0;
  int get totalAmount => _totalAmount;
  int get tabPosition => _tabPosition;
  int get currentPosition => _currentPosition;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<Product> get similarList => _similarList;
  ProductDetailsData get productDetailsData => _data;
  List<String> get benifitImages => _benifitImages;
  List<String> get benifitText => _benifitText;

  String _productId;

  setTabPosition(int value) {
    _tabPosition = value;
    notifyListeners();
  }

  void initData(String productId, AppRepo appRepo) {
    _productId = productId;
    _appRepo = appRepo;
    fetchProductDetails();
  }

  fetchProductDetails() async {
    try {
      final response = await _apiService.fetchProductDetails(_productId);
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _data = response.data;
        _data.qty = 1;
        _totalAmount = (double.parse(_data.newPrice) * _data.qty).toInt();
        fetchSimilarList(_data.categoryId, "1");
      } else {
        _hasError = true;
      }
      notifyListeners();
    } catch (e) {
      myPrint(e.toString());
      _loading = false;
      _hasError = true;
      notifyListeners();
    }
  }

  fetchSimilarList(String categoryId, String pageNO) async {
    try {
      final response = await _apiService.fetchProductList(pageNO, categoryId);
      if (response.status == Constants.SUCCESS) {
        _similarList = response.data;
        _similarList.removeWhere((element) => (element.id == _data.id));
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
    }
  }

  void onPageChanged(int index, CarouselPageChangedReason reason) {
    _currentPosition = index;
    notifyListeners();
  }

  void addClicked() {
    _data.qty++;
    _totalAmount = (double.parse(_data.newPrice) * _data.qty).toInt();
    notifyListeners();
  }

  void lessClicked() {
    if (_data.qty != 1) {
      _data.qty--;
      _totalAmount = (double.parse(_data.newPrice) * _data.qty).toInt();
      notifyListeners();
    }
  }

  void addToCart(String productId, String sizeId, int qty,
      {Function onError}) async {
    if (_appRepo.login) {
      try {
        showProgressDialogService("Please wait...");
        final response =
            await _apiService.addToCart(productId, qty.toString(), sizeId);
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
