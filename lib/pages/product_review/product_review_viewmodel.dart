import 'package:flutter/cupertino.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductReviewViewModel extends BaseViewModel with AppHelper{

  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  List<Product> _productReviewList;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<Product> get productReviewList => _productReviewList;

  AppRepo _appRepo;

  initData(AppRepo repo) {
    _appRepo = repo;
  }

  fetchOrderProduct({bool loading = true}) async {
    if (loading) {
      _loading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final response = await _apiService.fetchOrderProductReview();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _productReviewList = response.data;
        //_appRepo.setCartCount(_productReviewList.length);
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

  void updateRating(Product product, double v) {}

  void writeReview(BuildContext context,Product product ,int rating, String title, String review)async {
     progressDialog( "Please wait...",context);
    try {
      final response = await locator<ApiService>()
          .addReview(product.id, rating, title, review);
      hideProgressDialog(context);
      Utility.showCustomSnackBar(response.message, context);
     // _fetchData();
    } catch (e) {
      myPrint(e.toString());
      hideProgressDialog(context);
      Utility.showCustomSnackBar(SOMETHING_WRONG_TEXT, context);
    }
  }
}