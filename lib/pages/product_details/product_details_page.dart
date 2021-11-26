import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/AppQtyAddRemoveWidget.dart';
import 'package:lotus_farm/app_widget/app_product_tile.dart';
import 'package:lotus_farm/model/product_details_data.dart';
import 'package:lotus_farm/pages/cart_page/cart_page.dart';
import 'package:lotus_farm/pages/product_details/product_details_view_model.dart';
import 'package:lotus_farm/pages/review_page/review_page.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

class ProductDetailsPage extends StatefulWidget {
  final String heroTag;
  final String productId;

  const ProductDetailsPage({Key key, this.heroTag, this.productId})
      : super(key: key);
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  _getSliderIndicator(ProductDetailsViewModel model) {
    return Container(
        height: 40,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSmoothIndicator(
              activeIndex: model.currentPosition,
              count: model.productDetailsData.images.length,
              effect: WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.green,
                  dotColor: AppColors.grey400,
                  spacing: 6.0),
            ),
          ],
        )
        //  List.generate(model.bannerList.length, (position) {
        //   return Container(
        //     height: 14,
        //     padding: EdgeInsets.all(3),
        //     margin: EdgeInsets.all(4),
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: (model.currentPosition == position
        //           ? AppColors.green
        //           : AppColors.grey400),
        //     ),
        //   );
        // }

        );
  }

  _getProductImage(ProductDetailsViewModel model) {
    final size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24);
    final double itemWidth = size.width;
    return Container(
      height: 300,
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.mediumMargin),
      child: Neumorphic(
          style: NeumorphicStyle(
            color: Colors.transparent,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12))),
          ),
          child: (model.productDetailsData.images.length > 0)
              ? CarouselSlider.builder(
                  itemCount: model.productDetailsData.images.length,
                  itemBuilder: (BuildContext context, int index, int value) {
                    return CachedNetworkImage(
                      height: 300,
                      width: double.maxFinite,
                      imageUrl: model.productDetailsData.images[index].imageUrl,
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
                    );
                  },
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      aspectRatio: 1.0,
                      initialPage: 0,
                      autoPlayCurve: Curves.linear,
                      onPageChanged: (index, reason) {
                        model.onPageChanged(index, reason);
                      }))
              : Image.asset(
                  ImageAsset.noImage,
                  height: 300,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                )),
      //  Image.network(
      //   "https://b.zmtcdn.com/data/pictures/chains/8/48188/731e244b54f8e8b4df18379ee6e142d2.jpg",
      //   height: 300,
      //   width: double.maxFinite,
      //   fit: BoxFit.cover,
      // ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pricing",
                  style: TextStyle(
                    color: AppColors.grey400,
                  )),
              SizedBox(height: 4),
              RichText(
                  text: TextSpan(
                      text: AppStrings.rupee,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.blackLight,
                          fontWeight: FontWeight.normal),
                      children: [
                    TextSpan(
                        text: "${model.totalAmount}",
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColors.blackLight,
                            fontWeight: FontWeight.bold))
                  ])),
            ],
          ),
          Spacer(),
          AppQtyAddRemoveWidget(
            qty: "${model.productDetailsData.qty}",
            iconLeftPadding: false,
            iconRightPadding: false,
            textScaleRefactor: 0.9,
            textHorizontalPadding: 4,
            textVerticalPadding: 0,
            iconSize: 16,
            onAddClicked: () {
              model.addClicked();
            },
            onLessClicked: () {
              model.lessClicked();
            },
          ),
          Spacer(),
          AppButtonWidget(
            width: MediaQuery.of(context).size.width * 0.3,
            text: (model.productDetailsData.isInStock)
                ? "Add to cart"
                : "Pre Order",
            onPressed: () {
              if (model.productDetailsData.isInStock) {
                model.addToCart(model.productDetailsData.id, "",
                    model.productDetailsData.qty, onError: (String text) {
                  Utility.showSnackBar(context, text);
                });
              } else {
                Utility.pushToNext(ProductDetailsPage(productId: model.productDetailsData.preOrderId,), context);
              }
            },
          )
        ],
      ),
    );
  }

  _getPriceWithAddBtn(ProductDetailsViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                text: AppStrings.rupee,
                style: TextStyle(
                    fontSize: 24,
                    color: AppColors.blackLight,
                    fontWeight: FontWeight.normal),
                children: [
              TextSpan(
                  text: (double.parse(model.productDetailsData.newPrice))
                      .toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 24,
                      color: AppColors.blackLight,
                      fontWeight: FontWeight.bold))
            ])),
        SizedBox(
          width: 10,
        ),
        Visibility(
          visible: model.productDetailsData.newPrice !=
              model.productDetailsData.oldPrice,
          child: Text(
              "${AppStrings.rupee}${(double.parse(model.productDetailsData.oldPrice)).toStringAsFixed(0)}",
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.grey500,
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.normal)),
        ),
        Spacer(),
        Row(
          children: [
            Text(
              "Availability: ",
              textScaleFactor: 0.8,
              style: TextStyle(color: AppColors.grey500),
            ),
            Text(
              (model.productDetailsData.isInStock)
                  ? "in stock"
                  : "out of stock",
              textScaleFactor: 0.9,
              style: TextStyle(
                  color: (model.productDetailsData.isInStock)
                      ? Colors.lightGreen
                      : AppColors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )

        // RichText(
        //     text: TextSpan(
        //         text: AppStrings.rupee,
        //         style: TextStyle(
        //             fontSize: 20,
        //             color: AppColors.grey500,
        //             fontWeight: FontWeight.normal),
        //         children: [
        //       TextSpan(
        //           text: (double.parse(model.productDetailsData.oldPrice))
        //               .toStringAsFixed(0),
        //           style: TextStyle(
        //               fontSize: 20,
        //               color: AppColors.grey500,
        //               fontWeight: FontWeight.normal))
        //     ])),

        // AppQtyAddRemoveWidget(
        //   qty: "${model.productDetailsData.qty}",
        //   onAddClicked: () {
        //     model.addClicked();
        //   },
        //   onLessClicked: () {
        //     model.lessClicked();
        //   },
        // )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.55;
    final appRepo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<ProductDetailsViewModel>.reactive(
      viewModelBuilder: () => ProductDetailsViewModel(),
      onModelReady: (model) {
        model.initData(widget.productId, appRepo);
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          actions: [
            Stack(
              children: [
                Visibility(
                  visible: appRepo.login,
                  child: GestureDetector(
                    onTap: () {
                      Utility.pushToNext(CartPage(), context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: Neumorphic(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12)),
                            depth: 8,
                            lightSource: LightSource.topLeft,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 18,
                            ),
                          )),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Consumer<AppRepo>(
                    builder: (_, repo, child) => (repo.cartCount > 0)
                        ? new Container(
                            margin: EdgeInsets.only(left: 30),
                            decoration: BoxDecoration(
                                color: AppColors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppColors.green, width: 1.2)),
                            child: new Container(
                              padding: EdgeInsets.only(
                                  top: 4, bottom: 4, left: 4, right: 4),
                              child: new Text(
                                '${repo.cartCount}',
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white),
                              ),
                            ),
                          )
                        : SizedBox(height: 0, width: 0),
                  ),
                )
              ],
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: (model.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (model.hasError)
                ? AppErrorWidget(
                    message: SOMETHING_WRONG_TEXT,
                    onRetryCliked: () {
                      model.fetchProductDetails();
                    })
                : Stack(
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
                                  SizedBox(height: 5),
                                  _getSliderIndicator(model),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Spacing.bigMargin,
                                        vertical: Spacing.bigMargin),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                            textAlign: TextAlign.start,
                                            textScaleFactor: 1.3,
                                            text: TextSpan(
                                                text: "",
                                                style: TextStyle(
                                                    color: AppColors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: [
                                                  TextSpan(
                                                    text: model
                                                        .productDetailsData
                                                        .name,
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .blackLight,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  )
                                                ])),
                                        // SizedBox(height: 5),
                                        // Text(
                                        //   model.productDetailsData.category,
                                        //   textScaleFactor: 1.1,
                                        //   style: TextStyle(
                                        //       color: AppColors.grey600),
                                        // ),
                                        (model.productDetailsData.discount >
                                                    0 ||
                                                model.productDetailsData
                                                    .specialText.isNotEmpty)
                                            ? SizedBox(height: 8)
                                            : Container(),
                                        Row(
                                          children: [
                                            (model.productDetailsData.discount >
                                                    0)
                                                ? Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                            color: Colors
                                                                .lightGreen
                                                                .withOpacity(
                                                                    0.2)),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6),
                                                        child: Text(
                                                          "${model.productDetailsData.discount}% Discount",
                                                          textScaleFactor: 0.8,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                    ],
                                                  )
                                                : Container(),
                                            (model.productDetailsData
                                                    .specialText.isNotEmpty)
                                                ? Expanded(
                                                    child: Text(
                                                      "${model.productDetailsData.specialText}",
                                                      textScaleFactor: 0.9,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .redAccent),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        _getPriceWithAddBtn(model),
                                        SizedBox(height: 10),
                                        ChickenFeaturesWidget(
                                            data: model.productDetailsData),

                                        ///  CheckAvailabilityWidget(),
                                        // Descriptionwidget(
                                        //   decs: model.productDetailsData.desc,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  ProductTabWidget(),
                                  (model.similarList.length > 0)
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: Spacing.defaultMargin),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
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
                                                          color: AppColors
                                                              .blackLight,
                                                          fontWeight:
                                                              FontWeight.bold)),
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
                                                child: MediaQuery
                                                    .removeViewPadding(
                                                  context: context,
                                                  removeTop: true,
                                                  child: ListView.builder(
                                                    itemCount: model
                                                        .similarList.length,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        ClampingScrollPhysics(),
                                                    itemBuilder: (_, index) {
                                                      final product = model
                                                          .similarList[index];
                                                      return Container(
                                                        //height: 150,
                                                        width: 200,
                                                        child: Hero(
                                                          tag: "pro$index",
                                                          child: AppProductTile(
                                                            tag: "pro",
                                                            product: product,
                                                            showAddToCart:
                                                                false,
                                                            horizontal: Spacing
                                                                .mediumMargin,
                                                            vertical: Spacing
                                                                .smallMargin,
                                                            onTileClicked: () {
                                                              if (product
                                                                  .isInStock) {
                                                                Utility.pushToNext(
                                                                    ProductDetailsPage(
                                                                      heroTag:
                                                                          "pro$index",
                                                                      productId:
                                                                          product
                                                                              .id,
                                                                    ),
                                                                    context);
                                                              } else {
                                                                Utility.pushToNext(
                                                                    ProductDetailsPage(
                                                                      heroTag:
                                                                          "pro$index",
                                                                      productId:
                                                                          product
                                                                              .preOrderId,
                                                                    ),
                                                                    context);
                                                              }
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
                                      : Container()
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
      Descriptionwidget(
        decs: model.productDetailsData.desc,
      ),
      ReviewWidget(model.productDetailsData.reviewData.review),
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
                title: "Description",
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
          SizedBox(height: 20),
          _getTabWidget(model),
        ],
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget(
    this.reviewList, {
    Key key,
    this.showMore = true,
    this.setLimit = true,
  }) : super(key: key);
  final List<Review> reviewList;
  final bool showMore;
  final bool setLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.mediumMargin),
      child: (reviewList.length > 0)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.separated(
                      itemCount: (setLimit)
                          ? (reviewList.length > 5)
                              ? 5
                              : reviewList.length
                          : reviewList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      separatorBuilder: (_, index) => Container(
                            height: 8,
                          ),
                      itemBuilder: (_, index) {
                        final review = reviewList[index];
                        return Neumorphic(
                          style: NeumorphicStyle(color: AppColors.white),
                          child: Container(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                            text: review.userName,
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
                                            review.rating,
                                            (index) => Icon(
                                                  Icons.star,
                                                  size: 12,
                                                  color: AppColors.green,
                                                )),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 3),
                                  Text("as on ${review.date}",
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
                              subtitle: Text("${review.review}"),
                            ),
                          ),
                        );
                      }),
                ),
                Visibility(
                  visible: showMore,
                  child: TextButton(
                      onPressed: () {
                        Utility.pushToNext(
                            ReviewPage(
                              reviewList: reviewList,
                            ),
                            context);
                      },
                      child: Text(
                        "see all reviews",
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            )
          : Center(
              child: Text("No Reviews found",
                  style: TextStyle(
                    color: AppColors.grey700,
                    fontSize: 12,
                  ))),
    );
  }
}

class BenifitWidget extends StatelessWidget {
  const BenifitWidget({
    Key key,
    this.benifitText,
    this.benifitImages,
  }) : super(key: key);
  final benifitText;
  final benifitImages;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.9),
        itemCount: benifitText.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
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
                    SvgPicture.asset(
                      benifitImages[index],
                      height: 40,
                    ),
                    // Icon(
                    //   Icons.leaderboard,
                    //   color: AppColors.green,
                    //   size: 34,
                    // ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          benifitText[index],
                          textAlign: TextAlign.center,
                          textScaleFactor: 0.7,
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
                ? Border.all(color: AppColors.green, width: 1.0)
                : Border(),
            borderRadius: BorderRadius.circular((active) ? 6 : 0)),
        child: Text(title,
            textScaleFactor: 0.9,
            style: TextStyle(
                color: (active) ? AppColors.green : AppColors.blackGrey)),
      ),
    );
  }
}

class Descriptionwidget extends StatelessWidget {
  const Descriptionwidget({
    Key key,
    this.decs,
  }) : super(key: key);
  final decs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: Spacing.smallMargin, horizontal: Spacing.bigMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("Description",
          //     style: TextStyle(
          //         color: AppColors.blackLight, fontWeight: FontWeight.bold)),
          // SizedBox(
          //   height: 8,
          // ),
          Row(
            children: [
              Expanded(
                  child:
                      // Html(data: decs),
                      Text(decs,
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
        style: NeumorphicStyle(color: AppColors.tileColor),
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
    this.data,
  }) : super(key: key);

  final ProductDetailsData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Spacing.bigMargin),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: FeatureTile(
                image: ImageAsset.no_of_pieces,
                title: "No of Pieces ${data.piece}",
              )),
              Expanded(
                  child: FeatureTile(
                      image: ImageAsset.gross_wt,
                      title: "Gross Wt. ${data.grossWeight}"))
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                  child: FeatureTile(
                image: ImageAsset.serves,
                title: "Serves ${data.serves}",
              )),
              Expanded(
                  child: FeatureTile(
                image: ImageAsset.net_wt,
                title: "Net Wt. ${data.netWeight}",
              ))
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: FeatureTile(
                  image: ImageAsset.delivery_chicken,
                  title: "Delivery in: ${data.expectedDelivery}",
                ),
              )
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
    this.image,
    this.title,
  }) : super(key: key);

  final image;
  final title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          image,
          height: 22,
        ),
        // Icon(
        //   Icons.local_drink_outlined,
        //   color: AppColors.green,
        //   size: 18,
        // ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            textScaleFactor: 0.8,
          ),
        )
      ],
    );
  }
}
