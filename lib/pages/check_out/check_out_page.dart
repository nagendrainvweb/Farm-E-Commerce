import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/AppNeumorphicContainerWidget.dart';
import 'package:lotus_farm/app_widget/AppQtyAddRemoveWidget.dart';
import 'package:lotus_farm/app_widget/AppTextFeildOutlineWidget.dart';
import 'package:lotus_farm/app_widget/app_amount.dart';
import 'package:lotus_farm/pages/addEditAddressPage/addEditAddressPage.dart';
import 'package:lotus_farm/pages/address_page/address_page.dart';
import 'package:lotus_farm/pages/check_out/check_out_view_model.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stacked/stacked.dart';

class CheckoutPage extends StatefulWidget {
  final String totalAmount, payingAmount, discountAmount;

  const CheckoutPage(
      {Key key, this.totalAmount, this.payingAmount, this.discountAmount})
      : super(key: key);
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  _getBottomAddCart(CheckOutViewModel model) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          blurRadius: 6.0,
        ),
      ]),
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.defaultMargin, vertical: Spacing.extraBigMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Price"),
              AppAmountWidget(
                amount: model.totalAmount,
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery fees"),
              AppAmountWidget(
                amount: "0",
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Paying Amount"),
              AppAmountWidget(
                amount: model.payingAmount,
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButtonWidget(
                text: "PAY",
                width: MediaQuery.of(context).size.width * 0.6,
                verticalPadding: Spacing.mediumMargin,
                onPressed: () {
                  myPrint("Pay clicked");
                  model.payClicked();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  _getDeliveryMethod(CheckOutViewModel model) {
    return CheckOutOptionWidget();
  }

  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context);
    return ViewModelBuilder<CheckOutViewModel>.reactive(
      viewModelBuilder: () => CheckOutViewModel(),
      onModelReady: (model) {
        model.initData(appRepo, widget.totalAmount, widget.payingAmount,
            widget.discountAmount);
        model.fetchAddressList();
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Checkout",
            style: TextStyle(color: AppColors.blackGrey),
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
                    })
                : (model.addressList.isEmpty)
                    ? NoAddressWidget(onAddCliked: () async {
                        final value = await Utility.pushToNext(
                            AddEditAddressPage(), context);
                        if (value != null) {
                          model.fetchAddressList();
                        }
                      })
                    : Container(
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.smallMargin),
                                  child: Column(
                                    children: [
                                      CheckOutOptionWidget(
                                        title: "Address",
                                        child: Text(
                                          model.addressData.firstName +
                                              " " +
                                              model.addressData.lastName +
                                              "\n" +
                                              model.addressData.number +
                                              "\n" +
                                              model.addressData.address1 +
                                              ", " +
                                              model.addressData.address2 +
                                              ", " +
                                              model.addressData.city +
                                              ", " +
                                              model.addressData.state +
                                              " - " +
                                              model.addressData.pincode,
                                          style: TextStyle(
                                              color: AppColors.grey500,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12),
                                        ),
                                        onEditclicked: () {
                                          _showAddressSheet(model, context);
                                        },
                                      ),
                                      CheckOutOptionWidget(
                                        title: "Delivery Method",
                                        showEdit: false,
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    model
                                                        .onDeliveryRadioValueChanged(
                                                            1);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Delivery with Danzo  ",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blackGrey,
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        "(Free)",
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.green,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Radio(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  value: 1,
                                                  groupValue:
                                                      model.deliveryRadio,
                                                  onChanged: (int value) {
                                                    model
                                                        .onDeliveryRadioValueChanged(
                                                            value);
                                                  })
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    model
                                                        .onDeliveryRadioValueChanged(
                                                            2);
                                                  },
                                                  child: Text(
                                                    "Store Pickup",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.blackGrey,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                              Radio(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  value: 2,
                                                  groupValue:
                                                      model.deliveryRadio,
                                                  onChanged: (int value) {
                                                    model
                                                        .onDeliveryRadioValueChanged(
                                                            value);
                                                  })
                                            ],
                                          ),
                                        ]),
                                        // Text(
                                        //   "Free Delivery with Danzo",
                                        //   style: TextStyle(
                                        //       color: AppColors.grey500,
                                        //       fontWeight: FontWeight.normal,
                                        //       fontSize: 12),
                                        // ),
                                        // onEditclicked: () {
                                        //   _showDeliverySheet(context, model);
                                        // },
                                      ),
                                      Visibility(
                                        visible: model.deliveryRadio == 2,
                                        child: CheckOutOptionWidget(
                                          title: "Store Pickup Details",
                                          showEdit: (model.storeData != null),
                                          onEditclicked: () {
                                            _showBottomStoreList(
                                                context, model);
                                          },
                                          child: Column(
                                            children: [
                                              (model.storeData == null)
                                                  ? TextButton(
                                                      onPressed: () {
                                                        _showBottomStoreList(
                                                            context, model);
                                                      },
                                                      child: Text(
                                                          "Please Select Pickup Store and Date"))
                                                  : Container(
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            model.storeData
                                                                    .name +
                                                                "\n" +
                                                                model.storeData
                                                                    .phoneOne +
                                                                // ", " +
                                                                // model.storeData
                                                                //     .phoneTwo +
                                                                // "\n" +
                                                                "\n" +
                                                                model.storeData
                                                                    .street +
                                                                ", " +
                                                                model.storeData
                                                                    .city +
                                                                ", " +
                                                                model.storeData
                                                                    .stateProvince +
                                                                " - " +
                                                                model.storeData
                                                                    .postalCode,
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12),
                                                          ),
                                                          SizedBox(height: 5),
                                                          (model.pickUpDate ==
                                                                  null)
                                                              ? TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    final pickUpDate = await showDatePicker(
                                                                        context:
                                                                            context,
                                                                        initialDate:
                                                                            DateTime
                                                                                .now(),
                                                                        firstDate:
                                                                            DateTime
                                                                                .now(),
                                                                        lastDate: DateTime(
                                                                            DateTime.now()
                                                                                .year,
                                                                            DateTime.now()
                                                                                .month,
                                                                            DateTime.now().day +
                                                                                7));
                                                                    //
                                                                    if (pickUpDate !=
                                                                        null) {
                                                                      model.setPickUpDate(
                                                                          pickUpDate);
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                      "Please Select Pickup Date"))
                                                              : Column(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "Pickup Date : ",
                                                                            style:
                                                                                TextStyle(
                                                                              color: AppColors.grey700,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 11,
                                                                            )),
                                                                        Text(
                                                                            Utility.formattedDeviceMonthDate(model
                                                                                .pickUpDate),
                                                                            style:
                                                                                TextStyle(
                                                                              color: AppColors.grey700,
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 11,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    (model.timeSlot ==
                                                                            null)
                                                                        ? TextButton(
                                                                            onPressed:
                                                                                () async {
                                                                              showTimeSlotSheet(context, model, onTimeSelected: (String value) {
                                                                                model.setPickUpTime(value);
                                                                              });
                                                                            },
                                                                            child:
                                                                                Text("Please Select Pickup Time"))
                                                                        : Column(
                                                                            children: [
                                                                              SizedBox(height: 5),
                                                                              Row(
                                                                                children: [
                                                                                  Text("Pickup Time : ",
                                                                                      style: TextStyle(
                                                                                        color: AppColors.grey700,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 11,
                                                                                      )),
                                                                                  Text(model.timeSlot,
                                                                                      style: TextStyle(
                                                                                        color: AppColors.grey700,
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontSize: 11,
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          )
                                                                  ],
                                                                ),
                                                        ],
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                      CheckOutOptionWidget(
                                        title: "Payment Method",
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    model
                                                        .onRadioValueChanged(1);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "Net Banking/ Upi ",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .blackGrey,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        "(powered by Razarpay)",
                                                        style: TextStyle(
                                                            color:
                                                                AppColors.green,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Radio(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  value: 1,
                                                  groupValue:
                                                      model.paymentMethodRadio,
                                                  onChanged: (int value) {
                                                    model.onRadioValueChanged(
                                                        value);
                                                  })
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    model
                                                        .onRadioValueChanged(2);
                                                  },
                                                  child: Text(
                                                    "Cash on delivery",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.blackGrey,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Radio(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  value: 2,
                                                  groupValue:
                                                      model.paymentMethodRadio,
                                                  onChanged: (int value) {
                                                    model.onRadioValueChanged(
                                                        value);
                                                  })
                                            ],
                                          )
                                        ]),
                                        showEdit: false,
                                        onEditclicked: () {},
                                      ),
                                      CheckOutOptionWidget(
                                        title: "Coupon Code",
                                        showEdit: false,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Neumorphic(
                                                style: NeumorphicStyle(
                                                    depth: 0.5,
                                                    intensity: 0.0,
                                                    color: AppColors.tileColor),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .grey200,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: TextField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  "Enter Coupon Code",
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0,
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                            ),
                                                          )),
                                                          GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border(
                                                                left: BorderSide(
                                                                    color: AppColors
                                                                        .grey200,
                                                                    width: 1),
                                                              )),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15,
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            15),
                                                                child: Text(
                                                                  "APPLY",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: AppColors
                                                                          .redAccent),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            _getBottomAddCart(model),
                          ],
                        ),
                      ),
      ),
    );
  }

  void showTimeSlotSheet(BuildContext context, CheckOutViewModel model,
      {Function onTimeSelected}) async {
    String timeValue = "";
    myPrint("date is ${model.pickUpDate.weekday}");
    if (model.pickUpDate.weekday == 1) {
      timeValue = model.storeData.operationMon;
    } else if (model.pickUpDate.weekday == 2) {
      timeValue = model.storeData.operationTue;
    } else if (model.pickUpDate.weekday == 3) {
      timeValue = model.storeData.operationWed;
    } else if (model.pickUpDate.weekday == 4) {
      timeValue = model.storeData.operationThu;
    } else if (model.pickUpDate.weekday == 5) {
      timeValue = model.storeData.operationFri;
    } else if (model.pickUpDate.weekday == 6) {
      timeValue = model.storeData.operationSat;
    } else {
      timeValue = model.storeData.operationMon;
    }
    final jsonData = json.decode(timeValue);
    final startTime = int.parse(jsonData["from"][0]);
    final endTime = int.parse(jsonData["to"][0]);
    final slotCount = endTime - startTime;
    List<String> slotList = [];
    int end = startTime;
    for (int i = 0; i <= slotCount; i++) {
      final slotStart = end;
      final slotEnd = slotStart + 1;
      final value = getSlotFormat(slotStart, slotEnd, "00",
          (i == slotCount) ? jsonData["to"][1] : "00");
      myPrint("$value");
      slotList.add("$value");
      end = slotEnd;
    }

    final itemWidth = MediaQuery.of(context).size.width / 3;

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) {
          return Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: Spacing.extraBigMargin),
                      child: Text("Please Select Pickup Time Slot",
                          textScaleFactor: 1.2),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: AppColors.grey700,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.mediumMargin,
                        vertical: Spacing.smallMargin),
                    child: GridView.builder(
                        itemCount: slotList.length,
                        // padding: const EdgeInsets.all(Spacing.smallMargin),
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: (itemWidth / 50)),
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              onTimeSelected(slotList[index]);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: (model.timeSlot == slotList[index])
                                        ? AppColors.green
                                        : AppColors.grey300,
                                    width: 1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                  child: Text(
                                slotList[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.blackGrey),
                              )),
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          );
        });
  }

  String getSlotFormat(
      int start, int end, String startMinute, String endMinute) {
    final slot1 = Utility.pad2(start) + ":" + "$startMinute";
    final slot2 = Utility.pad2(end) + ":" + "$endMinute";
    return "$slot1 - $slot2";
  }

  _showBottomStoreList(BuildContext context, CheckOutViewModel model) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: Spacing.extraBigMargin),
                    child: Text("Please Select Store", textScaleFactor: 1.2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.grey700,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: model.storeList.length,
                    separatorBuilder: (_, index) => Container(
                        //height: 10,
                        ),
                    itemBuilder: (_, index) => Container(
                          child: StoreTile(
                            storeData: model.storeList[index],
                            selected: (model.storeData == null)
                                ? false
                                : model.storeData.id ==
                                    model.storeList[index].id,
                            onTap: () async {
                              Navigator.pop(context);
                              model.setStoreData(model.storeList[index]);
                            },
                          ),
                        )),
              ),
            ],
          );
        });
  }

  void _showAddressSheet(CheckOutViewModel model, BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (_) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: Spacing.extraBigMargin),
                    child: Text("Please Select Address", textScaleFactor: 1.2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppColors.grey700,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )
                ],
              ),
              Expanded(
                child: ListView.separated(
                    itemCount: model.addressList.length,
                    separatorBuilder: (_, index) => Container(
                        //height: 10,
                        ),
                    itemBuilder: (_, index) => Container(
                          child: AddressTile(
                            addressData: model.addressList[index],
                            selected: model.addressData.addressId ==
                                model.addressList[index].addressId,
                            onTap: () {
                              Navigator.pop(context);
                              model.setAddressData(model.addressList[index]);
                            },
                          ),
                        )),
              ),
            ],
          );
        });
  }
}

class CheckOutOptionWidget extends StatelessWidget {
  const CheckOutOptionWidget({
    Key key,
    this.onEditclicked,
    this.title,
    this.child,
    this.showEdit = true,
  }) : super(key: key);
  final Function onEditclicked;
  final String title;
  final Widget child;
  final bool showEdit;

  @override
  Widget build(BuildContext context) {
    return AppNeumorphicContainer(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.bigMargin, vertical: Spacing.defaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: AppColors.blackGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      child,
                      // Text(
                      //  desc,
                      //   style: TextStyle(
                      //       color: AppColors.grey500,
                      //       fontWeight: FontWeight.normal,
                      //       fontSize: 12),
                      // ),
                    ],
                  ),
                ),
                //  SizedBox(width:10),
                Visibility(
                  visible: showEdit,
                  child: IconButton(
                      onPressed: onEditclicked,
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.grey600,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NoAddressWidget extends StatelessWidget {
  const NoAddressWidget({Key key, this.onAddCliked}) : super(key: key);

  final Function onAddCliked;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // height: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            ImageAsset.address_missing,
            height: 300,
          ),
          // Icon(
          //   Icons.info_outline,
          //   color: Colors.grey.shade700,
          //   size: 70,
          // ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Empty list!",
            textAlign: TextAlign.center,
            style: extraBigTextStyle,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "You have no addresses at this moment.",
            textAlign: TextAlign.center,
            style: smallTextStyle,
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              onAddCliked();
              //Utility.pushToDashboard(context, 0);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.blackGrey),
              child: Text(
                'ADD ADDRESS',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
