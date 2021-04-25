import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/dashboard_data.dart';
import 'package:lotus_farm/model/offerResponse.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/model/state_data.dart';
import 'package:lotus_farm/model/storeData.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/Constants.dart';
import 'package:lotus_farm/utils/utility.dart';

class AppRepo extends ChangeNotifier {
  final _apiService = locator<ApiService>();
  bool _isLogin = false;
  bool _introDone = false;

  int _notificationCount = 0;
  int _cartCount = 0;

  DashboardData _dashboardData;
  List<Product> _productList;
  List<OffersImg> _offerImgList;
  List<StateData> _stateList = [];
  List<StoreData> _storeList = [];

  bool get login => _isLogin;
  int get notificationCount => _notificationCount;
  int get cartCount => _cartCount;
  bool get introDone => _introDone;
  DashboardData get dashboardData => _dashboardData;
  List<Product> get productList => _productList;
  List<OffersImg> get offerList => _offerImgList;
  List<StateData> get stateList => _stateList;
  List<StoreData> get storeList => _storeList;

  setLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }

  setOfferImageList(List<OffersImg> offerList) {
    this._offerImgList = offerList;
    notifyListeners();
  }

  setNotificationCount(int value) {
    _notificationCount = value;
    notifyListeners();
  }

  setCartCount(int value) {
    myPrint("inserteed cart count is $value");
    _cartCount = value;
    notifyListeners();
  }

  setIntroDone(bool value) {
    _introDone = value;
    notifyListeners();
  }

  init() async {
    _introDone = await Prefs.introDone;
    _isLogin = await Prefs.login;

    if (_isLogin) {
      fetchProfileDetails();
    }
    fetchStoreList();

    final stateResponse = await Prefs.stateList;
    if (stateResponse.isEmpty) {
      await fetchStateList();
    } else {
      final data = json.decode(stateResponse);
      for (var item in data) {
        _stateList.add(StateData.fromJson(item));
      }
    }
    myPrint("total states is ${_stateList.length}");
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

  fetchStateList() async {
    try {
      final response = await _apiService.fetchStateList();
      if (response.status == Constants.SUCCESS) {
        _stateList = response.data;
      }
    } catch (e) {
      myPrint(e.toString());
    }
  }

  fetchProfileDetails() async {
    try {
      final response = await _apiService.fetchProfileDetails();
    } catch (e) {
      myPrint(e.toString());
    }
  }

  setDashboardData(DashboardData data) {
    _dashboardData = data;
    notifyListeners();
  }

  setProductList(List<Product> list) {
    _productList = list;
    notifyListeners();
  }
}
