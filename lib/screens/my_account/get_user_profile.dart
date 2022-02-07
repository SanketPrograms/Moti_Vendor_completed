// To parse this JSON data, do
//
//     final getUserProfileModalclass = getUserProfileModalclassFromJson(jsonString);

import 'dart:convert';

GetUserProfileModalclass getUserProfileModalclassFromJson(String str) => GetUserProfileModalclass.fromJson(json.decode(str));

String getUserProfileModalclassToJson(GetUserProfileModalclass data) => json.encode(data.toJson());

class GetUserProfileModalclass {
  GetUserProfileModalclass({
    this.status,
    this.error,
    this.success,
    this.result,
  });

  String? status;
  int? error;
  int? success;
  Result? result;

  factory GetUserProfileModalclass.fromJson(Map<String, dynamic> json) => GetUserProfileModalclass(
    status: json["status"],
    error: json["error"],
    success: json["success"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "success": success,
    "result": result!.toJson(),
  };
}

class Result {
  Result({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.pass,
    this.usertype,
    this.status,
    this.imgpath,
    this.deleted,
    this.dt,
    this.shopName,
    this.shopAdd,
    this.shopPin,
    this.balance,
    this.vid,
    this.bankAccNo,
    this.bankAccName,
    this.storePhone,
    this.ifscCode,
  });

  String? id;
  String? email;
  String? phone;
  String? name;
  String? pass;
  String? usertype;
  String? status;
  String? imgpath;
  String? deleted;
  DateTime? dt;
  String? shopName;
  String? shopAdd;
  String? shopPin;
  String? balance;
  String? vid;
  dynamic bankAccNo;
  dynamic bankAccName;
  dynamic storePhone;
  dynamic ifscCode;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    email: json["email"],
    phone: json["phone"],
    name: json["name"],
    pass: json["pass"],
    usertype: json["usertype"],
    status: json["status"],
    imgpath: json["imgpath"],
    deleted: json["deleted"],
    dt: DateTime.parse(json["dt"]),
    shopName: json["shop_name"],
    shopAdd: json["shop_add"],
    shopPin: json["shop_pin"],
    balance: json["balance"],
    vid: json["vid"],
    bankAccNo: json["bank_acc_no"],
    bankAccName: json["bank_acc_name"],
    storePhone: json["store_phone"],
    ifscCode: json["ifsc_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "name": name,
    "pass": pass,
    "usertype": usertype,
    "status": status,
    "imgpath": imgpath,
    "deleted": deleted,
    "dt": dt!.toIso8601String(),
    "shop_name": shopName,
    "shop_add": shopAdd,
    "shop_pin": shopPin,
    "balance": balance,
    "vid": vid,
    "bank_acc_no": bankAccNo,
    "bank_acc_name": bankAccName,
    "store_phone": storePhone,
    "ifsc_code": ifscCode,
  };
}
