// To parse this JSON data, do
//
//     final myAddressesModel = myAddressesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MyAddressesModel myAddressesModelFromJson(String str) => MyAddressesModel.fromJson(json.decode(str));

String myAddressesModelToJson(MyAddressesModel data) => json.encode(data.toJson());

class MyAddressesModel {
    MyAddressesModel({
         required this.status,
         required this.url,
         required this.details,
    });

    String status;
    String url;
    List<Detail> details;

    factory MyAddressesModel.fromJson(Map<String, dynamic> json) => MyAddressesModel(
        status: json["status"],
        url: json["url"],
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
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
         required this.address,
         required this.addressLineOne,
         required this.addressLineTwo,
         required this.postCode,
         required this.city,
         required this.country,
         required this.location,
         required this.latitude,
         required this.longitude,
         required this.addressLabel,
         required this.landMark,
         required this.status,
         required this.createdOn,
         required this.updatedOn,
         required this.contactNo,
         required this.contactName,
         required this.createUserId,
         required this.updateUserId,
    });

    int id;
    int userId;
    String address;
    String addressLineOne;
    String addressLineTwo;
    String postCode;
    String city;
    String country;
    dynamic location;
    String latitude;
    String longitude;
    String addressLabel;
    dynamic landMark;
    int status;
    DateTime createdOn;
    DateTime updatedOn;
    dynamic contactNo;
    dynamic contactName;
    int createUserId;
    int updateUserId;

    factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        userId: json["user_id"],
        address: json["address"],
        addressLineOne: json["address_line_one"],
        addressLineTwo: json["address_line_two"],
        postCode: json["post_code"],
        city: json["city"],
        country: json["country"],
        location: json["location"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        addressLabel: json["address_label"],
        landMark: json["land_mark"],
        status: json["status"],
        createdOn: DateTime.parse(json["created_on"]),
        updatedOn: DateTime.parse(json["updated_on"]),
        contactNo: json["contact_no"],
        contactName: json["contact_name"],
        createUserId: json["create_user_id"],
        updateUserId: json["update_user_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "address": address,
        "address_line_one": addressLineOne,
        "address_line_two": addressLineTwo,
        "post_code": postCode,
        "city": city,
        "country": country,
        "location": location,
        "latitude": latitude,
        "longitude": longitude,
        "address_label": addressLabel,
        "land_mark": landMark,
        "status": status,
        "created_on": "${createdOn.year.toString().padLeft(4, '0')}-${createdOn.month.toString().padLeft(2, '0')}-${createdOn.day.toString().padLeft(2, '0')}",
        "updated_on": "${updatedOn.year.toString().padLeft(4, '0')}-${updatedOn.month.toString().padLeft(2, '0')}-${updatedOn.day.toString().padLeft(2, '0')}",
        "contact_no": contactNo,
        "contact_name": contactName,
        "create_user_id": createUserId,
        "update_user_id": updateUserId,
    };
}
