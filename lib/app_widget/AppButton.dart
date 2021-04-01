import 'package:flutter/material.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget({
    Key key,
    this.onPressed,
    this.width,
    this.borderRadius = 6.0,
    this.text,
    this.color = AppColors.green,
    this.verticalPadding = Spacing.defaultMargin, this.textScaleFactor= 1.0,
  }) : super(key: key);
  final Function onPressed;
  final double width;
  final double borderRadius;
  final String text;
  final Color color;
  final double textScaleFactor;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: width,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      textColor: AppColors.white,
      color: color,
      child: Text(
        text,
        textScaleFactor: textScaleFactor,
      ),
    );
  }
}
