import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lotus_farm/model/search_data.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/pages/search_page/search_view_model.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/style/app_colors.dart';
import 'package:lotus_farm/utils/utility.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      viewModelBuilder: () => SearchViewModel(),
      builder: (context, model, child) => Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          // elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: model.controller,
                    onChanged: model.updateUsername,
                    style: TextStyle(color: AppColors.blackGrey, fontSize: 16),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      model.clearText();
                    })
              ],
            ),
          ),
        ),
        body: Container(
            child: (model.searchDataList != null)
                ? ListView.builder(
                    itemCount: model.searchDataList.length,
                    itemBuilder: (context, index) {
                      SearchData search = model.searchDataList[index];
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          children: [
                            ListTile(
                              //contentPadding: EdgeInsets.symmetric(horizontal: 5),
                              leading: SizedBox(
                                height: 45,
                                width: 45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      height: 45,
                                      width: 45,
                                      imageUrl: Uri.encodeFull(
                                          search.images[0].imageUrl),
                                      placeholder: (context, data) {
                                        return Container(
                                          child: new Center(
                                            child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  new CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, value, data) =>
                                          SizedBox(
                                        width: 50,
                                        child: Center(
                                          child: Image.asset(
                                              "assets/no_image.png"),
                                        ),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    // decoration: BoxDecoration(
                                    //   image: DecorationImage(
                                    //       image: AssetImage(
                                    //         AssetsName.category2,
                                    //       ),
                                    //       fit: BoxFit.cover),
                                    // ),
                                  ),
                                ),
                              ),
                              trailing: Icon(
                                Icons.launch,
                                color: Colors.grey.shade400,
                              ),
                              title: new RichText(
                                text: TextSpan(
                                    text: search.name.substring(
                                        0, model.controller.text.length),
                                    style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500),
                                    children: [
                                      TextSpan(
                                        text: search.name.substring(
                                            model.controller.text.length),
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      )
                                    ]),
                              ),
                              onTap: () {
                                model.onListClicked(search.name);
                                Utility.pushToNext(
                                    ProductDetailsPage(
                                      productId: search.id,
                                    ), context);
                                //model.controller.text = search.name;
                                // query = list[index].name;
                                // showResults(context);
                                // close(context, null);
                                // Utility.pushToNext(
                                //     ProductDetails(
                                //       productId: list[index].id,
                                //     ),
                                //     context);
                              },
                            ),
                            Container(height: 1, color: AppColors.grey400),
                          ],
                        ),
                      );
                    })
                : Container(child: Center(child: Text("No Data found")))),
      ),
    );
  }
}

class _SearchTextFeildWidget extends HookViewModelWidget<SearchViewModel> {
  const _SearchTextFeildWidget({
    Key key,
  }) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(BuildContext context, SearchViewModel viewModel) {
    var controller = useTextEditingController();
    return Container(
      child: TextField(
        controller: controller,
        onChanged: viewModel.updateUsername,
        style: TextStyle(color: AppColors.blackGrey, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
        ),
      ),
    );
  }
}
