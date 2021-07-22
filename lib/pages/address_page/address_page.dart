import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/AppNeumorphicContainerWidget.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/model/storeData.dart';
import 'package:lotus_farm/pages/addEditAddressPage/addEditAddressPage.dart';
import 'package:lotus_farm/pages/address_page/address_view_model.dart';
import 'package:lotus_farm/pages/check_out/check_out_page.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _refreshkey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressViewModel>.reactive(
      viewModelBuilder: () => AddressViewModel(),
      onModelReady: (model) {
        model.fetchAddressList();
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title:
              Text("Addresses", style: TextStyle(color: AppColors.blackGrey)),
        ),
        floatingActionButton: Visibility(
          visible: (model.addressList != null && model.addressList.isNotEmpty),
          child: FloatingActionButton(
            child: Icon(Icons.add, color: AppColors.white),
            onPressed: () async {
              final value =
                  await Utility.pushToNext(AddEditAddressPage(), context);
              if (value != null) {
                Utility.showSnackBar(context, value);
                _refreshkey.currentState.show();
              }
            },
          ),
        ),
        body: (model.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (model.hasError)
                ? AppErrorWidget(
                    message: SOMETHING_WRONG_TEXT,
                    onRetryCliked: () async {
                      final value = await model.fetchAddressList();
                      if (value != null) {
                        Utility.showSnackBar(context, value);
                        _refreshkey.currentState.show();
                      }
                    })
                : (model.addressList.isEmpty)
                    ? NoAddressWidget(
                        onAddCliked: () async {
                          final value = await Utility.pushToNext(
                              AddEditAddressPage(), context);
                          if (value != null) {
                            Utility.showSnackBar(context, value);
                            _refreshkey.currentState.show();
                          }
                        },
                      )
                    //  Container(
                    //     child: Padding(
                    //     padding: const EdgeInsets.all(14.0),
                    //     child: Center(
                    //         child: Text(
                    //       "You do not have any Address,\nPlease Click + button to Add Address",
                    //       textAlign: TextAlign.center,
                    //       style:
                    //           TextStyle(color: AppColors.grey700, fontSize: 18),
                    //     )),
                    //   ))
                    : Container(
                        child: Container(
                          child: RefreshIndicator(
                            key: _refreshkey,
                            onRefresh: () async {
                              return await model.fetchAddressList(
                                  loading: false);
                            },
                            child: ListView.separated(
                                itemCount: model.addressList.length,
                                separatorBuilder: (_, index) => Container(
                                    //height: 10,
                                    ),
                                itemBuilder: (_, index) => AddressTile(
                                      addressData: model.addressList[index],
                                      onTap: () {
                                        _showActionSheet(index, model);
                                      },
                                    )),
                          ),
                        ),
                      ),
      ),
    );
  }

  _showActionSheet(int index, AddressViewModel model) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) => Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      final value = await Utility.pushToNext(
                          AddEditAddressPage(
                            address: model.addressList[index],
                          ),
                          context);
                      if (value != null) {
                        Utility.showSnackBar(context, value);
                        _refreshkey.currentState.show();
                      }
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.delete_outline,color: AppColors.grey800,size:22 ),
                        // SizedBox(width:8),
                        Text("Update",
                            style: TextStyle(color: AppColors.grey700))
                      ],
                    ),
                  ),
                  Container(height: 1, color: AppColors.grey200),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      model.deleteAddress(index, onMessage: (String text) {
                        Utility.showSnackBar(context, text);
                      });
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon(Icons.update_outlined,color: AppColors.grey800, ),
                        // SizedBox(width:8),
                        Text("Delete",
                            style: TextStyle(color: AppColors.grey700))
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}

class AddressTile extends StatelessWidget {
  const AddressTile({
    Key key,
    this.onTap,
    this.addressData,
    this.selected = false,
  }) : super(key: key);

  final Function onTap;
  final AddressData addressData;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AppNeumorphicContainer(
      radius: 8,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Container(
            //   child: Icon(Icons.home),
            // ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: selected ? AppColors.green : Colors.transparent,
                    width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${addressData.firstName} ${addressData.lastName}",
                      style: TextStyle(
                          color: AppColors.blackGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  Text("${addressData.number}",
                      style: TextStyle(
                          color: AppColors.grey600,
                          fontSize: 12,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            // "D/12, bandhan building, new society, sv road, malad east, mumbai, maharastra - 400097",
                            "${addressData.address1}, ${addressData.address2}, ${addressData.city}, ${addressData.state} - ${addressData.pincode}",
                            style: TextStyle(
                                color: AppColors.grey600,
                                fontSize: 12,
                                fontWeight: FontWeight.normal)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       borderRadius:
            //           BorderRadius.only(bottomLeft: Radius.circular(8)),
            //       color: AppColors.green,
            //     ),
            //     child: Icon(Icons.edit, color: AppColors.white, size: 14),
            //   ),
            // ),
            //  Align(
            //   alignment: Alignment.bottomRight,
            //   child:Container(
            //        padding: const EdgeInsets.all(12),
            //        decoration: BoxDecoration(
            //         borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
            //         color: AppColors.green,
            //        ),
            //        child: Icon(Icons.edit,color: AppColors.white,size:14),
            //      ) ,
            // ),
          ],
        ),
      ),
    );
  }
}

class StoreTile extends StatelessWidget {
  const StoreTile({
    Key key,
    this.onTap,
    this.storeData,
    this.selected = false,
  }) : super(key: key);

  final Function onTap;
  final StoreData storeData;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    var monday;
    String timeFrom;
    String timeTo;
    try {
      monday = json.decode(storeData.operationMon);
      timeFrom = monday["from"][0] + ":" + monday["from"][1];
      timeTo = monday["to"][0] + ":" + monday["to"][1];
    } catch (e) {
      timeFrom = "";
      timeTo = "";
    }
    return AppNeumorphicContainer(
      radius: 8,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Container(
            //   child: Icon(Icons.home),
            // ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: selected ? AppColors.green : Colors.transparent,
                    width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${storeData.name}",
                      style: TextStyle(
                          color: AppColors.blackGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "${storeData.phoneOne}  ${(storeData.phoneTwo.isNotEmpty) ? "/ ${storeData.phoneTwo}" : ""}",
                      style: TextStyle(
                          color: AppColors.grey600,
                          fontSize: 12,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            // "D/12, bandhan building, new society, sv road, malad east, mumbai, maharastra - 400097",
                            "${storeData.street}, ${storeData.city}, ${storeData.stateProvince} - ${storeData.postalCode}",
                            style: TextStyle(
                                color: AppColors.grey600,
                                fontSize: 12,
                                fontWeight: FontWeight.normal)),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                          // "D/12, bandhan building, new society, sv road, malad east, mumbai, maharastra - 400097",
                          "Timing : ",
                          style: TextStyle(
                              color: AppColors.grey600,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                      Text(
                          // "D/12, bandhan building, new society, sv road, malad east, mumbai, maharastra - 400097",
                          timeFrom + " - " + timeTo,
                          style: TextStyle(
                              color: AppColors.grey600,
                              fontSize: 12,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
