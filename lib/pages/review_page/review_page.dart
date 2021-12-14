import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotus_farm/model/product_details_data.dart';
import 'package:lotus_farm/pages/product_details/product_details_page.dart';
import 'package:lotus_farm/style/app_colors.dart';

class ReviewPage extends StatefulWidget {
  final List<Review> reviewList;

  const ReviewPage({Key key, this.reviewList}) : super(key: key);
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
       title: Text("Reviews",style: TextStyle(color: AppColors.blackGrey),), 
      ),
      body: ReviewWidget(widget.reviewList,
      showMore: false,
      setLimit: false,
      ) ,
    );
  }
}