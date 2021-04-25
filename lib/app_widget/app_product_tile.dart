import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';

class AppProductTile extends StatelessWidget {
  const AppProductTile({
    Key key,
    this.onTileClicked,
    this.horizontal = Spacing.defaultMargin,
    this.vertical = Spacing.defaultMargin,
    @required this.tag,
    this.onCartClicked,@required this.product,
  }) : super(key: key);
  final onTileClicked;
  final double horizontal;
  final double vertical;
  final String tag;
  final Function onCartClicked;
  final Product product;

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
                    child:
                    (product.images.length>0)? 
                    CachedNetworkImage(
                        width: double.maxFinite,
                         height: 130,
                        imageUrl: product.images[0].imageUrl,
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
                      )
                    :
                    Image.asset(
                     ImageAsset.noImage,
                      height: 130,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    )
                    ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.mediumMargin,
                      vertical: Spacing.smallMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                          style: TextStyle(

                              fontSize: 14, color: AppColors.blackText)),
                      SizedBox(
                        height: 3,
                      ),
                      Text(product.category,
                          style: TextStyle(
                              fontSize: 11, color: AppColors.grey500)),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RichText(
                                text: TextSpan(
                                    text: AppStrings.rupee,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.blackLight,
                                        fontWeight: FontWeight.normal),
                                    children: [
                                  TextSpan(
                                      text: "${product.newPrice}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.blackLight,
                                          fontWeight: FontWeight.bold))
                                ])),
                          ),
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
