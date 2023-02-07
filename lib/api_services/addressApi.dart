import 'dart:convert';
import 'dart:io';

import 'package:base_project_flutter/api_services/ApiHelper.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../globalFuctions/globalFunctions.dart';

class AddressApi {
  searchAddressByPostalCode(BuildContext context, String postalcode) async {
    var jsonMap;
    var uri =
        'https://api.getaddress.io/find/${postalcode}?api-key=${addressKey}&expand=true';
    var client = http.Client();
    try {
      var response = await client.get(Uri.parse(uri));
      print(uri);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        jsonMap = json.decode(jsonString);

        return jsonMap;
      } else {
        print(response.statusCode);
        // Twl.errorHandler(context, response.statusCode);
      }
    } on SocketException {
      print("error");
      // throw ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Check Internet'),
      // ));
    } catch (exception) {
      return jsonMap;
    }
  }

  // return jsonMap;
  // }
}
