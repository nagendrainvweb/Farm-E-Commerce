import 'package:flutter/material.dart';

class AppAppBar extends StatelessWidget {
  final title;

  const AppAppBar({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: title,
    );
  }
}
