// import 'dart:convert';
// import 'package:base_project_flutter/api_services/userApi.dart';
// import 'package:http/http.dart' as http;
// import 'package:base_project_flutter/api_services/orderApi.dart';
// import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';

// import '../../constants/constants.dart';
// import '../../constants/imageConstant.dart';
// import '../../globalFuctions/globalFunctions.dart';
// import '../../globalWidgets/button.dart';
// import '../../responsive.dart';
// import '../components/alertPage.dart';
// import '../successfullPage/thanksForStaetingGoalSucessfull.dart';

// class CustomCardPaymentScreen extends StatefulWidget {
//   const CustomCardPaymentScreen({Key? key}) : super(key: key);

//   @override
//   State<CustomCardPaymentScreen> createState() =>
//       _CustomCardPaymentScreenState();
// }

// class _CustomCardPaymentScreenState extends State<CustomCardPaymentScreen> {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _cardController = TextEditingController();

//   TextEditingController _expiryMonthController = TextEditingController();
//   TextEditingController _expiryYearController = TextEditingController();
//   TextEditingController _cvvController = TextEditingController();

//   final _formKey = new GlobalKey<FormState>();
//   bool loadingPaymentStatus = false;
//   loader(value) {
//     setState(() {
//       loadingPaymentStatus = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//           child: Scaffold(
//             backgroundColor: tWhite,
//             appBar: AppBar(
//               elevation: 0,
//               backgroundColor: tWhite,
//               leading: GestureDetector(
//                 onTap: () {
//                   Twl.navigateBack(context);
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 20),
//                   child: Image.asset(
//                     Images.NAVBACK,
//                     scale: 4,
//                   ),
//                 ),
//               ),
//             ),
//             body: SafeArea(
//               child: Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Please enter your payment details",
//                                 style: TextStyle(
//                                   color: tPrimaryColor,
//                                   fontSize: isTab(context) ? 18.sp : 21.sp,
//                                   // fontWeight: FontWeight.w500,
//                                   fontFamily: 'Signika',
//                                 ),
//                               ),
//                               SizedBox(height: 1.h),
//                               Text(
//                                 "This card will be saved and can be\nused for future Metfolio purchases",
//                                 style: TextStyle(
//                                   color: tSecondaryColor,
//                                   fontSize: isTab(context) ? 9.sp : 12.sp,
//                                   // fontWeight: FontWeight.w500,
//                                   // fontFamily: 'Signika',
//                                 ),
//                               ),
//                               SizedBox(height: 2.h),
//                               titleWidget('Name(as shown on Card)'),
//                               SizedBox(height: 1.h),
//                               TwlNormalTextField(
//                                 controller: _nameController,
//                                 textInputType: TextInputType.name,
//                                 validator: validateName,
//                               ),
//                               SizedBox(height: 3.h),
//                               titleWidget('Card Number'),
//                               SizedBox(height: 1.h),
//                               TwlNormalTextField(
//                                 controller: _cardController,
//                                 textInputType: TextInputType.number,
//                                 validator: validateCard,
//                                 inputForamtters: [
//                                   LengthLimitingTextInputFormatter(16)
//                                 ],
//                               ),
//                               SizedBox(height: 3.h),
//                               titleWidget('Card expiry date'),
//                               SizedBox(height: 1.h),
//                               Padding(
//                                 padding: EdgeInsets.only(right: 40.w),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: TwlNormalTextField(
//                                         controller: _expiryMonthController,
//                                         textInputType: TextInputType.datetime,
//                                         validator: validateExpiryMonth,
//                                         inputForamtters: [
//                                           LengthLimitingTextInputFormatter(2)
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Expanded(
//                                       child: TwlNormalTextField(
//                                         controller: _expiryYearController,
//                                         textInputType: TextInputType.datetime,
//                                         validator: validateExpiryYear,
//                                         inputForamtters: [
//                                           LengthLimitingTextInputFormatter(4)
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 3.h),
//                               titleWidget('CVV'),
//                               SizedBox(height: 1.h),
//                               Padding(
//                                 padding: EdgeInsets.only(right: 50.w),
//                                 child: TwlNormalTextField(
//                                   controller: _cvvController,
//                                   textInputType: TextInputType.number,
//                                   validator: validateCvv,
//                                   inputForamtters: [
//                                     LengthLimitingTextInputFormatter(4)
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 20.w),
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Button(
//                               borderSide: BorderSide.none,
//                               color: tPrimaryColor,
//                               textcolor: tWhite,
//                               bottonText: 'Continue',
//                               onTap:
//                                   (startLoading, stopLoading, btnState) async {
//                                 if (_formKey.currentState!.validate()) {
//                                   //startLoading();
//                                   loader(true);
//                                   var cardnumber = _cardController.text;
//                                   var expMonth = _expiryMonthController.text;
//                                   var expYear = _expiryYearController.text;
//                                   var cvc = _cvvController.text;

//                                   SharedPreferences sharedPrefs =
//                                       await SharedPreferences.getInstance();
//                                   var authCode =
//                                       sharedPrefs.getString('authCode');

//                                   var checkApi =
//                                       await UserAPI().checkApi(authCode);
//                                   print(checkApi);
//                                   if (checkApi != null &&
//                                       checkApi['status'] == "OK") {
//                                     // if (checkApi['detail']['stripe_cus_id'] != null &&
//                                     //     checkApi['detail']['stripe_cus_id'] != '') {
//                                     var cusID;
//                                     if (checkApi['detail']['stripe_cus_id'] ==
//                                             null ||
//                                         checkApi['detail']['stripe_cus_id'] ==
//                                             "") {
//                                       print("dibdsn");
//                                       var customerRes = await UserAPI()
//                                           .createCustomer(context);
//                                       print(customerRes);
//                                       if (customerRes != null &&
//                                           customerRes['status'] == "OK") {
//                                         setState(() {
//                                           cusID = customerRes['details']
//                                               ['stripe_cus_id'];
//                                         });
//                                         sharedPrefs.setString("cusId", cusID);
//                                       }
//                                     } else {
//                                       setState(() {
//                                         cusID =
//                                             checkApi['detail']['stripe_cus_id'];
//                                       });
//                                     }
//                                     print("cusID>>>>>>>>>>>>>>");
//                                     print(cusID);
//                                     var res = await OrderAPI()
//                                         .createGoalPayment(
//                                             context,
//                                             cardnumber,
//                                             expMonth,
//                                             expYear,
//                                             cvc,
//                                             _nameController.text);
//                                     print('createGoalPayment>>>>>>>>>>');
//                                     loader(false);
//                                     stopLoading();
//                                     print(res);
//                                     print(res['details']['card']['networks']
//                                         ['available'][0]);
//                                     print(cusID);

//                                     var paymentIntentData =
//                                         await createPaymentIntent('1', 'INR',
//                                             cusID, res['details']['id']);
//                                     print("paymentIntentData>>>>>>>>>");
//                                     print(paymentIntentData);
//                                     print(paymentIntentData['id']);
//                                     var cardType = res['details']['card']
//                                         ['networks']['available'][0];
//                                     var confirmRes = await UserAPI()
//                                         .confirmPayment(context,
//                                             paymentIntentData['id'], cardType);
//                                     print('confirmRes>>>>>>>>>>');
//                                     print(confirmRes);
//                                     print(confirmRes['next_action']
//                                         ['use_stripe_sdk']['stripe_js']);
//                                     loader(false);
//                                     stopLoading();
//                                     // }
//                                   }
//                                 }
//                               }),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 1.h,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (loadingPaymentStatus)
//           Center(
//             child: Container(
//               color: tBlack.withOpacity(0.3),
//               // padding:
//               //     EdgeInsets.only(top: 100),
//               height: 100.h,
//               width: 100.w,
//               alignment: Alignment.center,
//               child: CircularProgressIndicator(
//                 color: tPrimaryColor,
//               ),
//             ),
//           )
//       ],
//     );
//   }

//   createPaymentIntent(
//       String amount, String currency, String cusId, paymentMoethod) async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var userId;
//     setState(() {
//       userId = sharedPreferences.getString('userId');
//     });
//     // var orderId = userId + '_' + getRandomString(15);
//     print(userId);
//     print(cusId);
//     // print(orderId);
//     try {
//       Map<String, dynamic> body = {
//         'amount': calculateAmount(amount),
//         'currency': currency,
//         'payment_method_types[]': 'card',
//         'metadata[userid]': userId,
//         'customer': cusId,
//         'payment_method': paymentMoethod,
//         'setup_future_usage': 'off_session'
//       };
//       Codec<String, String> stringToBase64 = utf8.fuse(base64);
//       String encoded = stringToBase64.encode(
//           stripeScritKey);
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

//   calculateAmount(amount) {
//     print("djjd");
//     print(amount.runtimeType);
//     final a = (double.parse(amount)) * 100;
//     // final b = int.parse(a.toString());
//     // print(b);
//     return a.toStringAsFixed(0);
//   }

//   String? validateName(String? value) {
//     if (value!.isEmpty) {
//       // return "Name cant't be empty";
//       return "";
//     }
//     return null;
//   }

//   String? validateCard(String? value) {
//     if (value!.isEmpty) {
//       // return "card Number cant't be empty";
//       return "";
//     }
//     return null;
//   }

//   String? validateExpiryMonth(String? value) {
//     if (value!.isEmpty || double.parse(value) > 12) {
//       // return "Expiry month cant't be empty";
//       return "";
//     }
//     return null;
//   }

//   String? validateExpiryYear(String? value) {
//     if (value!.isEmpty) {
//       return "";
//       // return "Expiry Year cant't be empty";
//     }
//     return null;
//   }

//   String? validateCvv(String? value) {
//     if (value!.isEmpty) {
//       return "";
//       // return "cvv cant't be empty";
//     }
//     return null;
//   }

//   titleWidget(
//     String title,
//   ) {
//     return Text(
//       title,
//       style: TextStyle(
//         color: tSecondaryColor,
//         fontSize: isTab(context) ? 9.sp : 12.sp,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }

//   Widget textFormField(TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.text,
//       style: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
//       decoration: InputDecoration(
//         // prefix: Text('+91 ',style: TextStyle(color: tBlack),),

//         hintStyle: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
//         // hintText: 'Enter Your Mobile Number',
//         fillColor: tPrimaryTextformfield,
//         contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
//         filled: true,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(
//             width: 0,
//             style: BorderStyle.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
