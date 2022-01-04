import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/app_empty_widget.dart';
import 'package:lotus_farm/model/offerResponse.dart';
import 'package:lotus_farm/pages/offer_page/offer_view_model.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/utils/empty_widget.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class OfferPage extends StatefulWidget {
  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OfferViewModel>.reactive(
      viewModelBuilder: () => OfferViewModel(),
      onModelReady: (model) {
        model.fetchOffers();
      },
      builder: (_, model, child) => Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: Text(
              "Offers",
              style: TextStyle(color: AppColors.blackGrey),
            ),
          ),
          body: (model.loading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (model.hasError)
                  ? AppErrorWidget(
                      message: SOMETHING_WRONG_TEXT,
                      onRetryCliked: () {
                        model.fetchOffers();
                      })
                  :(model.offerImageList.isEmpty)?
                    CustomEmptyWidget(
                      text:"We do not have any offers right now,\nWe will come with exciting offer for you."
                    )
                  : Container(
                      child: ListView.builder(
                        itemCount: model.offerImageList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: _getOfferImage(
                                      model.offerImageList[index]),
                                  // _getCouponRow(_offerList[index]),
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.grey[200],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )),
    );
  }

  _getOfferImage(OffersImg offersImg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CachedNetworkImage(
        imageUrl: offersImg.bannerUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
