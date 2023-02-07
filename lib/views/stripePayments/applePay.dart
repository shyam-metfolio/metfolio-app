import 'dart:convert';

import 'package:base_project_flutter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApplePayScreen extends StatefulWidget {
  @override
  _ApplePayScreenState createState() => _ApplePayScreenState();
}

class _ApplePayScreenState extends State<ApplePayScreen> {
  @override
  void initState() {
    Stripe.instance.isApplePaySupported.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    Stripe.instance.isApplePaySupported.removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (Stripe.instance.isApplePaySupported.value)
          ApplePayButton(
            onPressed: _handlePayPress,
          )
        else
          Text('Apple Pay is not available in this device'),
      ],
    );
  }

  Future<void> _handlePayPress() async {
    try {
      // 1. Present Apple Pay sheet
      await Stripe.instance.presentApplePay(
        params: ApplePayPresentParams(
          cartItems: [
            ApplePayCartSummaryItem.immediate(
              label: 'Product Test',
              amount: '0.01',
            ),
          ],
          country: 'Es',
          currency: 'EUR',
        ),
      );

      // 2. fetch Intent Client Secret from backend
      final response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['clientSecret'];

      // 2. Confirm apple pay payment
      await Stripe.instance.confirmApplePayPayment(clientSecret);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text('Apple Pay payment succesfully completed')),
      // );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    }
  }

  fetchPaymentIntentClientSecret() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId;
    setState(() {
      userId = sharedPreferences.getString('userId');
    });
    // var orderId = userId + '_' + getRandomString(15);
    print(userId);
    // print(cusId);
    // print(orderId);
    try {
      Map<String, dynamic> body = {
        'amount': '100',
        'currency': currency,
        'payment_method_types[]': 'card',
        'metadata[userid]': userId,
        'customer': 'cus_MNfpMgXmYsMNU4',
        // 'payment_method': paymentMoethod,
        'setup_future_usage': 'off_session'
      };
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(stripeScritKey);
      print('encoded');
      print(encoded);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Basic ' + encoded,
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }
}
