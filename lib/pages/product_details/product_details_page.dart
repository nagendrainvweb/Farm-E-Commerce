import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppQtyAddRemoveWidget.dart';
import 'package:lotus_farm/app_widget/app_product_tile.dart';
import 'package:lotus_farm/pages/product_details/product_details_view_model.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class ProductDetailsPage extends StatefulWidget {
  final int heroTag;

  const ProductDetailsPage({Key key, this.heroTag}) : super(key: key);
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  _getProductImage(ProductDetailsViewModel model) {
    return Hero(
      tag: widget.heroTag,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.mediumMargin),
          child: Neumorphic(
            style: NeumorphicStyle(
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
            ),
            child: Image.network(
              "https://b.zmtcdn.com/data/pictures/chains/8/48188/731e244b54f8e8b4df18379ee6e142d2.jpg",
              height: 300,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
          )),
    );
  }

  _getBottomAddCart(ProductDetailsViewModel model) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.shade400,
          blurRadius: 6.0,
        ),
      ]),
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.defaultMargin, vertical: Spacing.extraBigMargin),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pricing",
                  style: TextStyle(
                    color: AppColors.grey400,
                  )),
                  SizedBox(height:4),
              RichText(
                  text: TextSpan(
                      text: AppStrings.rupee,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.blackLight,
                          fontWeight: FontWeight.normal),
                      children: [
                    TextSpan(
                        text: "500",
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.blackLight,
                            fontWeight: FontWeight.bold))
                  ])),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          AppQtyAddRemoveWidget(
            qty: "1",
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: AppButtonWidget(
              width: double.maxFinite,
              text: "Add to cart",
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  _getPriceWithAddBtn(ProductDetailsViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(
                text: AppStrings.rupee,
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.blackLight,
                    fontWeight: FontWeight.normal),
                children: [
              TextSpan(
                  text: "500",
                  style: TextStyle(
                      fontSize: 24,
                      color: AppColors.blackLight,
                      fontWeight: FontWeight.bold))
            ])),
        AppQtyAddRemoveWidget(
          qty: "1",
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
     var size = MediaQuery.of(context).size;
     final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.55;
    return ViewModelBuilder<ProductDetailsViewModel>.reactive(
      viewModelBuilder: () => ProductDetailsViewModel(),
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(icon: SvgPicture.asset(
              ImageAsset.cartBag,
              height: 20,
              width: 20,
              
            ), onPressed: (){})
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getProductImage(model),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.bigMargin,
                              vertical: Spacing.bigMargin),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  textAlign: TextAlign.start,
                                  textScaleFactor: 1.3,
                                  text: TextSpan(
                                      text: "Chicken ",
                                      style: TextStyle(
                                          color: AppColors.green,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: "Breast",
                                          style: TextStyle(
                                              color: AppColors.blackLight,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ])),
                              SizedBox(height: 5),
                              Text(
                                "Boneless",
                                textScaleFactor: 1.1,
                                style: TextStyle(color: AppColors.grey600),
                              ),
                              SizedBox(height: 10),
                              _getPriceWithAddBtn(model),
                              SizedBox(height: 10),
                              ChickenFeaturesWidget(),
                              CheckAvailabilityWidget(),
                              Descriptionwidget(),
                            ],
                          ),
                        ),
                        ProductTabWidget(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: Spacing.defaultMargin),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 1,
                                    width: 30,
                                    color: AppColors.blackLight,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("View Similar Products",
                                      textScaleFactor: 0.9,
                                      style: TextStyle(
                                          color: AppColors.blackLight,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 1,
                                    width: 30,
                                    color: AppColors.blackLight,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 265,
                                child: MediaQuery.removeViewPadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                    itemCount: 10,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (_, index) {
                                      return Container(
                                        //height: 150,
                                        width: 200,
                                        child: Hero(
                                          tag: "pro$index",
                                          child: AppProductTile(
                                            tag:"pro",
                                            horizontal: Spacing.mediumMargin,
                                            vertical: Spacing.smallMargin,
                                            onTileClicked: () {
                                              Utility.pushToNext(
                                                  ProductDetailsPage(
                                                    heroTag: index,
                                                  ),
                                                  context);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                  ),
                  _getBottomAddCart(model),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: Container(
            //     height: Size.fromHeight(70).height,
            //     child: AppBar(
            //      backgroundColor: Colors.transparent,
            //     actions: [
            //       // FloatingActionButton(
            //       //   onPressed: (){},
            //       //   child: Icon(Icons.shopping_bag_outlined,color: AppColors.white,),
            //       // )
            //     ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class ProductTabWidget extends ViewModelWidget<ProductDetailsViewModel> {
  const ProductTabWidget({
    Key key,
  }) : super(key: key, reactive: true);

  _getTabWidget(ProductDetailsViewModel model) {
    final List<Widget> widgetList = [
      BenifitWidget(),
      ReviewWidget(),
    ];
    return widgetList[model.tabPosition];
  }

  @override
  Widget build(BuildContext context, ProductDetailsViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.defaultMargin),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomTab(
                title: "Custom Tab",
                active: model.tabPosition == 0,
                onTapClicked: () {
                  model.setTabPosition(0);
                },
              ),
              CustomTab(
                title: "Reviews",
                active: model.tabPosition == 1,
                onTapClicked: () {
                  model.setTabPosition(1);
                },
              ),
            ],
          ),
          SizedBox(height:20),
          _getTabWidget(model),
        ],
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.mediumMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MediaQuery.removePadding(
            context: context,
      removeTop: true,
            child: ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                separatorBuilder: (_, index) => Container(
                      height: 8,
                    ),
                itemBuilder: (_, index) => Neumorphic(
                      style: NeumorphicStyle(color: AppColors.white),
                      child: Container(
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                        text: "Nagendra Prajapati",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.blackLight,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          //  TextSpan(
                                          //   text: "  as on 10/03/2021" ,
                                          //   style: TextStyle(fontSize: 10,color: AppColors.grey600,fontWeight: FontWeight.normal ),
                                          //  )
                                        ]),
                                  ),
                                  Row(
                                    children: List.generate(
                                        3,
                                        (index) => Icon(
                                              Icons.star,
                                              size: 12,
                                              color: AppColors.green,
                                            )),
                                  )
                                ],
                              ),
                              SizedBox(height:3),
                              Text("as on 10/03/2021",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.grey600,
                                      fontWeight: FontWeight.normal)),
                              SizedBox(height: 8)
                            ],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: Spacing.defaultMargin,
                              vertical: Spacing.halfSmallMargin),
                          subtitle: Text("very decilious checiken !!!"),
                        ),
                      ),
                    )),
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "see all reviews",
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}

class BenifitWidget extends StatelessWidget {
  const BenifitWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.9),
        itemCount: 6,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Neumorphic(
              style: NeumorphicStyle(
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(6)),
                  color: AppColors.white),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.defaultMargin,
                    vertical: Spacing.defaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.leaderboard,
                      color: AppColors.green,
                      size: 34,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Fresh with nurition intact",
                          textAlign: TextAlign.center,
                          textScaleFactor: 0.8,
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  const CustomTab({Key key, this.active, this.onTapClicked, this.title})
      : super(key: key);

  final bool active;
  final Function onTapClicked;
  final title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapClicked,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: Spacing.mediumMargin, horizontal: Spacing.extraBigMargin),
        decoration: BoxDecoration(
            border: (active)
                ? Border.all(color: AppColors.blackLight, width: 0.8)
                : Border(),
            borderRadius: BorderRadius.circular((active) ? 6 : 0)),
        child: Text(title,
            textScaleFactor: 0.9,
            style: TextStyle(
                color: (active) ? AppColors.blackLight : AppColors.blackGrey)),
      ),
    );
  }
}

class Descriptionwidget extends StatelessWidget {
  const Descriptionwidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.defaultMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description",
              style: TextStyle(
                  color: AppColors.blackLight, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                      "Chicken Breast is one of the meatier cuts of a Chicken, which comes from the breast-bone of the bird. This cut is skinless and has a supple texture. A good source of vitamins and minerals, Chicken Breast, is also a great choice for a lean protein diet. Apply a flavourful spice-rub and pan-fry, bake, grill, or slow-cook the Chicken Breast to relish this versatile cut. Order fresh Chicken Breast online from Licious and get it home-delivered.",
                      textScaleFactor: 0.8,
                      style: TextStyle(color: AppColors.grey600)))
            ],
          )
        ],
      ),
    );
  }
}

class CheckAvailabilityWidget extends StatelessWidget {
  const CheckAvailabilityWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.defaultMargin),
      child: Neumorphic(
        style:NeumorphicStyle(
          color:AppColors.tileColor
        ) ,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey200, width: 1),
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Check Availability",
                      contentPadding: const EdgeInsets.only(
                          left: 10.0, top: 10, bottom: 10),
                    ),
                  )),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        left: BorderSide(color: AppColors.grey200, width: 1),
                      )),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 15, left: 20, right: 15),
                        child: Text(
                          "CHECK",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.redAccent),
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
    );
  }
}

class ChickenFeaturesWidget extends StatelessWidget {
  const ChickenFeaturesWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.bigMargin),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: FeatureTile()),
              Expanded(child: FeatureTile())
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(child: FeatureTile()),
              Expanded(child: FeatureTile())
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.local_drink_outlined,
          color: AppColors.green,
          size: 18,
        ),
        SizedBox(width: 8),
        Text(
          "No. of Piceess 6-8",
          textScaleFactor: 0.8,
        )
      ],
    );
  }
}


