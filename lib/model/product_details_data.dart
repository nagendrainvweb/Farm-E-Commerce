import 'package:lotus_farm/model/product_data.dart';
import 'package:lotus_farm/utils/utility.dart';

class ProductDetailsData {
  String id;
  String name;
  String desc;
  String productUrl;
  String categoryId;
  String preOrderLink;
  String preOrderId;
  String category;
  bool isOffer;
  int sizeId;
  int offer;
  String oldPrice;
  String newPrice;
  int discount;
  String specialPrice;
  String specialTodate;
  String specialFromdate;
  int stockItem;
  String specialText;
  bool isInCart;
  bool isInWishlist;
  String availability;
  String selfLife;
  String expectedDelivery;
  String ingradientDetails;
  int qty;
  int rating;
  bool isInStock;
  String nutritionFacts;
  List<Images> images;
  List<Sizes> sizes;
  ReviewData reviewData;
  String grossWeight;
  String netWeight;
  String serves;
  String piece;

  ProductDetailsData(
      {this.id,
      this.name,
      this.desc,
      this.productUrl,
      this.category,
      this.preOrderLink,
      this.preOrderId,
      this.isOffer,
      this.offer,
      this.oldPrice,
      this.newPrice,
      this.isInCart,
      this.isInWishlist,
      this.availability,
      this.categoryId,
      this.selfLife,
      this.expectedDelivery,
      this.ingradientDetails,
      this.qty,
      this.rating,
      this.isInStock,
      this.nutritionFacts,
      this.images,
      this.sizes,
      this.grossWeight,
      this.netWeight,
      this.piece,
      this.serves,
      this.reviewData});

  ProductDetailsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desc = Utility.removeAllHtmlTags(json['desc']);
    productUrl = json['product_url'];
    categoryId = json['category_id'];
    category = json['category'];
    preOrderLink = json['pre_order_link'];
    preOrderId = json['pre_order_id'];
    isOffer = json['isOffer'];
    sizeId = json['size_id'];
    offer = json['offer'];
    oldPrice = json['old_price'].toString();
    newPrice = json['new_price'].toString();
    discount = json['discount'];
    specialPrice = json['special_price'];
    specialTodate = json['special_todate'];
    specialFromdate = json['special_fromdate'];
    stockItem = json['stockItem'];
    specialText = json['special_text']??"";
    isInCart = json['isInCart'];
    isInWishlist = json['isInWishlist'];
    availability = json['availability'];
    selfLife = json['self_life'];
    expectedDelivery = json['expected_delivery'];
    ingradientDetails = json['ingradient_details'];
    qty = json['qty'];
    rating = json['rating'];
    isInStock = json['isInStock'];
    nutritionFacts = json['Nutrition_facts'];
    grossWeight = json["gross_weight"]??"";
    netWeight = json["net_weight"]??"";
    serves = json["serves"]??"";
    piece = json["piece"]??"";
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    if (json['sizes'] != null) {
      sizes = new List<Sizes>();
      json['sizes'].forEach((v) {
        sizes.add(new Sizes.fromJson(v));
      });
    }
    sizes.sort((a, b) {
      double aPrice = double.parse(a.newPrice.toString());
      double bPrice = double.parse(b.newPrice.toString());
      return aPrice.compareTo(bPrice);
    });
    reviewData = json['review_data'] != null
        ? new ReviewData.fromJson(json['review_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['product_url'] = this.productUrl;
    data['category_id'] = this.categoryId;
    data['category'] = this.category;
    data['isOffer'] = this.isOffer;
    data['size_id'] = this.sizeId;
    data['offer'] = this.offer;
    data['old_price'] = this.oldPrice;
    data['new_price'] = this.newPrice;
    data['discount'] = this.discount;
    data['special_price'] = this.specialPrice;
    data['special_todate'] = this.specialTodate;
    data['special_fromdate'] = this.specialFromdate;
    data['stockItem'] = this.stockItem;
    data['special_text'] = this.specialText;
    data['isInCart'] = this.isInCart;
    data['isInWishlist'] = this.isInWishlist;
    data['availability'] = this.availability;
    data['self_life'] = this.selfLife;
    data['expected_delivery'] = this.expectedDelivery;
    data['ingradient_details'] = this.ingradientDetails;
    data['qty'] = this.qty;
    data['rating'] = this.rating;
    data['isInStock'] = this.isInStock;
    data['Nutrition_facts'] = this.nutritionFacts;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.sizes != null) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    if (this.reviewData != null) {
      data['review_data'] = this.reviewData.toJson();
    }
    return data;
  }
}

class Review {
  String id;
  int rating;
  String reviewTitle;
  String userName;
  String date;
  String time;
  String review;

  Review(
      {this.id,
      this.rating,
      this.reviewTitle,
      this.userName,
      this.date,
      this.time,
      this.review});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = int.parse(json['rating']);
    reviewTitle = json['review_title'];
    userName = json['user_name'];
    date = json['date'];
    time = json['time'];
    review = json['review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['review_title'] = this.reviewTitle;
    data['user_name'] = this.userName;
    data['date'] = this.date;
    data['time'] = this.time;
    data['review'] = this.review;
    return data;
  }
}

class ReviewData {
  int totalReviews;
  var averageRating;
  int fiveStarCount;
  int fourStarCount;
  int threeStarCount;
  int twoStarCount;
  int oneStarCount;
  Review my_review;
  List<Review> review;

  ReviewData(
      {this.totalReviews,
      this.averageRating,
      this.fiveStarCount,
      this.fourStarCount,
      this.threeStarCount,
      this.twoStarCount,
      this.oneStarCount,
      this.my_review,
      this.review});

  ReviewData.fromJson(Map<String, dynamic> json) {
    totalReviews = json['total_reviews'];
    averageRating = json['average_rating'];
    fiveStarCount = json['five_star_count'];
    fourStarCount = json['four_star_count'];
    threeStarCount = json['three_star_count'];
    twoStarCount = json['two_star_count'];
    oneStarCount = json['one_star_count'];
    if (json['my_review'] != null) {
      my_review = json['my_review'].length > 0
          ? new Review.fromJson(json['my_review'][0])
          : null;
    }
    if (json['review'] != null) {
      review = new List<Review>();
      json['review'].forEach((v) {
        review.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_reviews'] = this.totalReviews;
    data['average_rating'] = this.averageRating;
    data['five_star_count'] = this.fiveStarCount;
    data['four_star_count'] = this.fourStarCount;
    data['three_star_count'] = this.threeStarCount;
    data['two_star_count'] = this.twoStarCount;
    data['one_star_count'] = this.oneStarCount;
    if (this.review != null) {
      data['review'] = this.review.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
