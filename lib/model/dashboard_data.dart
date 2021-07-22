import 'package:lotus_farm/model/product_data.dart';

class DashboardData {
  int inCartcount;
  List<BannerData> banner;
  String subBanner;
  List<Products> products;
   List<Testimonials> testimonials;

  DashboardData({this.inCartcount,this.subBanner, this.banner,  this.testimonials,this.products});

  DashboardData.fromJson(Map<String, dynamic> json) {
    inCartcount = json['inCartcount'];
    if (json['banner'] != null) {
      banner = new List<BannerData>();
      json['banner'].forEach((v) {
        banner.add(new BannerData.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    subBanner = json["sub_banner"];
     if (json['testimonials'] != null) {
      testimonials = new List<Testimonials>();
      json['testimonials'].forEach((v) {
        testimonials.add(new Testimonials.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inCartcount'] = this.inCartcount;
    if (this.banner != null) {
      data['banner'] = this.banner.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    data["sub_banner"] = subBanner;
    return data;
  }
}

class BannerData {
  String id;
  String imageUrl;
  String type;
  String productId;

  BannerData({this.id, this.imageUrl, this.type, this.productId});

  BannerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['imageUrl'];
    type = json['type'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['type'] = this.type;
    data['product_id'] = this.productId;
    return data;
  }
}

class Products {
  String title;
  List<Product> items;

  Products({this.title, this.items});

  Products.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['items'] != null) {
      items = new List<Product>();
      json['items'].forEach((v) {
        items.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Testimonials {
  String testimonialId;
  String name;
  String content;

  Testimonials({this.testimonialId, this.name, this.content});

  Testimonials.fromJson(Map<String, dynamic> json) {
    testimonialId = json['testimonial_id'];
    name = json['name'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['testimonial_id'] = this.testimonialId;
    data['name'] = this.name;
    data['content'] = this.content;
    return data;
  }
}