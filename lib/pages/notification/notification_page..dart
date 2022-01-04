import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/app_widget/app_empty_widget.dart';
import 'package:lotus_farm/pages/notification/notification_view_model.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/custom_error_widget.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List colors = [
    Colors.red,
    Colors.deepPurple,
    Colors.blue,
    Colors.teal,
    Colors.orange
  ];
  Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      onModelReady: (model) {
        model.fetchNotifications();
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Text(
            "Notification",
            style: TextStyle(color: AppColors.blackGrey),
          ),
        ),
        body: (model.loading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (model.hasError)
                ? AppErrorWidget(
                    message: SOMETHING_WRONG_TEXT,
                    onRetryCliked: () {
                      model.fetchNotifications();
                    })
                :(model.notificationList.isEmpty)?
                CustomEmptyWidget(text: "You do not have notifications right now,\nPlease continue order with Dr Meat.", )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.mediumMargin,
                        vertical: Spacing.defaultMargin),
                    child: ListView.separated(
                      itemCount: model.notificationList.length,
                      separatorBuilder: (_, index) => Container(height: 15),
                      itemBuilder: (_, index) => Dismissible(
                        key: UniqueKey(),
                        background: slideLeftBackground(),
                        confirmDismiss: (direction) async {
                        final value =  await model.deleteNotification(
                              model.notificationList[index].id);
                          return value;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: AppColors.grey300),
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircleAvatar(
                                backgroundColor:
                                    colors[random.nextInt(colors.length)],
                                child: Icon(
                                  Icons.notifications,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            title: Text("${model.notificationList[index].title}"),
                            subtitle: Text("${model.notificationList[index].content}",
                            maxLines: 3,
                            style: TextStyle(fontSize:11),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(8)),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
