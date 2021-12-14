import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/AppNeumorphicContainerWidget.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/model/product_details_data.dart';
import 'package:lotus_farm/pages/cart/cart_widget.dart';
import 'package:lotus_farm/pages/product_review/product_review_viewmodel.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:stacked/stacked.dart';

class ProductReviewPage extends StatefulWidget {
  const ProductReviewPage({Key key}) : super(key: key);

  @override
  _ProductReviewPageState createState() => _ProductReviewPageState();
}

class _ProductReviewPageState extends State<ProductReviewPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        //backgroundColor: AppColors.white,
        title: Text(
          "Product Review",
          style: TextStyle(color: AppColors.blackLight),
        ),
      ),
      body: ViewModelBuilder<ProductReviewViewModel>.reactive(
        onModelReady: (model) {
          model..initData(appRepo);
          model.fetchOrderProduct();
        },
        viewModelBuilder: () => ProductReviewViewModel(),
        builder: (_, model, child) => (model.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (model.hasError)
                ? AppErrorWidget(
                    message: SOMETHING_WRONG_TEXT,
                    onRetryCliked: () {
                      model.fetchOrderProduct();
                    })
                : (model.productReviewList.isEmpty)
                    ? _getEmptyView
                    : Container(
                        child: RefreshIndicator(
                          key: _refreshKey,
                          onRefresh: () async {
                            await model.fetchOrderProduct(loading: false);
                          },
                          child: ListView.builder(
                              itemCount: model.productReviewList.length,
                              itemBuilder: (_, index) {
                                Product product =
                                    model.productReviewList[index];
                                return Container(
                                  child: AppNeumorphicContainer(
                                    child: Container(
                                      height: 120,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(12),
                                                    bottomLeft:
                                                        Radius.circular(12)),
                                                child: (product.images.length >
                                                        0)
                                                    ? CachedNetworkImage(
                                                        width: 120,
                                                        height:
                                                            double.maxFinite,
                                                        imageUrl: product
                                                            .images[0].imageUrl,
                                                        placeholder:
                                                            (context, data) {
                                                          return Container(
                                                            child: new Center(
                                                              child: SizedBox(
                                                                height: 20,
                                                                width: 20,
                                                                child:
                                                                    new CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        ImageAsset.noImage,
                                                        width: 120,
                                                        // height:80,
                                                        fit: BoxFit.cover,
                                                      )),
                                          ),
                                          Expanded(
                                              child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: Spacing.defaultMargin,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  product.name,
                                                  textScaleFactor: 1.1,
                                                  maxLines: 2,
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                SmoothStarRating(
                                                    allowHalfRating: false,
                                                    onRated: (v) async {
                                                      myPrint(v.toString());
                                                      await model.updateRating(
                                                          product, v);
                                                      
                                                    },
                                                    starCount: 5,
                                                    rating: product.reviewData
                                                                .my_review ==
                                                            null
                                                        ? 0.0
                                                        : product.reviewData
                                                            .my_review.rating.toDouble(),
                                                    size: 15.0,
                                                    isReadOnly: true,
                                                    filledIconData: Icons.star,
                                                    halfFilledIconData:
                                                        Icons.blur_on,
                                                    color: Colors.green,
                                                    borderColor:
                                                        AppColors.grey400,
                                                    spacing: 0.0),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                InkWell(
                                                  onTap: () async{
                                                    _showRatingDialog(
                                                        context, product,
                                                        onSubmitClicked:
                                                            (int rating,
                                                                String title,
                                                                String review)async {
                                                     await  model.writeReview(
                                                          context,
                                                          product,
                                                          rating,
                                                          title,
                                                          review);
                                                          _refreshKey.currentState
                                                          .show();
                                                      // myPrint(
                                                      //     "$rating $title $review");
                                                    });
                                                    //myPrint(" iam clicked");
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                        //color: AppColors.green
                                                        border: Border.all(
                                                            color:
                                                                AppColors.green,
                                                            width: 0.8),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.edit_outlined,
                                                          size: 12,
                                                          color:
                                                              AppColors.green,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          product.reviewData
                                                                      .my_review ==
                                                                  null
                                                              ? "Write your review"
                                                              : "Edit your review",
                                                          textScaleFactor: 0.7,
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .green),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
      ),
    );
  }

  _showRatingDialog(context, Product product, {Function onSubmitClicked}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) => RatingDialog(
            productId: product.id,
            onSubmitCliked: onSubmitClicked,
            name: product.name,
            myReview: product.reviewData.my_review));
  }

  get _getEmptyView {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              ImageAsset.emptyBag,
              height: 250,
            ),
            SizedBox(
              height: 15,
            ),
            Text('Your cart is empty',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              height: 10,
            ),
            Text(
              "You have no items in your shopping cart.\nLets's go buy something!",
              style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.2),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                Utility.pushToDashboard(context, 0);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColors.blackGrey),
                child: Text(
                  'BROWSE PRODUCT',
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  final productId;
  final onSubmitCliked;
  final Review myReview;
  final String name;
  RatingDialog(
      {@required this.productId,
      @required this.onSubmitCliked,
      @required this.myReview,
      this.name});
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  final titleController = TextEditingController();
  final reviewController = TextEditingController();

  bool isTitleError = false;
  bool isReviewError = false;

  double rating = 1;

  @override
  void initState() {
    super.initState();
    if (widget.myReview != null) {
      setState(() {
        titleController.text = widget.myReview.reviewTitle;
        reviewController.text = widget.myReview.review;
        rating = widget.myReview.rating.toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: new Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        // width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    'Please write your review on ${widget.name} ',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  )),
                  IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {
                      myPrint(v.toString());
                      setState(() {
                        rating = v;
                      });
                    },
                    starCount: 5,
                    rating: rating,
                    size: 35.0,
                    color: AppColors.green,
                    borderColor: AppColors.grey400,
                    spacing: 0.0),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: TextField(
                controller: titleController,
                maxLines: 1,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                decoration: InputDecoration(
                    hintText: "Write Summery",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    errorText: (isTitleError) ? "Please enter summery" : null,
                    border: OutlineInputBorder(
                        gapPadding: 1.0,
                        borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                            style: BorderStyle.solid))),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              child: TextField(
                controller: reviewController,
                maxLines: 4,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                decoration: InputDecoration(
                    hintText: 'Write a Review',
                    errorText: (isReviewError) ? "Please enter review" : null,
                    border: OutlineInputBorder(
                        gapPadding: 1.0,
                        borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                            style: BorderStyle.solid))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: AppColors.green,
                  child:
                      Text('Submit', style: TextStyle(color: AppColors.white)),
                  onPressed: () {
                    setState(() {
                      isTitleError = titleController.text.isEmpty;
                      isReviewError = reviewController.text.isEmpty;
                    });
                    if (!isTitleError && !isReviewError) {
                      Navigator.pop(context);
                      final reviewTitle = titleController.text;
                      final review = reviewController.text;
                      final ratings = rating.toInt();
                      widget.onSubmitCliked(ratings, reviewTitle, review);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
