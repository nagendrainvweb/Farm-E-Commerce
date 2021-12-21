import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/pages/login_page/login_view_model.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<AppRepo>(context,listen: false);
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model){
        model.initData(repo);
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(),
        extendBodyBehindAppBar: true,
        
        body: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.bigMargin, ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  Container(
                  //  color: AppColors.redAccent,
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(ImageAsset.logo,
                    fit: BoxFit.contain,
                     height: 270,
                    // width: 100,
                    ),
                  ),
                  //SizedBox(height: 50),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text(
                  //         "Enter Mobile Number",
                  //         textAlign: TextAlign.start,
                  //         style: TextStyle(
                  //             color: AppColors.blackLight,
                  //             fontWeight: FontWeight.normal),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                   SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.grey200, width: 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                            right: BorderSide(
                                color: AppColors.grey200, width: 1),
                          )),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, bottom: 15, left: 20, right: 15),
                            child: Text(
                              "+91",
                              style: TextStyle(color: AppColors.grey500),
                            ),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          controller: model.numberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 10.0, top: 18, bottom: 18),
                              //suffixIcon: Icon(Icons.call_outlined),
                              hintText: "Enter Mobile Number"),
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  AppButtonWidget(
                    onPressed: () {
                      model.checkValidNumber((String text) {
                        showSnackBar(text);
                      });
                    },
                    text: "Send OTP",
                    width: double.maxFinite,
                  ),
                  //SizedBox(height: 30),
                  // Text(
                  //   "or",
                  //   style: TextStyle(color: AppColors.blackLight),
                  // ),
                  // SizedBox(height: 30),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       padding: const EdgeInsets.all(14),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border:
                  //             Border.all(color: AppColors.blackGrey, width: 1),
                  //       ),
                  //       child: Icon(Icons.phone_android_outlined),
                  //     ),
                  //     SizedBox(
                  //       width: 25,
                  //     ),
                  //     Container(
                  //       padding: const EdgeInsets.all(14),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border:
                  //             Border.all(color: AppColors.blackGrey, width: 1),
                  //       ),
                  //       child: Icon(Icons.confirmation_number_outlined),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 40,
                  // ),
                  // TextButton(
                  //     onPressed: () {},
                  //     child: RichText(
                  //         text: TextSpan(
                  //             text: "Don't have an account?",
                  //             style: TextStyle(color: AppColors.grey500),
                  //             children: [
                  //           TextSpan(
                  //             text: " Sign up",
                  //             style: TextStyle(color: AppColors.blackLight),
                  //           )
                  //         ])))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
