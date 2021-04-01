import 'dart:convert';
import 'dart:io';

import 'package:lotus_farm/model/UserData.dart';
import 'package:lotus_farm/model/basic_response.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/services/base_request.dart';
import 'package:lotus_farm/extension/extensions.dart';
import 'package:http/http.dart' as http;
import 'package:lotus_farm/utils/Constants.dart';
import 'package:lotus_farm/utils/api_error_exception.dart';
import 'package:lotus_farm/utils/urlList.dart';
import 'package:lotus_farm/utils/utility.dart';

class ApiService extends BaseRequest {
  Future<BasicResponse<String>> sendOtp(mobile, otp) async {
    try {
      final commonFeilds = _getCommonFeild();
      final body = {"mobile_number": mobile, "otp": otp};
      body.addAll(commonFeilds);
      final request = await http.post(UrlList.SEND_OTP, body: body);
      final jsonResponse = json.decode(request.body);
      myPrint("otp response : ${request.body.toString()}");
      return BasicResponse.fromJson(json: jsonResponse, data: "");
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      // sendMail(UrlList.SEND_OTP, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(SOMETHING_WRONG_TEXT);
    }
  }

  Future<BasicResponse<String>> fetchUpdate() async {
    try {
      final commonFeilds = _getCommonFeild();
      final request = await http.post(UrlList.CHECK_UPDATE, body: commonFeilds);
      myPrint(request.toString());
      final jsonResponse = json.decode(request.body);
      return BasicResponse.fromJson(json: jsonResponse, data: "");
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      throw ApiErrorException(e.toString());
    }
  }

  /*  Fetch Token api */
  Future<BasicResponse<String>> fetchToken(String number) async {
    try {
      final commonFeilds = _getCommonFeild();
      final body = {
        "mobileNumber": number,
      };
      body.addAll(commonFeilds);
      final request =
          await http.post(UrlList.REGISTER_TOKEN, headers: headers, body: body);
      if (request.statusCode == 200) {
        final jsonResponse = json.decode(request.body);
        return BasicResponse.fromJson(json: jsonResponse, data: "");
      }
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } on Exception catch (e) {
      //sendMail(UrlList.CHECK_UPDATE, SOMETHING_WRONG_TEXT);
      throw ApiErrorException(e.toString());
    }
  }

  /*  Login Page api */
  Future<BasicResponse<User>> fetchUserlogin(String number) async {
    try {
      final commonFeilds = _getCommonFeild();
      final body = {
        "mobileNumber": number,
      };
      body.addAll(commonFeilds);
      final request = await http.post(UrlList.USER_LOGIN, body: body);
      myPrint(request.body.toString());
      if (request.statusCode == 200) {
        final jsonResponse = json.decode(request.body);
        var data = jsonResponse['data'];
        if (data != null) {
          data = User.fromJson(data);
        }
        return BasicResponse.fromJson(json: jsonResponse, data: data);
      }
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<String>> registerToken() async {
    final fcm_token = await Prefs.fcmToken;
    final user_id = await Prefs.userId;
    try {
      final commonFeilds = _getCommonFeild();
      final body = {"user_id": '$user_id', "fcm_token": '$fcm_token'};
      body.addAll(commonFeilds);
      final request = await http.post(UrlList.REGISTER_TOKEN, body: body);
      myPrint(request.body.toString());
      final jsonResponse = json.decode(request.body);
      return BasicResponse.fromJson(json: jsonResponse, data: "");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /*  Register Page api */
  Future<BasicResponse<User>> registerUser(firstName, lastName, mobileNumber,
      dob, email, password, imagebase64) async {
    final fcm_token = await Prefs.fcmToken;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "mobileNumber": '$mobileNumber',
      "first_name": '$firstName',
      "last_name": '$lastName',
      "imageBase64": '$imagebase64',
      "dob": '$dob',
      "email": '$email',
      "password": '$password',
      "fcm_token": '$fcm_token'
    };
    postJson.addAll(commonFeilds);
    myPrint(postJson.toString());
    myPrint(UrlList.USER_REGISTRATION);
    try {
      final request =
          await http.post(UrlList.USER_REGISTRATION, body: postJson);
      myPrint(request.body);
      if (request.statusCode == 200) {
        final jsonResponse = json.decode(request.body);
        myPrint(jsonResponse.toString());
        var data = jsonResponse['data'];
        if (jsonResponse[UrlConstants.STATUS] == UrlConstants.SUCCESS) {
          if (data != null) {
            data = User.fromJson(data);
          }
        }
        return BasicResponse.fromJson(json: jsonResponse, data: data);
      }
    } catch (e) {
      return throw Exception(e.toString());
    }
  }

  // common fields like device and app version
  _getCommonFeild() {
    final device = Constants.DEVICE;
    final appversion = Constants.VERSION;

    final map = {
      Constants.APP_VERSION: appversion,
      Constants.URL_DEVICE: device
    };
    return map;
  }

  Future<Map<String, dynamic>> _getHeader() async {
    final token = await Prefs.token;
    final header = {"authorization": "Bearer $token"};
    return header;
  }
}
