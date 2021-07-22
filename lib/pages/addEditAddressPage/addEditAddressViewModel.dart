import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/app_regex/appRegex.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/services/api_service.dart';
import '../../utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddEditAddressViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();
  final _snackBarService = locator<SnackbarService>();

  final stateController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final numberController = TextEditingController();
  final emailIdController = TextEditingController();
  final addressLineOneController = TextEditingController();
  final addressLinetwoController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();

  String _stateId = "";
  String _addressId = "";

  onChanged(String p1) {}

  void setStateId(String id) {
    _stateId = id;
    notifyListeners();
  }

  initData(AddressData address) async {
    final email = await Prefs.emailId;
    final number = await Prefs.mobileNumber;
    final firstName = await Prefs.name;
    final lastName = await Prefs.surName;
    if (address != null) {
      _addressId = address.addressId;
      firstNameController.text = address.firstName;
      lastNameController.text = address.lastName;
      numberController.text = address.number;
      emailIdController.text = address.emailId;
      addressLineOneController.text = address.address1;
      addressLinetwoController.text = address.address2;
      pincodeController.text = address.pincode;
      cityController.text = address.city;
      stateController.text = address.state;
    } else {
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      numberController.text = number;
      emailIdController.text = email;
    }
    notifyListeners();
  }

  void onSubmitclicked({Function onMessage}) {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final number = numberController.text;
    final email = emailIdController.text;
    final addressOne = addressLineOneController.text;
    final addressTwo = addressLinetwoController.text;
    final pincode = pincodeController.text;
    final city = cityController.text;
    final state = stateController.text;

    if (firstName.isEmpty) {
      onMessage("Please Enter First Name");
      return;
    }
    if (lastName.isEmpty) {
      onMessage("Please Enter Last Name");
      return;
    }
    if (!RegExp(AppRegex.mobile_regex).hasMatch(number)) {
      onMessage("Please Enter valid Mobile Number");
      return;
    }
    if (!RegExp(AppRegex.email_regex).hasMatch(email)) {
      onMessage("Please Enter valid Email Address");
      return;
    }
    if (addressOne.isEmpty) {
      onMessage("Please Enter Address Line 1");
      return;
    }

    if (addressTwo.isEmpty) {
      onMessage("Please Enter Address Line 2");
      return;
    }
    if (!RegExp(AppRegex.pincodeRegex).hasMatch(pincode)) {
      onMessage("Please Enter Valid Pincode");
      return;
    }
    if (city.isEmpty) {
      onMessage("Please Enter City");
      return;
    }
    if (state.isEmpty) {
      onMessage("Please Enter State");
      return;
    }
    addEditAddress(_addressId, firstName, lastName, number, email, addressOne,
        addressTwo, pincode, city, state, onMessage);
  }

  void addEditAddress(
      String addressId,
      String firstName,
      String lastName,
      String number,
      String email,
      String addressOne,
      String addressTwo,
      String pincode,
      String city,
      String state,
      Function onMessage) async {
    showProgressDialogService("Please wait...");
    try {
      final query = addressOne +
          ", " +
          addressTwo +
          ", " +
          city +
          ", " +
          state +
          " - " +
          pincode;
      myPrint("addres is $query");
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      print("${first.featureName} : ${first.coordinates}");
      final AddressData data = AddressData();
      data.addressId = addressId;
      data.firstName = firstName;
      data.lastName = lastName;
      data.number = number;
      data.emailId = email;
      data.address1 = addressOne;
      data.address2 = addressTwo;
      data.pincode = pincode;
      data.city = city;
      data.state = state;
      data.type = "";
      data.isDefault = true;
      data.latitude = first.coordinates.latitude.toString();
      data.longitude = first.coordinates.longitude.toString();

      final response = await _apiService.addUpdateAddress(data);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        _navigationService.back(result: response.message);
      } else {
        onMessage(response.message);
      }
    } catch (e) {
      hideProgressDialogService();
      onMessage(e.toString());
      myPrint(e.toString());
    }
  }
}
