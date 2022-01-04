import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/pages/cart/cart_widget.dart';
import 'package:lotus_farm/pages/category_page/category_page.dart';
import 'package:lotus_farm/pages/category_page/product_list_page.dart';
import 'package:lotus_farm/pages/category_page/pre_order_page.dart';
import 'package:lotus_farm/pages/dashboard/dashboard_widget.dart';
import 'package:lotus_farm/pages/home_page/home_view_model.dart';
import 'package:lotus_farm/pages/login_page/login_page.dart';
import 'package:lotus_farm/pages/more/more_widget.dart';
import 'package:lotus_farm/pages/notification/notification_page..dart';
import 'package:lotus_farm/pages/offer_page/offer_page.dart';
import 'package:lotus_farm/pages/profile/profile_widget.dart';
import 'package:lotus_farm/pages/search_page/search_page.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
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
  void initState() {
    super.initState();
    _performNotification();
  }

  _performNotification() {
    FirebaseMessaging.instance.getToken().then((value) => Prefs.setFcmToken(value));

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      print("FirebaseMessaging.instance.getInitialMessage() called");
      if (message != null) {
        Utility.pushToNext(NotificationPage(), context);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Utility.pushToNext(NotificationPage(), context);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FirebaseMessaging.onMessage.listen called");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        // flutterLocalNotificationsPlugin.show(
        //     notification.hashCode,
        //     notification.title,
        //     notification.body,
        //     NotificationDetails(
        //       android: AndroidNotificationDetails(
        //         channel.id,
        //         channel.name,
        //         channel.description,
        //         // TODO add a proper drawable resource to android, for now using
        //         //      one that already exists in example app.
        //         icon: 'launch_background',
        //       ),
        //     ));
      }
    });

    if (Platform.isIOS) {
      askNotificationPermission();
    }
  }

  askNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        model.initData(widget.position,context);
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          if (model.currentBottomIndex == 0) {
            return true;
          } else {
            model.onBottomButtonClicked(0);
            return false;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              (model.currentBottomIndex == 1)
                  ? "Everything Chicken"
                  : (model.currentBottomIndex == 2)
                      ? "Pre Order"
                      : "",
              style: TextStyle(color: AppColors.blackGrey),
            ),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: Container(
              // decoration: BoxDecoration(
              //   border: Border.all(color: AppColors.grey500),
              //   shape: BoxShape.circle
              // ),
              child: IconButton(
                  // visualDensity: VisualDensity.standard,
                  icon: Icon(Icons.account_circle_outlined),
                  onPressed: () {
                    Utility.pushToNext(
                        appRepo.login ? ProfileWidget() : LoginPage(), context);
                  }),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.search_outlined),
                  onPressed: () {
                    Utility.pushToNext(SearchPage(), context);
                  }),
              IconButton(
                  icon: Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Utility.pushToNext(
                        (appRepo.login) ? NotificationPage() : LoginPage(),
                        context);
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
                        ImageAsset.logo,
                        height: 30,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.list), label: "List"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.timer), label: "Pre Order"),
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
                              builder: (_, repo, child) => (repo.cartCount > 0)
                                  ? new Container(
                                      margin: EdgeInsets.only(left: 30),
                                      decoration: BoxDecoration(
                                          color: AppColors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.green,
                                              width: 1.2)),
                                      child: new Container(
                                        padding: EdgeInsets.only(
                                            top: 4,
                                            bottom: 4,
                                            left: 4,
                                            right: 4),
                                        child: new Text(
                                          '${repo.cartCount}',
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.white),
                                        ),
                                      ),
                                    )
                                  : SizedBox(height: 0, width: 0),
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
        view = ProductListPage(
          categoryId: "",
          isPreOrder: true,
        );
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
