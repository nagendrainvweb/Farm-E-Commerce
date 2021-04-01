import 'package:flutter/material.dart';
import 'package:lotus_farm/pages/more/more_view_model.dart';
import 'package:stacked/stacked.dart';

class MoreWidget extends StatefulWidget {
  @override
  _MoreWidgetState createState() => _MoreWidgetState();
}

class _MoreWidgetState extends State<MoreWidget> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MoreViewModel>.reactive(
      viewModelBuilder: () => MoreViewModel(),
      builder: (_, model, child) => Container(
        child: Center(
          child: Text("More"),
        ),
      ),
    );
  }
}