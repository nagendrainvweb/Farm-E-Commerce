import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/dashboard_data.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/pages/login_page/login_page.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/Constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DashboardViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  DashboardData _dashboardData;

  List<String> _bannerList = [
    "https://b.zmtcdn.com/data/pictures/chains/8/48188/09b465b6d54418e8d8d43ff64f04dfc3.jpg",
    "https://b.zmtcdn.com/data/pictures/chains/8/48188/5a2efc061852861b316275c4428e5007.jpg",
    "https://b.zmtcdn.com/data/pictures/chains/8/48188/731e244b54f8e8b4df18379ee6e142d2.jpg"
  ];

  List<String> get bannerList => _bannerList;
  int _currentPostion = 0;

  int get currentPosition => _currentPostion;
  bool get loading => _loading;
  bool get hasError => _hasError;
  DashboardData get dashboardData => _dashboardData;

  AppRepo _appRepo;

  void pageChanged(int index) {
    _currentPostion = index;
    notifyListeners();
  }

  void initTrending(AppRepo repo){
     _appRepo = repo;
  }

  void init(AppRepo repo) {
    _appRepo = repo;
    if (_appRepo.dashboardData != null) {
      _loading = false;
      _hasError = false;
      _dashboardData = _appRepo.dashboardData;
      notifyListeners();
    } else {
      fetchDashboardData();
    }
  }

  void fetchDashboardData({bool loading = true}) async {
    if (loading) {
      _loading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final response = await _apiService.fetchDashboard();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _appRepo.setDashboardData(response.data);
        _dashboardData = response.data;
        _appRepo.setCartCount(_dashboardData.inCartcount);
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
