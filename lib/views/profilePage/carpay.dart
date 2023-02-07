// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:stripe_payment/stripe_payment.dart';

// class StripeTransactionResponse {
//   String message;
//   bool success;
//   StripeTransactionResponse({required this.message, required this.success});
// }

// class StripeService {
//   static String apiBase = 'https://api.stripe.com/v1';
//   static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';

//   static String publishableKey="pk_test_51LaF4HSAI1ruU8VXf2zkAIMx3lGAIEF6OEE5IUpsi2s3rzgLNAZv8c65Qatl5oJsrIBBjE5w5u2ADkeB4uhYgFUr00kqGJhvrn";
//   static String secret_key =   'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE'; //your secret from stripe dashboard
//   static Map<String, String> headers = {
//     'Authorization': 'Bearer ${secret_key}',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//   static init() {
//     StripePayment.setOptions(StripeOptions(
//         publishableKey:
//         publishableKey,
//         merchantId: "Test",
//         androidPayMode: 'test'));
//   }

//   static Future<StripeTransactionResponse> payViaExistingCard(
//       {required String amount, required String currency, required CreditCard card}) async {
//     try {
//       var paymentMethod = await StripePayment.createPaymentMethod(PaymentMethodRequest(card: card));
//       var paymentIntent = await StripeService.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent!['client_secret'], paymentMethodId: paymentMethod.id));
//       if (response.status == 'succeeded') {
//         return new StripeTransactionResponse(message: 'Transaction successful', success: true);
//       } else {
//         return new StripeTransactionResponse(message: 'Transaction failed', success: false);
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction failed: ${err.toString()}', success: false);
//     }
//   }

//   static Future<StripeTransactionResponse> payWithNewCard({required String amount, required String currency}) async {
//     try {
//       var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
//       var paymentIntent = await StripeService.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent!['client_secret'], paymentMethodId: paymentMethod.id));
//       if (response.status == 'succeeded') {
//         return new StripeTransactionResponse(message: 'Transaction successful', success: true);
//       } else {
//         return new StripeTransactionResponse(message: 'Transaction failed', success: false);
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction failed: ${err.toString()}', success: false);
//     }
//   }

//   static getPlatformExceptionErrorResult(err) {
//     String message = 'Something went wrong';
//     if (err.code == 'cancelled') {
//       message = 'Transaction cancelled';
//     }

//     return new StripeTransactionResponse(message: message, success: false);
//   }

//   static Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       var response =
//       await http.post(Uri.parse(StripeService.paymentApiUrl), body: body, headers: StripeService.headers);
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//     return null;
//   }
// }
// class ExistingCardsPage extends StatefulWidget {
//   ExistingCardsPage({Key? key}) : super(key: key);

//   @override
//   ExistingCardsPageState createState() => ExistingCardsPageState();
// }

// class ExistingCardsPageState extends State<ExistingCardsPage> {
//   List cards = [
//     {
//       'cardNumber': '4242424242424242',
//       'expiryDate': '04/24',
//       'cardHolderName': 'John Doe',
//       'cvvCode': '424',
//       'showBackView': false,
//     },
//     {
//       'cardNumber': '5555555566554444',
//       'expiryDate': '04/23',
//       'cardHolderName': 'Jerim Kaura',
//       'cvvCode': '123',
//       'showBackView': false,
//     },
//     {
//       'cardNumber': '3755555566554444',
//       'expiryDate': '04/27',
//       'cardHolderName': 'Van Waler',
//       'cvvCode': '123',
//       'showBackView': false,
//     }
//   ];

//   payViaExistingCard(BuildContext context, card) async {
//    // ProgressDialog dialog = new ProgressDialog(context);
//   //  dialog.style(message: 'Please wait...');
//    // await dialog.show();
//     var expiryArr = card['expiryDate'].split('/');
//     CreditCard stripeCard = CreditCard(
//       number: card['cardNumber'],
//       expMonth: int.parse(expiryArr[0]),
//       expYear: int.parse(expiryArr[1]),
//     );
//     var response =
//     await StripeService.payViaExistingCard(amount: '2500', currency: 'USD', card: stripeCard);
//    // await dialog.hide();
//     Scaffold.of(context)
//         .showSnackBar(SnackBar(
//       content: Text(response.message),
//       duration: new Duration(milliseconds: 1200),
//     ))
//         .closed
//         .then((_) {
//       Navigator.pop(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('CHOOSE CARD'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: ListView.builder(
//           itemCount: cards.length,
//           itemBuilder: (BuildContext context, int index) {
//             var card = cards[index];
//             return InkWell(
//               onTap: () {
//                 payViaExistingCard(context, card);
//               },
//               child: Text('craddddd'),
//               // child: CreditCardWidget(
//               //   cardNumber: card['cardNumber'],
//               //   expiryDate: card['expiryDate'],
//               //   cardHolderName: card['cardHolderName'],
//               //   cvvCode: card['cvvCode'],
//               //   showBackView: false, onCreditCardWidgetChange: (CreditCardBrand ) {  },
//               // ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }


// class HomePages extends StatefulWidget {
//   HomePages({Key? key}) : super(key: key);

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePages> {
//   List<String>card=List.empty(growable: true);
//   bool isLoading=false;
//   onItemPress(BuildContext context, int index) async {
//     switch (index) {
//       case 0:
//         payViaNewCard(context);
//         break;
//       case 1:
//         Navigator.pushNamed(context, '/existing-cards');
//         break;
//     }
//   }

//   payViaNewCard(BuildContext context) async {
//     //ProgressDialog dialog = new ProgressDialog(context);
//    // dialog.style(message: 'Please wait...');
//     //await dialog.show();
//     setState(() {
//       isLoading=true;
//     });
//     var response = await StripeService.payWithNewCard(amount: '19900', currency: 'USD');
//     setState(() {
//       isLoading=false;
//     });
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Text(response.message),
//       duration:  Duration(milliseconds: 5000),
//     ));
//   }

//   @override
//   void initState() {
//     super.initState();
//     StripeService.init();
//     card.add("With New Card Card");
//     card.add("Choose Existing Card");
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SELECT PAYMENT'),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: Stack(
//           children: [
//             Column(
//             children: [
//               SizedBox(height: 40,),
//               // DialogButton(
//               //   width: 220,
//               //   height: 60,
//               //   child: Text(
//               //     "${199} \$",
//               //     style: TextStyle(color: Colors.white, fontSize: 28),
//               //   ),
//               //   onPressed: ()  {

//               //   },
//               //   gradient: LinearGradient(colors: [
//               //     Color.fromRGBO(72, 239, 25, 1.0),
//               //     Color.fromRGBO(52, 138, 199, 1.0)
//               //   ]),
//               // ),
//               SizedBox(height: 40,),
//               ListView.separated(
//                 shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     Icon icon;
//                     Text text;

//                     switch (index) {
//                       case 0:
//                         icon = Icon(Icons.add_circle, color: theme.primaryColor);
//                         text = Text('Pay via new card');
//                         break;
//                       case 1:
//                         icon = Icon(Icons.credit_card, color: theme.primaryColor);
//                         text = Text('Pay via existing card');
//                         break;
//                     }

//                     return InkWell(
//                       onTap: () {
//                         onItemPress(context, index);
//                       },
//                       child: ListTile(
//                         title: Text(card[index],style: TextStyle(fontSize: 20),),
//                         leading: Icon(Icons.credit_card_outlined,color: Colors.orange,),
//                       ),
//                     );
//                   },
//                   separatorBuilder: (context, index) => Divider(
//                     color: theme.primaryColor,
//                   ),
//                   itemCount: card.length),
//             ],
//           ),
//             if(isLoading)Center(child: CircularProgressIndicator(),)

//       ],
//         ),
//       ),
//     );
//   }
// }