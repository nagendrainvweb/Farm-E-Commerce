import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/model/storeData.dart';
import 'package:lotus_farm/pages/addEditAddressPage/addEditAddressPage.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/Constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CheckOutViewModel extends BaseViewModel {
  int _paymentMethodRadio = 1;
  int _deliveryRadio = 1;
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();
  Razorpay _razorpay;

  bool _loading = true;
  bool _hasError = false;
  List<AddressData> _addressList;
  List<StoreData> _storeList;
  AddressData _addressData;
  AppRepo _appRepo;
  StoreData _storeData;
  DateTime _pickUpDate;
  String _timeSlot;
  String _totalAmount, _payingAmount, _discountAmount;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<AddressData> get addressList => _addressList;
  AddressData get addressData => _addressData;
  List<StoreData> get storeList => _storeList;
  StoreData get storeData => _storeData;
  DateTime get pickUpDate => _pickUpDate;
  String get timeSlot => _timeSlot;
  String get totalAmount => _totalAmount;
  String get payingAmount => _payingAmount;
  String get discountAmount => _discountAmount;

  int get paymentMethodRadio => _paymentMethodRadio;
  int get deliveryRadio => _deliveryRadio;

  void onRadioValueChanged(int value) {
    _paymentMethodRadio = value;
    notifyListeners();
  }

  void onDeliveryRadioValueChanged(int value) {
    _deliveryRadio = value;
    notifyListeners();
  }

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
        if (_addressList.isNotEmpty) {
          int position =
              _addressList.indexWhere((element) => element.isDefault);
          if (position != -1) {
            _addressData = _addressList[position];
          } else {
            _addressData = _addressList[0];
          }
        }
        //else {
        //   final valid = await _dialogService.showCustomDialog(
        //     variant: DialogType.error,
        //     title: "Error",
        //     description: "No Address Found",
        //     mainButtonTitle: "Add Address",
        //     secondaryButtonTitle: "Cancel",
        //   );
        //   // final value =
        //   //     await _navigationService.navigateToView(AddEditAddressPage());
        //   // fetchAddressList();
        // }
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

  void setAddressData(AddressData data) {
    _addressData = data;
    notifyListeners();
  }

  void initData(AppRepo appRepo, String totalAmount, String payingAmount,
      String discountAmount) {
    _appRepo = appRepo;
    _totalAmount = totalAmount;
    _payingAmount = payingAmount;
    _discountAmount = discountAmount;
    notifyListeners();
    if (_appRepo.storeList.isNotEmpty) {
      _storeList = _appRepo.storeList;
    } else {
      fetchStoreList();
    }

    // razorpay event handler
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  fetchStoreList() async {
    try {
      final response = await _apiService.fetchStoreList();
      if (response.status == Constants.SUCCESS) {
        _storeList = response.data;
      }
      notifyListeners();
    } catch (e) {
      myPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
    myPrint("SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message,
    //     timeInSecForIos: 4);
    myPrint("ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
    myPrint("EXTERNAL_WALLET: " + response.walletName);
  }

  void setStoreData(StoreData data) {
    _pickUpDate = null;
    _timeSlot = null;
    _storeData = data;
    notifyListeners();
  }

  void setPickUpDate(DateTime pickUpDate) {
    _pickUpDate = pickUpDate;
    notifyListeners();
  }

  void setTimeSlot(String timeSlot) {
    _timeSlot = timeSlot;
    notifyListeners();
  }

  void setPickUpTime(String value) {
    _timeSlot = value;
    notifyListeners();
  }

  void payClicked() {
    var options = {
      'key': 'rzp_live_8L8V8KSkf9Af6x',
      'amount': 100,
      'name': 'Lotus farms',
      'description': 'checkien Pieces',
      'order_id':'',
      'timeout':60, // in seconds
      'prefill': {'contact': '8655891410', 'email': 'nagendra@inventifweb.com'}
    };
    _razorpay.open(options);
  }
}
