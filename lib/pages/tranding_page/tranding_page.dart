import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/app_product_tile.dart';
import 'package:lotus_farm/model/dashboard_data.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/pages/category_page/category_view_model.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_view_model.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_widget.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class TrendingPage extends StatefulWidget {
  final List<Product> list;

  const TrendingPage({Key key, this.list}) : super(key: key);
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context);
    return ViewModelBuilder<CategoryViewModel>.reactive(
        viewModelBuilder: () => CategoryViewModel(),
        onModelReady: (model) {
          model.initTrending(appRepo, widget.list);
        },
        builder: (_, model, child) => Scaffold(
            appBar: AppBar(
              title: Text("Trending",
                  style: TextStyle(color: AppColors.blackGrey)),
            ),
            body: Container(
              child: _getList(model),
            )));
  }

  _getList(CategoryViewModel model) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.smallMargin, vertical: Spacing.smallMargin),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: (itemWidth / 300)),
        itemCount: model.productList.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final product = model.productList[index];
          return Hero(
            tag: "trend$index",
            child: Container(
              child: AppProductTile(
                tag: "trend$index",
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
                  if (product.isInStock) {
                    Utility.pushToNext(
                        ProductDetailsPage(
                          heroTag: "trend$index",
                          productId: product.id,
                        ),
                        context);
                  }else{
                     Utility.pushToNext(
                        ProductDetailsPage(
                          heroTag: "trend$index",
                          productId: product.preOrderId,
                        ),
                        context);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
