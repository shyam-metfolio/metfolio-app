import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/paymentMethods/paymentListCards.dart';
import 'package:base_project_flutter/views/successfullPage/PurchesedConfirmSucessfull.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../api_services/orderApi.dart';
import '../../api_services/stripeApi.dart';
import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../components/alertPage.dart';
import '../stripePayments/gPay.dart';
import 'package:http/http.dart' as http;
import 'package:pay/pay.dart' as pay;

import '../successfullPage/changesSavesSucessfull.dart';
import '../successfullPage/thanksForStaetingGoalSucessfull.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage(
      {Key? key, this.amount, required this.type, required this.payment})
      : super(key: key);
  final amount;
  final type;
  final payment;

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage>
    with WidgetsBindingObserver {
  // var _paymentItems = [
  //   pay.PaymentItem(
  //     label: 'Total',
  //     amount: widget.amount.toString(),
  //     status: pay.PaymentItemStatus.final_price,
  //   )
  // ];
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    // WidgetsBinding.instance!.addObserver(this);
    Stripe.instance.isApplePaySupported.addListener(update);
    print(widget.amount);
    super.initState();
    // StripeNative.setPublishableKey(
    //     "pk_test_51LaF4HSAI1ruU8VXf2zkAIMx3lGAIEF6OEE5IUpsi2s3rzgLNAZv8c65Qatl5oJsrIBBjE5w5u2ADkeB4uhYgFUr00kqGJhvrn");
    // StripeNative.setMerchantIdentifier("merchant.rbii.stripe-example");
    e();
  }

  e() async {
    await analytics.logEvent(
      name: "payment_method_page",
      parameters: {
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'payment_method_page',
      properties: {"clicked": true},
    );

    mixpanel.track('payment_method_page', properties: {
      "button_clicked": true,
    });

    await logEvent("payment_method_page", {
      'clicked': true,
    });
  }

  @override
  void dispose() {
    Stripe.instance.isApplePaySupported.removeListener(update);
    // timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   checkCartCreatedTime(true);
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   checkCartCreatedTime(false);
  // }

  var cartCreateTime;
  // var msgTime;
  var finalMsgTime;
  var finalTime;
  var initialDuration;
  // late Timer timer;
  // checkCartCreatedTime(isinit) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var time = sharedPreferences.getString('cartCreatedTime');
  //   cartCreateTime = DateTime.parse(time.toString());
  //   finalMsgTime = cartCreateTime.add(const Duration(seconds: 300));
  //   print('11111111111111111111111');
  //   print(cartCreateTime);
  //   print(finalMsgTime);
  //   print('11111111111111111111111');
  //   DateTime endTime = finalMsgTime;
  //   DateTime currentTime = DateTime.now();
  //   finalTime = endTime.difference(currentTime).inSeconds;
  //   initialDuration = 300 - finalTime;
  //   print(finalTime);
  //   print(initialDuration);
  //   //  print(object);
  //   print('endTime ' + endTime.toString());
  //   print('currentTime ' + currentTime.toString());

  //   print('finalTime ' + finalTime.toString());
  //   print('initialDuration ' + initialDuration.toString());
  //   if (isinit == true) {
  //     print("time init done");
  //     await Future.delayed(Duration(seconds: int.parse(finalTime.toString())))
  //         .then((_) {
  //       WidgetsBinding.instance!.addPostFrameCallback((_) async {
  //         TimeOutPayment(context, (startLoading, stopLoading, btnState) async {
  //           //startLoading();
  //           // timer.cancel();
  //           Twl.navigateTo(
  //             context,
  //             BottomNavigation(
  //               tabIndexId: 1,
  //               actionIndex: 0,
  //             ),
  //           );
  //         });
  //       });
  //     });
  //     // timer = Timer.periodic(Duration(seconds: int.parse(finalTime.toString())),
  //     //     (Timer t) {
  //     //   TimeOutPayment(context, (startLoading, stopLoading, btnState) async {
  //     //     //startLoading();
  //     //     timer.cancel();
  //     //     Twl.navigateTo(
  //     //       context,
  //     //       BottomNavigation(
  //     //         tabIndexId: 0,
  //     //         actionIndex: 0,
  //     //       ),
  //     //     );
  //     //   });
  //     // });
  //   } else if (initialDuration > 0 &&
  //       initialDuration != null &&
  //       initialDuration <= 300) {
  //     print("time not done");
  //     // loader(false);
  //   } else {
  //     print("time done");
  //     // timer.cancel();
  //     WidgetsBinding.instance!.addPostFrameCallback((_) async {
  //       TimeOutPayment(context, (startLoading, stopLoading, btnState) async {
  //         //startLoading();
  //         // timer.cancel();
  //         Twl.navigateTo(
  //           context,
  //           BottomNavigation(
  //             tabIndexId: 1,
  //             actionIndex: 0,
  //           ),
  //         );
  //       });
  //     });
  //     // if (widget.type == '1' || widget.type == 1) {
  //     // getGoldPrice();
  //     // } else {}
  //     // Twl.navigateTo(
  //     //     context,
  //     //     BottomNavigation(
  //     //       actionIndex: 0,
  //     //       tabIndexId: 0,
  //     //     ));
  //   }
  // }

  // Future<String> get receiptPayment async {
  //   /* custom receipt w/ useReceiptNativePay */
  //   const receipt = <String, double>{};
  //   var aReceipt = Receipt(receipt, "Hat Store");
  //   var order = Order(5.50, 0, 0, "Some Store");
  //   // StripeNative.
  //   return await StripeNative.useNativePay(order);
  //   // return await StripeNative.useReceiptNativePay(aReceipt);
  // }

  // Future<String> get orderPayment async {
  //   // subtotal, tax, tip, merchant name
  //   var order = Order(5.50, 1.0, 2.0, "Some Store");
  //   return await StripeNative.useNativePay(order);
  // }
  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: tWhite,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: tWhite,
            leading: GestureDetector(
              onTap: () {
                // Twl.willpopAlert(context);
                // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
              child: GestureDetector(
                onTapDown: (v) {
                  setState(() {
                    selectedvalue = 1;
                    btnColor = tIndicatorColor.withOpacity(0.8);
                  });
                },
                onTapUp: (v) {
                  Timer(Duration(milliseconds: 100), () {
                    setState(() {
                      selectedvalue = null;
                      btnColor = tIndicatorColor;
                    });
                  });
                },
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
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'How would you like to pay?',
                    style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: isTab(context) ? 18.sp : 21.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Signika',
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 9.w,
                      left: 0,
                    ),
                    child: Text(
                      'We have a range of great options which you can use to pay!',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                      ),
                      // textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 40),

                  // if (Platform.isIOS)
                  if (Stripe.instance.isApplePaySupported.value)
                    GestureDetector(
                      onTap: () async {
                        try {
                          startLoader(true);
                          // Stripe.instance.openApplePaySetup();
                          await Stripe.instance.presentApplePay(
                            params: ApplePayPresentParams(
                              // requiredBillingContactFields: [
                              //   ApplePayContactFieldsType.name,
                              //   ApplePayContactFieldsType.emailAddress,
                              // ],
                              // requiredShippingAddressFields: [
                              //   ApplePayContactFieldsType.name,
                              //   ApplePayContactFieldsType.emailAddress,
                              // ],
                              // jcbEnabled: true,
                              // shippingMethods: [
                              //   ApplePayShippingMethod.fromJson(
                              //       {'name': 'ascasass'})
                              // ],
                              cartItems: [
                                ApplePayCartSummaryItem.immediate(
                                  label: (widget.type == myGoal ||
                                          widget.type == GoldType().EditGoal)
                                      ? 'Metfolio ${Secondarycurrency}1 to confirm, this will be refunded.'
                                      : 'Metfolio',
                                  amount: (widget.type == myGoal ||
                                          widget.type == GoldType().EditGoal)
                                      ? '1'
                                      : (widget.amount.toString()),
                                ),
                              ],
                              country: 'GB',
                              currency: currency,
                            ),
                          );

                          SharedPreferences sharedPrefs =
                              await SharedPreferences.getInstance();
                          var authCode = sharedPrefs.getString('authCode');
                          var checkApi = await UserAPI().checkApi(authCode);
                          print(checkApi);
                          if (checkApi != null && checkApi['status'] == 'OK') {
                            var cusID;
                            if (checkApi['detail']['stripe_cus_id'] == null ||
                                checkApi['detail']['stripe_cus_id'] == "") {
                              print("dibdsn");
                              var customerRes =
                                  await UserAPI().createCustomer(context);
                              print('customerRes>>>>>>>>>>>>.');
                              print(customerRes);
                              if (customerRes != null &&
                                  customerRes['status'] == "OK") {
                                setState(() {
                                  cusID =
                                      customerRes['details']['stripe_cus_id'];
                                });
                                sharedPrefs.setString("cusId", cusID);
                              }
                            } else {
                              setState(() {
                                cusID = checkApi['detail']['stripe_cus_id'];
                              });
                            }
                            print("cusId");
                            print(cusID);

                            sharedPrefs.setString('cusId', cusID);
                            // 2. fetch Intent Client Secret from backend
                            final response =
                                await fetchPaymentIntentClientSecret(cusID);
                            print('response>>>>>');
                            print(response);
                            final clientSecret =
                                response['details']['client_secret'];
                            var PNId = response['details']['id'];
                            // 2. Confirm apple pay payment
                            try {
                              await Stripe.instance
                                  .confirmApplePayPayment(clientSecret);
                              var paymentDetails = await Stripe.instance
                                  .retrievePaymentIntent(clientSecret);
                              print("pmId>>>>>>>>>>>>>");
                              print(paymentDetails.paymentMethodId);
                              if (widget.type == Buy) {
                                buyGold(PNId);
                                // cvcAlert(cardDetails[index], paymentMethodId);
                              } else if (widget.type == myGoal ||
                                  (widget.type == GoldType().EditGoal)) {
                                var billingDetails = BillingDetails();
                                setState(() {
                                  billingDetails = billingDetails.copyWith(
                                      name: checkApi['detail']['first_name'],
                                      phone: checkApi['detail']['username'],
                                      email: checkApi['detail']['email'],
                                      address: Address.fromJson({
                                        'city': checkApi['detail']
                                            ['delivery_address']['city'],
                                        'country': 'US',
                                        'line1': checkApi['detail']
                                                ['delivery_address']
                                            ['address_line_one'],
                                        'line2': checkApi['detail']
                                                ['delivery_address']
                                            ['address_line_two'],
                                        // 'state': 'Texas',
                                        'postalCode': checkApi['detail']
                                            ['delivery_address']['post_code'],
                                      }));
                                });

                                // mocked data for tests

                                // 2. Create payment method
                                var attechRes = await StripePaymentApi()
                                    .updateCustomer(
                                        paymentDetails.paymentMethodId
                                            .toString(),
                                        cusID);
                                print("attechRes>>>>>>>>>>>>>");
                                print(attechRes);
                                if (widget.type == myGoal) {
                                  await createGoal(
                                      paymentDetails.paymentMethodId);
                                } else {
                                  startLoader(false);
                                  Twl.navigateTo(
                                      context, ChangesSavedSucessful());
                                }
                              }
                            } catch (e) {
                              startLoader(false);
                              print("payment error" + e.toString());
                            }
                          }
                        } catch (e) {
                          startLoader(false);
                          print("eroor" + e.toString());
                        }
                      },
                      child: Column(
                        children: [
                          paymentMethodWidget(
                            context,
                            'Apple Pay',
                            'Pay using any card in your apple pay wallet',
                            Images.APPLEICONBALCK,
                            1,
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: tBlack,
                            ),
                            child: Image.asset(
                              Images.APPLEWHITEICON,
                              scale: 4,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  if (!Platform.isIOS)
                    GestureDetector(
                      onTap: () async {},
                      child: paymentMethodWidget(
                        context,
                        'Google Pay',
                        'Pay using any card in your google pay\nwallet',
                        Images.GPAYORDERICON,
                        2,
                      ),
                    ),
                  // SizedBox(
                  //   height: 75,
                  //   child: GooglePayButton(
                  //     onTap: () async {
                  //       final googlePaySupported = await Stripe.instance
                  //           .isGooglePaySupported(IsGooglePaySupportedParams());
                  //       if (googlePaySupported) {
                  //         try {
                  //           // 1. fetch Intent Client Secret from backend
                  //           SharedPreferences sharedPrefs =
                  //               await SharedPreferences.getInstance();
                  //           var authCode = sharedPrefs.getString('authCode');
                  //           var checkApi = await UserAPI().checkApi(authCode);
                  //           print(checkApi);
                  //           if (checkApi != null &&
                  //               checkApi['status'] == 'OK') {
                  //             var cusID;
                  //             var response;
                  //             // if (checkApi['detail']['stripe_cus_id'] == null ||
                  //             //     checkApi['detail']['stripe_cus_id'] == "") {
                  //             print("dibdsn");
                  //             var customerRes =
                  //                 await UserAPI().createCustomer(context);
                  //             print('customerRes>>>>>>>>>>>>.');
                  //             print(customerRes);
                  //             if (customerRes != null &&
                  //                 customerRes['status'] == "OK") {
                  //               setState(() {
                  //                 cusID =
                  //                     customerRes['details']['stripe_cus_id'];
                  //               });
                  //               sharedPrefs.setString("cusId", cusID);
                  //             }
                  //             response =
                  //                 await fetchPaymentIntentClientSecret(cusID);
                  //             print('response>>>>>>>>>>>>>>>>>>>>.');
                  //             print(response);
                  //             final clientSecret = response['client_secret'];

                  //             // 2.present google pay sheet
                  //             await Stripe.instance.initGooglePay(
                  //                 GooglePayInitParams(
                  //                     testEnv: true,
                  //                     merchantName: "Example Merchant Name",
                  //                     countryCode: 'GB'));

                  //             await Stripe.instance.presentGooglePay(
                  //               PresentGooglePayParams(
                  //                   clientSecret: clientSecret),
                  //             );

                  //             ScaffoldMessenger.of(context).showSnackBar(
                  //               const SnackBar(
                  //                   content: Text(
                  //                       'Google Pay payment succesfully completed')),
                  //             );
                  //             // }
                  //           }
                  //         } catch (e) {
                  //           print('Error during google pay' + e.toString());
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             SnackBar(content: Text('Error: $e')),
                  //           );
                  //         }
                  //       } else {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           SnackBar(
                  //               content: Text(
                  //                   'Google pay is not supported on this device')),
                  //         );
                  //       }
                  //     },
                  //   ),
                  // ),
                  // if (Platform.isIOS)
                  //   pay.ApplePayButton(
                  //     width: double.infinity,
                  //     paymentConfigurationAsset:
                  //         'apple_pay_payment_profile.json',
                  //     paymentItems: [
                  //       pay.PaymentItem(
                  //         label: 'Total',
                  //         amount: (widget.amount.toString()),
                  //         // amount: widget.amount.toString(),
                  //         status: pay.PaymentItemStatus.final_price,
                  //       ),
                  //     ],
                  //     margin: const EdgeInsets.only(top: 15),
                  //     onPaymentResult: onApplePayResult,
                  //     loadingIndicator: const Center(
                  //       child: CircularProgressIndicator(),
                  //     ),
                  //     childOnError: Text(''),
                  //     onError: (e) {
                  //       print(e);
                  //       // ScaffoldMessenger.of(context).showSnackBar(
                  //       //   const SnackBar(
                  //       //     content: Text(
                  //       //         'There was an error while trying to perform the payment'),
                  //       //   ),
                  //       // );
                  //     },
                  //   ),
                  SizedBox(height: 15),
                  if (Platform.isAndroid)
                    pay.GooglePayButton(
                      width: double.infinity,
                      paymentConfigurationAsset:
                          'google_pay_payment_profile.json',
                      paymentItems: [
                        pay.PaymentItem(
                          label: 'Total',
                          amount: (widget.type == myGoal ||
                                  (widget.type == GoldType().EditGoal))
                              ? '1'
                              : (widget.amount.toString()),
                          // amount: widget.amount.toString(),
                          status: pay.PaymentItemStatus.final_price,
                        ),
                      ],
                      margin: const EdgeInsets.only(top: 15),
                      onPaymentResult: onGooglePayResult,
                      // onPaymentResult: (data) {
                      //   print(data);
                      // },
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      onPressed: () async {
                        // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
                        await debugChangedStripePublishableKey();
                      },
                      childOnError:
                          Text('Google Pay is not available in this device'),
                      onError: (e) {
                        print(e);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text(
                        //         'There was an error while trying to perform the payment'),
                        //   ),
                        // );
                      },
                    ),
                  // GestureDetector(
                  //   onTap: () {
                  //     // startGooglePay(context, '100');
                  //   },
                  //   child: Container(
                  //     height: 40,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       color: tBlack,
                  //     ),
                  //     child: Image.asset(
                  //       Images.GPAYBUTTONICON,
                  //       scale: 4,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 40),
                  // paymentMethodWidget(
                  //   context,
                  //   'Google Pay',
                  //   'Pay using any card in your google pay wallet',
                  //   Images.GPAYORDERICON,
                  //   2,
                  // ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      // timer.cancel();
                      Twl.navigateTo(
                        context,
                        PaymentListCards(
                          amount: widget.amount,
                          paymentType: widget.type,
                        ),
                      );

                      await analytics.logEvent(
                        name: "card_chosen_as_payment_method",
                        parameters: {
                          "button_clicked": true,
                        },
                      );

                      Segment.track(
                        eventName: 'card_chosen_as_payment_method',
                        properties: {"clicked": true},
                      );

                      mixpanel
                          .track('card_chosen_as_payment_method', properties: {
                        "button_clicked": true,
                      });

                      await logEvent("card_chosen_as_payment_method", {
                        'clicked': true,
                      });
                    },
                    child: paymentMethodWidget(
                      context,
                      'Debit / Credit Card',
                      'Pay securely using your debit or credit\ncard',
                      Images.PAYMENTCARDICON,
                      3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
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
          ))
      ],
    );
  }

  bool isLoading = false;
  startLoader(value) {
    setState(() {
      isLoading = value;
    });
  }

  // Future<void> onApplePayResult(paymentResult) async {
  //   // startLoader(true);
  //   print("applepay");
  //   print(paymentResult['token']);
  //   try {
  //     //debugPrint(paymentResult.toString());
  //     // 1. Get Stripe token from payment result
  //     SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  //     var authCode = sharedPrefs.getString('authCode');
  //     var checkApi = await UserAPI().checkApi(authCode);
  //     print(checkApi);
  //     if (checkApi != null && checkApi['status'] == 'OK') {
  //       var cusID;
  //       if (checkApi['detail']['stripe_cus_id'] == null ||
  //           checkApi['detail']['stripe_cus_id'] == "") {
  //         print("dibdsn");
  //         var customerRes = await UserAPI().createCustomer(context);
  //         print('customerRes>>>>>>>>>>>>.');
  //         print(customerRes);
  //         if (customerRes != null && customerRes['status'] == "OK") {
  //           setState(() {
  //             cusID = customerRes['details']['stripe_cus_id'];
  //           });
  //           sharedPrefs.setString("cusId", cusID);
  //         }
  //       } else {
  //         setState(() {
  //           cusID = checkApi['detail']['stripe_cus_id'];
  //         });
  //       }
  //       print("cusId");
  //       print(cusID);

  //       // print(token['token']);
  //       // print(token['token']['data']);
  //       // startLoader(false);
  //       var token;
  //       try {
  //         // var tokens = Map.castFrom(json.decode(paymentResult.toString()));
  //         // print(tokens);
  //         // var s = json.decode(paymentResult.toString());
  //         // print(s);
  //         // Map<String, dynamic> tokenJson =
  //         //     Map<String, dynamic>.from(json.decode(paymentResult));
  //         // print("tokenJson");
  //         // print(tokenJson['data']);

  //         token = await Stripe.instance.createApplePayToken(paymentResult);
  //         print(token);
  //       } catch (e) {
  //         print("token");
  //         print(e);
  //       }

  //       // 2. fetch Intent Client Secret from backend
  //       final response = await fetchPaymentIntentClientSecret(cusID);
  //       print("response>>>>");
  //       print(response);
  //       if (response != null && response['status'] == "OK") {
  //         final clientSecret = response['details']['client_secret'];
  //         print("clientSecret>>>>>");
  //         print(clientSecret);

  //         final params = PaymentMethodParams.cardFromToken(
  //           paymentMethodData: PaymentMethodDataCardFromToken(
  //             token: token.id,
  //           ),
  //         );

  //         // 3. Confirm Apple pay payment method
  //         var paymentRes = await Stripe.instance.confirmPayment(
  //           clientSecret,
  //           params,
  //         );
  //         if (paymentRes.status == PaymentIntentsStatus.Succeeded) {
  //           if (widget.type == Buy) {
  //             buyGold(paymentRes.id);
  //             // cvcAlert(cardDetails[index], paymentMethodId);
  //           } else if (widget.type == myGoal) {
  //             var attechRes = await StripePaymentApi()
  //                 .updateCustomer(paymentRes.paymentMethodId.toString(), cusID);
  //             print("attechRes>>>>>>>>>>>>>");
  //             print(attechRes);
  //             createGoal(paymentRes.paymentMethodId);
  //           }
  //         }

  //         // ScaffoldMessenger.of(context).showSnackBar(
  //         //   const SnackBar(
  //         //       content: Text('Apple Pay payment succesfully completed')),
  //         // );
  //       }
  //     }
  //   } catch (e) {
  //     startLoader(false);
  //     // print("error" + e.toString());
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('Error: $e')),
  //     // );
  //   }
  // }

  //
  Future<void> onGooglePayResult(paymentResult) async {
    startLoader(true);
    try {
      // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json

      debugPrint(paymentResult.toString());
      // 2. fetch Intent Client Secret from backend

      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      var authCode = sharedPrefs.getString('authCode');
      var checkApi = await UserAPI().checkApi(authCode);
      print(checkApi);
      if (checkApi != null && checkApi['status'] == 'OK') {
        var cusID;
        var response;
        if (checkApi['detail']['stripe_cus_id'] == null ||
            checkApi['detail']['stripe_cus_id'] == "") {
          print("dibdsn");
          var customerRes = await UserAPI().createCustomer(context);
          print('customerRes>>>>>>>>>>>>.');
          print(customerRes);
          if (customerRes != null && customerRes['status'] == "OK") {
            setState(() {
              cusID = customerRes['details']['stripe_cus_id'];
            });
            sharedPrefs.setString("cusId", cusID);
          }
        } else {
          setState(() {
            cusID = checkApi['detail']['stripe_cus_id'];
          });
        }
        sharedPrefs.setString('cusId', cusID);
        response = await fetchPaymentIntentClientSecret(cusID);
        print('response>>>>>>>>>>>>>>>>>>>>.');
        print(response);
        if (response != null && response['status'] == "OK") {
          final clientSecret = response['details']['client_secret'];
          final token =
              paymentResult['paymentMethodData']['tokenizationData']['token'];
          print(token);
          final tokenJson = Map.castFrom(json.decode(token));
          print("tokenJson?>>>>>>>>>>>>>>>>>>>>");
          print(clientSecret);
          print(tokenJson);

          final params = PaymentMethodParams.cardFromToken(
            paymentMethodData: PaymentMethodDataCardFromToken(
              token: tokenJson['id'], // TODO extract the actual token
            ),
          );
          try {
            // 3. Confirm Google pay payment method
            var paymentRes = await Stripe.instance.confirmPayment(
              paymentIntentClientSecret: clientSecret,
              data: params,
            );
            print(paymentRes);
            print("'Google Pay payment succesfully completed>>>>>>>>>>.'");
            if (paymentRes.status == PaymentIntentsStatus.Succeeded) {
              if (widget.type == Buy) {
                await buyGold(paymentRes.id);
                // cvcAlert(cardDetails[index], paymentMethodId);
              } else if (widget.type == myGoal ||
                  (widget.type == GoldType().EditGoal)) {
                var attechRes = await StripePaymentApi().updateCustomer(
                    paymentRes.paymentMethodId.toString(), cusID);
                print("attechRes>>>>>>>>>>>>>");
                print(attechRes);
                if (widget.type == myGoal) {
                  await createGoal(paymentRes.paymentMethodId);
                } else {
                  startLoader(false);
                  Twl.navigateTo(context, ChangesSavedSucessful());
                }
              }
            }
            // startLoader(false);
          } catch (e) {
            startLoader(false);
            if (e is StripeException) {
              print("Error from Stripe: ${e.error.localizedMessage}");
              if (e.error.localizedMessage == null) {
              } else {
                declinedAlert(
                  context,
                  e.error.localizedMessage,
                  "Ok",
                );
              }
            } else {}
          }
        }
        // else {
        //   response = await fetchPaymentIntentClientSecret(cusID);
        //   print('response>>>>>>>>>>>>>>>>>>>>.');
        //   print(response);
        //   final clientSecret = response['details']['client_secret'];
        //   final token =
        //       paymentResult['paymentMethodData']['tokenizationData']['token'];
        //   print(token);
        //   final tokenJson = Map.castFrom(json.decode(token));
        //   print("tokenJson?>>>>>>>>>>>>>>>>>>>>");
        //   print(clientSecret);
        //   print(tokenJson);

        //   final params = PaymentMethodParams.cardFromToken(
        //     paymentMethodData: PaymentMethodDataCardFromToken(
        //       token: tokenJson['id'], // TODO extract the actual token
        //     ),
        //   );

        //   // 3. Confirm Google pay payment method
        //   var paymentRes = await Stripe.instance.confirmPayment(
        //     clientSecret,
        //     params,
        //   );
        //   print(paymentRes);
        //   print("'Google Pay payment succesfully completed>>>>>>>>>>.'");
        //   if (paymentRes.status == PaymentIntentsStatus.Succeeded) {
        //     if (widget.type == Buy) {
        //       buyGold(paymentRes.id);
        //       // cvcAlert(cardDetails[index], paymentMethodId);
        //     } else if (widget.type == myGoal) {
        //       var attechRes = await StripePaymentApi()
        //           .updateCustomer(paymentRes.paymentMethodId.toString(), cusID);
        //       print("attechRes>>>>>>>>>>>>>");
        //       print(attechRes);
        //       createGoal(paymentRes.paymentMethodId);
        //     }
        //   }
        //   startLoader(false);
        //   // ScaffoldMessenger.of(context).showSnackBar(
        //   //   const SnackBar(
        //   //       content: Text('Google Pay payment succesfully completed')),
        //   // );
        //   // }
        // }
      }
    } catch (e) {
      startLoader(false);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    }
  }

  createGoal(paymentMethodId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var goalName;
    var amount;
    var date;
    setState(() {
      goalName = sharedPreferences.getString("goalName");
      amount = sharedPreferences.getString("goalAmount");
      date = sharedPreferences.getString("goalDate");
    });
    print(goalName);
    print(amount);
    print(date);
    var addGoalRes = await OrderAPI()
        .addGoal(context, goalName, amount, date, paymentMethodId, currency);
    print('addGoalRes??????');
    print(addGoalRes);
    if (addGoalRes != null && addGoalRes['status'] == 'OK') {
      final facebookAppEvents = FacebookAppEvents();
      facebookAppEvents.logEvent(
        name: 'New Goal Created',
        // parameters: {
        //   'Sign up_id':
        //       'the_clickme_button',
        // },
      );
      sharedPreferences.remove("goalAmount");
      sharedPreferences.remove("goalDate");
      startLoader(false);
      Twl.navigateTo(context, ThanksForStartingGoalSucessful());
    } else {
      startLoader(false);
    }
  }

  buyGold(paymentIntentResult) async {
    print("buyGold>>>>>>>>>>>>start");
    var res = await OrderAPI().buyGold(context, paymentIntentResult);
    // paymentIntentResult[
    //         'details']
    //     ['id']);
    print(res);
    if (res != null && res['status'] == 'OK') {
      final facebookAppEvents = FacebookAppEvents();
      facebookAppEvents.logEvent(
        name: 'Purchase made',
        // parameters: {
        //   'Sign up_id':
        //       'the_clickme_button',
        // },
      );
      startLoader(false);
      print('buy gold');
      Twl.navigateTo(context, PurchesedConfirmSucessful());
    } else {
      startLoader(false);
    }
  }

  calculateAmount(amount) {
    print("djjd");
    print(amount.runtimeType);
    final a = (double.parse(amount)) * 100;
    // final b = int.parse(a.toString());
    // print(b);
    return a.toStringAsFixed(0);
  }

  fetchPaymentIntentClientSecret(cusId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId;
    setState(() {
      userId = sharedPreferences.getString('userId');
    });
    print(userId);
    try {
      var paymentIntentResult;
      if (widget.type == Buy) {
        var amount = calculateAmount(widget.amount.toString());
        paymentIntentResult = await StripePaymentApi()
            .createPaymentIntent(context, amount, currency, '', '', false, '');
      } else if (widget.type == myGoal ||
          (widget.type == GoldType().EditGoal)) {
        paymentIntentResult = await StripePaymentApi()
            .createPaymentIntent(context, '100', currency, '', '', true, '');
      }

      // await createPaymentIntent('1', 'INR', cusID,
      //     res['details']['id']);

      // print("paymentIntentData>>>>>>>>>");
      // print(paymentIntentResult);
      // print(paymentIntentResult['details']['id']);
      print(paymentIntentResult);
      if (paymentIntentResult != null &&
          paymentIntentResult['status'] == 'OK') {
        print(paymentIntentResult['details']['client_secret']);
        return paymentIntentResult;
      }
      //   Map<String, dynamic> body = {
      //     // widget.amount.toString()
      //     'amount': calculateAmount(widget.amount.toString()),
      //     // calculateAmount(widget.amount.toString()),
      //     'currency': currency,
      //     'payment_method_types[]': 'card',
      //     'metadata[userid]': userId,
      //     'customer': cusId,
      //     // 'payment_method': paymentMoethod,
      //     'setup_future_usage': 'off_session'
      //   };
      //   Codec<String, String> stringToBase64 = utf8.fuse(base64);
      //   String encoded = stringToBase64.encode(
      //       'sk_test_51LjgVyCWDgwcpbq2s5O0tHdZucayEwP3CWqkGZOUR2JhNjE1NH55MUK6JpOOds2nWqAHxYFGVkYzQ5Thw6ZtNW2900sEaX6CZ8');
      //   print('encoded');
      //   print(encoded);
      //   var response = await http.post(
      //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
      //       body: body,
      //       headers: {
      //         'Authorization': 'Basic ' + encoded,
      //         'Content-Type': 'application/x-www-form-urlencoded'
      //       });
      //   return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  Future<void> debugChangedStripePublishableKey() async {
    if (kDebugMode) {
      final profile =
          await rootBundle.loadString('assets/google_pay_payment_profile.json');
      final isValidKey = profile.contains(
          'pk_live_51LDA8pFoLFscXEZBRE5ZSwNVcT0FYeRQajkLZI1pdNN4kbR2Wwimx1fWWIibv2wXu0iEnW7gYR7t7eQv23tJ94ot00d1cPbzb3');
      assert(
        isValidKey,
        'No stripe publishable key added to assets/google_pay_payment_profile.json',
      );
    }
  }
  //  Future<void>
  // startGooglePay(context, price) async {
  //   final googlePaySupported = await Stripe.instance
  //       .isGooglePaySupported(IsGooglePaySupportedParams());
  //   print(googlePaySupported);
  //   if (googlePaySupported) {
  //     try {
  //       // 1. fetch Intent Client Secret from backend
  //       var amount = await Twl.calculateAmount(price);
  //       // print("sjdbcd");
  //       SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  //       var authCode = sharedPrefs.getString('authCode');
  //       var checkApi = await UserAPI().checkApi(authCode);
  //       print(checkApi);
  //       if (checkApi != null && checkApi['status'] == 'OK') {
  //         var cusID;
  //         if (checkApi['detail']['stripe_cus_id'] == null ||
  //             checkApi['detail']['stripe_cus_id'] == "") {
  //           print("dibdsn");
  //           var customerRes = await UserAPI().createCustomer(context);
  //           print(customerRes);
  //           print("cusID>>>>>>>>>>>>>>");
  //           print(cusID);
  //           if (customerRes != null && customerRes['status'] == "OK") {
  //             print("jbdasd");
  //             var billingDetails = BillingDetails(
  //                 // email: 'email@stripe.com',
  //                 // phone: '+48888000888',
  //                 // address: Address(
  //                 //   city: 'Houston',
  //                 //   country: 'US',
  //                 //   line1: '1459  Circle Drive',
  //                 //   line2: '',
  //                 //   state: 'Texas',
  //                 //   postalCode: '77063',
  //                 // ),
  //                 );
  //             // setState(() {
  //             billingDetails = billingDetails.copyWith(
  //                 name: 'narasimha',
  //                 phone: checkApi['detail']['username'],
  //                 email: checkApi['detail']['email'],
  //                 address: Address.fromJson({
  //                   'city': checkApi['detail']['delivery_address']['city'],
  //                   'country': 'US',
  //                   'line1': checkApi['detail']['delivery_address']
  //                       ['address_line_one'],
  //                   'line2': checkApi['detail']['delivery_address']
  //                       ['address_line_two'],
  //                   // 'state': 'Texas',
  //                   'postalCode': checkApi['detail']['delivery_address']
  //                       ['post_code'],
  //                 }));
  //             // });

  //             // mocked data for tests

  //             // 2. Create payment method

  //             final paymentMethod = await Stripe.instance
  //                 .createPaymentMethod(PaymentMethodParams.card(
  //               paymentMethodData: PaymentMethodData(
  //                 billingDetails: billingDetails,
  //               ),
  //             ));
  //             // setState(() {
  //             cusID = customerRes['details']['stripe_cus_id'];
  //             var paymentIntentResult = await StripePaymentApi()
  //                 .createPaymentIntent(
  //                     context, amount, currency, paymentMethod.id, '', false);
  //             print(paymentIntentResult);
  //             if (paymentIntentResult['status'] == "OK") {
  //               final clientSecret = paymentIntentResult['clientSecret'];

  //               // 2.present google pay sheet
  //               await Stripe.instance.initGooglePay(GooglePayInitParams(
  //                   // billingAddressConfig: ,
  //                   testEnv: true,
  //                   merchantName: "Narasimha",
  //                   countryCode: 'IN'));

  //               await Stripe.instance.presentGooglePay(
  //                 PresentGooglePayParams(
  //                     clientSecret: clientSecret, currencyCode: 'INR'),
  //               );
  //               // await Stripe.instance.initPaymentSheet(
  //               //     paymentSheetParameters: SetupPaymentSheetParameters(
  //               //         googlePay:
  //               //             PaymentSheetGooglePay(merchantCountryCode: 'US'),
  //               //         paymentIntentClientSecret:
  //               //             paymentIntentResult['client_secret'],
  //               //         setupIntentClientSecret:
  //               //             paymentIntentResult['client_secret'],
  //               //         customerEphemeralKeySecret:
  //               //             paymentIntentResult['client_secret'],
  //               //         customerId: paymentIntentResult
  //               //             .getPrefValue(key: 'sdn')
  //               //             .toString()));
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(
  //                     content:
  //                         Text('Google Pay payment succesfully completed')),
  //               );
  //             }
  //             // });
  //           }
  //         } else {
  //           // setState(() {
  //           cusID = checkApi['detail']['stripe_cus_id'];
  //           var billingDetails = BillingDetails(
  //               // email: 'email@stripe.com',
  //               // phone: '+48888000888',
  //               // address: Address(
  //               //   city: 'Houston',
  //               //   country: 'US',
  //               //   line1: '1459  Circle Drive',
  //               //   line2: '',
  //               //   state: 'Texas',
  //               //   postalCode: '77063',
  //               // ),
  //               );
  //           // setState(() {
  //           billingDetails = billingDetails.copyWith(
  //               name: 'narasimha',
  //               phone: checkApi['detail']['username'],
  //               email: checkApi['detail']['email'],
  //               address: Address.fromJson({
  //                 'city': checkApi['detail']['delivery_address']['city'],
  //                 'country': 'IN',
  //                 'line1': checkApi['detail']['delivery_address']
  //                     ['address_line_one'],
  //                 'line2': checkApi['detail']['delivery_address']
  //                     ['address_line_two'],
  //                 // 'state': 'Texas',
  //                 'postalCode': checkApi['detail']['delivery_address']
  //                     ['post_code'],
  //               }));
  //           // });

  //           // mocked data for tests

  //           // 2. Create payment method

  //           // final paymentMethod = await Stripe.instance
  //           //     .createPaymentMethod(PaymentMethodParams.card(
  //           //   paymentMethodData: PaymentMethodData(
  //           //     billingDetails: billingDetails,
  //           //   ),
  //           // ));
  //           // print(paymentMethod);
  //           // setState(() {
  //           // cusID = customerRes['details']['stripe_cus_id'];
  //           var paymentIntentResult = await StripePaymentApi()
  //               .createPaymentIntent(context, amount, 'Inr', '', '', false);
  //           print(paymentIntentResult);
  //           if (paymentIntentResult['status'] == "OK") {
  //             final clientSecret =
  //                 paymentIntentResult['details']['client_secret'];
  //             print(clientSecret);

  //             // 2.present google pay sheet
  //             await Stripe.instance.initGooglePay(GooglePayInitParams(
  //                 testEnv: true,
  //                 merchantName: "Example Merchant Name",
  //                 countryCode: 'IN'));

  //             var res =
  //                 await Stripe.instance.presentGooglePay(PresentGooglePayParams(
  //               clientSecret: clientSecret,
  //               currencyCode: "Inr",
  //             ));

  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                   content: Text('Google Pay payment succesfully completed')),
  //             );
  //           }
  //           // });
  //         }
  //       }
  //     } catch (e) {
  //       print('Error: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error: $e')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Google pay is not supported on this device')),
  //     );
  //   }
  // }

  Widget paymentMethodWidget(BuildContext context, String title,
      String subtitle, String imgUrl, int index) {
    return Container(
      child: Row(
        children: [
          Image.asset(
            imgUrl,
            scale: index == 3 ? 4 : 4,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 8.sp : 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 7.sp : 10.sp,
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, top: 6),
            child: title != 'Google Pay'
                ? Image.asset(
                    Images.NEXTICON,
                    scale: 4,
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
