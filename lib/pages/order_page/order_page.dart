import 'package:flutter/material.dart';
import 'package:lotus_farm/pages/order_page/order_view_model.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
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
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(),
        body: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Spacing.defaultMargin, vertical: Spacing.smallMargin),
          child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (_, index) => Container(
                    height: 12,
                  ),
              itemBuilder: (_, index) => Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.grey300),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.defaultMargin,
                                  vertical: Spacing.defaultMargin),
                          child: Row(
                            children: [
                                 Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Order Id #23541545",
                                      style: TextStyle(
                                          color: AppColors.grey600, fontSize: 13,fontWeight: FontWeight.bold ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "31 March 2021",
                                      style: TextStyle(
                                          color: AppColors.grey500, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Delivered",
                                      style: TextStyle(
                                          color: AppColors.green, fontSize: 11),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "31 March 2021",
                                      style: TextStyle(
                                          color: AppColors.grey500, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                                 Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "View Details >",
                                      style: TextStyle(
                                          color: AppColors.grey500, fontSize: 11),
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
    );
  }
}
