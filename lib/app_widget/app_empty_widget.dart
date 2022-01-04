import 'package:flutter/material.dart';
import 'package:lotus_farm/style/app_colors.dart';

class CustomEmptyWidget extends StatelessWidget {
  const CustomEmptyWidget({
    Key key, this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(
              Icons.info_outline_rounded,
              size: 80,
              color: AppColors.grey600,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey700, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
