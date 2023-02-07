// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:base_project_flutter/api_services/ApiHelper.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/models/myAddressesModel.dart';

import 'package:date_utils/date_utils.dart' as utls;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/apiConstants.dart';
import '../models/myOrders.dart';

class UserAPI {
  //Send OTP
  static sendOtp(BuildContext context, String username) async {
    String jsonResponse;
    var url = apiBaseUrl + SEND_OTP;
    print(url);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({'contact_no': username});
    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        jsonResponse = value.toString();

        var currentUser = json.decode(jsonResponse);
        print(currentUser);

        return currentUser;
      } else {
        Twl.errorHandler(context, response.statusCode);
        print(response.reasonPhrase);
      }
    } on SocketException {
      print("error");
      throw ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Check Internet'),
      ));
      // Twl.createAlert(context,'dfd','dfdfd');

    }
  }

  //Verify OTP
  verifyOtp(
      BuildContext context,
      String username,
      // String sessionId,
      String otpCode,
      String deviceToken,
      String deviceType) async {
    String jsonResponse;
    var url = apiBaseUrl + VERIFY_OTP;
    print(url);
    print(deviceToken);
    // print(sessionId);
    print(otpCode);
    print(username);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields.addAll({
      'contact_no': username,
      'otp_code': otpCode,
      'device_token': deviceToken,
      'device_type': deviceType,
      // 'session_code': sessionId
    });
    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var value = await response.stream.bytesToString();

        jsonResponse = value.toString();
        print(jsonResponse);
        var currentUser = json.decode(jsonResponse);

        return currentUser;
      } else {
        // Twl.errorHandler(context, response.statusCode);
        print(response.reasonPhrase);
      }
    } on SocketException {
      print("error");
      // throw ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Check Internet'),
      // ));
      // Twl.createAlert(context,'dfd','dfdfd');

    }
  }

  //Verify OTP
  verifyPasscodeOtp(
    BuildContext context,
    String contactNo,
    // String sessionId,
    String otpCode,
  ) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = VERIFF + headers['auth_code'];
    Map<String, String> params = {
      'contact_no': contactNo,
      'otp_code': otpCode,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    return jsonMap;
  }

  getHeader(BuildContext context) async {
    late String authCode;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    authCode = sharedPreferences.getString('authCode')!;
    if (authCode != null) {
      authCode = authCode;
    } else {
      authCode = '1';
    }
    try {
      var res = await UserAPI().checkApi(authCode);
      print('API Authcode');
      print(authCode);
      print(res);
      if (res != null || res['status'] == "OK") {
        // print(res);
        return {
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'keep-alive',
          'Accept': ' application/json',
          'Accept-Encoding': 'gzip, deflate, br',
          'auth_code': authCode,
        };
      } else {
        return {
          'Content-Type': 'application/json; charset=UTF-8',
          'Connection': 'keep-alive',
          'Accept': ' application/json',
          'Accept-Encoding': 'gzip, deflate, br',
          'auth_code': '1',
        };
      }
    } on SocketException {
      throw ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Check Internet'),
      ));
      // Twl.createAlert(context,'dfd','dfdfd');

    }
  }

//Check API
  checkApi(authCode) async {
    var client = http.Client();
    var url = apiBaseUrl + CHECK_API + authCode;
    var jsonMap;
    try {
      var response = await client.get(Uri.parse(url));
      print(response);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        jsonMap = json.decode(jsonString);
        return jsonMap;
      } else {
        print(response.statusCode);
      }
    } on SocketException {
      print("error");
    } catch (exception) {
      return jsonMap;
    }
  }

  updateProfile(BuildContext context, String firstName, String lastName,
      String email, String dob, String country) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = SIGNUP + headers['auth_code'];
    Map<String, String> params = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'date_of_birth': dob,
      'profile_image': '',
      'country': country
      // 'pin_code': pinCode,
      // 'address': address
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    var response = jsonMap;

    return response;
  }

  logout(BuildContext context) async {
    var response;
    var jsonMap;
    var url;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var authCode = sharedPreferences.getString('authCode');
    var headers = await UserAPI().getHeader(
      context,
    );
    url = LOGOUT + headers['auth_code'];
    print(url);
    jsonMap = await ApiHelper().getTypeGet(context, url);
    response = jsonMap;
    await sharedPreferences.clear();
    sharedPreferences.remove(authCode!);
    print("User Signed Out");
    return response;
  }

  veriff(BuildContext context, String firstName, String lastName,
      String idNumber) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = VERIFF + headers['auth_code'];
    Map<String, String> params = {
      'firstName': firstName,
      'lastName': lastName,
      'idNumber': idNumber,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  veriffCallBack(BuildContext context, String status, sessionId) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri =
        VERIFFCALLBACK + headers['auth_code'] + '&verificationId=' + sessionId;
    Map<String, String> params = {
      'status': status,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  checkUser(
    BuildContext context,
    String number,
  ) async {
    var jsonMap;
    var uri = CHECKUSER;
    Map<String, String> params = {
      'contact_no': number,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  // add to cart
  Future<MyOrderDetialsModel> getMyOrders(
      BuildContext context, String page, String goldType) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = MYORDERS + headers['auth_code'];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var startdate = sharedPreferences.getString('startDate');
    // var enddate = sharedPreferences.getString('endDate');
    var startdate;
    var enddate;
    if (goldType == '1' || goldType == '2') {
      var now = new DateTime.now();
      var formatter = new DateFormat('yyyy-MM-dd 00:00:00');
      var endformatter = new DateFormat('yyyy-MM-dd 23:59:59');
      print(utls.DateUtils.firstDayOfMonth(now));
      print(utls.DateUtils.lastDayOfMonth(now));
      startdate = formatter.format(utls.DateUtils.firstDayOfMonth(now));
      enddate = endformatter.format(utls.DateUtils.lastDayOfMonth(now));
      final DateFormat filteredValueformatter = DateFormat('MMMM yyyy');
      var filtervalue =
          filteredValueformatter.format(DateTime.parse(now.toString()));
      sharedPreferences.setString('filteredValue', filtervalue);
    } else {
      if (sharedPreferences.getString('startDate') != null &&
          sharedPreferences.getString('endDate') != null &&
          sharedPreferences.getString('startDate') != '' &&
          sharedPreferences.getString('endDate') != '') {
        startdate = sharedPreferences.getString('startDate');
        enddate = sharedPreferences.getString('endDate');
        final DateFormat filteredValueformatter = DateFormat('MMMM yyyy');
        var filtervalue =
            filteredValueformatter.format(DateTime.parse(startdate));
        sharedPreferences.setString('filteredValue', filtervalue);
      } else {
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd 00:00:00');
        var endformatter = new DateFormat('yyyy-MM-dd 23:59:59');
        print(utls.DateUtils.firstDayOfMonth(now));
        print(utls.DateUtils.lastDayOfMonth(now));
        startdate = formatter.format(utls.DateUtils.firstDayOfMonth(now));
        enddate = endformatter.format(utls.DateUtils.lastDayOfMonth(now));
        final DateFormat filteredValueformatter = DateFormat('MMMM yyyy');
        var filtervalue =
            filteredValueformatter.format(DateTime.parse(now.toString()));
        sharedPreferences.setString('filteredValue', filtervalue);
      }
    }

    print(uri);
    print(' startdate  enddate >>>>>>');
    print(startdate);
    print(enddate);
    Map<String, String> params = {
      'page': page,
      'start_date': startdate ?? '',
      'end_date': enddate ?? '',
      'gold_type': goldType
      // '2022-08-10 23:59:59'
      // enddate??''
    };
    print(uri);
    print(params);

    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    var response = MyOrderDetialsModel.fromJson(jsonMap);
    print(response);
    return response;
  }

  // avaliable gold
  checkAvaliableGold(BuildContext context, String goldType) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = TOTALGOLD + headers['auth_code'];
    Map<String, String> params = {
      'gold_type': goldType,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;
  }

  getGoldPrice(BuildContext context) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = GOLDPRICE;
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    // var response = jsonMap;

    return jsonMap;
  }

  // getGoldPrice(BuildContext context) async {
  //   var client = http.Client();
  //   var jsonMap;
  //   var jsonResponse;
  //   var headers = {'x-access-token': 'goldapi-80u6tl6xz09oy-io'};
  //   var date = DateTime.now().add(Duration(days: -1));
  //   var uri = 'https://www.goldapi.io/api/XAU/GBP/';
  //   // +
  //   //     date.toString();
  //   print(uri);
  //   var request = http.Request('GET', Uri.parse(uri));

  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     var value = await response.stream.bytesToString();

  //     jsonResponse = value.toString();

  //     var jsonMap = json.decode(jsonResponse);

  //     return jsonMap;
  //   } else {
  //     print(response.reasonPhrase);
  //     Twl.errorHandler(context, response.statusCode);
  //   }
  // }

  // my goals
  getMyGoals(BuildContext context) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = MYGOALS + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    // var response = jsonMap;

    return jsonMap;
  }

  // GOLDSETTING
  goldSetting(BuildContext context) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = GOLDSETTING;
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    // var response = jsonMap;

    return jsonMap;
  }

  //
  // goldWeightRange(BuildContext context) async {
  //   var jsonMap;
  //   var headers = await getHeader(context);
  //   var uri = GOLDWEIGHTRANGE;
  //   jsonMap = await ApiHelper().getTypeGet(context, uri);
  //   // var response = jsonMap;

  //   return jsonMap;
  // }

  addAddress(BuildContext context, String add1, String add2, String postCode,
      String city, String lat, String lng, String country) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = ADDADDRESS + headers['auth_code'];

    Map<String, String> params = {
      'address_line_one': add1,
      'address_line_two': add2,
      'post_code': postCode,
      'city': city,
      'latitude': lat,
      'longitude': lng,
      'address_label': '',
      'status': '1',
      'country': country
      // 'pin_code': pinCode,
      // 'address': address
    };
    print(params);
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    var response = jsonMap;

    return response;
  }

  // My address
  // add to cart
  Future<MyAddressesModel> getMyAddress(
    BuildContext context,
    String page,
  ) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = MYADDRESS + headers['auth_code'];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var startdate = sharedPreferences.getString('startDate');
    var enddate = sharedPreferences.getString('endDate');
    Map<String, String> params = {'page': page, 'status': '1'};
    print(uri);
    print(params);

    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    var response = MyAddressesModel.fromJson(jsonMap);
    return response;
  }

  addBankAcountDetails(
    context,
    String fullName,
    String accountNumber,
    String bankName,
    String shortCode,
  ) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = ADDBANKACCOUNT + headers['auth_code'];
    Map<String, String> params = {
      'full_name': fullName,
      'account_number': accountNumber,
      'bank_name': bankName,
      'short_code': shortCode,
      'status': '1',
      'currency': 'usd',
      'account_holder_type': 'individual',
      'country': 'US'
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;
  }

  getBankDetails(BuildContext context) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = BANKDETAILS + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    // var response = jsonMap;

    return jsonMap;
  }

  createCustomer(BuildContext context) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = CREATECUSTOMER + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    // var response = jsonMap;

    return jsonMap;
  }

  static getEncode() {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(
        'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE');
    print('encoded');
    print(encoded);
    return encoded;
  }

  confirmPayment(context, String PiId, String PmId) async {
    print('paymentMethodId >>>>>>');
    print(PiId);

    var jsonMap;
    var headers = await getHeader(context);
    var uri = CONFIRMPAYMENTINTENT + headers['auth_code'];
    Map<String, String> params = {
      'payment_method': PmId,
      'pi_Id': PiId,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;

    // final client = http.Client();
    // var encoded = getEncode();
    // print('pm_card_${cardType}');
    // Map<String, String> headers = {
    //   'Authorization': 'Basic ' + encoded,
    //   'Content-Type': 'application/x-www-form-urlencoded'
    // };
    // final String url =
    //     'https://api.stripe.com/v1/payment_intents/${PiId}/confirm';
    // var response = await client.post(
    //   Uri.parse(url),
    //   headers: headers,
    //   body: {
    //     'payment_method': 'pm_card_${cardType}',
    //     // 'payment_method': '${PmId}',

    //     // 'setup_future_usage': 'off_session',
    //     // 'metadata[auto_update_default_payment]':'true'
    //   },
    // );
    // if (response.statusCode == 200) {
    //   return json.decode(response.body);
    // } else {
    //   print(json.decode(response.body));
    //   Twl.errorHandler(context, response.statusCode);
    //   throw 'Failed to attach PaymentMethod.';
    // }
  }

  //Verify Email
  verifyEmail(
    BuildContext context,
    String otp,
  ) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = VERIFYEMAIL + headers['auth_code'];
    Map<String, String> params = {
      'otp': otp,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;
  }

  //Verify Email
  sendEmailOtp(
    BuildContext context,
    String email,
  ) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = SENDEMAILOTP + headers['auth_code'];
    Map<String, String> params = {
      'email': email,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;
  }

  //gold delivery
  goldDelivery(BuildContext context, String qty, String goldType,
      String addressId) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = GOLDDELIVERY + headers['auth_code'];
    Map<String, String> params = {
      'type_id': '5',
      'gold_units': qty,
      'gold_type': goldType,
      'delivery_address_id': addressId,
      'delivery_status': '1'
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;
  }

  enableOrDisableNotification(
    BuildContext context,
    String notificationValue,
  ) async {
    var jsonMap;
    var headers = await getHeader(context);
    var uri = ENABLEORDISABLE + headers['auth_code'];
    Map<String, String> params = {
      'notification': notificationValue,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;
  }

  deleteUser(String type) async {
    var jsonMap;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var authCode = sharedPreferences.getString('authCode')!;
    var uri = apiBaseUrl + DELETEACCOUNT + authCode + '&type=' + type;

    var client = http.Client();

    try {
      var response = await client.get(Uri.parse(uri));
      print(response);
      if (response.statusCode == 200) {
        var jsonString = response.body;
        jsonMap = json.decode(jsonString);
        return jsonMap;
      } else {
        print(response.statusCode);
      }
    } on SocketException {
      print("error");
    } catch (exception) {
      return jsonMap;
    }
  }
}
