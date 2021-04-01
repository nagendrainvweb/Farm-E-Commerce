import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppQtyAddRemoveWidget.dart';
import 'package:lotus_farm/app_widget/app_amount.dart';
import 'package:lotus_farm/app_widget/app_carousel.dart';
import 'package:lotus_farm/app_widget/app_product_tile.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_view_model.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

class DashboardWidget extends StatefulWidget {
  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  _getTopText() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.bigMargin, vertical: Spacing.smallMargin),
      child: RichText(
          textAlign: TextAlign.left,
          textScaleFactor: 1.1,
          text: TextSpan(
              text: "Get Fresh",
              style: TextStyle(color: AppColors.blackLight),
              children: [
                TextSpan(
                  text: " Chicken ",
                  style: TextStyle(
                      color: AppColors.green,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " From\nfarm. Not Freezer ",
                  style: TextStyle(color: AppColors.blackLight),
                )
              ])),
    );
  }

  _getSliderIndicator(DashboardViewModel model) {
    return Container(
        height: 40,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSmoothIndicator(
              activeIndex: model.currentPosition,
              count: 3,
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

  _getSheduleOrder(DashboardViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.bigMargin, vertical: Spacing.smallMargin),
      child: Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        child: Image.network(
          "https://b.zmtcdn.com/data/pictures/chains/8/48188/731e244b54f8e8b4df18379ee6e142d2.jpg",
          height: 80,
          fit: BoxFit.cover,
          width: double.maxFinite,
        ),
      ),
    );
  }

  _getCarousel(DashboardViewModel model) {
    return Container(
      child: Neumorphic(
        margin: const EdgeInsets.symmetric(
            horizontal: Spacing.defaultMargin, vertical: Spacing.defaultMargin),
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        child: AppCarousel(
          true,
          bannerList: model.bannerList,
          onPageChanged: (int index, reason) {
            model.pageChanged(index);
          },
        ),
      ),
    );
  }

  _getListHeader(DashboardViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.bigMargin, vertical: Spacing.defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Trending",
              style: TextStyle(
                  color: AppColors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text("See All",
              style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 13,
                  fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  _getList(DashboardViewModel model) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.smallMargin, vertical: Spacing.smallMargin),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, 
            childAspectRatio: (itemWidth / 290)),
        itemCount: 10,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Hero(
            tag: "dash$index",
            child: Container(
              child: AppProductTile(
                tag: "dash",
                horizontal: Spacing.smallMargin,
                vertical: Spacing.defaultMargin,
                onCartClicked: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => AddToCartWidget(
                            onAddToCartClicked: () {
                              Navigator.pop(context);
                            },
                          ));
                },
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(),
      builder: (_, model, child) => Container(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getTopText(),
            _getCarousel(model),
            _getSliderIndicator(model),
            // Container(
            //   child: AnimatedSmoothIndicator(
            //   activeIndex: model.currentPosition,
            //   count: 3,
            //   effect: ExpandingDotsEffect(
            //       dotHeight: 8,
            //       dotWidth: 8,
            //       activeDotColor: AppColors.green,
            //       dotColor: AppColors.grey500,
            //       spacing: 4.0),
            // ),
            // ),
            _getSheduleOrder(model),
            _getListHeader(model),
            _getList(model),
          ],
        )),
      ),
    );
  }
}

class AddToCartWidget extends StatefulWidget {
  const AddToCartWidget({
    Key key,
    this.onAddToCartClicked,
  }) : super(key: key);

  final Function onAddToCartClicked;

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.defaultMargin, vertical: Spacing.bigMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Price",
                  style: TextStyle(
                    color: AppColors.grey400,
                  )),
              AppAmountWidget(
                amount: "500",
              )
            ],
          ),
          Spacer(),
          AppQtyAddRemoveWidget(
            qty: "1",
            iconLeftPadding: false,
            iconRightPadding: false,
            textScaleRefactor: 0.9,
            textHorizontalPadding: 4,
            textVerticalPadding: 0,
            iconSize: 16,
          ),
          Spacer(),
          AppButtonWidget(
            width: MediaQuery.of(context).size.width * 0.3,
            text: "Add to Cart",
            textScaleFactor: 0.9,
            onPressed: widget.onAddToCartClicked,
          )
        ],
      ),
    );
  }
}
