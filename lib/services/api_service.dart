import 'dart:convert';
import 'dart:io';

import 'package:lotus_farm/model/UserData.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/model/basic_response.dart';
import 'package:lotus_farm/model/dashboard_data.dart';
import 'package:lotus_farm/model/offerResponse.dart';
import 'package:lotus_farm/model/pastOrderData.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/model/product_details_data.dart';
import 'package:lotus_farm/model/search_data.dart';
import 'package:lotus_farm/model/state_data.dart';
import 'package:lotus_farm/model/storeData.dart';
import 'package:lotus_farm/model/updateCartResponse.dart';
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
      final body = {"mobileNumber": number, "fcm_token": "xzbdguygduy"};
      body.addAll(commonFeilds);
      final request = await http
          .post(UrlList.USER_LOGIN, body: body)
          .timeout(Duration(seconds: 30));
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
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /*  Register Page api */
  Future<BasicResponse<User>> registerUser(
      firstName, lastName, mobileNumber, email, password, imagebase64) async {
    final fcm_token = await Prefs.fcmToken;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "mobileNumber": '$mobileNumber',
      "first_name": '$firstName',
      "last_name": '$lastName',
      "imageBase64": '$imagebase64',
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
        var jsondata = jsonResponse['data'];
        User user;
        if (jsonResponse[UrlConstants.STATUS] == UrlConstants.SUCCESS) {
          if (jsondata != null) {
            user = User.fromJson(jsondata);
          }
        }
        return BasicResponse.fromJson(json: jsonResponse, data: user);
      }
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<DashboardData>> fetchDashboard() async {
    try {
      final userId = await Prefs.userId;
      final commonFeild = _getCommonFeild();
      final postJson = {
        "user_id": "$userId",
      };
      postJson.addAll(commonFeild);
      final request = await http.post(UrlList.FETCH_DASHBOARD,
          body: postJson, headers: await _getHeader());
      myPrint(request.body);
      final jsonResponse = json.decode(request.body);
      final basicResponse =
          BasicResponse<DashboardData>.fromJson(json: jsonResponse);
      var data = jsonResponse[UrlConstants.DATA];
      if (data != null) {
        data = DashboardData.fromJson(jsonResponse[UrlConstants.DATA]);
        basicResponse.data = data;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<List<Product>>> fetchAllProducts() async {
    try {
      final request = await http.post(
        UrlList.FETCH_ALL_PRODICTS,
      );
      myPrint(request.body);
      final jsonResponse = json.decode(request.body);
      final data = jsonResponse[UrlConstants.DATA];
      final response =
          BasicResponse<List<Product>>.fromJson(json: jsonResponse);
      final List<Product> productList = [];
      if (response.status == Constants.SUCCESS) {
        final items = data["items"];
        for (var map in items) {
          productList.add(Product.fromJson(map));
        }
        response.data = productList;
        return response;
      } else {
        throw Exception(jsonResponse["message"]);
      }
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<OfferResponse>> fetchOffers() async {
    final userid = await Prefs.userId;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "user_id": "$userid",
    };
    postJson.addAll(commonFeilds);
    try {
      final request = await http.post(UrlList.FETCH_OFFERS,
          body: postJson, headers: await _getHeader());
      final response = json.decode(request.body);
      var data = response[UrlConstants.DATA];
      //Prefs.setOfferResponse(request.body);
      if (data != null) {
        data = OfferResponse.fromJson(data);
        // minimumOrderValue = data.minimumVal;
        // maximumOrderValue = data.maximumVal;
      }
      return BasicResponse.fromJson(json: response, data: data);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<String>> updateProfileDetails(
      firstName, lastName, mobileNumber, city, email) async {
    final userid = await Prefs.userId;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "user_id": '$userid',
      "first_name": '$firstName',
      "last_name": '$lastName',
      "city": '$city',
      "email": '$email',
    };
    postJson.addAll(commonFeilds);
    myPrint(postJson.toString());
    try {
      final request = await http.post(UrlList.UPDATE_USER_DETAILS,
          body: postJson, headers: await _getHeader());
      myPrint(request.body);
      final jsonResponse = json.decode(request.body);

      final basicResponse =
          BasicResponse<String>.fromJson(json: jsonResponse, data: "");
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<User>> fetchProfileDetails() async {
    try {
      final userId = await Prefs.userId;
      final commonFeilds = _getCommonFeild();
      final postJson = {
        "user_id": '$userId',
      };
      postJson.addAll(commonFeilds);
      myPrint(postJson.toString());
      final request = await http.post(UrlList.FETCH_USER_DETAILS,
          headers: await _getHeader(), body: postJson);
      myPrint(request.body);
      if (request.statusCode == 200) {
        final jsonResponse = json.decode(request.body);
        var data = jsonResponse["data"];
        if (data != null) {
          data = User.fromJson(data);
          Prefs.setUserId(data.id);
          Prefs.setName(data.firstName);
          Prefs.setSurName(data.lastName);
          Prefs.setEmailId(data.emailId);
          Prefs.setMobileNumber(data.mobileNumber);
          Prefs.setCity(data.city);
          Prefs.setProfilePic(data.profile_pic);
        }
        return BasicResponse.fromJson(json: jsonResponse, data: data);
      }
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /*  Address Page api */
  Future<BasicResponse<List<AddressData>>> fetchAddress() async {
    final userId = await Prefs.userId;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "user_id": '$userId',
    };
    postJson.addAll(commonFeilds);
    myPrint(postJson.toString());
    try {
      final result = await http.post(UrlList.FETCH_ADDRESSES,
          headers: await _getHeader(), body: postJson);
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<AddressData>>.fromJson(json: response);
      List<AddressData> items = [];
      if (basicResponse.status == Constants.SUCCESS) {
        var data = response["data"];
        if (data != null) {
          data.forEach((v) {
            final data = new AddressData.fromJson(v);
            if (data.state != null && data.pincode != null) {
              items.add(new AddressData.fromJson(v));
            }
          });
        }
        basicResponse.data = items;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<List<PastOrderData>>> fetchPastOrders() async {
    final userId = await Prefs.userId;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "user_id": '$userId',
    };
    postJson.addAll(commonFeilds);
    myPrint(postJson.toString());
    try {
      final result = await http.post(UrlList.FETCH_PAST_ORDERS,
          headers: await _getHeader(), body: postJson);
      myPrint(result.body);
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<PastOrderData>>.fromJson(json: response);
      List<PastOrderData> items = [];
      if (basicResponse.status == Constants.SUCCESS) {
        var data = response["data"];
        if (data != null) {
          data.forEach((v) {
            final data = new PastOrderData.fromJson(v);
            items.add(data);
          });
        }
        basicResponse.data = items;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<List<SearchData>>> fetchSearchData(
      var searchText) async {
    try {
      final commonFeilds = _getCommonFeild();
      final postJson = {
        "text": '$searchText',
      };
      postJson.addAll(commonFeilds);
      myPrint(postJson.toString());

      final result = await http.post(UrlList.FETCH_SEARCH_DATA, body: postJson);
      myPrint(result.body);
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<List<SearchData>>.fromJson(json: response);
      List<SearchData> items = [];
      if (basicResponse.status == Constants.SUCCESS) {
        var data = response["data"];
        if (data != null) {
          data.forEach((v) {
            final data = new SearchData.fromJson(v);
            items.add(data);
          });
        }
        basicResponse.data = items;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<ProductDetailsData>> fetchProductDetails(
      var productId) async {
    final commonFeilds = _getCommonFeild();
    final postJson = {"product_id": '$productId'};
    postJson.addAll(commonFeilds);
    myPrint(postJson.toString());
    try {
      final result =
          await http.post(UrlList.FETCH_PRODUCT_DETAILS, body: postJson);
      myPrint(result.body.toString());
      final response = json.decode(result.body);
      final basicResponse =
          BasicResponse<ProductDetailsData>.fromJson(json: response);
      if (basicResponse.status == Constants.SUCCESS) {
        ProductDetailsData data =
            ProductDetailsData.fromJson(response[Constants.DATA]);
        basicResponse.data = data;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<List<Product>>> fetchCartDetails() async {
    final userId = await Prefs.userId;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "user_id": '$userId',
    };
    postJson.addAll(commonFeilds);

    try {
      final request = await http.post(UrlList.FETCH_CART_DATA,
          headers: await _getHeader(), body: postJson);
      final jsonResponse = json.decode(request.body);
      final basicResponse =
          BasicResponse<List<Product>>.fromJson(json: jsonResponse);
      final data = jsonResponse[UrlConstants.DATA];
      List<Product> productlist = [];
      if (data != null) {
        List itemsArray = data['product'];
        for (var i = 0; i < itemsArray.length; i++) {
          productlist.add(Product.fromJson(itemsArray[i]));
        }
        basicResponse.data = productlist;
      }
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<String>> addToCart(
      String productId, var qty, var sizeId) async {
    final userid = await Prefs.userId;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "user_id": '$userid',
      "product_id": '$productId',
      "qty": '$qty',
      "size": '$sizeId',
    };
    postJson.addAll(commonFeilds);
    myPrint(postJson.toString());
    try {
      final request = await http.post(UrlList.ADD_TO_CART,
          headers: await _getHeader(), body: postJson);
      myPrint(request.body);
      final response = json.decode(request.body);
      final basicResponse = BasicResponse<String>.fromJson(json: response);
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<String>> removeFromCart(
      var productId, var sizeId) async {
    final userid = await Prefs.userId;
    final commonFeilds = _getCommonFeild();
    final postJson = {
      "user_id": '$userid',
      "product_id": '$productId',
      "size": '$sizeId',
    };
    postJson.addAll(commonFeilds);
    myPrint(postJson.toString());
    final request = await http.post(UrlList.REMOVE_FROM_CART,
        headers: await _getHeader(), body: postJson);
    try {
      final jsonResponse = json.decode(request.body);
      myPrint(request.body.toString());
      return BasicResponse.fromJson(json: jsonResponse, data: "");
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<List<StateData>>> fetchStateList() async {
    try {
      final request = await http.post(UrlList.FETCH_STATE_LIST);
      final response = json.decode(request.body);
      final basicResponse =
          BasicResponse<List<StateData>>.fromJson(json: response);
      List data = response[UrlConstants.DATA];
      List<StateData> stateList = [];
      if (basicResponse.status == Constants.SUCCESS) {
        if (data != null) {
          Prefs.setStateList(json.encode(data));
          for (var item in data) {
            stateList.add(StateData.fromJson(item));
          }
        }
      }
      basicResponse.data = stateList;

      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<String>> addUpdateAddress(
      AddressData addressData) async {
    final userid = await Prefs.userId;
    final commonfeild = _getCommonFeild();
    var postJson = addressData.toJson();
    postJson['user_id'] = '$userid';
    postJson.addAll(commonfeild);
    myPrint(postJson.toString());
    // final postJson =
    //     {"user_id": $userid,"address_id":$address_id,"name":$name,"isDetault":$isDetault,"type":$type,"number":$number,"email_id":$email_id,"flat_no":$flat_no,"street_name":$street_name,"area":$area,"landmark":$landmark,"city":$city,"state":$state,"pincode":$pincode,"appVersion": $appversion, "device": $device};
    try {
      final request = await http.post(UrlList.ADD_EDIT_ADDRESS,
          headers: await _getHeader(), body: postJson);
      myPrint(request.body.toString());
      final jsonResponse = json.decode(request.body);
      return BasicResponse<String>.fromJson(json: jsonResponse, data: "");
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<String>> deleteAddress(var addressId) async {
    final userid = await Prefs.userId;
    final commonfeild = _getCommonFeild();
    final postJson = {
      "user_id": '$userid',
      "address_id": '$addressId',
    };
    postJson.addAll(commonfeild);
    myPrint(postJson.toString());
    try {
      final request = await http.post(UrlList.DELETE_ADDRESS,
          headers: await _getHeader(), body: postJson);
      myPrint(request.body.toString());
      final jsonResponse = json.decode(request.body);
      return BasicResponse<String>.fromJson(json: jsonResponse, data: "");
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<UpdateCartResponse>> updateCart(
      List<Product> cartList, String coupon_title, String total_amount) async {
    final userid = await Prefs.userId;
    final commonFeild = _getCommonFeild();
    Map<String, dynamic> body = new Map<String, dynamic>();
    body['user_id'] = '$userid';
    body['coupon_code'] = '$coupon_title';
    body['total_amount'] = '$total_amount';
    body.addAll(commonFeild);
    List data = [];
    for (var product in cartList) {
      data.add(product.toCartJson());
    }
    body['data'] = data;
    final postBody = json.encode(body);
    myPrint(json.encode(body.toString()));
    // calling api
    try {
      final request = await http.post(UrlList.UPDATE_CART,
          body: postBody, headers: await _getHeader());
      myPrint(request.body.toString());
      final jsonRequest = json.decode(request.body);
      var data;
      if (jsonRequest[UrlConstants.STATUS] == UrlConstants.SUCCESS) {
        data = UpdateCartResponse.fromJson(jsonRequest[UrlConstants.DATA]);
      }
      return BasicResponse.fromJson(json: jsonRequest, data: data);
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<List<Product>>> fetchProductList(
      var pageNo, var categoryid) async {
    final userId = await Prefs.userId;
    final common = _getCommonFeild();
    final postJson = {
      "user_id": '$userId',
      "pageNo": '$pageNo',
      "category_id": '$categoryid',
    };
    postJson.addAll(common);
    myPrint(postJson.toString());
    try {
      final request = await http.post(UrlList.FETCH_PRODUCTS,
          headers: await _getHeader(), body: postJson);
      final jsonResponse = json.decode(request.body);
      final basicResponse =
          BasicResponse<List<Product>>.fromJson(json: jsonResponse);
      var data = jsonResponse[UrlConstants.DATA];
      final List<Product> list = [];
      if (data != null) {
        final jsonList = data["items"];
        for (var map in jsonList) {
          list.add(Product.fromJson(map));
        }
      }
      basicResponse.data = list;
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<BasicResponse<List<StoreData>>> fetchStoreList() async {
    final userId = await Prefs.userId;
    final common = _getCommonFeild();
    final postJson = {
      "user_id": '$userId',
    };
    postJson.addAll(common);
    myPrint(postJson.toString());
    try {
      final request = await http.post(UrlList.STORE_LIST,
          headers: await _getHeader(), body: postJson);
      final jsonResponse = json.decode(request.body);
      final basicResponse =
          BasicResponse<List<StoreData>>.fromJson(json: jsonResponse);
      var data = jsonResponse[UrlConstants.DATA];
      final List<StoreData> list = [];
      if (data != null) {
        for (var map in data) {
          list.add(StoreData.fromJson(map));
        }
      }
      basicResponse.data = list;
      return basicResponse;
    } on SocketException catch (e) {
      throw ApiErrorException(NO_INTERNET_CONN);
    } catch (e) {
      throw Exception(e.toString());
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
    final header = {Constants.AUTH: "$token"};
    myPrint(header.toString());
    return header;
  }
}
