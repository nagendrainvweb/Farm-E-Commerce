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
    this.onCartClicked,
    this.onPreOrderClicked,
    @required this.product, this.showAddToCart=true,
  }) : super(key: key);
  final onTileClicked;
  final double horizontal;
  final double vertical;
  final String tag;
  final Function onCartClicked, onPreOrderClicked;
  final Product product;
  final bool showAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GestureDetector(
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
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
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
                        child: (product.images.length > 0)
                            ? CachedNetworkImage(
                                width: double.maxFinite,
                                height: 140,
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
                            : Image.asset(
                                ImageAsset.noImage,
                                height: 140,
                                width: double.maxFinite,
                                fit: BoxFit.cover,
                              )),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.mediumMargin,
                          vertical: 5
                          ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 52,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(product.name,
                                    maxLines: 3,
                                    //  overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.blackText)),
                                SizedBox(
                                  height: 4,
                                ),
                                // Text(product.category,
                                //     style: TextStyle(
                                //         fontSize: 11, color: AppColors.grey500)),
                              ],
                            ),
                          ),
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
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
                                              text: "${product.newPrice}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.blackLight,
                                                  fontWeight: FontWeight.bold))
                                        ])),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    (product.newPrice != product.oldPrice)
                                        ? RichText(
                                            text: TextSpan(
                                                text: AppStrings.rupee,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.grey500,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                children: [
                                                TextSpan(
                                                    text:
                                                        "${product.oldPrice.toString()}",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.grey500,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ]))
                                        : Container()
                                  ],
                                ),
                              ),
                            (showAddToCart)?  Container(
                                child:
                              (product.isInStock)
                                  ? IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: onCartClicked,
                                      icon: Icon(Icons.shopping_cart_sharp,
                                          color: AppColors.grey400, size: 20),
                                    )
                                  : Container()
                                  // OutlineButton(
                                  //     onPressed: onPreOrderClicked,
                                  //     child: Text(
                                  //       "Pre Order",
                                  //       textScaleFactor: 0.8,
                                  //     ),
                                  //     materialTapTargetSize:
                                  //         MaterialTapTargetSize.shrinkWrap,
                                  //     // borderSide: BorderSide(color: Colors.red),
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(30),
                                  //     ),
                                  //     textColor: Colors.red,
                                  //     padding: const EdgeInsets.symmetric(
                                  //         horizontal: 0, vertical: 2),
                                  //   )
                                    
                                    ):Container()
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
          (product.discount != 0)
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: horizontal,
                      vertical: vertical,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      color: AppColors.green.withOpacity(0.4),
                    ),
                    padding: const EdgeInsets.all(7),
                    child: Text(
                      "${product.discount}% off",
                      style: TextStyle(fontSize: 11,color: AppColors.blackGrey),
                    ),
                  ),
                )
              : Container(),
         
               Align(
                  alignment: Alignment.topRight,
                  child: Visibility(
                    visible: !product.isInStock,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: horizontal,
                        vertical: vertical,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12)),
                        color: AppColors.redAccent.withOpacity(0.4),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "out of stock",
                        style:
                            TextStyle(fontSize: 10, color: AppColors.blackLight),
                      ),
                    ),
                  ),
                )
              
        ],
      ),
    );
  }
}
