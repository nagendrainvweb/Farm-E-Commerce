import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/model/storeData.dart';
import 'package:lotus_farm/pages/addEditAddressPage/addEditAddressPage.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/api_error_exception.dart';
import '../../app/app_helper.dart';
import '../../app/locator.dart';
import '../../utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../utils/utility.dart';
import '../../utils/utility.dart';
import '../../utils/utility.dart';
import '../../utils/utility.dart';

class CheckOutViewModel extends BaseViewModel with AppHelper {
  int _paymentMethodRadio = 1;
  int _deliveryRadio = 1;
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();
  String _orderId;
 // Razorpay _razorpay;

  final couponController = TextEditingController();

  bool _loading = true;
  bool _hasError = false;
  bool _couponApplied = false;
  String _couponText = "";
  List<AddressData> _addressList;
  List<StoreData> _storeList;
  AddressData _addressData;
  AppRepo _appRepo;
  StoreData _storeData;
  DateTime _pickUpDate;
  DateTime _deliveryDate;
  TimeOfDay _deliveryTimeSlot;
  String _timeSlot;
  String _totalAmount, _payingAmount, _discountAmount;
  Function onPaymentCallback;

  bool get loading => _loading;
  bool get hasError => _hasError;
  List<AddressData> get addressList => _addressList;
  AddressData get addressData => _addressData;
  List<StoreData> get storeList => _storeList;
  StoreData get storeData => _storeData;
  DateTime get pickUpDate => _pickUpDate;
  DateTime get deliveryDate => _deliveryDate;
  TimeOfDay get deliveryTimeSlot => _deliveryTimeSlot;
  String get timeSlot => _timeSlot;
  String get totalAmount => _totalAmount;
  String get payingAmount => _payingAmount;
  String get discountAmount => _discountAmount;
  bool get couponApplied => _couponApplied;
  String get couponText => _couponText;

  int get paymentMethodRadio => _paymentMethodRadio;
  int get deliveryRadio => _deliveryRadio;

  void onRadioValueChanged(int value) {
    _paymentMethodRadio = value;
    notifyListeners();
  }

  @override
  void dispose() {
   // _razorpay.clear(); // Removes all listeners
    super.dispose();
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
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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

  initPaymentcallBack({Function callback}) {
    this.onPaymentCallback = callback;
    notifyListeners();
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   // Fluttertoast.showToast(
  //   //     msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
  //   //myPrint("SUCCESS: " + response.paymentId);
  //   updatePayment(
  //       _orderId, response.paymentId, Constants.SUCCESS, _payingAmount);
  // }

  updatePayment(String orderId, String paymentId, String status,
      String payingAmount) async {
    try {
      showProgressDialogService("Please wait...");
      final payResponse = await _apiService.updatePayment(
          _orderId, paymentId, status, payingAmount);
      hideProgressDialogService();

      onPaymentCallback(
          (payResponse.status == Constants.SUCCESS),
          payResponse.data.status.id,
          payResponse.data.status.orderId,
          paymentId,
          payingAmount,
          _appRepo, retry: () {
        updatePayment(orderId, paymentId, status, payingAmount);
      });
    } catch (e) {
      hideProgressDialogService();
      myPrint(e.toString());
    }
  }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   // Fluttertoast.showToast(
  //   //     msg: "ERROR: " + response.code.toString() + " - " + response.message,
  //   //     timeInSecForIos: 4);
  //   myPrint("ERROR: " + response.code.toString() + " - " + response.message);
  //  // _snackBarService.showSnackbar(message: response.message);
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Fluttertoast.showToast(
  //   //     msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  //   myPrint("EXTERNAL_WALLET: " + response.walletName);
  // }

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

  void setDeliveryDate(DateTime deliveryDate) {
    _deliveryDate = deliveryDate;
    notifyListeners();
  }

  void setTimeSlot(String timeSlot) {
    _timeSlot = timeSlot;
    notifyListeners();
  }

  void setDeliveryTimeSlot(TimeOfDay deliveryTimeSlot) {
    _deliveryTimeSlot = deliveryTimeSlot;
    notifyListeners();
  }

  void setPickUpTime(String value) {
    _timeSlot = value;
    notifyListeners();
  }

  void payClicked(BuildContext context, {Function onCashOnDelivery}) async {
    print("hey i am called");
    // myPrint("hey i am called");

    //
    try {
      showProgressDialogService("Please wait...");
      final pickupDateTime = (pickUpDate != null)
          ? Utility.formattedServerDate(pickUpDate) + " " + timeSlot
          : "";
      final deliveryDateTime = (deliveryDate != null)
          ? Utility.formattedServerDate(deliveryDate) +
              " " +
              deliveryTimeSlot.format(context)
          : "";
      myPrint('pickup date $pickupDateTime');
      final response = await _apiService.placeOrder(
          _addressData.addressId,
          _addressData.addressId,
          "",
          "",
          _discountAmount,
          (_deliveryRadio == 1) ? deliveryDateTime : pickupDateTime,
          "",
          "",
          _addressData.latitude,
          _addressData.longitude,
          (deliveryRadio == 1) ? "dunzo" : "pickup",
          (_paymentMethodRadio == 1 ? "razorpay" : "cashondelivery"));

      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        _orderId = response.data["order_id"];
        if (_paymentMethodRadio == 1) {
          _startRazorPay(response.data["order_id"],
              double.parse(response.data["amount"]).toInt());
        } else {
          _updateCodOrder(
            response.data["order_id"],
            response.data["amount"]
          );
          // onCashOnDelivery(response.data);
        }
      } else {
        _dialogService.showCustomDialog(
            variant: DialogType.error,
            title: "Error",
            description: response.message,
            mainButtonTitle: "OK");
      }
    } catch (e) {
      hideProgressDialogService();
    }
  }

  _updateCodOrder(String orderId, String amount) async {
    try {
      showProgressDialogService("Please wait...");
      final payResponse =
          await _apiService.updatePaymentFree(orderId, amount, "");
       onPaymentCallback(
          (payResponse.status == Constants.SUCCESS),
          payResponse.data.status.id,
          payResponse.data.status.orderId,
          "",
          payingAmount,
          _appRepo, retry: () {
       _updateCodOrder(
            orderId,
          amount
          );
      });
      
    } catch (e) {
      hideProgressDialogService();
      myPrint(e.toString());
            _dialogService.showCustomDialog(
          variant: DialogType.error,
          title: "Error",
          description: SOMETHING_WRONG_TEXT,
          mainButtonTitle: "OK");
    }
  }

  _startRazorPay(String orderId, int amount) async {
    final name = await Prefs.name;
    final last_name = await Prefs.surName;
    final number = await Prefs.mobileNumber;
    final email = await Prefs.emailId;
    var options = {
      'key': AppStrings.liveKey,
      'amount': int.parse(_payingAmount) * 100,
      'name': 'Dr Meat',
      'description': '',
      //'order_id': '$orderId',
      'timeout': 240, // in seconds
      'prefill': {
        'contact': '$number',
        'email': '$email',
        'name': '$name $last_name'
      }
    };
    //_razorpay.open(options);
  }

  void applyCoupon() async {
    try {
      showProgressDialogService("Please wait...");
      final response =
          await _apiService.verifyCoupons(couponController.text, _payingAmount);
      hideProgressDialogService();
      _couponApplied = true;
      _couponText = "Coupon applied sucessfully";
      final discount = double.parse(response.data.discountAmount).toInt();
      _discountAmount = discount.toString();
      _payingAmount = (int.parse(_payingAmount) - discount.toInt()).toString();
      notifyListeners();
    } catch (e) {
      hideProgressDialogService();
      _dialogService.showCustomDialog(
          variant: DialogType.error,
          title: "Error",
          description: "${e.message}",
          mainButtonTitle: "OK");
    }
  }

  void clearCoupon() {
    couponController.text = "";
    _couponApplied = false;
    _couponText = "";
    notifyListeners();
  }

  void resetResetDeliveryDateTime() {
    _deliveryDate = null;
    _deliveryTimeSlot = null;
    notifyListeners();
  }
}
