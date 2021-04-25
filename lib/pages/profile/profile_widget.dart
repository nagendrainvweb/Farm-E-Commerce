import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lotus_farm/app/locator.dart';
import 'package:lotus_farm/pages/account_page/account_page.dart';
import 'package:lotus_farm/pages/address_page/address_page.dart';
import 'package:lotus_farm/pages/order_page/order_page.dart';
import 'package:lotus_farm/pages/profile/profile_view_model.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/dialog_helper.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  _getTopView(ProfileViewModel model) {
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
                  Text(model.name,
                      textScaleFactor: 1.1,
                      style: TextStyle(color: AppColors.blackGrey))
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () async {
                  final value =
                      await Utility.pushToNext(AccountPage(), context);
                  if (value ?? false) {
                    Utility.showSnackBar(
                        context, "profile Updated Successfully");
                  }
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

  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      viewModelBuilder: () => ProfileViewModel(),
      onModelReady: (model) {
        model.initData();
      },
      builder: (_, model, child) => SingleChildScrollView(
        child: DefaultTextStyle(
          style: TextStyle(color: AppColors.blackGrey),
          child: Column(
            children: [
              _getTopView(model),
              SizedBox(height: 15),
              ProfileTile(
                title: "My Orders",
                onTap: () {
                  Utility.pushToNext(OrderPage(), context);
                },
              ),
              ProfileTile(
                title: "Address Book",
                onTap: () {
                  Utility.pushToNext(AddressPage(), context);
                },
              ),
              ProfileTile(
                title: "My Product Reviews",
                onTap: () {},
              ),
              ProfileTile(
                title: "Manage Sub Accounts",
                onTap: () {},
              ),
              ProfileTile(
                title: "Newsletter Subscription",
                onTap: () {},
              ),
              ProfileTile(
                title: "Support Center",
                onTap: () {},
              ),
              ProfileTile(
                title: "Logout",
                onTap: () {
                  DialogHelper.showLogoutDialog(context, () async {
                    await Prefs.clear();
                    Utility.pushToDashboard(context,2);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  final title;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        margin: const EdgeInsets.symmetric(
            horizontal: Spacing.defaultMargin, vertical: Spacing.smallMargin),
        style: NeumorphicStyle(
            color: AppColors.tileColor,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12))),
        child: ListTile(
          onTap: onTap,
          title: Text(title),
          trailing: Icon(Icons.chevron_right_sharp),
        ));
  }
}
