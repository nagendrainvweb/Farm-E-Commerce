import 'package:flutter/material.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/font.dart';

class AppExpansionTileWidget extends StatelessWidget {
  final String title;
  final double fontSize;
  final backgroundColor;
  final bool initiallyExpanded;
  final List<Widget> children;

   AppExpansionTileWidget(
      {Key key,
      this.title,
      this.fontSize = FontSize.normal,
      this.backgroundColor = AppColors.blue,
      this.initiallyExpanded, this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          // border: Border.on(color: AppColors.grey400, width: 1.0),
          borderRadius: BorderRadius.circular(6.0)),
     // margin: const EdgeInsets.all(Spacing.smallMargin),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        title: Text(title,
            style:
                TextStyle(fontSize: fontSize, color: AppColors.white)),
        children: children,
      ),
    );
  }
}
