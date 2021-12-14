import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotus_farm/app/appRepository.dart';
import 'package:lotus_farm/pages/address_page/address_page.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:provider/provider.dart';

class StoreLocationPage extends StatefulWidget {
  const StoreLocationPage({Key key}) : super(key: key);

  @override
  _StoreLocationPageState createState() => _StoreLocationPageState();
}

class _StoreLocationPageState extends State<StoreLocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          "Store Location",
          style: TextStyle(color: AppColors.blackGrey),
        ),
      ),
      body: Container(
        child: Consumer<AppRepo>(
            builder: (context, repo, child) =>
                ListView.builder(
                  itemCount: repo.storeList.length,
                  itemBuilder: (context, index) {
                  return StoreTile(
                    storeData: repo.storeList[index],
                    onTap: (){

                    },
                  );
                })),
      ),
    );
  }
}
