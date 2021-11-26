import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lotus_farm/app_widget/AppErrorWidget.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/model/order_details_data.dart';
import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/pages/address_page/address_page.dart';
import 'package:lotus_farm/pages/cart/cart_widget.dart';
import 'package:lotus_farm/pages/order_details/order_details_view_model.dart';
import 'package:lotus_farm/pages/order_page/order_view_model.dart';
import 'package:lotus_farm/resources/strings/app_strings.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/empty_widget.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class OrderDetailsPage extends StatefulWidget {
  final orderId;

  const OrderDetailsPage({Key key, this.orderId}) : super(key: key);
  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderDetailsViewModel>.reactive(
      viewModelBuilder: () => OrderDetailsViewModel(),
      onModelReady: (model) {
        model.fetchOrderDetails(widget.orderId);
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Order Id #${widget.orderId}",
            style: TextStyle(color: AppColors.blackGrey),
          ),
        ),
        body: Container(
        
          child: (model.loading)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (model.hasError)
                  ? AppErrorWidget(
                      message: SOMETHING_WRONG_TEXT,
                      onRetryCliked: () {
                        model.fetchOrderDetails(widget.orderId);
                      })
                  : SingleChildScrollView(
                      child: Container(
                        child: new Column(
                          children: <Widget>[
                            SizedBox(
                              height: 3,
                            ),
                            TrackView(
                              status: model.orderData.status,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            _getOrderDetails(model),
                            SizedBox(
                              height: 5,
                            ),
                            _getPaymentDetails(model),
                            SizedBox(
                              height: 5,
                            ),
                            _getShippingDetails('BILLING ADDRESS',
                                model.orderData.billingAddress),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

    _getShippingDetails(var title,AddressData addressData) {
    var addressStyle = TextStyle(
        color: Colors.grey.shade700, fontSize: 12, letterSpacing: 0.3);
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: title,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          AddressTile(
            addressData: addressData,
            tileColor: AppColors.white,
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       Row(
          //         children: <Widget>[
          //           Text(
          //             '${addressData.firstName} ${addressData.lastName}',
          //             style: TextStyle(
          //                 color: AppColors.green,
          //                 fontSize: 13,
          //                 fontWeight: FontWeight.w700),
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         height: 15,
          //       ),
          //       Text(
          //         '${addressData.number}',
          //         style: addressStyle,
          //       ),
          //       SizedBox(
          //         height: 5,
          //       ),
          //       Text(
          //         '${addressData.addressOne}, ${addressData.streetName}, ${addressData.landmark}',
          //         style: addressStyle,
          //       ),
          //       SizedBox(
          //         height: 5,
          //       ),
          //       Text(
          //         '${addressData.city}-${addressData.pincode}',
          //         style: addressStyle,
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  _getPaymentDetails(OrderDetailsViewModel model) {
    OrderDetailsData data = model.orderData;
    var totalAmount = 0;
    for (var product in data.product) {
      totalAmount = totalAmount + product.amount;
    }
    var payAmount = data.payment.paymentAmount != null? double.parse(data.payment.paymentAmount).toStringAsFixed(2):"0";
    var discountAmount = totalAmount - double.parse(payAmount);
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: 'PAYMENT SUMMARY',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                _buildDetailsRow(
                    'Payment Method',
                    '${data.payment.paymentMethod}',
                    Colors.grey.shade700,
                    FontWeight.normal),
                SizedBox(
                  height: 14,
                ),
                _buildDetailsRow(
                    'Total Value',
                    '${AppStrings.rupee}$totalAmount',
                    Colors.grey.shade700,
                    FontWeight.normal),
                SizedBox(
                  height: 14,
                ),
                _buildDetailsRow(
                    'Delivery Charges (FREE)',
                    '${AppStrings.rupee} 0',
                    Colors.grey.shade700,
                    FontWeight.normal),
                SizedBox(
                  height: 14,
                ),
                _buildDetailsRow(
                    'Discount',
                   (payAmount=="0")?"- 0" :'- ${AppStrings.rupee}${discountAmount.toStringAsFixed(2)}',
                    Colors.grey.shade700,
                    FontWeight.normal),
                SizedBox(
                  height: 14,
                ),
                // _buildDetailsRow('Wallet', '$rupee 97', Colors.grey.shade700,
                //     FontWeight.normal),
                // SizedBox(
                //   height: 14,
                // ),
                _buildDetailsRow(
                    'Amount paid',
                    '${AppStrings.rupee}${payAmount}',
                    Colors.lightGreen,
                    FontWeight.w600),
                SizedBox(
                  height: 14,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildDetailsRow(var title, var value, var color, var weight) {
    var style = TextStyle(
        color: color, fontSize: 14, fontWeight: weight, letterSpacing: 0.2);
    return Container(
      //padding:const EdgeInsets.only(right: 30),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: new Text(
              title,
              style: style,
            ),
          ),
          Text(
            value,
            style: style,
          ),
        ],
      ),
    );
  }

  _getOrderDetails(OrderDetailsViewModel model) {
    OrderDetailsData data = model.orderData;
    var payAmount = data.payment.paymentAmount!=null?  double.parse(data.payment.paymentAmount).toStringAsFixed(2):"Pending";
    // var totalAmount = 0;
    // for (var product in data.product) {
    //   totalAmount = totalAmount + product.amount;
    // }

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: 'ORDER ID ',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w700),
                      children: <TextSpan>[
                        TextSpan(
                            text: '  #${model.orderData.status?.orderId}',
                            style: TextStyle(color: Colors.grey.shade700))
                      ]),
                ),
                Text(
                  '${AppStrings.rupee}${payAmount}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.lightGreen,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: List.generate(data.product.length, (index) {
              return _productRow(index, model);
            }),
          )
        ],
      ),
    );
  }

  _productRow(int index, OrderDetailsViewModel model) {
    List<Product> list = model.orderData.product;
    var total =
        int.parse('${list[index].newPrice}') * int.parse('${list[index].qty}');
    var selectedSize = "";
    // var price = list[index].newPrice;
    // for (Sizes size in list[index].sizes) {
    //   if (price ==
    //       (list[index].newPrice + double.parse(size.newPrice)).toInt()) {
    //     selectedSize = '(${size.size})';
    //     list[index].size_id = int.parse(size.id);
    //   }
    // }
    return Container(
      child: CartItemTile(
        product: list[index],
        isDetails: true,
      ),
    );
  }
}

class TrackView extends StatefulWidget {
  final Status status;
  TrackView({@required this.status});
  @override
  _TrackViewState createState() => _TrackViewState();
}

class _TrackViewState extends State<TrackView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getTackView,
    );
  }

  get _getTackView {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Stack(
        children: <Widget>[
          //_getBackView,
          _getTopView,
        ],
      ),
    );
  }

  get _getTopView {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy hh:mm:ss");
    DateTime dateTime = dateFormat.parse(widget.status.orderDate);
    DateTime statusDateTime = dateFormat.parse(widget.status.statusDate);
    String formattedOrderDate =
        DateFormat('dd MMM yyyy dd:mm').format(dateTime);
    String formattedStatusDate =
        DateFormat('dd MMM yyyy dd:mm').format(statusDateTime);
    return Column(
      children: <Widget>[
        _orderTrackRow(Colors.green, Colors.green, "Ordered And Approved",
            "$formattedOrderDate", "Your Order has been placed.",
            isLast: false, isDesc: true),

        // _orderTrackRow(grey,Colors.grey, "${widget.status.status}",
        //     "$formattedStatusDate","Your order has pending status",isLast:false,isDesc:true),
        // _orderTrackRow(
        //     Colors.green, Colors.green, "Shipped", "Mon, 7th Aug'19","Your item is out for delivery",isLast:false,isDesc:true),
        // _orderTrackRow(
        //     grey, Colors.green, "Completed", "Mon, 7th Aug'19","Your item is out for delivery",isLast:false,isDesc:true),
        _orderTrackRow(
            AppColors.white,
            (widget.status.status == "pending")
                ? AppColors.grey300
                : Colors.green,
            "${widget.status.status}",
            "$formattedStatusDate",
            "",
            isLast: true,
            isDesc: false),
      ],
    );
  }

  _orderTrackRow(
      var firstColor, var bulletColor, var text, var secondText, var desc,
      {var isLast, var isDesc}) {
    return Container(
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            margin: EdgeInsets.only(left: 4),
            padding: EdgeInsets.only(bottom: (isLast) ? 0 : 30),
            decoration: BoxDecoration(
                border: Border(left: BorderSide(color: firstColor, width: 2))),
            child: Container(
              margin: const EdgeInsets.only(left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(text,
                            style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        child: Text(secondText,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            )),
                      ),
                    ],
                  ),
                  (isDesc)
                      ? SizedBox(
                          height: 8,
                        )
                      : Container(),
                  (isDesc)
                      ? Container(
                          child: Text(desc,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                              )),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: _getBullet(bulletColor),
                ),
                //  (isLast)?Container(): Container(
                //    height: 50,
                //     child:  _getLine(firstColor, secondColor),
                //   )
                // ,
              ],
            ),
          ),
          // _getTrackDetails
        ],
      ),
    );
  }

  _getLine(var firstColor, var secondColor) {
    return Center(
      child: Container(
        width: 2.5,
        color: AppColors.green,
      ),
    );
  }

  _getBullet(var bulletColor) {
    return Container(
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bulletColor),
      ),
    );
  }

  get _getTrackDetails {
    return Expanded(
      child: Container(
        height: 50,
        color: AppColors.green,
      ),
    );
  }
}
