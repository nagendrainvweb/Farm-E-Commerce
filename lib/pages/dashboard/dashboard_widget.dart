import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/AppQtyAddRemoveWidget.dart';
import 'package:lotus_farm/app_widget/app_amount.dart';
import 'package:lotus_farm/app_widget/app_carousel.dart';
import 'package:lotus_farm/app_widget/app_product_tile.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_view_model.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/pages/tranding_page/tranding_page.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
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
              count: model.dashboardData.banner.length,
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
        child: CachedNetworkImage(
          width: double.maxFinite,
          height: 80,
          imageUrl: model.dashboardData.subBanner,
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
    );
  }

  _getCarousel(DashboardViewModel model) {
    return Container(
      child: AppCarousel(
        true,
        bannerList:
            model.dashboardData.banner.map((e) => e.imageUrl).toList(),
        onPageChanged: (int index, reason) {
          model.pageChanged(index);
        },
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
          InkWell(
            onTap: () {
              Utility.pushToNext(TrendingPage(
                list: model.dashboardData.products[1].items
              ), context);
            },
            child: Text("See All",
                style: TextStyle(
                    color: AppColors.grey500,
                    fontSize: 13,
                    fontWeight: FontWeight.normal)),
          ),
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
            crossAxisCount: 2, childAspectRatio: (itemWidth / 290)),
        itemCount: model.dashboardData.products[1].items.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final product = model.dashboardData.products[1].items[index];
          return Hero(
            tag: "dash$index",
            child: Container(
              child: AppProductTile(
                tag: "dash",
                product: product,
                horizontal: Spacing.smallMargin,
                vertical: Spacing.defaultMargin,
                onCartClicked: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => AddToCartWidget(
                            amount: product.newPrice,
                            onAddToCartClicked: (int qty) {
                              Navigator.pop(context);
                              model.addToCart(product, qty,
                                  onError: (String text) {
                                Utility.showSnackBar(context, text);
                              });
                              //myPrint((product.newPrice * qty).toString());
                            },
                          ));
                },
                onTileClicked: () {
                  Utility.pushToNext(
                      ProductDetailsPage(
                        heroTag: "dash$index",
                        productId: product.id,
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
    final repo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<DashboardViewModel>.reactive(
      viewModelBuilder: () => DashboardViewModel(),
      onModelReady: (model) {
        model.init(repo);
      },
      builder: (_, model, child) => (model.loading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (model.hasError)
              ? AppErrorWidget(
                  message: SOMETHING_WRONG_TEXT,
                  onRetryCliked: () {
                    model.fetchDashboardData();
                  })
              : Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      return await model.fetchDashboardData(loading: false);
                    },
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
                ),
    );
  }
}

class AddToCartWidget extends StatefulWidget {
  const AddToCartWidget({
    Key key,
    this.onAddToCartClicked,
    this.amount,
  }) : super(key: key);

  final Function onAddToCartClicked;
  final int amount;

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  int qty = 1;
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
                amount: getAmount(),
              )
            ],
          ),
          Spacer(),
          AppQtyAddRemoveWidget(
            qty: "$qty",
            iconLeftPadding: false,
            iconRightPadding: false,
            textScaleRefactor: 0.9,
            textHorizontalPadding: 4,
            textVerticalPadding: 0,
            iconSize: 16,
            onAddClicked: () {
              setState(() {
                qty++;
              });
            },
            onLessClicked: () {
              if (qty != 1) {
                setState(() {
                  qty--;
                });
              }
            },
          ),
          Spacer(),
          AppButtonWidget(
            width: MediaQuery.of(context).size.width * 0.3,
            text: "Add to Cart",
            textScaleFactor: 0.9,
            onPressed: () {
              widget.onAddToCartClicked(qty);
            },
          )
        ],
      ),
    );
  }

  int getAmount() {
    int amount = (widget.amount * qty);
    return amount;
  }
}
