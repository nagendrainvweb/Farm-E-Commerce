import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppNeumorphicContainerWidget.dart';
import 'package:lotus_farm/app_widget/AppQtyAddRemoveWidget.dart';
import 'package:lotus_farm/app_widget/AppTextFeildOutlineWidget.dart';
import 'package:lotus_farm/app_widget/app_amount.dart';
import 'package:lotus_farm/pages/check_out/check_out_view_model.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:stacked/stacked.dart';

class CheckoutPage extends StatefulWidget {
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
                amount: "1500",
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery fees"),
              AppAmountWidget(
                amount: "50",
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Paying Amount"),
              AppAmountWidget(
                amount: "1550",
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
                onPressed: () {},
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
    return ViewModelBuilder<CheckOutViewModel>.reactive(
      viewModelBuilder: () => CheckOutViewModel(),
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Checkout",
            style: TextStyle(color: AppColors.blackGrey),
          ),
        ),
        body: Container(
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
                          title: "Delivery Method",
                          child: Text(
                            "Free Delivery with Danzo",
                            style: TextStyle(
                                color: AppColors.grey500,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                          onEditclicked: () {},
                        ),
                        CheckOutOptionWidget(
                          title: "Address",
                          child: Text(
                            "D/11, jai santoshi mata building, kurar village, malad east, mumbai 400097",
                            style: TextStyle(
                                color: AppColors.grey500,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                          onEditclicked: () {},
                        ),
                        CheckOutOptionWidget(
                          title: "Payment Method",
                          child: Column(children: [
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      model.onRadioValueChanged(1);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "Net Banking/ Upi ",
                                          style: TextStyle(
                                              color: AppColors.blackGrey,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          "(powered by Razarpay)",
                                          style: TextStyle(
                                              color: AppColors.green,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Radio(
                                    visualDensity: VisualDensity.compact,
                                    value: 1,
                                    groupValue: model.paymentMethodRadio,
                                    onChanged: (int value) {
                                      model.onRadioValueChanged(value);
                                    })
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      model.onRadioValueChanged(2);
                                    },
                                    child: Text(
                                      "Cash on delivery",
                                      style: TextStyle(
                                          color: AppColors.blackGrey,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                Radio(
                                    visualDensity: VisualDensity.compact,
                                    value: 2,
                                    groupValue: model.paymentMethodRadio,
                                    onChanged: (int value) {
                                      model.onRadioValueChanged(value);
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
                                                color: AppColors.grey200,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Enter Coupon Code",
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10.0,
                                                        top: 10,
                                                        bottom: 10),
                                              ),
                                            )),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                  left: BorderSide(
                                                      color: AppColors.grey200,
                                                      width: 1),
                                                )),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 15.0,
                                                          bottom: 15,
                                                          left: 20,
                                                          right: 15),
                                                  child: Text(
                                                    "APPLY",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                        color: AppColors.blackGrey,
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
