import 'package:flutter/material.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class AppHelper {
  bool isLoading = false;
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();

  showProgressDialogService(String message) {
    isLoading = true;
    _dialogService.showCustomDialog(
        variant: DialogType.progress, description: message);
  }

  hideProgressDialogService() {
    if (isLoading) {
      _navigationService.back();
      isLoading = false;
    }
  }

  progressDialog(var message, BuildContext context) {
    isLoading = true;
    // _dialogService.showCustomDialog(variant: DialogType.progress,description: message);
    showDialog(
        context: context,
        //barrierDismissible: false,
        builder: (context) {
          return new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: new WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: new Container(
                    color: Colors.white,
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // new SizedBox(height: 10,
                        new CircularProgressIndicator(),
                        //),

                        new Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: new Text(
                            message,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }

  hideProgressDialog(BuildContext context) {
    if (isLoading) {
      //   _navigatorService.back();
      Navigator.pop(context);
      isLoading = false;
    }
  }
}
