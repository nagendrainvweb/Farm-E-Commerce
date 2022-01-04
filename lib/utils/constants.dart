import 'dart:io';

const STATUS_LOADING = "PAYMENT_LOADING";
const STATUS_SUCESSFUL = "PAYMENT_SUCESSFUL";
const STATUS_PENDING = "STATUS_PENDING";
const STATUS_FAILED = "STATUS_FAILED";
const STATUS_CHECKSUM_FAILED = "STATUS_CHECKSUM_FAILED";

class Constants {
  static final RUPEE = "₹";
  static final AUTH = "authorization";
  static final INTRO_DONE = "intro_done";
  static final SUBSCRIPTION = "subscription";
  static final SKIP_LOGIN = "skip_login";
  static final LAST_NAME = "last_name";
  static final IS_LOGIN = "isLogin";
  static final TOKEN = "token";
  static final SUCCESS = "success";
  static final USERID = "user_id";
  static final PROFILE_PIC = "profile_pic";
  static final NOTIFICATION_ID = "notification_id";
  static final MAINCAT = "mainCategoryId";
  static final NAME = "name";
  static final MIDDLE_NAME = "middle_name";
  static final SUR_NAME = "sur_nmae";
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
  static final PROFILEPIC = "Profile_pic";
  static final CATEGORY_ID = "category_id";
  static final PRODUCT_ID = "product_id";
  static final AUTORIZATION = "Autorization";
  static final BEARER = "Bearer";
  static final TIMESTAMP = "timestamp";
  static final CODE = "code";
  static final MESSAGE = "message";
  static final APP_VERSION = "appVersion";
  static final DATA = "data";
  static final STATE_LIST = "state_list";
  static final CITY_LIST = "city_list";
  static final FAQ = "faq";
  static final TERMS = "terms";
  static final PRIVACY = "privacy";
  static final LOGIN_DATE = "login_date";

  static final SUBSCRIPTION_DATE = "subcription_date";
  static final SUBSCRIPTION_EXPIRY_DATE = "subcription_expiry_date";
  static final CRIF_DATA = "crif_data";

  static final API_KEY = "54YsbY2sxkg-zJEIEp2ThPZK4AIPpa5Q0kjjjPKecI";
  static final OTP_SENDER_CODE = "MYPROS";

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

  static final URL_DEVICE = "device";

  static final ANDROID_VERSION = "3";
  static final IOS_VERSION = "3";
  static final ANDROID_DEVICE = "android";
  static final IOS_DEVICE = "ios";

  static final CART_COUNT = "cart_count";
  static final NOTIFICATION_COUNT = "notification_count";

  static final WEIGHT_1 = "500 gms";
  static final WEIGHT_2 = "1 Kgs";

  static final SKIN_1 = "With Skin";
  static final SKIN_2 = "Skinless";

  static final BONE_1 = "With Bone";
  static final BONE_2 = "Boneless";
}
