import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lotus_farm/services/api_service.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked_services/stacked_services.dart';

final locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => ApiService());
}

setupDialogUi() {
  final dialogService = locator<DialogService>();
  final builders = {
    DialogType.error : (context, sheetRequest, completer) => _ErrorDialog(request: sheetRequest, completer: completer),
    DialogType.progress : (context, sheetRequest, completer) => _ProgressDialog(request: sheetRequest, completer: completer)
  };
  dialogService.registerCustomDialogBuilders(builders);
}

class _ProgressDialog extends StatelessWidget {
  const _ProgressDialog({
    Key key, this.request, this.completer,
  }) : super(key: key);

    final DialogRequest request;
  final Function(DialogResponse) completer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                    request.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                )
              ],
            ),
          )
          //)
          ),
    );
  }
}

class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog({
    Key key,
    this.request, this.completer,
  }) : super(key: key);
  final DialogRequest request;
  final Function(DialogResponse) completer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
             padding: const EdgeInsets.only(top: 20, bottom: 8, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (request.title.isNotEmpty)
                    ? Column(
                        children: [
                          Text(
                            request.title,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      )
                    : Container(),
                Text(
                  request.description,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      color: CustomColor.kgreyTextColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
              onPressed: () => completer(DialogResponse(confirmed: true)),
                child: Text('OK'),
                textColor: Colors.blue
              )
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }
}

enum DialogType { base, form, progress, error }