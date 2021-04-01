import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';

class AppNeumorphicContainer extends StatelessWidget {
  final child;
  final double radius;
  final color;
  final double horizontalPadding, verticalPadding;

  const AppNeumorphicContainer(
      {Key key, this.child, this.radius = 12, this.color = AppColors.tileColor, this.horizontalPadding=Spacing.mediumMargin, this.verticalPadding=Spacing.smallMargin})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin:  EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      style: NeumorphicStyle(
          color: color,
          intensity: 0.6,
          surfaceIntensity: 0.50,
          boxShape:
              NeumorphicBoxShape.roundRect(BorderRadius.circular(radius))),
      child: child,
    );
  }
}
