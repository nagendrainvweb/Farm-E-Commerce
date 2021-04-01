import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:lotus_farm/app_widget/AppNeumorphicContainerWidget.dart';
import 'package:lotus_farm/pages/addEditAddressPage/addEditAddressPage.dart';
import 'package:lotus_farm/pages/address_page/address_view_model.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddressViewModel>.reactive(
      viewModelBuilder: () => AddressViewModel(),
      builder: (_, model, child) => Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: AppColors.white),
          onPressed: () {
            Utility.pushToNext(AddEditAddressPage(), context);
          },
        ),
        body: Container(
          child: ListView.separated(
              itemCount: 10,
              separatorBuilder: (_, index) => Container(
                  //height: 10,
                  ),
              itemBuilder: (_, index) => AddressTile(
                    onTap: () {
                      Utility.pushToNext(AddEditAddressPage(), context);
                    },
                  )),
        ),
      ),
    );
  }
}

class AddressTile extends StatelessWidget {
  const AddressTile({
    Key key,
    this.onTap,
  }) : super(key: key);

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return AppNeumorphicContainer(
      radius: 8,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // Container(
            //   child: Icon(Icons.home),
            // ),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.bigMargin, vertical: Spacing.bigMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nagendra Prajapati",
                      style: TextStyle(
                          color: AppColors.blackGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 8,
                  ),
                  Text("8655891410",
                      style: TextStyle(
                          color: AppColors.grey600,
                          fontSize: 12,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            "D/12, bandhan building, new society, sv road, malad east, mumbai, maharastra - 400097",
                            style: TextStyle(
                                color: AppColors.grey600,
                                fontSize: 12,
                                fontWeight: FontWeight.normal)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     padding: const EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //       borderRadius:
            //           BorderRadius.only(bottomLeft: Radius.circular(8)),
            //       color: AppColors.green,
            //     ),
            //     child: Icon(Icons.edit, color: AppColors.white, size: 14),
            //   ),
            // ),
            //  Align(
            //   alignment: Alignment.bottomRight,
            //   child:Container(
            //        padding: const EdgeInsets.all(12),
            //        decoration: BoxDecoration(
            //         borderRadius: BorderRadius.only(topLeft: Radius.circular(12)),
            //         color: AppColors.green,
            //        ),
            //        child: Icon(Icons.edit,color: AppColors.white,size:14),
            //      ) ,
            // ),
          ],
        ),
      ),
    );
  }
}
