import 'package:flutter/material.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/app_neumorpic_text_feild.dart';
import 'package:lotus_farm/pages/addEditAddressPage/addEditAddressViewModel.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:stacked/stacked.dart';

class AddEditAddressPage extends StatefulWidget {
  @override
  _AddEditAddressPageState createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddEditAddressViewModel>.reactive(
      viewModelBuilder: ()=> AddEditAddressViewModel(),
      builder: (_,model,child)=>
      Scaffold(
      //  extendBodyBehindAppBar: true,
        appBar: AppBar(),
        body: Container(
          child: SingleChildScrollView(
           child: Column(
            children: [
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
              ),
               
               AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "Email Id",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                 icon: Icons.email_outlined,
              ),
               AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "Address line 1",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                 icon: Icons.location_city_outlined,
              ),
               AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "Address line 2",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                 icon: Icons.location_city_outlined,
              ),
               AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "PinCode",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                icon: Icons.pin_drop_outlined,
              ),
               AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "City",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                 icon: Icons.pin_drop_outlined,
              ),
               AppNeumorpicTextFeild(
                //controller: model.emailController,
                hintText: "State",
                fillColor: AppColors.white,
                textInputType: TextInputType.emailAddress,
                onChanged: model.onChanged,
                 icon: Icons.pin_drop_outlined,
              ),
               
              SizedBox(height:10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.defaultMargin),
                child: AppButtonWidget(
                  width: double.maxFinite,
                 text: "SUBMIT", 
                 onPressed: (){
                   
                 },
                ),
              ),
              SizedBox(height:20),
            ], 
           ), 
          ),
        ),
      ),
    );
  }
}