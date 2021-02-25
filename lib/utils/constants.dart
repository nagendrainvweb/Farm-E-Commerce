import 'dart:io';

class Constants {
  static final RUPEE = "₹";
  static final IS_LOGIN = "isLogin";
  static final TOKEN = "fcm_token";
  static final SUCCESS = "success";
  static final USERID = "user_id";
  static final PROFILE_PIC = "profile_pic";
  static final NOTIFICATION_ID = "notification_id";
  static final MAINCAT = "mainCategoryId";
  static final NAME = "name";
  static final USER_NAME = "username";
  static final MOBILE_NO = "mobile_no";
  static final ROLE = "role";
  static final GST_NO = "gstNo";
  static final CATEGORY = "category";
  static final COUNTRY = "country";
  static final STATE = "state";
  static final CITY = "city";
  static final PINCODE = "pincode";
  static final STATUS = "status";
  static final ADDRESS = "address";
  static final EMAIl = "email";
  static final FCM_TOKEN = "fcm_token";
  static final CATEGORY_ID = "category_id";
  static final PRODUCT_ID = "product_id";
  static final AUTORIZATION = "Autorization";
  static final BEARER = "Bearer";

  static final MOBILE = 'mobile';
  static final OTP = 'otp';
  static final TIMESTAMP = 'timestamp';
  static final CODE = 'code';
  static final MESSAGE = 'message';
  static final APP_VERSION = 'appVersion';
  static final DATA = "data";

  static final RAMESH_SHIRTING = "Ramesh Shirtings";
  static final MONTORO_SHIRT = "Montoro Shirts";
  static final GANGORE_SAREE = "Gangore Sarees";

  static final IMAGE_PATH =
      "http://betadevelopment.in/garodiya/public/uploads/category_images/";
  static final PRODUCT_IMAGE_PATH =
      "http://betadevelopment.in/garodiya/public/uploads/product_images/";
  static final OPTION_IMAGE_PATH =
      "http://betadevelopment.in/garodiya/public/uploads/option_value_images/";

  static final VERSION = (Platform.isAndroid) ? ANDROID_VERSION : IOS_VERSION;
  static final DEVICE = (Platform.isAndroid) ? ANDROID_DEVICE : IOS_DEVICE;

  static final ANDROID_VERSION = "1";
  static final IOS_VERSION = "1";
  static final ANDROID_DEVICE = "android";
  static final IOS_DEVICE = "ios";


  static final CART_COUNT = "cart_count";
  static final NOTIFICATION_COUNT = "notification_count";
}