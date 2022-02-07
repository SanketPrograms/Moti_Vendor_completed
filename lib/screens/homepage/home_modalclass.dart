// To parse this JSON data, do
//
//     final homeModalclass = homeModalclassFromJson(jsonString);

import 'dart:convert';

HomeModalclass homeModalclassFromJson(String str) => HomeModalclass.fromJson(json.decode(str));

String homeModalclassToJson(HomeModalclass data) => json.encode(data.toJson());

class HomeModalclass {
  HomeModalclass({
    this.status,
    this.error,
    this.success,
    this.result,
  });

  String? status;
  int? error;
  int? success;
  Result? result;

  factory HomeModalclass.fromJson(Map<String, dynamic> json) => HomeModalclass(
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
    this.porders,
    this.dorders,
    this.corders,
    this.torders,
    this.thomesec,
    this.tdboy,
    this.tsales,
  });

  int? porders;
  int? dorders;
  int? corders;
  int? torders;
  int? thomesec;
  int? tdboy;
  int? tsales;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    porders: json["porders"],
    dorders: json["dorders"],
    corders: json["corders"],
    torders: json["torders"],
    thomesec: json["thomesec"],
    tdboy: json["tdboy"],
    tsales: json["tsales"],
  );

  Map<String, dynamic> toJson() => {
    "porders": porders,
    "dorders": dorders,
    "corders": corders,
    "torders": torders,
    "thomesec": thomesec,
    "tdboy": tdboy,
    "tsales": tsales,
  };
}
