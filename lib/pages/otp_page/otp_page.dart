import 'package:flutter/material.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/app_appBar.dart';
import 'package:lotus_farm/pages/otp_page/otp_view_model.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stacked/stacked.dart';

class OtpPage extends StatefulWidget {
  final String number;

  const OtpPage({Key key, this.number}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.reactive(
      viewModelBuilder: () => OtpViewModel(),
      onModelReady: (model) {
        model.init(widget.number);
        model.sendOtp();
      },
      builder: (_, model, child) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("OTP verification",
                        style: TextStyle(color: AppColors.blackLight)),
                    SizedBox(height: 20),
                    PinCodeTextField(
                      length: 6,
                      controller: model.otpController,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 40,
                          fieldWidth: 40,
                          inactiveFillColor: Colors.white,
                          activeFillColor: Colors.white,
                          inactiveColor: AppColors.grey400,
                          activeColor: AppColors.grey400,
                          selectedFillColor: AppColors.white,
                          borderWidth: 1),
                      animationDuration: Duration(milliseconds: 300),
                      //rbackgroundColor: Colors.blue.shade50,
                      enableActiveFill: true,
                      // errorAnimationController: errorController,
                      // controller: textEditingController,
                      onCompleted: (v) {
                        print("Completed");
                      },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          // currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                      appContext: context,
                    ),
                    SizedBox(height: 30),
                    AppButtonWidget(
                      onPressed: () {
                        model.verifyOtp();
                      },
                      text: "Verify Code",
                      width: double.maxFinite,
                    ),
                    SizedBox(height: 30),
                    (model.isLoading)
                        ? CircularProgressIndicator()
                        : Column(
                            children: [
                              Visibility(
                                  visible: model.timer != 0,
                                  child: Text("00:${model.timer}")),
                              Visibility(
                                  visible: model.timer == 0,
                                  child: TextButton(
                                      onPressed: () {
                                        model.sendOtp();
                                      },
                                      child: RichText(
                                          text: TextSpan(
                                              text: "Don't receive a code?",
                                              style: TextStyle(
                                                  color: AppColors.grey500),
                                              children: [
                                            TextSpan(
                                              text: " Resend",
                                              style: TextStyle(
                                                  color: AppColors.blackLight),
                                            )
                                          ])))),
                            ],
                          ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
