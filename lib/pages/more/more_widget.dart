import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/pages/about_page/about_page.dart';
import 'package:lotus_farm/pages/contact_page/contact_page.dart';
import 'package:lotus_farm/pages/faq/faq_page.dart';
import 'package:lotus_farm/pages/more/more_view_model.dart';
import 'package:lotus_farm/pages/offer_page/offer_page.dart';
import 'package:lotus_farm/pages/profile/profile_widget.dart';
import 'package:lotus_farm/pages/store_location/store_location_page.dart';
import 'package:lotus_farm/pages/terms_policy_page/terms_policy_page.dart';
import 'package:lotus_farm/prefrence_util/Prefs.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class MoreWidget extends StatefulWidget {
  @override
  _MoreWidgetState createState() => _MoreWidgetState();
}

class _MoreWidgetState extends State<MoreWidget> {
  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context, listen: false);
    return ViewModelBuilder<MoreViewModel>.reactive(
      viewModelBuilder: () => MoreViewModel(),
      builder: (_, model, child) => Container(
        child: Column(
          children: [
            ProfileTile(
              title: "Offers",
              onTap: () {
                Utility.pushToNext(OfferPage(), context);
              },
            ),
            ProfileTile(
              title: "Store Location",
              onTap: () {
                Utility.pushToNext(StoreLocationPage(), context);
              },
            ),
            ProfileTile(
              title: "FAQ",
              onTap: () async {
                final faq = await Prefs.faq;
                Utility.pushToNext(
                    TermsPolicyPage(
                      title: "FAQ",
                      data: faq,
                    ),
                    context);
              },
            ),
            ProfileTile(
              title: "Terms & Condition",
              onTap: ()async {
                final terms =  await Prefs.terms;
                Utility.pushToNext(
                    TermsPolicyPage(
                      title: "Terms & Condition",
                      data: terms,
                    ),
                    context);
              },
            ),
            ProfileTile(
              title: "Privacy policy",
              onTap: () async{
                final privacy = await Prefs.privacy;
                Utility.pushToNext(
                    TermsPolicyPage(
                      title: "Privacy policy",
                      data: privacy,
                    ),
                    context);
              },
            ),
            ProfileTile(
              title: "Contact Us",
              onTap: () {
                Utility.pushToNext(ContactUsPage(), context);
              },
            ),
            ProfileTile(
              title: "About Us",
              onTap: () {
                Utility.pushToNext(
                    AboutPage(
                      url: "https://drmeatshop.com/about-us",
                    ),
                    context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
