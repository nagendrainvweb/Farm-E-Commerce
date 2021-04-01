import 'package:flutter/material.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';

class AppAmountWidget extends StatelessWidget {
  const AppAmountWidget({
    Key key,
    this.amount= 500,
    this.amountColor = AppColors.blackLight,
    this.rupeeColor = AppColors.blackLight,
  }) : super(key: key);
  final amount;
  final amountColor, rupeeColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: AppStrings.rupee,
            style: TextStyle(
                fontSize: 14,
                color: rupeeColor,
                fontWeight: FontWeight.normal),
            children: [
          TextSpan(
              text: amount,
              style: TextStyle(
                  fontSize: 18,
                  color: amountColor,
                  fontWeight: FontWeight.bold))
        ]));
  }
}
