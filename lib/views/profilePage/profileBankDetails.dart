import 'dart:async';
import 'dart:convert';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalName.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../PersonalDetails/PersonalDetails.dart';
import '../paymentMethods/paymentCardDetails.dart';

class ProfileBankDetails extends StatefulWidget {
  const ProfileBankDetails({Key? key}) : super(key: key);

  @override
  State<ProfileBankDetails> createState() => _ProfileBankDetailsState();
}

class _ProfileBankDetailsState extends State<ProfileBankDetails> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _banknameController = TextEditingController();
  TextEditingController _sortCodeController = TextEditingController();
  TextEditingController _accountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var btnColor = tIndicatorColor;
  var selectedvalue;
  bool loadingPaymentStatus = false;
  loader(value) {
    setState(() {
      loadingPaymentStatus = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: tWhite,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: tWhite,
              leading: GestureDetector(
                onTap: () {
                  Twl.navigateBack(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: selectedvalue == 1 ? btnColor : tWhite,
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(
                      Images.NAVBACK,
                      scale: 4,
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bank Details",
                                style: TextStyle(
                                  color: tPrimaryColor,
                                  fontSize: isTab(context) ? 18.sp : 21.sp,
                                  // fontWeight: FontWeight.w500,
                                  fontFamily: 'Signika',
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                "When selling gold on Metfolio, this bank\naccount will be saved as a future option",
                                style: TextStyle(
                                  color: tSecondaryColor,
                                  fontSize: isTab(context) ? 9.sp : 12.sp,
                                  // fontWeight: FontWeight.w500,
                                  // fontFamily: 'Signika',
                                ),
                              ),
                              SizedBox(height: 2.h),
                              titleWidget('Full Name (as shown in your bank)'),
                              SizedBox(height: 1.h),
                              Padding(
                                padding: EdgeInsets.only(right: 6.w),
                                child: TwlNormalTextField(
                                  inputForamtters: <TextInputFormatter>[
                                    UpperCaseFormatter()
                                  ],
                                  controller: _nameController,
                                  textInputType: TextInputType.text,
                                  validator: usernameValidator,
                                ),
                              ),
                              SizedBox(height: 2.5.h),
                              titleWidget('Bank Name'),
                              SizedBox(height: 1.h),
                              Padding(
                                padding: EdgeInsets.only(right: 6.w),
                                child: TwlNormalTextField(
                                  inputForamtters: <TextInputFormatter>[
                                    UpperCaseFormatter()
                                  ],
                                  controller: _banknameController,
                                  textInputType: TextInputType.text,
                                  validator: banknameValidator,
                                ),
                              ),
                              SizedBox(height: 2.5.h),
                              titleWidget('Sort Code'),
                              SizedBox(height: 1.h),
                              Padding(
                                  padding: EdgeInsets.only(right: 40.w),
                                  child: TwlNormalTextField(
                                    controller: _sortCodeController,
                                    textInputType: TextInputType.number,
                                    validator: sortCodevalidate,
                                    maxlength: 8,
                                    inputForamtters: [
                                      // LengthLimitingTextInputFormatter(16),
                                      FilteringTextInputFormatter.digitsOnly,
                                      SortCodeFormatter()
                                    ],
                                  )),
                              SizedBox(height: 2.5.h),
                              titleWidget('Account Number'),
                              SizedBox(height: 1.h),
                              Padding(
                                  padding: EdgeInsets.only(right: 40.w),
                                  child: TwlNormalTextField(
                                    controller: _accountController,
                                    textInputType: TextInputType.number,
                                    inputForamtters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    maxlength: 10,
                                    validator: accountValidate,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 2.h),
                        child: Align(
                          alignment: Alignment.center,
                          child: Button(
                              borderSide: BorderSide.none,
                              color: tPrimaryColor,
                              textcolor: tWhite,
                              bottonText: 'Continue',
                              onTap:
                                  (startLoading, stopLoading, btnState) async {
                                FocusScope.of(context).unfocus();
                                // //startLoading();
                                if (_formKey.currentState!.validate()) {
                                  //startLoading();
                                  loader(true);
                                  var name = _nameController.text;
                                  var bankName = _banknameController.text;
                                  var sortCode = _sortCodeController.text;
                                  var acountNumber = _accountController.text;
                                  var res = await UserAPI()
                                      .addBankAcountDetails(context, name,
                                          acountNumber, bankName, sortCode);
                                  print(res);
                                  if (res != null && res['status'] == "OK") {
                                    loader(false);
                                    stopLoading();
                                    Twl.navigateBack(context);
                                    // Twl.navigateTo(context, BottomNavigation());
                                  } else {
                                    loader(false);
                                    stopLoading();
                                    Twl.createAlert(
                                        context, 'error', res['error']);
                                  }
                                  // Twl.navigateBack(context);
                                }

                                // await makePayment(amount: '5', currency: 'INR');
                                // if (_formKey.currentState!.validate()) {
                                //   Twl.navigateTo(context, OtpPage());

                                // var res =await  UserAPI.sendOtp(context,_userNameController.text);
                                // if (res != null && res['status'] == 'OK'){ Twl.navigateTo(context, OtpPage());}
                                // }
                                // stopLoading();
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (loadingPaymentStatus)
          Center(
            child: Container(
              color: tBlack.withOpacity(0.3),
              // padding:
              //     EdgeInsets.only(top: 100),
              height: 100.h,
              width: 100.w,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: tPrimaryColor,
              ),
            ),
          )
      ],
    );
  }

  // Map<String, dynamic>? paymentIntentData;

  // Future<void> makePayment(
  //     {required String amount, required String currency}) async {
  //   print(amount);
  //   try {
  //     paymentIntentData = await createPaymentIntent(amount, currency);
  //     print(paymentIntentData);
  //     if (paymentIntentData != null) {
  //       await Stripe.instance.initPaymentSheet(
  //           paymentSheetParameters: SetupPaymentSheetParameters(
  //         applePay: PaymentSheetApplePay(
  //           merchantCountryCode: 'IN',
  //         ),
  //         googlePay: PaymentSheetGooglePay(merchantCountryCode: 'IN'),
  //         // testEnv: true,
  //         // merchantCountryCode: 'US',
  //         merchantDisplayName: 'Prospects',
  //         customerId: paymentIntentData!['customer'],
  //         paymentIntentClientSecret:
  //             // 'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE',
  //             paymentIntentData!['client_secret'],
  //         customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
  //       ));
  //       // final intent = PaymentIntent.fromJson({
  //       //   "amount": 1.00,
  //       //   "currency": 'usd',
  //       //   "id": 'clientId',
  //       //   "created": "010112022",
  //       //   "status": 'Processing',
  //       //   "clientSecret":
  //       //       'pk_test_51LaF4HSAI1ruU8VXf2zkAIMx3lGAIEF6OEE5IUpsi2s3rzgLNAZv8c65Qatl5oJsrIBBjE5w5u2ADkeB4uhYgFUr00kqGJhvrn',
  //       //   "livemode": true,
  //       //   "captureMethod": "Automatic",
  //       //   "confirmationMethod": "Automatic",
  //       //   //"payment_method_types": ['card']
  //       // });
  //       // final paymentMethod = await Stripe.instance.createPaymentMethod(
  //       //     PaymentMethodParams.card(paymentMethodData: PaymentMethodData()));
  //       // await Stripe.instance.confirmSetupIntent(
  //       //   intent.clientSecret,
  //       //   PaymentMethodParams.card(
  //       //     paymentMethodData: PaymentMethodData(),
  //       //   ),
  //       // );
  //       displayPaymentSheet();
  //     }
  //   } catch (e, s) {
  //     print('exception:$e$s');
  //   }
  // }

  // displayPaymentSheet() async {
  //   final cardDetails = CardDetails(
  //     number: '4242424242424242',
  //     cvc: '123',
  //     expirationMonth: 04,
  //     expirationYear: 2025,
  //   );
  //   final billingDetails = BillingDetails(
  //     name: 'Name',
  //     email: 'email@flutterstripe.com',
  //     phone: '+48888000888',
  //     address: Address(
  //       city: 'Houston',
  //       country: 'US',
  //       line1: '1459  Circle Drive',
  //       line2: '',
  //       state: 'Texas',
  //       postalCode: '77063',
  //     ),
  //   );
  //   try {
  //     // await Stripe.instance.presentPaymentSheet( );
  //     var res = await Stripe.instance.dangerouslyUpdateCardDetails(
  //       cardDetails,
  //     );
  //     final token = await Stripe.instance.createToken(
  //       // ignore: deprecated_member_use
  //       CreateTokenParams(
  //           type: TokenType.Card, address: billingDetails.address),
  //     );
  //     final tokens = token.id;
  //     final tokenJson = Map.castFrom(json.decode(tokens));
  //     //   final PaymentMethodParams paymentMethodParams = PaymentMethodParams.cardFromToken(
  //     //   token: token,
  //     //   setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
  //     // );
  //     //     await Stripe.instance.confirmSetupIntent(
  //     //        clientSecret,
  //     //     tokens  ,
  //     //   );

  //     var tokenId = tokenJson['id'];
  //     print('token: $tokenId');
  //     // final params = Stripe.PaymentMethodParams.cardFromToken(
  //     //   token: tokenId,
  //     // );
  //     print('token');
  //     // print(token);
  //     // final paymentMethod = await Stripe.instance.createPaymentMethod(
  //     //   PaymentMethodParams.card(
  //     //     paymentMethodData: PaymentMethodData(
  //     //       billingDetails: billingDetails,
  //     //     ),
  //     //   ),
  //     // );
  //     print('paymentMethod');
  //     // print(paymentMethod);

  //     // final paymentMethod = await Stripe.instance.createPaymentMethod(
  //     //   PaymentMethodParams.cardFromToken(
  //     //     paymentMethodData: PaymentMethodDataCardFromToken(token: token.id),
  //     //   ),
  //     // );
  //     // 3. create intent on the server
  //     // final paymentIntentResult =
  //     //     await _createNoWebhookPayEndpointMethod(paymentMethod.id);
  //     // expect(paymentIntentResult['status'], 'succeeded');
  //     // print(paymentIntentResult);
  //     // print('paymentIntentResult[status]');
  //     // await Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Payment Successful!'),
  //     ));
  //     // Get.snackbar('Payment', 'Payment Successful',
  //     //     snackPosition: SnackPosition.BOTTOM,
  //     //     backgroundColor: Colors.green,
  //     //     colorText: Colors.white,
  //     //     margin: const EdgeInsets.all(10),
  //     //     duration: const Duration(seconds: 2));
  //   } on Exception catch (e) {
  //     if (e is StripeException) {
  //       print("Error from Stripe: ${e.error.localizedMessage}");
  //     } else {
  //       print("Unforeseen error: ${e}");
  //     }
  //   } catch (e) {
  //     print("exception:$e");
  //   }
  // }

  // Future<Map<String, dynamic>> _createNoWebhookPayEndpointMethod(
  //     String paymentMethodId) async {
  //   // final ipAddress = kApiUrl.split('\n').last.trim();
  //   final url = Uri.parse('http://metfolio.anxion.co.in/api/user/webhook');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'useStripeSdk': true,
  //       'paymentMethodId': paymentMethodId,
  //       'currency': 'INR',
  //       'items': [
  //         {'id': 'id'}
  //       ]
  //     }),
  //   );
  //   return json.decode(response.body);
  // }

  // //  Future<Map<String, dynamic>>
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'card',
  //       // 'card[number]': 4242424242424242,
  //       // 'card[exp_month]': 8,
  //       // 'card[exp_year]': 2023,
  //       // 'card[cvc]': 314
  //     };
  //     Codec<String, String> stringToBase64 = utf8.fuse(base64);
  //     String encoded = stringToBase64.encode(
  //         'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE');
  //     print('encoded');
  //     print(encoded);
  //     var response = await http.post(
  //         Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //         body: body,
  //         headers: {
  //           'Authorization': 'Basic ' + encoded,
  //           'Content-Type': 'application/x-www-form-urlencoded'
  //         });
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     print('err charging user: ${err.toString()}');
  //   }
  // }

  // calculateAmount(String amount) {
  //   final a = (int.parse(amount)) * 100;
  //   return a.toString();
  // }
  // Future<void> makePayment() async {
  //   // final url = Uri.parse(
  //   //     '${firebaseFunction}');

  //   // final response =
  //   //     await http.get(url, headers: {'Content-Type': 'application/json'});
  //   print('initialised');
  //   // this.paymentIntentData = json.decode(response.body);
  //   // final data = await createTestPaymentSheet();
  //   try {
  //     print('initialised1');
  //     await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //       // paymentIntentClientSecret: paymentIntentData!['paymentIntent'],
  //       customFlow: true,
  //       // Main params
  //       merchantDisplayName: 'Flutter Stripe Store Demo',
  //       paymentIntentClientSecret:
  //           'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE',
  //       // Customer keys
  //       // customerEphemeralKeySecret: data['ephemeralKey'],
  //       customerId: '11',
  //       // Extra options
  //       applePay: PaymentSheetApplePay(
  //         merchantCountryCode: 'DE',
  //       ),
  //       googlePay: PaymentSheetGooglePay(merchantCountryCode: 'DE'),
  //       style: ThemeMode.dark,
  //     ));
  //   } catch (e) {
  //     print(e);
  //     Twl.createAlert(context, 'error', e.toString());
  //   }

  //   // setState(() {});

  //   print('initialised');
  //   try {
  //     var payment = await Stripe.instance.presentPaymentSheet();
  //     // setState(() {
  //     //   paymentIntentData = null;
  //     // });
  //     print("payment");
  //     // print(payment.toS);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Payment Successful!'),
  //     ));
  //   } catch (e) {
  //     print(e);
  //   }
  //   // await displayPaymentSheet();
  // }

  String? usernameValidator(String? username) {
    if (username!.isEmpty || username == '') {
      return "";
    }
    return null;
  }

  String? banknameValidator(String? bankNme) {
    if (bankNme!.isEmpty) {
      return "";
    }
    return null;
  }

  String? sortCodevalidate(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
    }
    return null;
  }

  String? accountValidate(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
      // } else if (value.length != 10) {
      //   return "";
    } else {
      return null;
    }
  }

  titleWidget(String title) {
    return Text(
      title,
      style: TextStyle(
        color: tSecondaryColor,
        fontSize: isTab(context) ? 9.sp : 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget textFormField(TextEditingController controller, TextInputType type,
      String Function(String?) validator) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator,
      style: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
      decoration: InputDecoration(
        // prefix: Text('+91 ',style: TextStyle(color: tBlack),),

        hintStyle: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
        // hintText: 'Enter Your Mobile Number',
        fillColor: tPrimaryTextformfield,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
