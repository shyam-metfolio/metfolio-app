// To parse this JSON data, do
//
//     final myOrderDetialsModel = myOrderDetialsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyOrderDetialsModel myOrderDetialsModelFromJson(String str) =>
    MyOrderDetialsModel.fromJson(json.decode(str));

String myOrderDetialsModelToJson(MyOrderDetialsModel data) =>
    json.encode(data.toJson());

class MyOrderDetialsModel {
  MyOrderDetialsModel({
    required this.status,
    required this.url,
    required this.details,
  });

  String status;
  String url;
  List<Detail> details;

  factory MyOrderDetialsModel.fromJson(Map<String, dynamic> json) =>
      MyOrderDetialsModel(
        status: json["status"],
        url: json["url"],
        details: List<Detail>.from(json["details"] == null
            ? []
            : json["details"]!.map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "url": url,
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
      };
}

class Detail {
  Detail({
    required this.id,
    required this.userId,
    required this.quantity,
    required this.paymentType,
    required this.subTotal,
    required this.tax,
    required this.serviceCharge,
    required this.taxableTotal,
    required this.totalWTax,
    required this.status,
    required this.paymentStatus,
    required this.ipRess,
    required this.typeId,
    required this.deliveryStatus,
    required this.moveDesc,
    required this.createdOn,
    required this.updatedOn,
    required this.createUserId,
    required this.updateUserId,
  });

  int id;
  int userId;
  String quantity;
  dynamic paymentType;
  dynamic subTotal;
  dynamic tax;
  dynamic serviceCharge;
  dynamic taxableTotal;
  dynamic totalWTax;
  dynamic status;
  dynamic paymentStatus;
  dynamic ipRess;
  dynamic typeId;
  dynamic deliveryStatus;
  dynamic moveDesc;
  DateTime createdOn;
  DateTime updatedOn;
  dynamic createUserId;
  dynamic updateUserId;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        userId: json["user_id"],
        quantity: json["quantity"],
        paymentType: json["payment_type"],
        subTotal: json["sub_total"] == null ? null : json["sub_total"],
        tax: json["tax"],
        serviceCharge: json["service_charge"],
        taxableTotal: json["taxable_total"],
        totalWTax: json["total_w_tax"],
        status: json["status"],
        paymentStatus: json["payment_status"],
        ipRess: json["ip_ress"],
        typeId: json["type_id"],
        deliveryStatus:
            json["delivery_status"] == null ? null : json["delivery_status"],
        moveDesc: json["move_desc"] == null ? '' : json["move_desc"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        createUserId: json["create_user_id"],
        updateUserId: json["update_user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "quantity": quantity,
        "payment_type": paymentType,
        "sub_total": subTotal == null ? null : subTotal,
        "tax": tax,
        "service_charge": serviceCharge,
        "taxable_total": taxableTotal,
        "total_w_tax": totalWTax,
        "status": status,
        "payment_status": paymentStatus,
        "ip_ress": ipRess,
        "type_id": typeId,
        "delivery_status": deliveryStatus == null ? null : deliveryStatus,
        "move_desc": moveDesc == null ? null : moveDesc,
        "created_on": createdOn.toIso8601String(),
        "updated_on": updatedOn.toIso8601String(),
        "create_user_id": createUserId,
        "update_user_id": updateUserId,
      };
}
