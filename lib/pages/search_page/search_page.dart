import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lotus_farm/model/search_data.dart';
import 'package:lotus_farm/pages/search_page/search_view_model.dart';
import 'package:lotus_farm/resources/images/images.dart';
import 'package:lotus_farm/style/app_colors.dart';
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
      builder: (context, model, child) =>
         Scaffold(
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
                      style:
                          TextStyle(color: AppColors.blackGrey, fontSize: 16),
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
                        SearchData search =
                            model.searchDataList[index];
                        return Container(
                            child: ListTile(
                          title: Text(search.name),
                          onTap: (){
                            // if(search.isProduct){
                            //   Utility.replaceWith(ProductDetailsPage(
                            //     id: search.id,
                            //     title: search.name,
                            //   ), context);
                            // }else{
                            //   Utility.replaceWith(CategoryPage(
                            //     parentId: search.id,
                            //     title: search.name,
                            //   ), context);
                            // }
                          },
                          subtitle:
                              Text((search.isProduct) ? "Product" : "category"),
                          trailing: Icon(Icons.launch),
                          leading: SizedBox(
                            height: 45,
                            width: 45,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                child: CachedNetworkImage(
                                  imageUrl: Uri.encodeFull(search.imageUrl),
                                  placeholder: (context, data) {
                                    return Container(
                                      child: new Center(
                                        child: SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: new CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  errorWidget: (context, value, data) =>
                                      Container(
                                    child: Center(
                                      child: Image.asset(ImageAsset.noImage),
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
                        ));
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
