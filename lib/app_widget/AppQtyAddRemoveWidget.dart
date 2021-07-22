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
    this.textVerticalPadding = 8,
    this.qty, this.onAddClicked, this.onLessClicked,
  }) : super(key: key);

  final double iconSize;
  final String qty;
  final double textScaleRefactor, textHorizontalPadding, textVerticalPadding;
  final bool iconLeftPadding, iconRightPadding;
  final Function onAddClicked,onLessClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      //  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey500),
          borderRadius: BorderRadius.circular(6), color: AppColors.white),
      child: Row(
        children: [
          Visibility(visible: iconLeftPadding, child: SizedBox(width: 5)),
          IconButton(
              icon: Icon(Icons.remove),
              color: AppColors.blackGrey,
              visualDensity: VisualDensity.compact,
              iconSize: iconSize,
              onPressed: onLessClicked),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: textHorizontalPadding,
                vertical: textVerticalPadding),
            child: Text(qty,
                textScaleFactor: textScaleRefactor,
                style: TextStyle(
                    color: AppColors.blackGrey, fontWeight: FontWeight.bold)),
          ),
          IconButton(
              icon: Icon(Icons.add),
              color: AppColors.blackGrey,
              visualDensity: VisualDensity.compact,
              iconSize: iconSize,
              onPressed: onAddClicked),
          Visibility(visible: iconLeftPadding, child: SizedBox(width: 5)),
        ],
      ),
    );
  }
}
