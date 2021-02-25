import 'package:flutter/material.dart';
import 'package:lotus_farm/utils/utility.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key key, this.msg,
  }) : super(key: key);

  final msg;
  @override
  Widget build(BuildContext context) {
    return Center(
     child: Container(
       padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Icon(Icons.error_outline,color: CustomColor.kgreyColor,size: 100,),
         SizedBox(height: 10,),
         Text(msg??'No Data Found',textScaleFactor: 1.2,style: TextStyle(color:CustomColor.blackGrey),)
       ], 
      ), 
     ), 
    );
  }
}