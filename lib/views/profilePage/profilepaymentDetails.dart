import 'dart:async';
import 'dart:convert';
import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/api_services/stripeApi.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalName.dart';
import 'package:base_project_flutter/views/successfullPage/changesSavesSucessfull.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:http/http.dart' as http;
import 'package:base_project_flutter/api_services/orderApi.dart';
import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../PersonalDetails/PersonalDetails.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../components/alertPage.dart';
import '../paymentMethods/paymentCardDetails.dart';
import '../successfullPage/PurchesedConfirmSucessfull.dart';
import '../successfullPage/thanksForStaetingGoalSucessfull.dart';

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     return TextEditingValue(
//       text: capitalize(newValue.text),
//       selection: newValue.selection,
//     );
//   }
// }

// String capitalize(String value) {
//   if (value.trim().isEmpty) return "";
//   return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
// }

class ProfilePaymentDetails extends StatefulWidget {
  const ProfilePaymentDetails(
      {Key? key, this.goalName, this.amount, this.date, required this.type})
      : super(key: key);
  final goalName;
  final amount;
  final date;
  final type;
  @override
  State<ProfilePaymentDetails> createState() => _ProfilePaymentDetailsState();
}

class _ProfilePaymentDetailsState extends State<ProfilePaymentDetails> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cardController = TextEditingController();

  TextEditingController _expiryMonthController = TextEditingController();
  TextEditingController _expiryYearController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  final _formKey = new GlobalKey<FormState>();
  bool loadingPaymentStatus = false;
  loader(value) {
    setState(() {
      loadingPaymentStatus = value;
    });
  }

  bool hasError = false;
  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(false);
      },
      child: Stack(
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
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Please enter your payment details",
                                  style: TextStyle(
                                    color: tPrimaryColor,
                                    fontSize: isTab(context) ? 18.sp : 21.sp,
                                    // fontWeight: FontWeight.w500,
                                    fontFamily: 'Signika',
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "This card will be saved and can be\nused for future Metfolio purchases",
                                  style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 9.sp : 12.sp,
                                    // fontWeight: FontWeight.w500,
                                    // fontFamily: 'Signika',
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                titleWidget('Name (as shown on card)'),
                                SizedBox(height: 1.h),
                                TwlNormalTextField(
                                  textCapitalization: TextCapitalization.words,
                                  inputForamtters: <TextInputFormatter>[
                                    UpperCaseFormatter()
                                  ],
                                  controller: _nameController,
                                  textInputType: TextInputType.text,
                                  validator: validateName,
                                ),
                                SizedBox(height: 2.h),
                                titleWidget('Card Number'),
                                SizedBox(height: 1.h),
                                TwlNormalTextField(
                                  controller: _cardController,
                                  textInputType: TextInputType.number,
                                  validator: validateCard,
                                  onchnage: (v) {
                                    setState(() {
                                      hasError = false;
                                    });
                                    _formKey.currentState!.validate();
                                  },
                                  // maxLines: 19,
                                  maxlength: 19,
                                  inputForamtters: [
                                    // LengthLimitingTextInputFormatter(16)
                                    FilteringTextInputFormatter.digitsOnly,
                                    CardNumberFormatter()
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                titleWidget('Card expiry date'),
                                SizedBox(height: 1.h),
                                Padding(
                                  padding: EdgeInsets.only(right: 40.w),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TwlNormalTextField(
                                          controller: _expiryMonthController,
                                          textInputType: TextInputType.datetime,
                                          onchnage: (v) {
                                            setState(() {
                                              hasError = false;
                                            });
                                            _formKey.currentState!.validate();
                                          },
                                          validator: validateExpiryMonth,
                                          inputForamtters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(2)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: TwlNormalTextField(
                                          controller: _expiryYearController,
                                          textInputType: TextInputType.datetime,
                                          validator: validateExpiryYear,
                                          onchnage: (v) {
                                            setState(() {
                                              hasError = false;
                                            });
                                            _formKey.currentState!.validate();
                                          },
                                          inputForamtters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(4)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                titleWidget('CVV'),
                                SizedBox(height: 1.h),
                                Padding(
                                  padding: EdgeInsets.only(right: 50.w),
                                  child: TwlNormalTextField(
                                    onchnage: (v) {
                                      setState(() {
                                        hasError = false;
                                      });
                                      _formKey.currentState!.validate();
                                    },
                                    controller: _cvvController,
                                    textInputType: TextInputType.number,
                                    validator: validateCvv,
                                    inputForamtters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Align(
                            alignment: Alignment.center,
                            child: Button(
                                borderSide: BorderSide.none,
                                color: tPrimaryColor,
                                textcolor: tWhite,
                                bottonText: 'Continue',
                                onTap: (startLoading, stopLoading,
                                    btnState) async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    loader(true);
                                    // //startLoading();
                                    var cardnumber = _cardController.text
                                        .replaceAll(' ', '');
                                    var expMonth = _expiryMonthController.text;
                                    var expYear = _expiryYearController.text;
                                    var cvc = _cvvController.text;

                                    SharedPreferences sharedPrefs =
                                        await SharedPreferences.getInstance();
                                    var authCode =
                                        sharedPrefs.getString('authCode');

                                    var checkApi =
                                        await UserAPI().checkApi(authCode);
                                    print(checkApi);
                                    if (checkApi != null &&
                                        checkApi['status'] == "OK") {
                                      // if (checkApi['detail']['stripe_cus_id'] != null &&
                                      //     checkApi['detail']['stripe_cus_id'] != '') {
                                      var cusID;
                                      var customerRes;
                                      if (checkApi['detail']['stripe_cus_id'] ==
                                              null ||
                                          checkApi['detail']['stripe_cus_id'] ==
                                              "") {
                                        print("dibdsn");
                                        customerRes = await UserAPI()
                                            .createCustomer(context);
                                        print(customerRes);
                                        if (customerRes != null &&
                                            customerRes['status'] == "OK") {
                                          setState(() {
                                            cusID = customerRes['details']
                                                ['stripe_cus_id'];
                                          });
                                          sharedPrefs.setString("cusId", cusID);
                                          print("cusID>>>>>>>>>>>>>>");
                                          print(cusID);
                                          var res = await OrderAPI()
                                              .createGoalPayment(
                                                  context,
                                                  cardnumber,
                                                  expMonth,
                                                  expYear,
                                                  cvc,
                                                  _nameController.text);
                                          print('createGoalPayment>>>>>>>>>>');
                                          // stopLoading();
                                          print(res);
                                          // print(res['details']['card']['networks']
                                          //     ['available'][0]);
                                          print(cusID);

                                          sharedPrefs.setString('cusId', cusID);
                                          var pmId = res['details']['id'];

                                          if (res != null &&
                                              res['status'] == 'OK') {
                                            var paymentIntentResult =
                                                await StripePaymentApi()
                                                    .createPaymentIntent(
                                                        context,
                                                        '100',
                                                        currency,
                                                        res['details']['id'],
                                                        '',
                                                        true,
                                                        '');
                                            // await createPaymentIntent('1', 'INR', cusID,
                                            //     res['details']['id']);

                                            print("paymentIntentData>>>>>>>>>");
                                            print(paymentIntentResult);
                                            print(paymentIntentResult['details']
                                                ['id']);
                                            if (paymentIntentResult != null &&
                                                paymentIntentResult['status'] ==
                                                    'OK') {
                                              // var cardType = res['details']['card']
                                              //     ['networks']['available'][0];
                                              // var confirmRes = await UserAPI()
                                              //     .confirmPayment(
                                              //         context,
                                              //         paymentIntentData['details']['id'],
                                              //         cardType);
                                              // print('confirmRes>>>>>>>>>>');
                                              // print(confirmRes);

                                              // print(confirmRes['next_action']
                                              //     ['use_stripe_sdk']['stripe_js']);
                                              // print(confirmRes['next_action']);
                                              // final paymentIntent = await Stripe
                                              //     .instance
                                              //     .handleNextAction(
                                              //         paymentIntentResult['details']
                                              //             ['client_secret']);
                                              // print(paymentIntent.status);
                                              // if (paymentIntent.status ==
                                              //     PaymentIntentsStatus
                                              //         .RequiresConfirmation) {
                                              // 5. Call API to confirm intent
                                              try {
                                                var res = await Stripe.instance
                                                    .confirmPayment(
                                                  paymentIntentClientSecret:
                                                      paymentIntentResult[
                                                              'details']
                                                          ['client_secret'],
                                                  data: PaymentMethodParams
                                                      .cardFromMethodId(
                                                          paymentMethodData:
                                                              PaymentMethodDataCardFromMethod(
                                                    paymentMethodId: pmId,
                                                    // cvc: cvc
                                                  )),
                                                );
                                                if (res.status ==
                                                    PaymentIntentsStatus
                                                        .Succeeded) {
                                                  SharedPreferences
                                                      sharedPreferences =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  // if (_formKey.currentState!.validate() &&
                                                  //     monthsSelectedValue != null) {
                                                  var goalName;
                                                  var amount;
                                                  var date;
                                                  setState(() {
                                                    goalName = sharedPreferences
                                                        .getString("goalName");
                                                    amount = sharedPreferences
                                                        .getString(
                                                            "goalAmount");
                                                    date = sharedPreferences
                                                        .getString("goalDate");
                                                  });
                                                  if ((widget.type ==
                                                      GoldType().EditGoal)) {
                                                    var cardres =
                                                        await StripePaymentApi()
                                                            .addPaymentCardDetails(
                                                                context,
                                                                pmId,
                                                                cusID);
                                                    print(cardres);
                                                    if (cardres != null &&
                                                        cardres['status'] ==
                                                            'OK') {
                                                      loader(false);
                                                      // Twl.navigateBack(context);
                                                      Twl.navigateTo(context,
                                                          ChangesSavedSucessful());
                                                    } else {
                                                      loader(false);
                                                    }
                                                  } else {
                                                    var addGoalRes =
                                                        await OrderAPI()
                                                            .addGoal(
                                                                context,
                                                                goalName,
                                                                amount,
                                                                date,
                                                                pmId,
                                                                currency);
                                                    print('addGoalRes??????');
                                                    print(addGoalRes);
                                                    if (addGoalRes != null &&
                                                        addGoalRes['status'] ==
                                                            'OK') {
                                                      final facebookAppEvents =
                                                          FacebookAppEvents();
                                                      facebookAppEvents
                                                          .logEvent(
                                                        name:
                                                            'New Goal Created',
                                                        // parameters: {
                                                        //   'Sign up_id':
                                                        //       'the_clickme_button',
                                                        // },
                                                      );
                                                      stopLoading();
                                                      loader(false);
                                                      Twl.navigateTo(context,
                                                          ThanksForStartingGoalSucessful());
                                                    } else {
                                                      loader(false);
                                                      stopLoading();
                                                    }
                                                  }
                                                } else {
                                                  loader(false);
                                                  stopLoading();
                                                  print(res.status);
                                                  setState(() {
                                                    hasError = true;
                                                  });
                                                  _formKey.currentState!
                                                      .validate();
                                                }
                                              } catch (e) {
                                                loader(false);
                                                stopLoading();
                                                print(
                                                    'res.statueeeeeeeees????????????????????');
                                                print(e);
                                                setState(() {
                                                  hasError = true;
                                                });
                                              }
                                            } else {
                                              stopLoading();
                                              loader(false);
                                              // Twl.createAlert(context, 'error',
                                              //     paymentIntentResult['error']);
                                            }
                                          } else {
                                            loader(false);
                                            // Twl.createAlert(
                                            //     context, 'error', res['error']);
                                          }
                                          // }
                                        } else {
                                          loader(false);
                                          stopLoading();
                                          // Twl.createAlert(context, "error",
                                          //     customerRes['error']);
                                        }
                                      } else {
                                        setState(() {
                                          cusID = checkApi['detail']
                                              ['stripe_cus_id'];
                                        });
                                        print("cusID>>>>>>>>>>>>>>");
                                        print(cusID);
                                        var res = await OrderAPI()
                                            .createGoalPayment(
                                                context,
                                                cardnumber,
                                                expMonth,
                                                expYear,
                                                cvc,
                                                _nameController.text);
                                        print('createGoalPayment>>>>>>>>>>');
                                        // stopLoading();
                                        print(res);
                                        // print(res['details']['card']['networks']
                                        //     ['available'][0]);
                                        print(cusID);

                                        if (res != null &&
                                            res['status'] == 'OK') {
                                          var pmId = res['details']['id'];
                                          var paymentIntentResult =
                                              await StripePaymentApi()
                                                  .createPaymentIntent(
                                                      context,
                                                      '100',
                                                      currency,
                                                      res['details']['id'],
                                                      '',
                                                      true,
                                                      '');
                                          // await createPaymentIntent('1', 'INR', cusID,
                                          //     res['details']['id']);

                                          print("paymentIntentData>>>>>>>>>");
                                          print(paymentIntentResult);
                                          print(paymentIntentResult['details']
                                              ['id']);
                                          if (paymentIntentResult != null &&
                                              paymentIntentResult['status'] ==
                                                  'OK') {
                                            // var cardType = res['details']['card']
                                            //     ['networks']['available'][0];
                                            // var confirmRes = await UserAPI()
                                            //     .confirmPayment(
                                            //         context,
                                            //         paymentIntentData['details']['id'],
                                            //         cardType);
                                            // print('confirmRes>>>>>>>>>>');
                                            // print(confirmRes);

                                            // print(confirmRes['next_action']
                                            //     ['use_stripe_sdk']['stripe_js']);
                                            // print(confirmRes['next_action']);
                                            print(paymentIntentResult['details']
                                                ['client_secret']);
                                            // final paymentIntent = await Stripe
                                            //     .instance
                                            //     .handleNextAction(
                                            //         paymentIntentResult['details']
                                            //             ['client_secret']);
                                            // print(paymentIntent);
                                            // print(paymentIntent.status);
                                            // if (paymentIntent.status ==
                                            //     PaymentIntentsStatus
                                            //         .RequiresConfirmation) {
                                            // 5. Call API to confirm intent
                                            // stripePublicKey ='pk_test_51LjgVyCWDgwcpbq2UIfZw8gNszLkH8kxRA1jm5mKJbuW8xPhOsKgt1ApEy8vjbhfigKHSRKFIHUcwAIIvBAyKVTB00oQIJOYhK';
                                            try {
                                              var res = await Stripe.instance
                                                  .confirmPayment(
                                                paymentIntentClientSecret:
                                                    paymentIntentResult[
                                                            'details']
                                                        ['client_secret'],
                                                data: PaymentMethodParams
                                                    .cardFromMethodId(
                                                        paymentMethodData:
                                                            PaymentMethodDataCardFromMethod(
                                                                paymentMethodId:
                                                                    pmId,
                                                                cvc: cvc)),
                                              );
                                              print("confirmPayment>>>>>>");
                                              print(res);
                                              if (res.status ==
                                                  PaymentIntentsStatus
                                                      .Succeeded) {
                                                SharedPreferences
                                                    sharedPreferences =
                                                    await SharedPreferences
                                                        .getInstance();

                                                // if (_formKey.currentState!.validate() &&
                                                //     monthsSelectedValue != null) {
                                                var goalName;
                                                var amount;
                                                var date;
                                                setState(() {
                                                  goalName = sharedPreferences
                                                      .getString("goalName");
                                                  amount = sharedPreferences
                                                      .getString("goalAmount");
                                                  date = sharedPreferences
                                                      .getString("goalDate");
                                                });
                                                var addGoalRes =
                                                    await OrderAPI().addGoal(
                                                        context,
                                                        goalName,
                                                        amount,
                                                        date,
                                                        pmId,
                                                        currency);
                                                print('addGoalRes??????');
                                                print(addGoalRes);
                                                if (addGoalRes != null &&
                                                    addGoalRes['status'] ==
                                                        'OK') {
                                                  stopLoading();
                                                  loader(false);
                                                  Twl.navigateTo(context,
                                                      ThanksForStartingGoalSucessful());
                                                } else {
                                                  loader(false);
                                                  stopLoading();
                                                  // Twl.createAlert(
                                                  //     context,
                                                  //     'error',
                                                  //     addGoalRes['error']
                                                  //         ['message']);
                                                }
                                              } else {
                                                loader(false);
                                                stopLoading();
                                                print(
                                                    'res.status????????????????????');
                                                print(res.status);
                                                setState(() {
                                                  hasError = true;
                                                });
                                                _formKey.currentState!
                                                    .validate();
                                              }
                                            } catch (e) {
                                              if (e is StripeException) {
                                                print(
                                                    "Error from Stripe: ${e.error.localizedMessage}");
                                                // if (e.error.localizedMessage ==
                                                //     'Your card was declined.') {
                                                setState(() {
                                                  loadingPaymentStatus = false;
                                                });
                                                Twl.navigateBack(context);
                                                declinedAlert(
                                                  context,
                                                  e.error.localizedMessage,
                                                  // 'You have insufficient funds to complete this purchase.',
                                                  "Ok",
                                                );
                                              } else {
                                                setState(() {
                                                  loadingPaymentStatus = false;
                                                });
                                                setState(() {
                                                  hasError = true;
                                                });
                                                _formKey.currentState!
                                                    .validate();
                                              }
                                              // } else {
                                              //   setState(() {
                                              //     loadingPaymentStatus = false;
                                              //   });
                                              //   setState(() {
                                              //     hasError = true;
                                              //   });
                                              //   _formKey.currentState!
                                              //       .validate();
                                              //   print("Unforeseen error: $e");
                                              // }
                                              // loader(false);
                                              // stopLoading();
                                              // print(
                                              //     'res.statueeeeeeeees????????????????????');
                                              // print(e);
                                              // setState(() {
                                              //   hasError = true;
                                              // });
                                              // _formKey.currentState!.validate();
                                            }
                                            // } else {
                                            //   loader(false);
                                            //   stopLoading();
                                            //   // Twl.createAlert(context, 'error',
                                            //   //     paymentIntentResult['error']);
                                            // }
                                          } else {
                                            loader(false);
                                            // Twl.createAlert(context, 'error',
                                            //     paymentIntentResult['error']);
                                          }
                                        } else {
                                          setState(() {
                                            hasError = true;
                                          });
                                          loader(false);
                                          _formKey.currentState!.validate();
                                          // Twl.createAlert(
                                          //     context, 'error', res['error']);
                                        }
                                      }

                                      // if (customerRes != null &&
                                      //     customerRes['status'] == "OK") {
                                      //   print("cusID>>>>>>>>>>>>>>");
                                      //   print(cusID);
                                      //   var res = await OrderAPI().createGoalPayment(
                                      //       context,
                                      //       cardnumber,
                                      //       expMonth,
                                      //       expYear,
                                      //       cvc,
                                      //       _nameController.text);
                                      //   print('createGoalPayment>>>>>>>>>>');
                                      //   // stopLoading();
                                      //   print(res);
                                      //   // print(res['details']['card']['networks']
                                      //   //     ['available'][0]);
                                      //   print(cusID);
                                      //   var pmId = res['details']['id'];
                                      //   if (res != null && res['status'] == 'OK') {
                                      //     var paymentIntentResult =
                                      //         await StripePaymentApi()
                                      //             .createPaymentIntent(context, '100',
                                      //                 currency, res['details']['id'], '',true);
                                      //     // await createPaymentIntent('1', 'INR', cusID,
                                      //     //     res['details']['id']);

                                      //     print("paymentIntentData>>>>>>>>>");
                                      //     print(paymentIntentResult);
                                      //     print(paymentIntentResult['details']['id']);
                                      //     if (paymentIntentResult != null &&
                                      //         paymentIntentResult['status'] == 'OK') {
                                      //       // var cardType = res['details']['card']
                                      //       //     ['networks']['available'][0];
                                      //       // var confirmRes = await UserAPI()
                                      //       //     .confirmPayment(
                                      //       //         context,
                                      //       //         paymentIntentData['details']['id'],
                                      //       //         cardType);
                                      //       // print('confirmRes>>>>>>>>>>');
                                      //       // print(confirmRes);

                                      //       // print(confirmRes['next_action']
                                      //       //     ['use_stripe_sdk']['stripe_js']);
                                      //       // print(confirmRes['next_action']);
                                      //       final paymentIntent = await Stripe.instance
                                      //           .handleNextAction(
                                      //               paymentIntentResult['details']
                                      //                   ['client_secret']);
                                      //       print(paymentIntent.status);
                                      //       if (paymentIntent.status ==
                                      //           PaymentIntentsStatus
                                      //               .RequiresConfirmation) {
                                      //         // 5. Call API to confirm intent
                                      //         var res =
                                      //             await Stripe.instance.confirmPayment(
                                      //           paymentIntentResult['details']
                                      //               ['client_secret'],
                                      //           PaymentMethodParams.cardFromMethodId(
                                      //               paymentMethodData:
                                      //                   PaymentMethodDataCardFromMethod(
                                      //                       paymentMethodId: pmId)),
                                      //         );
                                      //         if (res.status ==
                                      //             PaymentIntentsStatus.Succeeded) {
                                      //           SharedPreferences sharedPreferences =
                                      //               await SharedPreferences
                                      //                   .getInstance();

                                      //           // if (_formKey.currentState!.validate() &&
                                      //           //     monthsSelectedValue != null) {
                                      //           var goalName;
                                      //           var amount;
                                      //           var date;
                                      //           setState(() {
                                      //             goalName = sharedPreferences
                                      //                 .getString("goalName");
                                      //             amount = sharedPreferences
                                      //                 .getString("goalAmount");
                                      //             date = sharedPreferences
                                      //                 .getString("goalDate");
                                      //           });
                                      //           var addGoalRes = await OrderAPI()
                                      //               .addGoal(context, goalName, amount,
                                      //                   date, pmId, "INR");
                                      //           print('addGoalRes??????');
                                      //           print(addGoalRes);
                                      //           if (addGoalRes != null &&
                                      //               addGoalRes['status'] == 'OK') {
                                      //             stopLoading();
                                      //             Twl.navigateTo(context,
                                      //                 ThanksForStartingGoalSucessful());
                                      //           } else {
                                      //             stopLoading();
                                      //             Twl.createAlert(context, 'error',
                                      //                 addGoalRes['error']['message']);
                                      //           }
                                      //         }
                                      //       } else {
                                      //         stopLoading();
                                      //         Twl.createAlert(context, 'error',
                                      //             paymentIntentResult['error']);
                                      //       }
                                      //       // showDialog(
                                      //       //   context: context,
                                      //       //   barrierDismissible:
                                      //       //       false, // user must tap button!
                                      //       //   builder: (BuildContext context) {
                                      //       //     return AlertDialog(
                                      //       //       backgroundColor: tTextformfieldColor,
                                      //       //       shape: RoundedRectangleBorder(
                                      //       //           borderRadius: BorderRadius.all(
                                      //       //               Radius.circular(15.0))),
                                      //       //       // title: const Text('Are you sure you want to exit?'),
                                      //       //       // content: SingleChildScrollView(
                                      //       //       //   child: ListBody(
                                      //       //       //     children: const <Widget>[
                                      //       //       //       Text('This is a demo alert dialog.'),
                                      //       //       //       Text('Would you like to approve of this message?'),
                                      //       //       //     ],
                                      //       //       //   ),
                                      //       //       // ),
                                      //       //       actions: <Widget>[
                                      //       //         Column(
                                      //       //           children: [
                                      //       //             Center(
                                      //       //               child: Container(
                                      //       //                   // elevation: 0,
                                      //       //                   // color: tTextformfieldColor,
                                      //       //                   // shape:
                                      //       //                   //     RoundedRectangleBorder(
                                      //       //                   //   borderRadius:
                                      //       //                   //       BorderRadius.circular(
                                      //       //                   //           10),
                                      //       //                   // ),
                                      //       //                   child: Container(
                                      //       //                 height: 350,
                                      //       //                 width: double.infinity,
                                      //       //                 child: Padding(
                                      //       //                   padding: const EdgeInsets
                                      //       //                           .symmetric(
                                      //       //                       horizontal: 30,
                                      //       //                       vertical: 10),
                                      //       //                   child: Column(
                                      //       //                       mainAxisAlignment:
                                      //       //                           MainAxisAlignment
                                      //       //                               .spaceAround,
                                      //       //                       children: [
                                      //       //                         Column(children: [
                                      //       //                           SizedBox(
                                      //       //                             height: 20,
                                      //       //                           ),
                                      //       //                           Text(
                                      //       //                             ' confirm ${Secondarycurrency}1',
                                      //       //                             style: TextStyle(
                                      //       //                                 color:
                                      //       //                                     tSecondaryColor,
                                      //       //                                 fontSize: isTab(
                                      //       //                                         context)
                                      //       //                                     ? 13.sp
                                      //       //                                     : 16.sp,
                                      //       //                                 fontWeight:
                                      //       //                                     FontWeight
                                      //       //                                         .w400),
                                      //       //                             textAlign:
                                      //       //                                 TextAlign
                                      //       //                                     .center,
                                      //       //                           ),
                                      //       //                         ]),
                                      //       //                         // if (image != null)
                                      //       //                         Image.asset(
                                      //       //                           Images.NEWGOAL,
                                      //       //                           scale: 1.3,
                                      //       //                         ),
                                      //       //                         Column(
                                      //       //                           children: [
                                      //       //                             Center(
                                      //       //                               child:
                                      //       //                                   Container(
                                      //       //                                 width: double
                                      //       //                                     .infinity,
                                      //       //                                 child:
                                      //       //                                     ArgonButton(
                                      //       //                                   height: isTab(
                                      //       //                                           context)
                                      //       //                                       ? 70
                                      //       //                                       : 40,
                                      //       //                                   width: 90.w,
                                      //       //                                   color:
                                      //       //                                       tPrimaryColor,
                                      //       //                                   borderRadius:
                                      //       //                                       15,
                                      //       //                                   child: Text(
                                      //       //                                     'verify',
                                      //       //                                     style:
                                      //       //                                         TextStyle(
                                      //       //                                       color:
                                      //       //                                           tSecondaryColor,
                                      //       //                                       fontSize:
                                      //       //                                           13.sp,
                                      //       //                                       fontWeight:
                                      //       //                                           FontWeight.w600,
                                      //       //                                     ),
                                      //       //                                   ),
                                      //       //                                   loader:
                                      //       //                                       Container(
                                      //       //                                     // height: 40,
                                      //       //                                     // width: double.infinity,
                                      //       //                                     padding: EdgeInsets.symmetric(
                                      //       //                                         horizontal:
                                      //       //                                             0),
                                      //       //                                     child: Lottie
                                      //       //                                         .asset(
                                      //       //                                       loading
                                      //       //                                           .LOADING,
                                      //       //                                       // width: 50.w,
                                      //       //                                     ),
                                      //       //                                   ),
                                      //       //                                   onTap: (startLoading,
                                      //       //                                       stopLoading,
                                      //       //                                       btnState) async {
                                      //       //                                     Twl.launchURL(
                                      //       //                                         context,
                                      //       //                                         confirmRes['next_action']['use_stripe_sdk']
                                      //       //                                             [
                                      //       //                                             'stripe_js']);
                                      //       //                                   },
                                      //       //                                 ),
                                      //       //                               ),
                                      //       //                             ),
                                      //       //                             SizedBox(
                                      //       //                                 height: 10),
                                      //       //                             Center(
                                      //       //                               child:
                                      //       //                                   Container(
                                      //       //                                 width: double
                                      //       //                                     .infinity,
                                      //       //                                 child:
                                      //       //                                     ArgonButton(
                                      //       //                                   height: isTab(
                                      //       //                                           context)
                                      //       //                                       ? 70
                                      //       //                                       : 40,
                                      //       //                                   width: 90.w,
                                      //       //                                   color:
                                      //       //                                       tPrimaryColor,
                                      //       //                                   borderRadius:
                                      //       //                                       15,
                                      //       //                                   child: Text(
                                      //       //                                     'Continue',
                                      //       //                                     style:
                                      //       //                                         TextStyle(
                                      //       //                                       color:
                                      //       //                                           tSecondaryColor,
                                      //       //                                       fontSize:
                                      //       //                                           13.sp,
                                      //       //                                       fontWeight:
                                      //       //                                           FontWeight.w600,
                                      //       //                                     ),
                                      //       //                                   ),
                                      //       //                                   loader:
                                      //       //                                       Container(
                                      //       //                                     // height: 40,
                                      //       //                                     // width: double.infinity,
                                      //       //                                     padding: EdgeInsets.symmetric(
                                      //       //                                         horizontal:
                                      //       //                                             0),
                                      //       //                                     child: Lottie
                                      //       //                                         .asset(
                                      //       //                                       loading
                                      //       //                                           .LOADING,
                                      //       //                                       // width: 50.w,
                                      //       //                                     ),
                                      //       //                                   ),
                                      //       //                                   onTap: (startLoading,
                                      //       //                                       stopLoading,
                                      //       //                                       btnState) async {
                                      //       //                                         //startLoading();
                                      //       //                                     if (confirmRes !=
                                      //       //                                         null) {
                                      //       //                                       var pmId;
                                      //       //                                       setState(
                                      //       //                                           () {
                                      //       //                                         pmId =
                                      //       //                                             res['details']['id'];
                                      //       //                                       });
                                      //       //                                       print(
                                      //       //                                           pmId);

                                      //       //                                       var addGoalRes = await OrderAPI().addGoal(
                                      //       //                                           context,
                                      //       //                                           widget.goalName,
                                      //       //                                           widget.amount,
                                      //       //                                           widget.date,
                                      //       //                                           pmId,
                                      //       //                                           "INR");
                                      //       //                                       print(
                                      //       //                                           'addGoalRes??????');
                                      //       //                                       print(
                                      //       //                                           addGoalRes);
                                      //       //                                       if (addGoalRes !=
                                      //       //                                               null &&
                                      //       //                                           addGoalRes['status'] ==
                                      //       //                                               'OK') {
                                      //       //                                         // var confirmPayment = await OrderAPI()
                                      //       //                                         //     .confirmGoalPayment(
                                      //       //                                         //         context,
                                      //       //                                         //         addGoalRes['details']
                                      //       //                                         //             ['latest_invoice']);
                                      //       //                                         // if (confirmPayment != null &&
                                      //       //                                         //     confirmPayment['status'] == 'OK') {
                                      //       //                                         //   print('confirmPayment');
                                      //       //                                         //   print(confirmPayment);
                                      //       //                                         // Twl.launchURL(context, confirmPayment['details']['hosted_invoice_url']);
                                      //       //                                         stopLoading();
                                      //       //                                         Twl.navigateTo(
                                      //       //                                             context,
                                      //       //                                             ThanksForStartingGoalSucessful());
                                      //       //                                         // } else {
                                      //       //                                         //   stopLoading();
                                      //       //                                         //   Twl.createAlert(context, 'error',
                                      //       //                                         //       confirmPayment['error']);
                                      //       //                                         // }

                                      //       //                                         // Twl.navigateTo(context, PaymentDetails());
                                      //       //                                       } else {
                                      //       //                                         stopLoading();
                                      //       //                                         Twl.createAlert(
                                      //       //                                             context,
                                      //       //                                             'error',
                                      //       //                                             addGoalRes['error']['message']);
                                      //       //                                       }
                                      //       //                                     } else {
                                      //       //                                       stopLoading();
                                      //       //                                       Twl.createAlert(
                                      //       //                                           context,
                                      //       //                                           'error',
                                      //       //                                           res['error']);
                                      //       //                                     }
                                      //       //                                      stopLoading();
                                      //       //                                   },
                                      //       //                                 ),
                                      //       //                               ),
                                      //       //                             )
                                      //       //                           ],
                                      //       //                         ),
                                      //       //                       ]),
                                      //       //                 ),
                                      //       //               )),
                                      //       //             ),
                                      //       //           ],
                                      //       //         )
                                      //       //       ],
                                      //       //     );
                                      //       //   },
                                      //       // );

                                      //       // customAlert(
                                      //       //     context,
                                      //       //     'confirm ${Secondarycurrency}1',
                                      //       //     "verify",
                                      //       //     'continue',
                                      //       //     (Images.NEWGOAL), (startLoading,
                                      //       //         stopLoading, btnState) async {
                                      //       //   //startLoading();
                                      //       //   Twl.launchURL(
                                      //       //       context,
                                      //       //       confirmRes['next_action']
                                      //       //           ['use_stripe_sdk']['stripe_js']);
                                      //       //   if (confirmRes != null) {
                                      //       //     var pmId;
                                      //       //     setState(() {
                                      //       //       pmId = res['details']['id'];
                                      //       //     });
                                      //       //     print(pmId);

                                      //       //     var addGoalRes = await OrderAPI().addGoal(
                                      //       //         context,
                                      //       //         widget.goalName,
                                      //       //         widget.amount,
                                      //       //         widget.date,
                                      //       //         pmId,
                                      //       //         "INR");
                                      //       //     print('addGoalRes??????');
                                      //       //     print(addGoalRes);
                                      //       //     if (addGoalRes != null &&
                                      //       //         addGoalRes['status'] == 'OK') {
                                      //       //       // var confirmPayment = await OrderAPI()
                                      //       //       //     .confirmGoalPayment(
                                      //       //       //         context,
                                      //       //       //         addGoalRes['details']
                                      //       //       //             ['latest_invoice']);
                                      //       //       // if (confirmPayment != null &&
                                      //       //       //     confirmPayment['status'] == 'OK') {
                                      //       //       //   print('confirmPayment');
                                      //       //       //   print(confirmPayment);
                                      //       //       // Twl.launchURL(context, confirmPayment['details']['hosted_invoice_url']);
                                      //       //       stopLoading();
                                      //       //       Twl.navigateTo(context,
                                      //       //           ThanksForStartingGoalSucessful());
                                      //       //       // } else {
                                      //       //       //   stopLoading();
                                      //       //       //   Twl.createAlert(context, 'error',
                                      //       //       //       confirmPayment['error']);
                                      //       //       // }

                                      //       //       // Twl.navigateTo(context, PaymentDetails());
                                      //       //     } else {
                                      //       //       stopLoading();
                                      //       //       Twl.createAlert(context, 'error',
                                      //       //           addGoalRes['error']['message']);
                                      //       //     }
                                      //       //   } else {
                                      //       //     stopLoading();
                                      //       //     Twl.createAlert(
                                      //       //         context, 'error', res['error']);
                                      //       //   }
                                      //       //   stopLoading();
                                      //       // });

                                      //     } else {
                                      //       Twl.createAlert(context, 'error',
                                      //           paymentIntentResult['error']);
                                      //     }
                                      //   } else {
                                      //     Twl.createAlert(
                                      //         context, 'error', res['error']);
                                      //   }
                                      // } else {
                                      //   Twl.createAlert(
                                      //       context, "error", customerRes['error']);
                                      // }
                                      stopLoading();
                                      // }
                                    }

                                    // Twl.navigateBack(context);
                                  }
                                  // //startLoading();
                                }
                                // stopLoading();
                                // }
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
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
            ))
        ],
      ),
    );
  }

  createPaymentIntent(
      String amount, String currency, String cusId, paymentMoethod) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId;
    setState(() {
      userId = sharedPreferences.getString('userId');
    });
    // var orderId = userId + '_' + getRandomString(15);
    print(userId);
    print(cusId);
    // print(orderId);
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'metadata[userid]': userId,
        'customer': cusId,
        'payment_method': paymentMoethod,
        'setup_future_usage': 'off_session',
        'metadata[is_refund]': 'true'
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

  calculateAmount(amount) {
    print("djjd");
    print(amount.runtimeType);
    final a = (double.parse(amount)) * 100;
    // final b = int.parse(a.toString());
    // print(b);
    return a.toStringAsFixed(0);
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return "";
      // return "Name cant't be empty";
    }
    return null;
  }

  String? validateCard(String? value) {
    if (value!.isEmpty || hasError) {
      return "";
      // return "card Number cant't be empty";
    }
    return null;
  }

  String? validateExpiryMonth(String? value) {
    if (value!.isEmpty || int.parse(value) > 12 || hasError) {
      return "";
    }
    return null;
  }

  String? validateExpiryYear(String? value) {
    if (value!.isEmpty || hasError) {
      return "";
    }
    return null;
  }

  String? validateCvv(String? value) {
    if (value!.isEmpty || hasError) {
      return "";
    }
    return null;
  }

  titleWidget(
    String title,
  ) {
    return Text(
      title,
      style: TextStyle(
        color: tSecondaryColor,
        fontSize: isTab(context) ? 9.sp : 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget textFormField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
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




// showDialog(
//                                     context: context,
//                                     barrierDismissible:
//                                         false, // user must tap button!
//                                     builder: (BuildContext context) {
//                                       return AlertDialog(
//                                         backgroundColor: tTextformfieldColor,
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.all(
//                                                 Radius.circular(15.0))),
//                                         // title: const Text('Are you sure you want to exit?'),
//                                         // content: SingleChildScrollView(
//                                         //   child: ListBody(
//                                         //     children: const <Widget>[
//                                         //       Text('This is a demo alert dialog.'),
//                                         //       Text('Would you like to approve of this message?'),
//                                         //     ],
//                                         //   ),
//                                         // ),
//                                         actions: <Widget>[
//                                           Column(
//                                             children: [
//                                               Center(
//                                                 child: Container(
//                                                     // elevation: 0,
//                                                     // color: tTextformfieldColor,
//                                                     // shape:
//                                                     //     RoundedRectangleBorder(
//                                                     //   borderRadius:
//                                                     //       BorderRadius.circular(
//                                                     //           10),
//                                                     // ),
//                                                     child: Container(
//                                                   height: 350,
//                                                   width: double.infinity,
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: 30,
//                                                         vertical: 10),
//                                                     child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceAround,
//                                                         children: [
//                                                           Column(children: [
//                                                             SizedBox(
//                                                               height: 20,
//                                                             ),
//                                                             Text(
//                                                               '',
//                                                               style: TextStyle(
//                                                                   color:
//                                                                       tSecondaryColor,
//                                                                   fontSize: isTab(
//                                                                           context)
//                                                                       ? 13.sp
//                                                                       : 16.sp,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400),
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                             ),
//                                                           ]),
//                                                           // if (image != null)
//                                                           //   Image.asset(
//                                                           //     image!,
//                                                           //     scale: 4,
//                                                           //   ),
//                                                           Column(
//                                                             children: [
//                                                               Center(
//                                                                 child:
//                                                                     Container(
//                                                                   width: double
//                                                                       .infinity,
//                                                                   child:
//                                                                       ArgonButton(
//                                                                     height: isTab(
//                                                                             context)
//                                                                         ? 70
//                                                                         : 40,
//                                                                     width: 90.w,
//                                                                     color:
//                                                                         tPrimaryColor,
//                                                                     borderRadius:
//                                                                         15,
//                                                                     child: Text(
//                                                                       'verify',
//                                                                       style:
//                                                                           TextStyle(
//                                                                         color:
//                                                                             tSecondaryColor,
//                                                                         fontSize:
//                                                                             13.sp,
//                                                                         fontWeight:
//                                                                             FontWeight.w600,
//                                                                       ),
//                                                                     ),
//                                                                     loader:
//                                                                         Container(
//                                                                       // height: 40,
//                                                                       // width: double.infinity,
//                                                                       padding: EdgeInsets.symmetric(
//                                                                           horizontal:
//                                                                               0),
//                                                                       child: Lottie
//                                                                           .asset(
//                                                                         loading
//                                                                             .LOADING,
//                                                                         // width: 50.w,
//                                                                       ),
//                                                                     ),
//                                                                     onTap: (startLoading,
//                                                                         stopLoading,
//                                                                         btnState) async {
//                                                                       Twl.launchURL(
//                                                                           context,
//                                                                           confirmRes['next_action']['use_stripe_sdk']
//                                                                               [
//                                                                               'stripe_js']);
//                                                                     },
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                   height: 10),
//                                                               Center(
//                                                                 child:
//                                                                     Container(
//                                                                   width: double
//                                                                       .infinity,
//                                                                   child:
//                                                                       ArgonButton(
//                                                                     height: isTab(
//                                                                             context)
//                                                                         ? 70
//                                                                         : 40,
//                                                                     width: 90.w,
//                                                                     color:
//                                                                         tPrimaryColor,
//                                                                     borderRadius:
//                                                                         15,
//                                                                     child: Text(
//                                                                       'continue',
//                                                                       style:
//                                                                           TextStyle(
//                                                                         color:
//                                                                             tSecondaryColor,
//                                                                         fontSize:
//                                                                             13.sp,
//                                                                         fontWeight:
//                                                                             FontWeight.w600,
//                                                                       ),
//                                                                     ),
//                                                                     loader:
//                                                                         Container(
//                                                                       // height: 40,
//                                                                       // width: double.infinity,
//                                                                       padding: EdgeInsets.symmetric(
//                                                                           horizontal:
//                                                                               0),
//                                                                       child: Lottie
//                                                                           .asset(
//                                                                         loading
//                                                                             .LOADING,
//                                                                         // width: 50.w,
//                                                                       ),
//                                                                     ),
//                                                                     onTap: (startLoading,
//                                                                         stopLoading,
//                                                                         btnState) async {
//                                                                       var paymentStatus = await StripePaymentApi().capturePayment(
//                                                                           context,
//                                                                           paymentIntentData[
//                                                                               'id']);
//                                                                       print(
//                                                                           paymentStatus);
//                                                                       if (paymentStatus['error']['payment_intent']
//                                                                               [
//                                                                               'status'] ==
//                                                                           'succeeded') {
//                                                                         if (confirmRes !=
//                                                                             null) {
//                                                                           var pmId;
//                                                                           setState(
//                                                                               () {
//                                                                             pmId =
//                                                                                 res['details']['id'];
//                                                                           });
//                                                                           print(
//                                                                               pmId);

//                                                                           var addGoalRes = await OrderAPI().addGoal(
//                                                                               context,
//                                                                               widget.goalName,
//                                                                               widget.amount,
//                                                                               widget.date,
//                                                                               pmId,
//                                                                               "INR");
//                                                                           print(
//                                                                               'addGoalRes??????');
//                                                                           print(
//                                                                               addGoalRes);
//                                                                           if (addGoalRes != null &&
//                                                                               addGoalRes['status'] == 'OK') {
//                                                                             // var confirmPayment = await OrderAPI()
//                                                                             //     .confirmGoalPayment(
//                                                                             //         context,
//                                                                             //         addGoalRes['details']
//                                                                             //             ['latest_invoice']);
//                                                                             // if (confirmPayment != null &&
//                                                                             //     confirmPayment['status'] == 'OK') {
//                                                                             //   print('confirmPayment');
//                                                                             //   print(confirmPayment);
//                                                                             // Twl.launchURL(context, confirmPayment['details']['hosted_invoice_url']);
//                                                                             stopLoading();
//                                                                             Twl.navigateTo(context,
//                                                                                 ThanksForStartingGoalSucessful());
//                                                                             // } else {
//                                                                             //   stopLoading();
//                                                                             //   Twl.createAlert(context, 'error',
//                                                                             //       confirmPayment['error']);
//                                                                             // }

//                                                                             // Twl.navigateTo(context, PaymentDetails());
//                                                                           } else {
//                                                                             stopLoading();
//                                                                             Twl.createAlert(
//                                                                                 context,
//                                                                                 'error',
//                                                                                 addGoalRes['error']['message']);
//                                                                           }
//                                                                         } else {
//                                                                           stopLoading();
//                                                                           Twl.createAlert(
//                                                                               context,
//                                                                               'error',
//                                                                               res['error']);
//                                                                         }
//                                                                       }else{
//                                                                         Twl.createAlert(context, 'error', 'verify your account');
//                                                                       }
//                                                                     },
//                                                                   ),
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         ]),
//                                                   ),
//                                                 )),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       );
//                                     });


// await Stripe.instance.initPaymentSheet(
                                //     paymentSheetParameters:
                                //         SetupPaymentSheetParameters(
                                //   applePay: PaymentSheetApplePay(
                                //     merchantCountryCode: 'IN',
                                //   ),
                                //   googlePay: PaymentSheetGooglePay(
                                //       merchantCountryCode: 'IN'),
                                //   // testEnv: true,
                                //   // merchantCountryCode: 'US',
                                //   // billingDetails: billingDetails,
                                //   merchantDisplayName: 'Prospects',
                                //   customerId: 'cus_MMcPfzOyaEbrxx',
                                //   paymentIntentClientSecret:
                                //       // 'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE',
                                //       paymentIntentData['client_secret'],
                                //   customerEphemeralKeySecret:
                                //       paymentIntentData['ephemeralKey'],
                                // ));

                                // await Stripe.instance.presentPaymentSheet(
                                //     parameters: PresentPaymentSheetParameters(
                                //   clientSecret: paymentIntentData['client_secret'],
                                //   confirmPayment: true,
                                // ));
                                // await Stripe.instance.confirmPaymentSheetPayment();