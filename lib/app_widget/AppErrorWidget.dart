import 'package:flutter/material.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/utils/text_style.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget(
      {Key key, @required this.message, @required this.onRetryCliked})
      : super(key: key);

  final message;
  final onRetryCliked;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.info_outline,
              color: Colors.grey.shade700,
              size: 70,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Sorry, Something went wrong",
              textAlign: TextAlign.center,
              style: extraBigTextStyle,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Try reloading the page. We're working hard to fix problem for you as soon as possible",
              textAlign: TextAlign.center,
              style: smallTextStyle,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                onRetryCliked();
                //Utility.pushToDashboard(context, 0);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: AppColors.blackGrey),
                child: Text(
                  'RETRY',
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