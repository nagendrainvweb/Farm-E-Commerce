import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/app_neumorpic_text_feild.dart';
import 'package:lotus_farm/pages/account_page/account_view_model.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  _getTopView(AccountViewModel model) {
    return Container(
      child: Neumorphic(
        margin: const EdgeInsets.symmetric(horizontal: Spacing.defaultMargin),
        style: NeumorphicStyle(
            color: AppColors.tileColor,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12))),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.extraBigMargin,
                  vertical: Spacing.bigMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.green,
                    ),
                    child: SvgPicture.asset(
                      ImageAsset.avator,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text("Nagendra Prajapati",
                      textScaleFactor: 1.1,
                      style: TextStyle(color: AppColors.blackGrey))
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  //Utility.pushToNext(AccountPage(), context);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppColors.green,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(12))),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 12,
                    color: AppColors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountViewModel>.reactive(
      viewModelBuilder: () => AccountViewModel(),
      onModelReady: (model) {
        model.initData();
      },
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Account",
            style: TextStyle(color: AppColors.blackGrey),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //_getTopView(model),

                Center(
                  child: Neumorphic(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Spacing.defaultMargin),
                    style: NeumorphicStyle(
                        color: AppColors.tileColor,
                        boxShape: NeumorphicBoxShape.circle()),
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: CircleAvatar(
                        child: SvgPicture.asset(
                          ImageAsset.avator,
                          height: 130,
                          width: 130,
                        ),
                        backgroundColor: AppColors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                AppNeumorpicTextFeild(
                  controller: model.firstNameController,
                  hintText: "First Name",
                  onChanged: (e) {},
                  onSubmit: (e) {},
                  textInputType: TextInputType.name,
                  icon: Icons.person_outline,
                ),
                AppNeumorpicTextFeild(
                  controller: model.lastNameController,
                  hintText: "Last Name",
                  onChanged: (e) {},
                  onSubmit: (e) {},
                  textInputType: TextInputType.name,
                  icon: Icons.person_outline,
                ),
                AppNeumorpicTextFeild(
                  controller: model.numberController,
                  hintText: "Mobile Number",
                  onChanged: (e) {},
                  onSubmit: (e) {},
                  enabled: false,
                  textInputType: TextInputType.name,
                  icon: Icons.call_outlined,
                ),
                AppNeumorpicTextFeild(
                  controller: model.emailController,
                  hintText: "Email Id",
                  onChanged: (e) {},
                  onSubmit: (e) {},
                  enabled: false,
                  textInputType: TextInputType.name,
                  icon: Icons.email_outlined,
                ),
                AppNeumorpicTextFeild(
                    hintText: "City",
                    controller: model.cityController,
                    onChanged: (e) {},
                    onSubmit: (e) {},
                    textInputType: TextInputType.name,
                    icon: Icons.location_city_outlined),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.defaultMargin),
                  child: AppButtonWidget(
                    text: "Submit",
                    width: double.maxFinite,
                    onPressed: () {
                      model.updateProfile(onError: (String text) {
                        Utility.showSnackBar(context, text);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
