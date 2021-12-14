import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotus_farm/pages/cart/cart_widget.dart';
import 'package:lotus_farm/style/app_colors.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text("Cart",style: TextStyle(color: AppColors.blackGrey), ),
      ),
      body: Container(
        child: CartWidget(),
      ),
    );
  }
}