import 'package:flutter/material.dart';
import 'package:lotus_farm/style/app_colors.dart';

class AppQtyAddRemoveWidget extends StatelessWidget {
  const AppQtyAddRemoveWidget({
    Key key,
    this.iconSize = 18,
    this.textScaleRefactor = 1.1,
    this.iconLeftPadding = true,
    this.iconRightPadding = true,
    this.textHorizontalPadding = 10,
    this.textVerticalPadding =8 ,
    this.qty,
  }) : super(key: key);

  final double iconSize;
  final String qty;
  final double textScaleRefactor, textHorizontalPadding,textVerticalPadding;
  final bool iconLeftPadding, iconRightPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      //  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: AppColors.green),
      child: Row(
        children: [
          Visibility(
            visible: iconLeftPadding,
            child: SizedBox(width: 5)),
          IconButton(
              icon: Icon(Icons.remove),
              color: AppColors.white,
              visualDensity: VisualDensity.compact,
              iconSize: iconSize,
              onPressed: () {}),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: textHorizontalPadding, vertical: textVerticalPadding),
            child: Text(qty,
                textScaleFactor: textScaleRefactor,
                style: TextStyle(
                    color: AppColors.white, fontWeight: FontWeight.bold)),
          ),
          IconButton(
              icon: Icon(Icons.add),
              color: AppColors.white,
              visualDensity: VisualDensity.compact,
              iconSize: iconSize,
              onPressed: () {}),
          Visibility(
             visible: iconLeftPadding,
            child: SizedBox(width: 5)),
        ],
      ),
    );
  }
}
