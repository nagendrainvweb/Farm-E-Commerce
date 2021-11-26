import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppNeumorphicContainerWidget.dart';
import 'package:lotus_farm/model/dashboard_data.dart';
import 'package:lotus_farm/pages/category_page/pre_order_page.dart';
import 'package:lotus_farm/pages/category_page/product_list_page.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    final appRepo = Provider.of<AppRepo>(context, listen: false);
    return Container(
      child: ListView.builder(
          // gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2, childAspectRatio: (itemWidth / 330)),
          itemCount: appRepo.dashboardData.categories.length,
          itemBuilder: (_, index) {
            final Categories data = appRepo.dashboardData.categories[index];
            return InkWell(
              onTap: () {
                Utility.pushToNext(PreOrderPage(categoryId: data.id, isPreOrder: false,title: data.title,), context);
              },
              child: Container(
                height: Utility.getScreenHeight(context) * 0.25,
                child: AppNeumorphicContainer(
                  child: CachedNetworkImage(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    imageUrl: data.imageUrl,
                    errorWidget: (_, value, data) {
                      return Image.asset(
                        ImageAsset.noImage,
                        height: double.maxFinite,
                        width: double.maxFinite,
                        fit: BoxFit.contain,
                      );
                    },
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
              ),
            );
          }),
    );
  }
}
