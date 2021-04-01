import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';

class AppProductTile extends StatelessWidget {
  const AppProductTile({
    Key key,
    this.onTileClicked,
    this.horizontal = Spacing.defaultMargin,
    this.vertical = Spacing.defaultMargin,
    @required this.tag, this.onCartClicked,
  }) : super(key: key);
  final onTileClicked;
  final double horizontal;
  final double vertical;
  final String tag;
  final Function onCartClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          onTileClicked();
          // Utility.pushToNext(
          //     ProductDetails(
          //       productId:
          //           _productList[index]
          //               .id,
          //     ),
          //     context);
        },
        child: Container(
            child: Neumorphic(
          margin: EdgeInsets.symmetric(
            horizontal: horizontal,
            vertical: vertical,
          ),
          drawSurfaceAboveChild: true,
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          ),
          child: Container(
            color: AppColors.tileColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    child: Image.network(
                      "https://b.zmtcdn.com/data/pictures/chains/8/48188/731e244b54f8e8b4df18379ee6e142d2.jpg",
                      height: 130,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    )),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.mediumMargin,
                      vertical: Spacing.smallMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Chicken Currey Cut",
                          style: TextStyle(
                              fontSize: 14, color: AppColors.blackText)),
                      SizedBox(
                        height: 3,
                      ),
                      Text("Boonless",
                          style: TextStyle(
                              fontSize: 12, color: AppColors.grey500)),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: AppStrings.rupee,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.blackLight,
                                      fontWeight: FontWeight.normal),
                                  children: [
                                TextSpan(
                                    text: "500",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.blackLight,
                                        fontWeight: FontWeight.bold))
                              ])),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: onCartClicked,
                            icon: Icon(Icons.shopping_cart_sharp,
                                color: AppColors.grey400, size: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}
