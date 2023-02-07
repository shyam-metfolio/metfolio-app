import 'dart:convert';
import 'package:base_project_flutter/api_services/ApiHelper.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/apiConstants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../globalFuctions/globalFunctions.dart';

class StripePaymentApi {
  getEncode() async {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var stripesecretKey = sharedPrefs.getString('stripesecretKey');
    String encoded = stringToBase64.encode(stripesecretKey.toString());
    print('encoded');
    print(encoded);
    return encoded;
  }

  // Future<Map<String, dynamic>>
  _createCustomer() async {
    final client = http.Client();
    var encoded = await getEncode();
    Map<String, String> headers = {
      'Authorization': 'Basic ' + encoded,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/customers';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {'description': 'narasimha'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to register as a customer.';
    }
  }

  // Future<Map<String, dynamic>>
  _createPaymentIntents() async {
    final client = http.Client();
    var encoded = await getEncode();
    Map<String, String> headers = {
      'Authorization': 'Basic ' + encoded,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/payment_intents';

    Map<String, dynamic> body = {
      'amount': '2000',
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response =
        await client.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to create PaymentIntents.';
    }
  }

  // Future<void>
  _createCreditCard(String customerId, String paymentIntentClientSecret) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      applePay: PaymentSheetApplePay(
        merchantCountryCode: 'IN',
      ),
      googlePay: PaymentSheetGooglePay(merchantCountryCode: 'IN'),
      style: ThemeMode.dark,
      // testEnv: true,
      // merchantCountryCode: 'JP',
      merchantDisplayName: 'Flutter Stripe Store Demo',
      customerId: customerId,
      paymentIntentClientSecret: paymentIntentClientSecret,
    ));

    await Stripe.instance.presentPaymentSheet();
  }

  // Future<void> payment() async {
  //   _init();
  //   final _customer = await _createCustomer();
  //   final _paymentIntent = await _createPaymentIntents();
  //   await _createCreditCard(_customer['id'], _paymentIntent['client_secret']);
  // }

  // Future<Map<String, dynamic>>
  _createPaymentMethod(
      {required String number,
      required String expMonth,
      required String expYear,
      required String cvc}) async {
    final client = http.Client();
    var encoded = await getEncode();

    Map<String, String> headers = {
      'Authorization': 'Basic ' + encoded,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/payment_methods';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'type': 'card',
        'card[number]': '$number',
        'card[exp_month]': '$expMonth',
        'card[exp_year]': '$expYear',
        'card[cvc]': '$cvc',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to create PaymentMethod.';
    }
  }

  // Future<Map<String, dynamic>>
  attachPaymentMethod(String paymentMethodId, String customerId) async {
    final client = http.Client();
    var encoded = await getEncode();

    Map<String, String> headers = {
      'Authorization': 'Basic ' + encoded,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url =
        'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'customer': customerId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to attach PaymentMethod.';
    }
  }

  // Future<Map<String, dynamic>>
  updateCustomer(String paymentMethodId, String customerId) async {
    final client = http.Client();
    var encoded = await getEncode();

    Map<String, String> headers = {
      'Authorization': 'Basic ' + encoded,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/customers/$customerId';

    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'invoice_settings[default_payment_method]': paymentMethodId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to update Customer.';
    }
  }

  // Future<Map<String, dynamic>> _createSubscriptions(String customerId) async {
  //   String encoded = '';
  //   setState(() {
  //     encoded = stringToBase64.encode(
  //         'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE');
  //     print('encoded');
  //     print(encoded);
  //   });

  //   Map<String, String> headers = {
  //     'Authorization': 'Basic ' + encoded,
  //     'Content-Type': 'application/x-www-form-urlencoded'
  //   };
  //   final String url = 'https://api.stripe.com/v1/subscriptions';

  //   Map<String, dynamic> body = {
  //     'customer': customerId,
  //     'items[0][price]': '100',
  //   };

  //   var response =
  //       await client.post(Uri.parse(url), headers: headers, body: body);
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     print(json.decode(response.body));
  //     throw 'Failed to register as a subscriber.';
  //   }
  // }

  // Future<void>
  subscriptions() async {
    _init();
    final _customer = await _createCustomer();
    print('_customer>>>>>>>>>>>');
    print(_customer);
    // final _paymentMethod = await _createPaymentMethod(
    //     number: '4242424242424242', expMonth: '03', expYear: '23', cvc: '123');
    // print("_paymentMethod>>>>>>>>>");
    // print(_paymentMethod);
    // final _attachMethod =
    //     await _attachPaymentMethod(_paymentMethod['id'], _customer['id']);
    // print('_attachMethod>>>>>>>');
    // print(_attachMethod);
    // final _updateCustomers =
    //     await _updateCustomer(_paymentMethod['id'], _customer['id']);
    // print('_updateCustomers>>>>>');
    // print(_updateCustomers);
    // return _customer['id'];
    // await _createSubscriptions(_customer['id']);
  }

  // void
  static _init() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    Stripe.publishableKey = sharedPrefs.getString('stripePublicKey').toString();
  }

//   CardDetails _card = CardDetails(
//     number: number,
//     expirationYear: expirationYear,
//     expirationMonth: expirationMonth,
//     cvc: cvc);
// await Stripe.instance.dangerouslyUpdateCardDetails(_card);
// final billingDetails = BillingDetails();
// final paymentMethod =
// await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
//   billingDetails: billingDetails,
// ));
  getCustomerCards(context, String customerId) async {
    final client = http.Client();
    var encoded = await getEncode();
    print('customerId>>>>>>>>>>>');
    print(customerId);
    Map<String, String> headers = {
      'Authorization': 'Basic ' + encoded,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/payment_methods';

    var request = http.Request(
        'GET', Uri.parse('https://api.stripe.com/v1/payment_methods'));
    request.bodyFields = {'customer': customerId, 'type': 'card'};
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('response.statusCode');
    print(response.statusCode);
    if (response.statusCode == 200) {
      var value = await response.stream.bytesToString();
      var jsonResponse = value.toString();
      return json.decode(jsonResponse);
    } else {
      print("card list error " + response.statusCode.toString());
      // Twl.errorHandler(context, response.statusCode);
    }
  }

  //  confirmGoalPayment
  addPaymentCardDetails(BuildContext context, String pmId, String cusID) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = PAYMENTMETHODATTCH + headers['auth_code'];
    Map<String, String> params = {'pm_id': pmId, 'stripe_create_cusId': cusID};
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  // getcustomer details
  getCustomerPaymentDetails(context, String cusId) async {
    final client = http.Client();
    var encoded = await getEncode();
    var headers = {
      'Authorization': 'Basic ' + encoded,
    };
    var request = http.Request(
        'GET', Uri.parse('https://api.stripe.com/v1/customers/${cusId}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var value = await response.stream.bytesToString();
      var jsonResponse = value.toString();
      return json.decode(jsonResponse);
    } else {
      print("error " + response.statusCode.toString());
      // Twl.errorHandler(context, response.statusCode);
    }
  }

  // detach card
  detachCardDetails(context, String pmID) async {
    final client = http.Client();
    var encoded = await getEncode();
    print('pmID>>>');
    print(pmID);
    var headers = {
      'Authorization': 'Basic ' + encoded,
    };
    var request = http.Request('POST',
        Uri.parse('https://api.stripe.com/v1/payment_methods/${pmID}/detach'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('response');
    print(response);
    if (response.statusCode == 200) {
      var value = await response.stream.bytesToString();
      var jsonResponse = value.toString();
      return json.decode(jsonResponse);
    } else {
      print(response.statusCode);
      // Twl.errorHandler(context, response.statusCode);
    }
  }

  // capture payment
  capturePayment(context, String pID) async {
    final client = http.Client();
    var encoded = await getEncode();
    print('pmID>>>');
    print(pID);
    var headers = {
      'Authorization': 'Basic ' + encoded,
    };
    var request = http.Request('POST',
        Uri.parse('https://api.stripe.com/v1/payment_methods/${pID}/capture'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('response');
    print(response);
    if (response.statusCode == 400) {
      var value = await response.stream.bytesToString();
      var jsonResponse = value.toString();
      return json.decode(jsonResponse);
    } else {
      print(response.statusCode);
      // Twl.errorHandler(context, response.statusCode);
    }
  }

  // create paymentintent
  createPaymentIntent(context, String amount, String currency, String pmId,
      paymentToken, refund, cvcToken) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = CREATEPAYMENTINTENT + headers['auth_code'];
    Map<String, String> params;
    if (refund == true) {
      params = {
        'amount': amount,
        'currency': currency,
        'setup_future_usage': 'off_session',
        'payment_method': pmId,
        // 'confirmation_method': 'manual',
        // 'confirm': 'true',
        // 'payment_method_options[card][cvc_token]': paymentToken,
        'metadata[is_refund]': refund.toString(),
        'cvc_token': cvcToken
      };
    } else {
      params = {
        'amount': amount,
        'currency': currency,
        'setup_future_usage': 'on_session',
        'payment_method': pmId,
        // 'confirmation_method': 'manual',
        // 'confirm': 'true',
        // 'payment_method_options[card][cvc_token]': paymentToken,
        'cvc_token': cvcToken
      };
    }
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;
  }

  // create cvc
  createCvcToken(context, String cvc) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = CREATECVCTOKEN + headers['auth_code'];
    Map<String, String> params = {
      'cvc_update[cvc]': cvc,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);

    return jsonMap;
  }

  // crate setupintent

  // capture payment
  createSetUpIntent(context, String cusId) async {
    final client = http.Client();
    var encoded = await getEncode();
    print('cusId>>>');
    print(cusId);
    var headers = {
      'Authorization': 'Basic ' + encoded,
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.stripe.com/v1/setup_intents'));

    request.headers.addAll(headers);

    request.bodyFields = {'customer': cusId, 'payment_method_types[]': 'card'};
    http.StreamedResponse response = await request.send();
    print('response');
    print(response);
    if (response.statusCode == 200) {
      var value = await response.stream.bytesToString();
      var jsonResponse = value.toString();
      return json.decode(jsonResponse);
    } else {
      print(response.statusCode);
      // Twl.errorHandler(context, response.statusCode);
    }
  }
}
