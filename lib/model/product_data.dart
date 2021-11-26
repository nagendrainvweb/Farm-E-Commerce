import 'package:lotus_farm/model/product_details_data.dart';
import 'package:lotus_farm/utils/utility.dart';

class Product {
  String id;
  String name;
  String desc;
  String category;
  String categoryId;
  String grossWeight;
  String netWeight;
  String preOrderLink;
  String preOrderId;
  bool isOffer;
  int offer;
  bool isInStock;
  int oldPrice;
  int newPrice;
  int discount;
  String specialPrice;
  String specialTodate;
  String specialFromdate;
  int stockItem;
  String specialText;
  bool isInCart;
  bool isInWishlist;
  int qty;
  List<Images> images;
  List<Sizes> sizes;
  int amount;
  String size_id;
  int orderBy;
  ReviewData reviewData;

  Product(
      {this.id,
      this.name,
      this.desc,
      this.category,
      this.categoryId,
      this.grossWeight,
      this.netWeight,
      this.preOrderLink,
      this.preOrderId,
      this.isOffer,
      this.offer,
      this.isInStock,
      this.oldPrice,
      this.newPrice,
      this.discount,
      this.specialPrice,
      this.specialTodate,
      this.specialFromdate,
      this.stockItem,
      this.specialText,
      this.isInCart,
      this.isInWishlist,
      this.qty,
      this.amount,
      this.images,
      this.size_id,
      this.orderBy,
      this.reviewData,
      this.sizes});

  Product.fromJson(Map<String, dynamic> json, {int order}) {
    id = json['id'];
    name = json['name'];
    desc = json['desc'];
    category = json['category'];
    categoryId = json['category_id'];
    grossWeight = json['gross_weight'];
    netWeight = json['net_weight'];
    preOrderLink = json['pre_order_link'];
    preOrderId = json['pre_order_id'];
    isOffer = json['isOffer'];
    offer = json['offer'];
    isInStock = json['isInStock'];
    oldPrice =  double.parse(json['old_price'].toString()).toInt();
    newPrice = double.parse(json['new_price'].toString()).toInt();
    discount = json['discount'];
    specialPrice = json['special_price'].toString();
    specialTodate = json['special_todate'].toString();
    specialFromdate = json['special_fromdate'].toString();
    stockItem = json['stockItem'];
    specialText = json['special_text'];
    isInCart = json['isInCart'];
    isInWishlist = json['isInWishlist'];
    qty = json['qty'];
    size_id = json["size_id"].toString();
    amount = json['amount'];
    orderBy = order;
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    reviewData = json['items'] != null
        ? new ReviewData.fromJson(json['items'])
        : null;
    // if (json['sizes'] != null) {
    //   sizes = new List<Sizes>();
    //   json['sizes'].forEach((v) {
    //     sizes.add(new Sizes.fromJson(v));
    //   });
    //   sizes.sort((a, b) {
    //     double aPrice = double.parse(a.newPrice.toString());
    //     double bPrice = double.parse(b.newPrice.toString());
    //     return aPrice.compareTo(bPrice);
    //   });
    // }
  }

  Map<String, dynamic> toCartJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.id;
    data['qty'] = this.qty;
    data['category_id'] = this.categoryId;
    data['amount'] = this.amount;
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['category'] = this.category;
    data['category_id'] = this.categoryId;
    data['isOffer'] = this.isOffer;
    data['offer'] = this.offer;
    data['isInStock'] = this.isInStock;
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
    data['qty'] = this.qty;
    data['amount'] = this.amount;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.sizes != null) {
      data['sizes'] = this.sizes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String id;
  String imageUrl;

  Images({this.id, this.imageUrl});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    return data;
  }
}

class Sizes {
  String id;
  String size;
  String oldPrice;
  String newPrice;

  Sizes({this.id, this.size, this.oldPrice, this.newPrice});

  Sizes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
    oldPrice = json['old_price'];
    newPrice = json['new_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    data['old_price'] = this.oldPrice;
    data['new_price'] = this.newPrice;
    return data;
  }
}
