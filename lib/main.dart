import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/pages/home_page/home_page.dart';
import 'package:lotus_farm/pages/into_page/intro_page.dart';
import 'package:lotus_farm/pages/login_page/login_page.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:stacked_services/stacked_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  setupDialogUi();

  final model = AppRepo();
  await model.init();

  runApp(MyApp(
    repo: model,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppRepo repo;

  const MyApp({Key key, this.repo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppRepo>.value(value: repo),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lotus farm',
        navigatorKey: StackedService.navigatorKey,
        themeMode: ThemeMode.light,
        //  theme: NeumorphicThemeData(
        //   baseColor: Color(0xFFFFFFFF),
        //   lightSource: LightSource.topLeft,
        //   depth: 10,
        //   accentColor: AppColors.green,

        // ),
        // darkTheme: NeumorphicThemeData(
        //   baseColor: Color(0xFF3E3E3E),
        //   lightSource: LightSource.topLeft,
        //   depth: 6,
        // ),
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage()
        },
        theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            accentColor: AppColors.green,
            appBarTheme: AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.transparent,
                brightness: Brightness.light,
                //titleTextStyle: TextStyle(color:AppColors.blackGrey),
                iconTheme: IconThemeData(color: AppColors.blackGrey))),
        home: (repo.introDone) ? HomePage() : IntroPage(),
      ),
    );
  }

  
}
