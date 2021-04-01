import 'package:flutter/material.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/font.dart';

class AppTextFeildOutlineWidget extends StatelessWidget {
  final Widget suffix;
  final String hintText;
  final String errorText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function(String) validator;
  final Key key;
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

  AppTextFeildOutlineWidget(
      {this.hintText,
      this.suffix,
      this.key,
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
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: TextFormField(
        style: style ??
            TextStyle(
                color: AppColors.blackLight.withOpacity(.8),
                fontSize: FontSize.title),
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: textInputType,
        textAlign: textAlign,
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        cursorWidth: 1.40,
        cursorHeight: 20.0,
        enableInteractiveSelection:
            enableInteractiveSelection, // will disable paste operation
        enabled: enabled,
        onChanged: (e) {
          onChanged(e);
        },
        onFieldSubmitted: (e) => onSubmit(e),
        decoration: InputDecoration(
            fillColor: fillColor,
            filled: filled,
            // hintText: hintText,
            labelText: hintText,
            suffixIcon: suffix,
            errorText: errorText,
            hintStyle: TextStyle(
              color: AppColors.grey400,
              fontSize: FontSize.subtitle,
            ),
            contentPadding:
                const EdgeInsets.only(left: 10.0, top: 18, bottom: 18),
            focusedBorder: OutlineInputBorder(
              borderSide: borderSide,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(borderRadius)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(borderRadius)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: AppColors.grey200))),
      ),
    );
  }
}
