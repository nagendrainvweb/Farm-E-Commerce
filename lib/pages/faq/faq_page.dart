import 'package:flutter/material.dart';
import 'package:lotus_farm/app_widget/AppNeumorphicContainerWidget.dart';
import 'package:lotus_farm/style/app_colors.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAQ",
          style: TextStyle(color: AppColors.blackGrey),
        ),
      ),
      body: Container(
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, index) => 
              AppNeumorphicContainer(
                child: ListTile(
                  trailing: Icon(Icons.expand_more_rounded),
                 // contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  horizontalTitleGap: 10,
                  title: Text("1. Do I need to create or register an account to place my order?"),
                  subtitle: (false)?Column(
                    children: [
                      SizedBox(height: 8,),
                      Text("Ans: Yes, it is mandatory to create an account to place an order. Please click < > to create a new account."),
                    ],
                  ):null,
                ),
              )
              // AppNeumorphicContainer(
              //       child: Column(
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Text(
              //               "Do I need to create or register an account to place my order?",
              //               style: TextStyle(fontWeight: FontWeight.bold),
              //             ),
              //           ),
              //           Text(
              //               "Ans: Yes, it is mandatory to create an account to place an order. Please click < > to create a new account.",
              //               style: TextStyle(color: AppColors.blackText,fontSize: 14),
              //               )
              //         ],
              //       ),
              //     )
                  
                  )),
    );
  }
}
