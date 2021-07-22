import 'package:flutter/material.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/pages/order_page/order_view_model.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/empty_widget.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderViewModel>.reactive(
      viewModelBuilder: () => OrderViewModel(),
      onModelReady: (model) {
        model.fetchOrderList();
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("My Orders",style: TextStyle(color:AppColors.blackGrey), ),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Spacing.defaultMargin, vertical: Spacing.smallMargin),
          child: (model.loading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (model.hasError)
                  ? AppErrorWidget(
                      message: SOMETHING_WRONG_TEXT,
                      onRetryCliked: () {
                        model.fetchOrderList();
                      })
                  : (model.orderList.isEmpty)
                  ? EmptyWidget(
                     )
                  : Container(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          return await model.fetchOrderList(loading: false);
                        },
                        child: ListView.separated(
                            itemCount: model.orderList.length,
                            separatorBuilder: (_, index) => Container(
                                  height: 12,
                                ),
                            itemBuilder: (_, index) => Container(
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColors.grey300),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Spacing.defaultMargin,
                                            vertical: Spacing.defaultMargin),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Order Id #${model.orderList[index].orderId}",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.grey600,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "${model.orderList[index].orderDate}",
                                                    //"31 March 2021",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.grey500,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${model.orderList[index].status}",
                                                    style: TextStyle(
                                                        color: AppColors.green,
                                                        fontSize: 11),
                                                  ),
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "${model.orderList[index].statusDate}",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.grey500,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "View Details >",
                                                    style: TextStyle(
                                                        color:
                                                            AppColors.grey500,
                                                        fontSize: 11),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                      ),
                    ),
        ),
      ),
    );
  }
}
