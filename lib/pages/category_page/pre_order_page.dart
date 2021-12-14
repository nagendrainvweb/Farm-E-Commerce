import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppNeumorphicContainerWidget.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/pages/cart_page/cart_page.dart';
import 'package:lotus_farm/pages/category_page/product_list_page.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/constants.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';

class PreOrderPage extends StatefulWidget {
  const PreOrderPage(
      {Key key,
      @required this.title,
      @required this.categoryId,
      this.isPreOrder})
      : super(key: key);
  final String title;
  final String categoryId;
  final bool isPreOrder;

  @override
  _PreOrderPageState createState() => _PreOrderPageState();
}

class _PreOrderPageState extends State<PreOrderPage> {
  String weight = "";
  String skin = "";
  String bone = "";
  bool _isFilter = false;

  double priceValue = 130.00;
  _showFilterSheet(BuildContext context,
      {Function onApplyClicked, Function onClearClicked}) {
    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (_) => FilterWidget(
              priceValue: priceValue,
              weight: weight,
              skin: skin,
              bone: bone,
              onApplyClicked: onApplyClicked,
              onClearClicked: onClearClicked,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          widget.title,
          style: TextStyle(color: AppColors.blackGrey),
        ),
        actions: [
          Consumer<AppRepo>(
            builder: (_, appRepo, child) => Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                    visible: appRepo.login,
                    child: IconButton(
                      onPressed: () {
                        Utility.pushToNext(CartPage(), context);
                      },
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        //  size: 18,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: (appRepo.cartCount > 0)
                      ? Container(
                          margin: EdgeInsets.only(left: 30,bottom: 5),
                          decoration: BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppColors.green, width: 1.2)),
                          child: new Container(
                            padding: EdgeInsets.only(
                                top: 4, bottom: 4, left: 4, right: 4),
                            child: new Text(
                              '${appRepo.cartCount}',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white),
                            ),
                          ),
                        )
                      : SizedBox(height: 0, width: 0),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                _showFilterSheet(context, onClearClicked: () {
                  Navigator.pop(context);
                  priceValue = 130.00;
                  weight = "";
                  skin = "";
                  bone = "";
                }, onApplyClicked: (priceNew, weightNew, skinNew, boneNew) {
                  Navigator.pop(context);
                  priceValue = priceNew;
                  weight = weightNew;
                  skin = skinNew;
                  bone = boneNew;
                });
              },
              icon: Icon(Icons.filter_alt_outlined))
        ],
      ),
      body: ProductListPage(
        categoryId: widget.categoryId,
        isPreOrder: widget.isPreOrder,
      ),
    );
  }
}

class FilterWidget extends StatefulWidget {
  FilterWidget(
      {Key key,
      this.priceValue,
      this.weight,
      this.skin,
      this.bone,
      this.onClearClicked,
      this.onApplyClicked})
      : super(key: key);

  double priceValue;
  final onApplyClicked, onClearClicked;
  String weight, skin, bone;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String bone = "", skin = "", weight = "";
  double priceValue = 0.0;

  _getTab(String text, bool selected, Function onClick) {
    return InkWell(
      onTap: onClick,
      child: AppNeumorphicContainer(
          color: selected ? AppColors.green : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
            child: Text(
              "$text",
              style: TextStyle(
                  color: selected ? AppColors.white : AppColors.blackText),
            ),
          )),
    );
  }

  @override
  void initState() {
    priceValue = widget.priceValue;
    weight = widget.weight;
    skin = widget.skin;
    bone = widget.bone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //  crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Row(
              children: [
                Text(
                  "Apply Filters",
                  textScaleFactor: 1.1,
                  style: TextStyle(
                      color: AppColors.grey700, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.grey600,
                    ))
              ],
            ),
          ),
          Container(height: 1, color: AppColors.grey400),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price : 130 - ${priceValue.toStringAsFixed(0)}",
                  style: TextStyle(
                      color: AppColors.blackGrey, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      "130",
                      textScaleFactor: 0.9,
                    ),
                    Expanded(
                      child: Slider(
                        value: priceValue,
                        min: 130,
                        max: 420,
                        divisions: 5,
                        label: priceValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            priceValue = value;
                          });
                        },
                      ),
                    ),
                    Text("420")
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //  Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  child: Text(
                    "Weight :",
                    style: TextStyle(
                        color: AppColors.blackGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // SizedBox(width: 50,),
                Expanded(
                  child: Row(
                    children: [
                      _getTab(Constants.WEIGHT_1,
                          weight.contains(Constants.WEIGHT_1), () {
                        setState(() {
                          weight = Constants.WEIGHT_1;
                        });
                      }),
                      _getTab(Constants.WEIGHT_2,
                          weight.contains(Constants.WEIGHT_2), () {
                        setState(() {
                          weight = Constants.WEIGHT_2;
                        });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  child: Text(
                    "Skin :",
                    style: TextStyle(
                        color: AppColors.blackGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //  SizedBox(width: 10,),
                Expanded(
                  child: Row(
                    children: [
                      _getTab(Constants.SKIN_1, skin.contains(Constants.SKIN_1),
                          () {
                        setState(() {
                          skin = Constants.SKIN_1;
                        });
                      }),
                      _getTab(Constants.SKIN_2, skin.contains(Constants.SKIN_2),
                          () {
                        setState(() {
                          skin = Constants.SKIN_2;
                        });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  child: Text(
                    "Bone :",
                    style: TextStyle(
                        color: AppColors.blackGrey,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                //  SizedBox(width: 10,),
                Expanded(
                  child: Row(
                    children: [
                      _getTab(Constants.BONE_1, bone.contains(Constants.BONE_1),
                          () {
                        setState(() {
                          bone = Constants.BONE_1;
                        });
                      }),
                      _getTab(Constants.BONE_2, bone.contains(Constants.BONE_2),
                          () {
                        setState(() {
                          bone = Constants.BONE_2;
                        });
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.bigMargin),
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: AppButtonWidget(
                    // width: 100,
                    verticalPadding: Spacing.mediumMargin,
                    onPressed: () => widget.onClearClicked(),
                    text: "Clear",
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: AppButtonWidget(
                    // width: 100,
                    verticalPadding: Spacing.mediumMargin,
                    onPressed: () =>
                        widget.onApplyClicked(priceValue, weight, skin, bone),
                    text: "Apply",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
