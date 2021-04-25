import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/offerResponse.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/Constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OfferViewModel extends BaseViewModel {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  bool _loading = true;
  bool _hasError = false;
  List<OffersImg> _offerImageList;
  AppRepo _appRepo;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<OffersImg> get offerImageList => _offerImageList;

  initData(AppRepo appRepo) {
    _appRepo = appRepo;
    if (_appRepo.offerList != null) {
      fetchOffers();
    } else {
      _loading = false;
      _hasError = false;
      _offerImageList = _appRepo.offerList;
      notifyListeners();
    }
  }

  fetchOffers({bool loading = true}) async {
    if (loading) {
      _loading = true;
      _hasError = false;
      notifyListeners();
    }
    try {
      final response = await _apiService.fetchOffers();
      _loading = false;
      if (response.status == Constants.SUCCESS) {
        _offerImageList = response.data.offersImg??[];
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
