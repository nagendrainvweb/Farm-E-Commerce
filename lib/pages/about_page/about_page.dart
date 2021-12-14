import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lotus_farm/style/app_colors.dart';

class AboutPage extends StatefulWidget {
  final String url;
  const AboutPage({Key key, this.url}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  InAppWebViewController _webViewController;
  bool _loadingPayment = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: AppColors.white,
          title: Text(
            "About us",
            style: TextStyle(color: AppColors.blackGrey),
          ),
        ),
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: true,
                          mediaPlaybackRequiresUserGesture: false,
                          javaScriptEnabled: true,
                          javaScriptCanOpenWindowsAutomatically: true,
                        ),
                        android: AndroidInAppWebViewOptions(
                          useWideViewPort: false,
                          useHybridComposition: true,
                          loadWithOverviewMode: true,
                          domStorageEnabled: true,
                        ),
                        ios: IOSInAppWebViewOptions(
                            allowsInlineMediaPlayback: true,
                            enableViewportScale: true,
                            ignoresViewportScaleLimits: true)),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onLoadStart:
                        (InAppWebViewController controller, Uri page) async {
                      if (!page.toString().contains("/about-us")) {
                        Navigator.pop(context);
                      }
                    },
                    onLoadStop:
                        (InAppWebViewController controller, Uri page) async {
                      print(page);
                      if (_loadingPayment) {
                        this.setState(() {
                          _loadingPayment = false;
                        });
                      }
                    },
                  )),
              (_loadingPayment)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(),
            ],
          ),
        ));
  }
}
