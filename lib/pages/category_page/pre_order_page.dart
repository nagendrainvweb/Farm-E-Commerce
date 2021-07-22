import 'package:flutter/material.dart';
import 'package:lotus_farm/pages/category_page/category_page.dart';
import 'package:lotus_farm/style/app_colors.dart';

class PreOrderPage extends StatefulWidget {
  const PreOrderPage({ Key key }) : super(key: key);

  @override
  _PreOrderPageState createState() => _PreOrderPageState();
}

class _PreOrderPageState extends State<PreOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("Pre Order",style: TextStyle(color: AppColors.blackGrey),),) ,
      
      body: CategoryPage(isPreOrder: true,),
    );
  }
}