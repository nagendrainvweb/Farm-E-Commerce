import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppQtyAddRemoveWidget.dart';
import 'package:lotus_farm/app_widget/app_amount.dart';
import 'package:lotus_farm/pages/cart/cart_view_model.dart';
import 'package:lotus_farm/pages/check_out/check_out_page.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  _getBottomWidget(CartViewModel model) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          blurRadius: 6.0,
        ),
      ]),
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.defaultMargin, vertical: Spacing.defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total Pricing",
                  style: TextStyle(
                    color: AppColors.grey400,
                  )),
              AppAmountWidget(
                amount: "500",
              )
            ],
          ),

          // QtyAddRemoveWidget(),
          // SizedBox(
          //   width: 15,
          // ),
          AppButtonWidget(
            width: MediaQuery.of(context).size.width * 0.3,
            text: "Checkout",
            onPressed: () {
              Utility.pushToNext(CheckoutPage(), context);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartViewModel>.reactive(
      viewModelBuilder: () => CartViewModel(),
      builder: (_, model, child) => Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.separated(
                  itemCount: 4,
                  separatorBuilder: (_, index) => Container(
                      // height: 15,
                      ),
                  itemBuilder: (_, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                          visible: index == 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.defaultMargin),
                            child: Text("Item (3)",
                                style: TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.bold)),
                          )),
                      CartItemTile(),
                    ],
                  ),
                ),
              ),
            ),
            _getBottomWidget(model),
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      child: Neumorphic(
        margin: const EdgeInsets.symmetric(
            horizontal: Spacing.defaultMargin, vertical: Spacing.mediumMargin),
        style: NeumorphicStyle(
            intensity: 8,
            depth: 4,
            color: AppColors.tileColor,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12))),
        child: Stack(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12)),
                      child: CachedNetworkImage(
                        width: 120,
                        height: double.maxFinite,
                        imageUrl: AppStrings.demoImage,
                        placeholder: (context, data) {
                          return Container(
                            child: new Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: new CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        },
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.defaultMargin,
                        vertical: Spacing.defaultMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Chichen Thing",
                          textScaleFactor: 1.1,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Boneless Chicken Thing cut",
                          textScaleFactor: 0.8,
                          style: TextStyle(color: AppColors.green),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppAmountWidget(
                              amount: "500",
                              rupeeColor: AppColors.green,
                            ),
                            AppQtyAddRemoveWidget(
                              qty: "1",
                              iconLeftPadding: false,
                              iconRightPadding: false,
                              textScaleRefactor: 0.9,
                              textHorizontalPadding: 4,
                              textVerticalPadding: 0,
                              iconSize: 16,
                            )
                          ],
                        )
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        // topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                    color: Colors.red.shade400),
                child: Icon(
                  Icons.delete_forever_outlined,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
