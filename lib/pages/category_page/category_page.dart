import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/app_product_tile.dart';
import 'package:lotus_farm/pages/category_page/category_view_model.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_view_model.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_widget.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.0;
    final double itemWidth = size.width / 2;
    final appRepo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<CategoryViewModel>.reactive(
      viewModelBuilder: () => CategoryViewModel(),
      onModelReady: (model) {
        model.initData(appRepo);
      },
      builder: (_, model, child) => Container(
        child: (model.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (model.hasError)
                ? AppErrorWidget(
                    message: SOMETHING_WRONG_TEXT,
                    onRetryCliked: () {
                      model.fetchAllProducts();
                    })
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.smallMargin,
                        vertical: Spacing.smallMargin),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        return await model.fetchAllProducts(loading: false);
                      },
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            new SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: (itemWidth / 290)),
                        itemCount: model.productList.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final product = model.productList[index];
                          return Hero(
                            tag: "cat$index",
                            child: Container(
                              child: AppProductTile(
                                tag: "cat",
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
                                                Utility.showSnackBar(
                                                    context, text);
                                              });
                                              //myPrint((product.newPrice * qty).toString());
                                            },
                                          ));
                                },
                                onTileClicked: () {
                                  Utility.pushToNext(
                                      ProductDetailsPage(
                                        heroTag: "cat$index",
                                        productId:product.id ,
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
      ),
    );
  }
}
