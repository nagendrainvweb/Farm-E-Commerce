import 'package:flutter/material.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/app_widget/AppButton.dart';
import 'package:lotus_farm/app_widget/app_neumorpic_text_feild.dart';
import 'package:lotus_farm/app_widget/customBottomSelectorWidget.dart';
import 'package:lotus_farm/model/address_data.dart';
import 'package:lotus_farm/pages/addEditAddressPage/addEditAddressViewModel.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/style/spacing.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class AddEditAddressPage extends StatefulWidget {
  final AddressData address;

  const AddEditAddressPage({Key key, this.address}) : super(key: key);
  @override
  _AddEditAddressPageState createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  @override
  Widget build(BuildContext context) {
    final appRepo = Provider.of<AppRepo>(context);
    return ViewModelBuilder<AddEditAddressViewModel>.reactive(
      viewModelBuilder: () => AddEditAddressViewModel(),
      onModelReady: (model) {
        model.initData(widget.address);
      },
      builder: (_, model, child) => Scaffold(
        //  extendBodyBehindAppBar: true,
       appBar: AppBar(
          title: Text((widget.address==null)? "Add Address":"Edit Address",style:TextStyle(color: AppColors.blackGrey)),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppNeumorpicTextFeild(
                  controller: model.firstNameController,
                  hintText: "First Name",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                  onChanged: model.onChanged,
                  icon: Icons.person_outline,
                ),
                AppNeumorpicTextFeild(
                  controller: model.lastNameController,
                  hintText: "Last Name",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.name,
                  onChanged: model.onChanged,
                  icon: Icons.person_outline,
                ),
                AppNeumorpicTextFeild(
                  controller: model.numberController,
                  hintText: "Mobile Number",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.number,
                  onChanged: model.onChanged,
                  icon: Icons.call_outlined,
                ),
                AppNeumorpicTextFeild(
                  controller: model.emailIdController,
                  hintText: "Email Id",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.emailAddress,
                  onChanged: model.onChanged,
                  icon: Icons.email_outlined,
                ),
                AppNeumorpicTextFeild(
                  controller: model.addressLineOneController,
                  hintText: "Address line 1",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.multiline,
                  onChanged: model.onChanged,
                  icon: Icons.location_city_outlined,
                ),
                AppNeumorpicTextFeild(
                  controller: model.addressLinetwoController,
                  hintText: "Address line 2",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.multiline,
                  onChanged: model.onChanged,
                  icon: Icons.location_city_outlined,
                ),
                AppNeumorpicTextFeild(
                  controller: model.pincodeController,
                  hintText: "PinCode",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.number,
                  onChanged: model.onChanged,
                  icon: Icons.pin_drop_outlined,
                ),
                AppNeumorpicTextFeild(
                  controller: model.cityController,
                  hintText: "City",
                  fillColor: AppColors.white,
                  textInputType: TextInputType.text,
                  onChanged: model.onChanged,
                  icon: Icons.pin_drop_outlined,
                ),
                GestureDetector(
                  onTap: () {
                    _showBottonSheet(
                        "Please Select State",
                        appRepo.stateList.map((e) => e.name).toList(),
                        model.stateController.text, (index) {
                      model.stateController.text =
                          appRepo.stateList[index].name;
                      model.setStateId(appRepo.stateList[index].id);
                    });
                  },
                  child: AppNeumorpicTextFeild(
                    controller: model.stateController,
                    hintText: "State",
                    fillColor: AppColors.white,
                    textInputType: TextInputType.text,
                    onChanged: model.onChanged,
                    enableInteractiveSelection: false,
                    enabled: false,
                    icon: Icons.pin_drop_outlined,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.defaultMargin),
                  child: AppButtonWidget(
                    width: double.maxFinite,
                    text: "SUBMIT",
                    onPressed: () {
                      model.onSubmitclicked(onMessage: (String text) {
                        Utility.showSnackBar(context, text);
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showBottonSheet(String title, List<String> list, String selectedText,
      Function onItemClicked) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(Spacing.sheetRadius)
            ),
        builder: (_) => CustomSelectWidegt(
              title: title,
              list: list,
              selectedText: selectedText,
              onItemClicked: onItemClicked,
            ));
  }
}
