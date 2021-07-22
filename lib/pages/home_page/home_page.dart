import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/pages/cart/cart_widget.dart';
import 'package:lotus_farm/pages/category_page/category_page.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_widget.dart';
import 'package:lotus_farm/pages/home_page/home_view_model.dart';
import 'package:lotus_farm/pages/more/more_widget.dart';
import 'package:lotus_farm/pages/offer_page/offer_page.dart';
import 'package:lotus_farm/pages/profile/profile_widget.dart';
import 'package:lotus_farm/pages/search_page/search_page.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class HomePage extends StatefulWidget {
  final int position;
  const HomePage({Key key, this.position = 0}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        model.initData(widget.position);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
           title:(model.currentBottomIndex == 1)? Text("Everything Chicken",style: TextStyle(color: AppColors.blackGrey),): Container(),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.notifications_outlined), onPressed: () {}),
          actions: [
            IconButton(
                icon: Icon(Icons.search_outlined),
                onPressed: () {
                  Utility.pushToNext(SearchPage(), context);
                }),
            IconButton(
                icon: SvgPicture.asset(ImageAsset.offer, width: 24, height: 24),
                onPressed: () {
                  Utility.pushToNext(OfferPage(), context);
                }),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: AppColors.grey500,
            selectedItemColor: AppColors.green,
            currentIndex: model.currentBottomIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 20,
            type: BottomNavigationBarType.fixed,
            onTap: model.onBottomButtonClicked,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Container(
                    child: Image.asset(
                      ImageAsset.logo_small_png,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(
                  icon: Container(
                    child: Stack(
                      children: <Widget>[
                        Center(
                            child: Icon(
                          Icons.shopping_cart,
                          size: 20,
                        )),
                        Align(
                            alignment: Alignment.topCenter,
                          child: Consumer<AppRepo>(
                            builder: (_,repo,child)=>
                            (repo.cartCount > 0 )?
                              new Container(
                                margin: EdgeInsets.only(left: 30),
                                decoration: BoxDecoration(
                                    color: AppColors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.green,width: 1.2)
                                    ),
                                child: new Container(
                                  padding: EdgeInsets.only(
                                      top: 4, bottom: 4, left: 4, right: 4),
                                  child: new Text(
                                    '${repo.cartCount}',
                                    style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.white),
                                  ),
                                ),
                              ): SizedBox(height: 0,width:0),
                            ),
                        )
                        // : SizedBox()
                      ],
                    ),
                  ),
                  label: "Cart"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.more_vert), label: "More"),
            ]),
        body: _getWidget(model),
      ),
    );
  }

  _getWidget(HomeViewModel model) {
    Widget view;
    switch (model.currentBottomIndex) {
      case 0:
        view = DashboardWidget();
        break;
      case 1:
        view = CategoryPage();
        break;
      case 2:
        view = ProfileWidget();
        break;
      case 3:
        view = CartWidget();
        break;
      case 4:
        view = MoreWidget();
        break;
      default:
        view = Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
          child: Center(
            child: AppErrorWidget(
                message: "Error",
                onRetryCliked: () {
                  model.retryClicked();
                }),
          ),
        );
    }
    return view;
  }
}
