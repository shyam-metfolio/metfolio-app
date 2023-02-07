// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class GooglePayStripeScreen extends StatefulWidget {
//   const GooglePayStripeScreen({Key? key}) : super(key: key);

//   @override
//   _GooglePayStripeScreenState createState() => _GooglePayStripeScreenState();
// }

// class _GooglePayStripeScreenState extends State<GooglePayStripeScreen> {
//   Future<void> startGooglePay() async {
//     final googlePaySupported = await Stripe.instance
//         .isGooglePaySupported(IsGooglePaySupportedParams());
//     if (googlePaySupported) {
//       try {
//         // 1. fetch Intent Client Secret from backend
//         final response = await fetchPaymentIntentClientSecret();
//         final clientSecret = response['client_secret'];
//         print(response);
//         print(clientSecret);
//         // 2.present google pay sheet
//         await Stripe.instance.initGooglePay(GooglePayInitParams(
//             testEnv: true,
//             merchantName: "Example Merchant Name",
//             countryCode: 'IN'));

//         await Stripe.instance.presentGooglePay(
//           PresentGooglePayParams(clientSecret: clientSecret),
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Google Pay payment succesfully completed')),
//         );
//       } catch (e) {
//          print("narsimha");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } else {

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Google pay is not supported on this device')),
//       );
//     }
//   }

//   // Future<Map<String, dynamic>>
//   fetchPaymentIntentClientSecret() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var userId;
//     setState(() {
//       userId = sharedPreferences.getString('userId');
//     });
//     // var orderId = userId + '_' + getRandomString(15);
//     print(userId);
//     // print(cusId);
//     // print(orderId);
//     try {
//       Map<String, dynamic> body = {
//         'amount': '100',
//         'currency': "INR",
//         'payment_method_types[]': 'card',
//         'metadata[userid]': userId,
//         'customer': 'cus_MNfpMgXmYsMNU4',
//         // 'payment_method': paymentMoethod,
//         'setup_future_usage': 'off_session'
//       };
//       Codec<String, String> stringToBase64 = utf8.fuse(base64);
//       String encoded = stringToBase64.encode(
//           'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE');
//       print('encoded');
//       print(encoded);
//       var response = await http.post(
//           Uri.parse('https://api.stripe.com/v1/payment_intents'),
//           body: body,
//           headers: {
//             'Authorization': 'Basic ' + encoded,
//             'Content-Type': 'application/x-www-form-urlencoded'
//           });
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (defaultTargetPlatform == TargetPlatform.android)
//           SizedBox(
//             height: 75,
//             child: GooglePayButton(
//               onTap: () {
//                 startGooglePay();
//               },
//             ),
//           )
//         else
//           Text('Google Pay is not available in this device'),
//       ],
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart' as pay;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

const _paymentItems = [
  pay.PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: pay.PaymentItemStatus.final_price,
  )
];

class GooglePayScreen extends StatefulWidget {
  @override
  _GooglePayScreenState createState() => _GooglePayScreenState();
}

class _GooglePayScreenState extends State<GooglePayScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pay.GooglePayButton(
          paymentConfigurationAsset: 'google_pay_payment_profile.json',
          paymentItems: _paymentItems,
          margin: const EdgeInsets.only(top: 15),
          onPaymentResult: onGooglePayResult,
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),
          onPressed: () async {
            // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
            await debugChangedStripePublishableKey();
          },
          childOnError: Text('Google Pay is not available in this device'),
          onError: (e) {
            print('error' + e.toString());
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text(
            //         'There was an error while trying to perform the payment'),
            //   ),
            // );
          },
        ),
      ],
    );
  }

  Future<void> onGooglePayResult(paymentResult) async {
    try {
      // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json

      debugPrint(paymentResult.toString());
      // 2. fetch Intent Client Secret from backend
      final response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['clientSecret'];
      final token =
          paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));
      print(tokenJson);

      final params = PaymentMethodParams.cardFromToken(
        paymentMethodData: PaymentMethodDataCardFromToken(
          token: tokenJson['id'], // TODO extract the actual token
        ),
      );

      // 3. Confirm Google pay payment method
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: params,
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text('Google Pay payment succesfully completed')),
      // );
    } catch (e) {
      print('error' + e.toString());
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

  Future<void> debugChangedStripePublishableKey() async {
    if (kDebugMode) {
      final profile =
          await rootBundle.loadString('assets/google_pay_payment_profile.json');
      final isValidKey = !profile.contains('<ADD_YOUR_KEY_HERE>');
      assert(
        isValidKey,
        'No stripe publishable key added to assets/google_pay_payment_profile.json',
      );
    }
  }
}
