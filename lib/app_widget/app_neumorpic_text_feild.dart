import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';

class AppNeumorpicTextFeild extends StatelessWidget {
  const AppNeumorpicTextFeild(
      {Key key,
      this.hintText,
      this.suffix,
      this.controller,
      this.textInputType,
      this.filled = true,
      this.obscureText = false,
      this.enableInteractiveSelection = true,
      this.enabled = true,
      this.maxLines = 1,
      this.style,
      this.textAlign = TextAlign.start,
      this.fillColor = AppColors.white,
      this.borderSide = const BorderSide(color: Colors.blue),
      this.borderRadius = 4.0,
      this.textCapitalization = TextCapitalization.none,
      this.focusNode,
      this.onChanged,
      this.validator,
      this.onSubmit,
      this.errorText, this.icon})
      : super(key: key);

  final Widget suffix;
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function(String) validator;
  final obscureText;
  final TextStyle style;
  final TextAlign textAlign;
  final Color fillColor;
  final bool filled;
  final TextCapitalization textCapitalization;
  final BorderSide borderSide;
  final double borderRadius;
  final Function(String) onChanged;
  final FocusNode focusNode;
  final Function(String) onSubmit;
  final int maxLines;
  final bool enabled;
  final bool enableInteractiveSelection;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.symmetric(
          horizontal: Spacing.defaultMargin, vertical: Spacing.mediumMargin),
      style: NeumorphicStyle(
          color: AppColors.tileColor,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12))),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.grey200, width: 1),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(
                right: BorderSide(color: AppColors.white, width: 1),
              )),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15, left: 20, right: 15),
                child: Icon(icon, color: AppColors.grey400),
              ),
            ),
            Expanded(
                child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmit,
              keyboardType: textInputType,
              enabled: enabled,
              enableInteractiveSelection: enableInteractiveSelection,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.only(left: 20.0, top: 15, bottom: 15),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
