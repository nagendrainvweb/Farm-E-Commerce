import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/app_regex/appRegex.dart';
import 'package:lotus_farm/model/UserData.dart';
import 'package:lotus_farm/pages/home_page/home_page.dart';
import 'package:lotus_farm/pages/otp_page/otp_page.dart';
import 'package:lotus_farm/pages/registration/registration_page.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/services/api_service.dart';
import '../../utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel with AppHelper {
  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();

  AppRepo _appRepo;

  final numberController = TextEditingController();

  void loginClicked(Function onError) async {
    //_navigationService.navigateToView(OtpPage());
    showProgressDialogService("Please wait...");
    try {
      final number = numberController.text;
      final response = await _apiService.fetchUserlogin(number);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        _setData(response.data);
      } else {
        final value = await _navigationService.navigateToView(RegistrationPage(
          number: number,
        ));
        //onError(response.message);
      }
    } catch (e) {
      hideProgressDialogService();
      onError(e.toString());
    }
  }

  void _setData(User data) async {
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

  void checkValidNumber(Function onError) async {
    final valid = RegExp(AppRegex.mobile_regex).hasMatch(numberController.text);
    if (valid) {
      // loginClicked(onError);
      final value = await _navigationService.navigateToView(OtpPage(
        number: numberController.text,
      ));
      if (value ?? false) {
        loginClicked(onError);
      }
    } else {
      onError("Please Enter valid mobile number");
    }
  }

  initData(AppRepo repo) {
    _appRepo = repo;
    notifyListeners();
  }
}
