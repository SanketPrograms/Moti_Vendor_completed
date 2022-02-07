// To parse this JSON data, do
//
//     final getVariantsModalclass = getVariantsModalclassFromJson(jsonString);

import 'dart:convert';

GetVariantsModalclass getVariantsModalclassFromJson(String str) => GetVariantsModalclass.fromJson(json.decode(str));

String getVariantsModalclassToJson(GetVariantsModalclass data) => json.encode(data.toJson());

class GetVariantsModalclass {
  GetVariantsModalclass({
    this.status,
    this.error,
    this.success,
    this.result,
  });

  String? status;
  int? error;
  int? success;
  List<Result>? result;

  factory GetVariantsModalclass.fromJson(Map<String, dynamic> json) => GetVariantsModalclass(
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
    this.imgpath,
    this.img,
    this.status,
    this.deleted,
    this.dt,
  });

  String? id;
  String? name;
  dynamic imgpath;
  String? img;
  String? status;
  String? deleted;
  DateTime? dt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    imgpath: json["imgpath"],
    img: json["img"],
    status: json["status"],
    deleted: json["deleted"],
    dt: DateTime.parse(json["dt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "imgpath": imgpath,
    "img": img,
    "status": status,
    "deleted": deleted,
    "dt": dt!.toIso8601String(),
  };
}
