import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/app_product_tile.dart';
import 'package:lotus_farm/pages/category_page/product_list_view_model.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_view_model.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_widget.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class ProductListPage extends StatefulWidget {
  final String categoryId;
  final bool isPreOrder;

  const ProductListPage(
      {Key key, @required this.categoryId, @required this.isPreOrder})
      : super(key: key);
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.0;
    final double itemWidth = size.width / 2;
    final appRepo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<ProductListViewModel>.reactive(
      viewModelBuilder: () => ProductListViewModel(),
      onModelReady: (model) {
        model.initData(appRepo, widget.isPreOrder, widget.categoryId);
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
                      model.fetchProductList(widget.categoryId, loading: true);
                    })
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.smallMargin,
                        vertical: Spacing.smallMargin),
                   
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            if (model.hasNext && !model.loadMore) {
                              model.fetchProductList(widget.categoryId,loading: false);
                            }
                            // _loadMore();
                            //print(' i am at bottom');
                          }
                          return true;
                        },
                         child: RefreshIndicator(
                      onRefresh: () async {
                        if (widget.isPreOrder) {
                          return await model.fetchPreOrder(loading: false);
                        } else {
                          model.productList.clear();
                          return await model.fetchProductList(widget.categoryId,
                              loading: true);
                        }
                      },
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: (itemWidth / 300)),
                          itemCount: model.productList.length,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final product = model.productList[index];
                            return 
                                Container(
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
                                                cartQty: product.qty,
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
                                            productId: (product.isInStock)
                                                ? product.id
                                                : product.preOrderId,
                                          ),
                                          context);
                                    },
                                  ),
                            
                              
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
