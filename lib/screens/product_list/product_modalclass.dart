// To parse this JSON data, do
//
//     final productListModalclass = productListModalclassFromJson(jsonString);

import 'dart:convert';

ProductListModalclass productListModalclassFromJson(String str) => ProductListModalclass.fromJson(json.decode(str));

String productListModalclassToJson(ProductListModalclass data) => json.encode(data.toJson());

class ProductListModalclass {
  ProductListModalclass({
    this.status,
    this.error,
    this.success,
    this.result,
  });

  String? status;
  int? error;
  int? success;
  List<Result>? result;

  factory ProductListModalclass.fromJson(Map<String, dynamic> json) => ProductListModalclass(
    status: json["status"],
    error: json["error"],
    success: json["success"],
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "error": error,
    "success": success,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.id,
    this.name,
    this.category,
    this.subcategory,
    this.brand,
    this.discount,
    this.description,
    this.status,
    this.deleted,
    this.dt,
    this.vendor,
    this.findicator,
    this.homecat,
    this.pincodes,
    this.imgs,
    this.opts,
  });

  String? id;
  String? name;
  String? category;
  String? subcategory;
  String? brand;
  String? discount;
  String? description;
  String? status;
  String? deleted;
  DateTime? dt;
  String? vendor;
  String? findicator;
  String? homecat;
  String? pincodes;
  List<Img>? imgs;
  List<Opt>? opts;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    category: json["category"],
    subcategory: json["subcategory"],
    brand: json["brand"],
    discount: json["discount"],
    description: json["description"],
    status: json["status"],
    deleted: json["deleted"],
    dt: DateTime.parse(json["dt"]),
    vendor: json["vendor"],
    findicator: json["findicator"],
    homecat: json["homecat"],
    pincodes: json["pincodes"] == null ? null : json["pincodes"],
    imgs: List<Img>.from(json["imgs"].map((x) => Img.fromJson(x))),
    opts: List<Opt>.from(json["opts"].map((x) => Opt.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "subcategory": subcategory,
    "brand": brand,
    "discount": discount,
    "description": description,
    "status": status,
    "deleted": deleted,
    "dt": dt!.toIso8601String(),
    "vendor": vendor,
    "findicator": findicator,
    "homecat": homecat,
    "pincodes": pincodes == null ? null : pincodes,
    "imgs": List<dynamic>.from(imgs!.map((x) => x.toJson())),
    "opts": List<dynamic>.from(opts!.map((x) => x.toJson())),
  };
}

class Img {
  Img({
    this.id,
    this.product,
    this.imgpath,
    this.deleted,
    this.dt,
    this.iorder,
  });

  String? id;
  String? product;
  String? imgpath;
  String? deleted;
  DateTime? dt;
  String? iorder;

  factory Img.fromJson(Map<String, dynamic> json) => Img(
    id: json["id"],
    product: json["product"],
    imgpath: json["imgpath"],
    deleted: json["deleted"],
    dt: DateTime.parse(json["dt"]),
    iorder: json["iorder"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product,
    "imgpath": imgpath,
    "deleted": deleted,
    "dt": dt!.toIso8601String(),
    "iorder": iorder,
  };
}

class Opt {
  Opt({
    this.id,
    this.product,
    this.variants,
    this.price,
    this.deleted,
    this.dt,
  });

  String? id;
  String? product;
  String? variants;
  String? price;
  String? deleted;
  DateTime? dt;

  factory Opt.fromJson(Map<String, dynamic> json) => Opt(
    id: json["id"],
    product: json["product"],
    variants: json["variants"],
    price: json["price"],
    deleted: json["deleted"],
    dt: DateTime.parse(json["dt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product,
    "variants": variants,
    "price": price,
    "deleted": deleted,
    "dt": dt!.toIso8601String(),
  };
}
