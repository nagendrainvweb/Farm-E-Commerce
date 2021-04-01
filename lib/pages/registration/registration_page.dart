import 'package:flutter/material.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/app_neumorpic_text_feild.dart';
import 'package:lotus_farm/pages/registration/registration_view_model.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:stacked/stacked.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistrationViewModel>.reactive(
      viewModelBuilder: () => RegistrationViewModel(),
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Text(
                    "Mobile number is not registered with us,\n Please Enter your details.",
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                  ),
                  ],
                ),
              ),
               SizedBox(height: 20),
              AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "First Name",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                icon: Icons.person_outline,
              ),
              AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "Last Name",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                icon: Icons.person_outline,
              ),
              AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "Mobile Number",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                icon: Icons.call_outlined,
                enabled: false,
              ),
              AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "Email Id",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.defaultMargin),
                child: AppButtonWidget(
                  width: double.maxFinite,
                  text: "SUBMIT",
                  onPressed: () {
                    model.submitClicked();
                  },
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
