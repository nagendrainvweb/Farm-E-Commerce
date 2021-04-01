import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/pages/home_page/home_page.dart';
import 'package:lotus_farm/pages/into_page/intro_page.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  setupDialogUi();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: AppColors.green,
        appBarTheme: AppBarTheme(
         elevation: 0,
         backgroundColor: Colors.transparent,
         brightness: Brightness.light ,
         //titleTextStyle: TextStyle(color:AppColors.blackGrey),
         iconTheme: IconThemeData(
           color: AppColors.blackGrey
         )
        )
      ),
      home: IntroPage(),
    );
  }
}

