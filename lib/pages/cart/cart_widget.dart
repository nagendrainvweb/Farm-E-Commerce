import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/AppQtyAddRemoveWidget.dart';
import 'package:lotus_farm/app_widget/app_amount.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/pages/cart/cart_view_model.dart';
import 'package:lotus_farm/pages/check_out/check_out_page.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/dialog_helper.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  _getBottomWidget(CartViewModel model) {
    int totalAmount = 0;
    for (Product product in model.cartList) {
      totalAmount = totalAmount + product.amount;
    }
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
                amount: "$totalAmount",
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
              //Utility.pushToNext(CheckoutPage(), context);
              model.checkOutClicked(onMessage: (String text) {
                Utility.showSnackBar(context, text);
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context);
    return ViewModelBuilder<CartViewModel>.reactive(
      viewModelBuilder: () => CartViewModel(),
      onModelReady: (model) {
        model.initData(appRepo);
        model.fetchCartList();
      },
      builder: (_, model, child) => (model.loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (model.hasError)
              ? AppErrorWidget(
                  message: SOMETHING_WRONG_TEXT,
                  onRetryCliked: () {
                    model.fetchCartList();
                  })
              : (model.cartList.isEmpty)
                  ? _getEmptyView
                  : Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              child: ListView.separated(
                                itemCount: model.cartList.length,
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
                                              horizontal:
                                                  Spacing.defaultMargin),
                                          child: Text(
                                              "Item (${model.cartList.length})",
                                              style: TextStyle(
                                                  color: AppColors.green,
                                                  fontWeight: FontWeight.bold)),
                                        )),
                                    CartItemTile(
                                      product: model.cartList[index],
                                      onAddClicked: () {
                                        model.cartList[index].qty++;
                                        model.cartList[index].amount =
                                            model.cartList[index].newPrice *
                                                model.cartList[index].qty;
                                        model.notifyListeners();
                                      },
                                      onLessClicked: () {
                                        if (model.cartList[index].qty != 1) {
                                          model.cartList[index].qty--;
                                          model.cartList[index].amount =
                                              model.cartList[index].newPrice *
                                                  model.cartList[index].qty;
                                          model.notifyListeners();
                                        }
                                      },
                                      onDeleteClicked: () {
                                        DialogHelper.showRemoveDialog(
                                            context,
                                            model.cartList[index].name,
                                            'Remove product from cart ?',
                                            'REMOVE', () async {
                                          Navigator.pop(context);
                                          model.removeFromCart(
                                              model.cartList[index],
                                              onMessage: (String text) {
                                            Utility.showSnackBar(context, text);
                                          });
                                          //await _removeFromCartlist(index);
                                          // if (cartList.length > 0) {
                                          //   _calculateDiscount();
                                          // }
                                        });
                                      },
                                    ),
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

  get _getEmptyView {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              ImageAsset.emptyBag,
              height: 250,
            ),
            SizedBox(
              height: 15,
            ),
            Text('Your cart is empty',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Text(
              "You have no items in your shopping cart.\nLets's go buy something!",
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.2),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                Utility.pushToDashboard(context, 0);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.blackGrey),
                child: Text(
                  'BROWSE PRODUCT',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    Key key,
    @required this.product,
    this.onAddClicked,
    this.onLessClicked,
    this.onDeleteClicked,
  }) : super(key: key);

  final Product product;
  final Function onAddClicked;
  final Function onLessClicked;
  final Function onDeleteClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
            GestureDetector(
              onTap: () {
                Utility.pushToNext(ProductDetailsPage(
                    productId: product.id,
                ), context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                        child: (product.images.length > 0)
                            ? CachedNetworkImage(
                                width: 120,
                                height: double.maxFinite,
                                imageUrl: product.images[0].imageUrl,
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
                              )
                            : Image.asset(
                                ImageAsset.noImage,
                                width: 120,
                                height: double.maxFinite,
                                fit: BoxFit.cover,
                              )),
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
                          product.name,
                          textScaleFactor: 1.1,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          product.category,
                          textScaleFactor: 0.8,
                          style: TextStyle(color: AppColors.green),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppAmountWidget(
                              amount: "${(product.amount)}",
                              rupeeColor: AppColors.green,
                            ),
                            AppQtyAddRemoveWidget(
                              qty: "${product.qty}",
                              iconLeftPadding: false,
                              iconRightPadding: false,
                              textScaleRefactor: 0.9,
                              textHorizontalPadding: 4,
                              textVerticalPadding: 0,
                              iconSize: 16,
                              onAddClicked: onAddClicked,
                              onLessClicked: onLessClicked,
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
              child: InkWell(
                onTap: onDeleteClicked,
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
