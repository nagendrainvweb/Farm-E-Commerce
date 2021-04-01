import 'package:flutter/material.dart';
import 'package:lotus_farm/app_widget/app_product_tile.dart';
import 'package:lotus_farm/pages/category_page/category_view_model.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_view_model.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_widget.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
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
    return ViewModelBuilder<CategoryViewModel>.reactive(
      viewModelBuilder: () => CategoryViewModel(),
      builder: (_, model, child) => Container(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.smallMargin, vertical: Spacing.smallMargin),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                childAspectRatio: (itemWidth/itemHeight)
                ),
            itemCount: 10,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Hero(
                tag: "cat$index",
                child: Container(
                  child: AppProductTile(
                    tag: "cat",
                    horizontal: Spacing.smallMargin,
                    vertical: Spacing.defaultMargin,
                    onCartClicked: (){
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
        ),
      ),
    );
  }
}
