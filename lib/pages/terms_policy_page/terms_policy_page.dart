import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsPolicyPage extends StatefulWidget {
  const TermsPolicyPage({Key key, this.title, this.data}) : super(key: key);
  final String title;
  final String data;

  @override
  _TermsPolicyPageState createState() => _TermsPolicyPageState();
}

class _TermsPolicyPageState extends State<TermsPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          widget.title,
          style: TextStyle(color: AppColors.blackGrey),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Html(
            data: widget.data,
            onLinkTap: (String value) {
              myPrint("link value is $value");
              canLaunch(value);
            },
          ),
        ),
      ),
    );
  }
}
