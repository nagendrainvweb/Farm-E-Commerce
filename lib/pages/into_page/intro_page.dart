import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lotus_farm/pages/home_page/home_page.dart';
import 'package:lotus_farm/pages/into_page/intro_view_model.dart';
import 'package:lotus_farm/pages/login_page/login_page.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stacked/stacked.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  CarouselController buttonCarouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IntroViewModel>.reactive(
      viewModelBuilder: () => IntroViewModel(),
      builder: (_, model, child) => Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: CarouselSlider.builder(
                      itemCount: 2,
                      carouselController: buttonCarouselController,
                      itemBuilder: (_, index, value) => Container(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ImageAsset.delivery_chicken,
                              height: 250,
                            ),
                            SizedBox(height: 40),
                            RichText(
                                textScaleFactor: 1.5,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: "Get Fresh",
                                    style:
                                        TextStyle(color: AppColors.blackLight),
                                    children: [
                                      TextSpan(
                                        text: " Chicken ",
                                        style: TextStyle(
                                            color: AppColors.green,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: " From\nfarm. Not Freezer ",
                                        style: TextStyle(
                                            color: AppColors.blackLight),
                                      )
                                    ])),
                          ],
                        ),
                      ),
                      options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 15),
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                          viewportFraction: 1.0,
                          aspectRatio: 0.7,
                          initialPage: 0,
                          autoPlayCurve: Curves.linear,
                          onPageChanged: (index, reason) =>
                              model.onPageChanged(index)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSmoothIndicator(
                                activeIndex: model.currentPage,
                                count: 2,
                                effect: WormEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    activeDotColor: AppColors.green,
                                    dotColor: AppColors.grey500,
                                    spacing: 6.0),
                              )
                            ]
                            // List.generate(
                            //     2,
                            //     (index) => Row(
                            //           children: [
                            //             Container(
                            //               width: (model.currentPage == index)
                            //                   ? 20
                            //                   : 8,
                            //               height: 4,
                            //               decoration: BoxDecoration(
                            //                 color: (model.currentPage == index)
                            //                     ? AppColors.green
                            //                     : AppColors.grey400,
                            //                 shape: (model.currentPage == index)
                            //                     ? BoxShape.rectangle
                            //                     : BoxShape.circle,
                            //               ),
                            //             ),
                            //             SizedBox(
                            //               width: 5,
                            //             )
                            //           ],
                            //         )).toList(),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                //  visible: (model.currentPage == 1),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                      onPressed: () async {
                        if (model.currentPage == 1) {
                          await Prefs.setIntroDone(true);
                          Utility.pushToNext(HomePage(), context);
                        } else {
                          buttonCarouselController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear);
                        }
                      },
                      label: Text((model.currentPage == 0)?"NEXT":"DONE")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
