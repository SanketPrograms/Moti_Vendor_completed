// To parse this JSON data, do
//
//     final orderHistoryModalclass = orderHistoryModalclassFromJson(jsonString);

import 'dart:convert';

OrderHistoryModalclass orderHistoryModalclassFromJson(String str) => OrderHistoryModalclass.fromJson(json.decode(str));

String orderHistoryModalclassToJson(OrderHistoryModalclass data) => json.encode(data.toJson());

class OrderHistoryModalclass {
  OrderHistoryModalclass({
    this.status,
    this.error,
    this.success,
    this.result,
  });

  String? status;
  int? error;
  int? success;
  List<Result>? result;

  factory OrderHistoryModalclass.fromJson(Map<String, dynamic> json) => OrderHistoryModalclass(
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
    this.userid,
    this.vendor,
    this.subtotal,
    this.total,
    this.status,
    this.txnId,
    this.pmode,
    this.paid,
    this.deleted,
    this.dt,
    this.tax,
    this.shipping,
    this.placed,
    this.aid,
    this.odate,
    this.did,
    this.name,
  });

  String? id;
  String? userid;
  String? vendor;
  String? subtotal;
  String? total;
  dynamic status;
  String? txnId;
  String? pmode;
  String? paid;
  String? deleted;
  DateTime? dt;
  String? tax;
  String? shipping;
  String? placed;
  String? aid;
  dynamic odate;
  String? did;
  String? name;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    userid: json["userid"],
    vendor: json["vendor"],
    subtotal: json["subtotal"],
    total: json["total"],
    status: json["status"],
    txnId: json["txn_id"],
    pmode: json["pmode"],
    paid: json["paid"],
    deleted: json["deleted"],
    dt: DateTime.parse(json["dt"]),
    tax: json["tax"],
    shipping: json["shipping"],
    placed: json["placed"],
    aid: json["aid"],
    odate: json["odate"],
    did: json["did"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userid": userid,
    "vendor": vendor,
    "subtotal": subtotal,
    "total": total,
    "status": status,
    "txn_id": txnId,
    "pmode": pmode,
    "paid": paid,
    "deleted": deleted,
    "dt": dt!.toIso8601String(),
    "tax": tax,
    "shipping": shipping,
    "placed": placed,
    "aid": aid,
    "odate": odate,
    "did": did,
    "name": name,
  };
}
