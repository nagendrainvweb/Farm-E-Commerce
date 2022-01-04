import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/app_regex/appRegex.dart';
import 'package:lotus_farm/model/UserData.dart';
import 'package:lotus_farm/pages/home_page/home_page.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/services/api_service.dart';
import '../../utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegistrationViewModel extends BaseViewModel with AppHelper {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<ApiService>();
  final _snackService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();

  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final numberController = TextEditingController();
  final emailController = TextEditingController();

  AppRepo _appRepo;

  onChanged(String value) {}

  void submitClicked({Function onError}) {
    final name = nameController.text;
    final lastname = lastnameController.text;
    final number = numberController.text;
    final email = emailController.text;

    final validEmail = RegExp(AppRegex.email_regex).hasMatch(email);
    final validNumber = RegExp(AppRegex.mobile_regex).hasMatch(number);

    if (name.isNotEmpty && lastname.isNotEmpty && validEmail && validNumber) {
      registerUser(name, lastname, number, email, onError);
    } else {
      onError("Please Enter valid Details");
    }

    //_navigationService.navigateToView(HomePage());
  }

  void initData(AppRepo repo, String number) {
    _appRepo = repo;
    numberController.text = number;
    notifyListeners();
  }

  void _setData(User data) async {
    final date = Utility.formattedDeviceDate(DateTime.now());
    Prefs.setLoginDate(date);
    Prefs.setUserId(data.id);
    Prefs.setName(data.firstName);
    Prefs.setSurName(data.lastName);
    Prefs.setMobileNumber(data.mobileNumber);
    Prefs.setEmailId(data.emailId);
    Prefs.setToken(data.accessToken);

    Prefs.setProfilePic(data.profile_pic);
    Prefs.setLogin(true);

    _navigationService.clearTillFirstAndShowView(HomePage());
  }

  void registerUser(String name, String lastname, String number, String email,
      Function onError) async {
    showProgressDialogService("Please wait...");
    try {
      final response = await _apiService.registerUser(
          name, lastname, number, email, "", "");
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        _setData(response.data);
      } else {
        onError(response.message);
        //_snackBarServices.showSnackbar(message: response.message);
      }
    } catch (e) {
      hideProgressDialogService();
       onError(e.toString());
      //_snackBarServices.showSnackbar(message: e.toString());
    }
  }
}
