import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemCount: 10,
          itemBuilder: (_, index) => Container(
                child: ListTile(
                  title: Text("index is $index"),
                ),
              )),
    );
  }
}