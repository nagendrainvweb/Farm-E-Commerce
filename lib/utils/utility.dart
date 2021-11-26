import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/pages/home_page/home_page.dart';
import 'package:stacked_services/stacked_services.dart';

var smallTextStyle = TextStyle(
    fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey.shade700);

var extraSmallTextStyle = TextStyle(
    fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey.shade600);
var disabledTextStyle = TextStyle(
    fontSize: 10, fontWeight: FontWeight.normal, color: Colors.grey.shade500);

var enabledTextStyle =
    TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white);

var normalTextStyle = TextStyle(
    fontSize: 13, fontWeight: FontWeight.normal, color: Colors.grey.shade700);

var bigTextStyle = TextStyle(
    fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey.shade700);

var extraBigTextStyle = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade700);

var toolbarStyle = TextStyle(fontSize: 16);
var addressStyle = TextStyle(
    color: CustomColor.kgreyTextColor, fontSize: 12, letterSpacing: 0.3);

var desciptionTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 11,
    height: 1.5,
    color: Colors.grey.shade600);

class CustomColor {
  static Color kwhiteColor = const Color(0xFFFFFFFF);
  static Color kredColor = Colors.red;
  static Color kgreyColor = Colors.grey.shade600;
  static Color kgreyBorderColor = Colors.grey.shade400;
  static Color kgreyTextColor = Colors.black87;
  static Color kgreenColor = Colors.green;
  static Color blackGrey = Color(0xff3c3c3c);
  static Color pink = Colors.pink;
}

final String NO_INTERNET_CONN = "No internet connection";
final String SOMETHING_WRONG_TEXT =
    "Something went wrong, sorry for inconvenience cause you, Please try after some time.";

myPrint(String text) {
  print(text);
}

class CustomMargins {}

class AssetsName {
  static final NO_IMAGE = "assets/no_image.png";
}

class Utility {
  static getOneThirdWidth(BuildContext context) {
    return MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width * 0.3;
  }

  static printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
  }

  static Future pushToNext(final page, BuildContext context) {
    return Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => page,
          settings: RouteSettings(name: '${page.runtimeType}')),
    );
  }

  static double getScreenWidth(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return size.width;
  }
    static double getScreenHeight(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return size.height;
  }
  // static Future pushToDashboard(int position) async {
  //   final _navigationService = locator<NavigationService>();
  //   return await _navigationService.clearTillFirstAndShowView(HomePage(
  //     position: position,
  //   ));
  // }

  static pushToDashboard(BuildContext context, var position) {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
          builder: (BuildContext context) => HomePage(
                position: position,
              )),
      ModalRoute.withName('/LoginPage'),
    );
  }

  static showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  static Future replaceWith(final page, BuildContext context) {
    return Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
          builder: (context) => page,
          settings: RouteSettings(name: '${page.runtimeType}')),
    );
  }

  static String formattedDeviceDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String pad2(int number) {
    return (number < 10 ? '0' : '') + number.toString();
  }

  static String formattedDeviceMonthDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String formattedServerDate(DateTime dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime parseServerDate(String dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('yyyy-MM-dd').parse(dateTime);
  }

  static DateTime parseDeviceDate(String dateTime) {
    // dateTime = dateTime.add(Duration(hours: 5,minutes: 30));
    return DateFormat('dd/MM/yyyy').parse(dateTime);
  }

  static void showCustomSnackBar(message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
