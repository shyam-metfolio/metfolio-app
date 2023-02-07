import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../constants/constants.dart';
import '../../globalWidgets/button.dart';

class StripePayment extends StatefulWidget {
  StripePayment({Key? key}) : super(key: key);

  @override
  State<StripePayment> createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  final client = http.Client();
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  Future<Map<String, dynamic>> _createCustomer() async {
    String encoded = '';
    setState(() {
      encoded = stringToBase64.encode(
          stripeScritKey);
      print('encoded');
      print(encoded);
    });

    Map<String, String> headers = {
      'Authorization': 'Basic ' + encoded,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/customers';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {'description': 'new customer'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to register as a customer.';
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntents() async {
    String encoded = '';
    setState(() {
      encoded = stringToBase64.encode(
          stripeScritKey);
      print('encoded');
      print(encoded);
    });

    Map<String, String> headers = {
      'Authorization': 'Basic ' + encoded,
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final String url = 'https://api.stripe.com/v1/payment_intents';

    Map<String, dynamic> body = {
      'amount': '2000',
      'currency': 'INR',
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

  Future<void> _createCreditCard(
      String customerId, String paymentIntentClientSecret) async {
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

  Future<void> payment() async {
    _init();
    final _customer = await _createCustomer();
    final _paymentIntent = await _createPaymentIntents();
    await _createCreditCard(_customer['id'], _paymentIntent['client_secret']);
  }

  Future<Map<String, dynamic>> _createPaymentMethod(
      {required String number,
      required String expMonth,
      required String expYear,
      required String cvc}) async {
    String encoded = '';
    setState(() {
      encoded = stringToBase64.encode(
          stripeScritKey);
      print('encoded');
      print(encoded);
    });

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

  Future<Map<String, dynamic>> _attachPaymentMethod(
      String paymentMethodId, String customerId) async {
    String encoded = '';
    setState(() {
      encoded = stringToBase64.encode(
          stripeScritKey);
      print('encoded');
      print(encoded);
    });

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

  Future<Map<String, dynamic>> _updateCustomer(
      String paymentMethodId, String customerId) async {
    String encoded = '';
    setState(() {
      encoded = stringToBase64.encode(
          stripeScritKey);
      print('encoded');
      print(encoded);
    });

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

  Future<void> subscriptions() async {
    _init();
    final _customer = await _createCustomer();
    print('_customer>>>>>>>>>>>');
    print(_customer);
    final _paymentMethod = await _createPaymentMethod(
        number: '4242424242424242', expMonth: '03', expYear: '23', cvc: '123');
    print("_paymentMethod>>>>>>>>>");
    print(_paymentMethod);
    final _attachMethod =
        await _attachPaymentMethod(_paymentMethod['id'], _customer['id']);
    print('_attachMethod>>>>>>>');
    print(_attachMethod);
    final _updateCustomers =
        await _updateCustomer(_paymentMethod['id'], _customer['id']);
    print('_updateCustomers>>>>>');
    print(_updateCustomers);
    // await _createSubscriptions(_customer['id']);
  }

  Future<void> _init() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        child: Align(
          alignment: Alignment.center,
          child: Button(
              borderSide: BorderSide.none,
              color: tPrimaryColor,
              textcolor: tWhite,
              bottonText: 'Confirm',
              onTap: (startLoading, stopLoading, btnState) async {
                subscriptions();
              }),
        ),
      ),
    );
  }
}
