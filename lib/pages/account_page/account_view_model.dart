import 'package:flutter/widgets.dart';
import 'package:lotus_farm/app/app_helper.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../utils/constants.dart';

class AccountViewModel extends BaseViewModel with AppHelper {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final cityController = TextEditingController();

  final _apiService = locator<ApiService>();
  final _navigationService = locator<NavigationService>();

  void initData() async {
    final name = await Prefs.name;
    final lastname = await Prefs.surName;
    final number = await Prefs.mobileNumber;
    final email = await Prefs.emailId;
    final city = await Prefs.city;
    final profilePic = await Prefs.profilePic;

    firstNameController.text = name;
    lastNameController.text = lastname;
    numberController.text = number;
    emailController.text = email;
    cityController.text = city;

    notifyListeners();
  }

  void updateProfile({Function onError}) {
    final name = firstNameController.text;
    final lastname = lastNameController.text;
    final number = numberController.text;
    final email = emailController.text;
    final city = cityController.text;
    if (firstNameController.text.isEmpty) {
      onError("Please Enter First Name");
      return;
    }
    if (lastNameController.text.isEmpty) {
      onError("Please Enter Last Name");
      return;
    }
    if (cityController.text.isEmpty) {
      onError("Please Enter City");
      return;
    }

    //myPrint("every thing is good");
    updateProfileDetails(name, lastname, number, email, city, onError);
  }

  updateProfileDetails(String firstName, String lastName, String mobileNumber,
      String email, String city, Function onError) async {
    showProgressDialogService("Please wait...");
    try {
      final response = await _apiService.updateProfileDetails(
          firstName, lastName, mobileNumber, city, email);
      hideProgressDialogService();
      if (response.status == Constants.SUCCESS) {
        Prefs.setName(firstName);
        Prefs.setSurName(lastName);
        Prefs.setMobileNumber(mobileNumber);
        Prefs.setEmailId(email);
        Prefs.setCity(city);
        _navigationService.back(result: true);
      } else {
        onError(response.message);
      }
    } catch (e) {
      hideProgressDialogService();
      myPrint(e.toString());
      onError(e.toString());
    }
  }
}
