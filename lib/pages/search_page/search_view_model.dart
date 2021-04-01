import 'package:flutter/material.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/model/search_data.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel{

  String _searchText="";
  final controller = TextEditingController();
  bool _isError = true;

  final _apiService = locator<ApiService>();
  final _dialogService = locator<DialogService>();
  final _snackBarService = locator<SnackbarService>();


  String get searchText => _searchText;
  bool get isError => _isError;
  List<SearchData> get searchDataList => _searchDataList;


  List<SearchData> _searchDataList;
  
  void updateUsername(String value) {
    _searchText = value;
    notifyListeners();

    if(_searchText.length>2){
      _fetchSearchData();
    }
  }

  _fetchSearchData()async{
    // try{
    //   final resposne = await _apiService.fetchSearchData(_searchText);
    //   if(resposne.status == Constants.SUCCESS){
    //     _isError = false;
    //     //_searchData = resposne.data;
    //   }else{
    //     //_searchData = null;
    //     _isError = true;
    //   }
    //   notifyListeners();
    // }catch(e){
    //   _isError = true;
    //   notifyListeners();
    // }
  }

  void clearText() {
    _searchText = "";
    controller.clear();
    _searchDataList = null;
    notifyListeners();
  }
}