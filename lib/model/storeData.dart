class StoreData {
  String id;
  String name;
  String description;
  String city;
  String country;
  String street;
  String phoneOne;
  String stateProvince;
  String postalCode;
  String phoneTwo;
  String website;
  String fax;
  String email;
  String latitude;
  String longitude;
  String operationMon;
  String operationTue;
  String operationWed;
  String operationThu;
  String operationFri;
  String operationSat;
  String operationSun;


  StoreData(
      {this.id,
      this.name,
      this.description,
      this.city,
      this.country,
      this.street,
      this.phoneOne,
      this.stateProvince,
      this.postalCode,
      this.phoneTwo,
      this.website,
      this.fax,
      this.email,
      this.latitude,
      this.longitude,
      this.operationMon,
      this.operationTue,
      this.operationWed,
      this.operationThu,
      this.operationFri,
      this.operationSat,
      this.operationSun
      });

  StoreData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    city = json['city']??"";
    country = json['country']??"";
    street = json['street']??"";
    phoneOne = json['phone_one']??"";
    stateProvince = json['state_province'];
    postalCode = json['postal_code']??"";
    phoneTwo = json['phone_two']??"";
    website = json['website']??"";
    fax = json['fax']??"";
    email = json['email']??"";
    latitude = json['latitude']??"";
    longitude = json['longitude']??"";
    operationMon = json['operation_mon'];
    operationTue = json['operation_tue'];
    operationWed = json['operation_wed'];
    operationThu = json['operation_thu'];
    operationFri = json['operation_fri'];
    operationSat = json['operation_sat'];
    operationSun = json['operation_sun'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['city'] = this.city;
    data['country'] = this.country;
    data['street'] = this.street;
    data['phone_one'] = this.phoneOne;
    data['state_province'] = this.stateProvince;
    data['postal_code'] = this.postalCode;
    data['phone_two'] = this.phoneTwo;
    data['website'] = this.website;
    data['fax'] = this.fax;
    data['email'] = this.email;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['operation_mon'] = this.operationMon;
    data['operation_tue'] = this.operationTue;
    data['operation_wed'] = this.operationWed;
    data['operation_thu'] = this.operationThu;
    data['operation_fri'] = this.operationFri;
    data['operation_sat'] = this.operationSat;
    data['operation_sun'] = this.operationSun;
    return data;
  }
}
