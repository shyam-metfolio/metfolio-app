import 'dart:io';

import 'package:base_project_flutter/api_services/stripeApi.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/views/PersonalDetails/PersonalDetails.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalName.dart';
import 'package:base_project_flutter/views/term&ConditionPage/term&condition.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:veriff_flutter/veriff_flutter.dart';
import '../../api_services/orderApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../globalWidgets/twlTextField.dart';
import '../../responsive.dart';
// import 'package:firebase_ml_vision_raw_bytes/firebase_ml_vision_raw_bytes.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
// import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../components/alertPage.dart';
import '../successfullPage/PurchesedConfirmSucessfull.dart';

class PaymentCardDetails extends StatefulWidget {
  PaymentCardDetails({Key? key, this.amount}) : super(key: key);
  final amount;

  @override
  State<PaymentCardDetails> createState() => _PaymentCardDetailsState();
}

class _PaymentCardDetailsState extends State<PaymentCardDetails>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // WidgetsBinding.instance!.addObserver(this);
    super.initState();

    //  _channel = MlKitChannel();
  }

  @override
  void dispose() {
    // timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _cardController = TextEditingController();

  TextEditingController _expiryMonthController = TextEditingController();
  TextEditingController _expiryYearController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  CreditCardValidator _ccValidator = CreditCardValidator();
  final _formKey = new GlobalKey<FormState>();
  CardDetails _card = CardDetails();
  bool loadingPaymentStatus = false;
  loader(value) {
    setState(() {
      loadingPaymentStatus = value;
    });
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
  //     //   timer.cancel();
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
  //   }
  // }

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
              body: Form(
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
                              // SizedBox(height: 2.h),
                              // GestureDetector(
                              //   onTap: () async {
                              //     // final File imageFile = await getImageFile();
                              //     // final FirebaseVisionImage visionImage =
                              //     //     await FirebaseVisionImage.fromFile(imageFile);
                              //     // print("visionImage>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                              //     // final textRec =
                              //     //     await FirebaseVision.instance.textRecognizer();
                              //     // var text = await textRec.processImage(visionImage);
                              //     // print("text>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                              //     // // print(text.text.characters);
                              //     // print(text.text.characters.first);
                              //     // String pattern = '^4[0-9]{12}(?:[0-9]{3})?\$';
                              //     // RegExp regEx = RegExp(pattern);

                              //     // // String mailAddress = "";

                              //     // for (TextBlock block in text.blocks) {
                              //     //   for (TextLine line in block.lines) {
                              //     //     // print(line.text + '\n');
                              //     //     var ccNumResults =
                              //     //         _ccValidator.validateCCNum(line.text);
                              //     //     print(line.text);
                              //     //     print(ccNumResults.ccType);
                              //     //     // Checking if the line contains an email address
                              //     //     // if (regEx.hasMatch(line.text)) {
                              //     //     //   print("textensd>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                              //     //     //   print(line.text + '\n');
                              //     //     // }
                              //     //     // mailAddress +=
                              //     //     // var res = CardUtils().getCardIssuer(line.text);
                              //     //     // print(res);
                              //     //     // line.text + '\n';
                              //     //     // }
                              //     //   }
                              //     // }
                              //   },
                              //   child: Row(
                              //     children: [
                              //       Image.asset(
                              //         Images.PAYMENTCARDICON,
                              //         scale: 3.5,
                              //       ),
                              //       SizedBox(
                              //         width: 4.w,
                              //       ),
                              //       Text(
                              //         "Scan Card",
                              //         style: TextStyle(
                              //             color: tSecondaryColor,
                              //             fontSize: isTab(context) ? 9.sp : 12.sp,
                              //             fontWeight: FontWeight.w400),
                              //       ),
                              //       SizedBox(
                              //         width: 6.w,
                              //       ),
                              //       Image.asset(
                              //         Images.NEXTICON,
                              //         scale: 4,
                              //       )
                              //     ],
                              //   ),
                              // ),
                              SizedBox(height: 4.h),
                              titleWidget('Name (as shown on card)'),
                              SizedBox(height: 1.h),
                              TwlNormalTextField(
                                textCapitalization: TextCapitalization.words,
                                inputForamtters: [UpperCaseFormatter()],
                                controller: _nameController,
                                textInputType: TextInputType.text,
                                validator: validateName,
                              ),
                              SizedBox(height: 2.h),
                              titleWidget('Card Number'),
                              SizedBox(height: 1.h),
                              TwlNormalTextField(
                                onchnage: (value) {
                                  setState(() {
                                    hasError = false;
                                  });
                                  print(value.replaceAll(' ', ''));
                                  var ccNumResults =
                                      _ccValidator.validateCCNum(value);
                                  print(ccNumResults.ccType);
                                  setState(() {
                                    _card = _card.copyWith(
                                        number: value.replaceAll(' ', ''));
                                  });
                                  print(_card);
                                },
                                controller: _cardController,
                                textInputType: TextInputType.number,
                                validator: validateCard,
                                maxlength: 19,
                                inputForamtters: [
                                  // LengthLimitingTextInputFormatter(16),
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
                                        onchnage: (value) {
                                          setState(() {
                                            hasError = false;
                                            _card = _card.copyWith(
                                                expirationMonth:
                                                    int.tryParse(value));
                                          });
                                          _formKey.currentState!.validate();
                                        },
                                        // prefixText: c,
                                        controller: _expiryMonthController,
                                        textInputType: TextInputType.datetime,
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
                                        onchnage: (value) {
                                          setState(() {
                                            hasError = false;
                                            _card = _card.copyWith(
                                                expirationYear:
                                                    int.tryParse(value));
                                          });
                                          _formKey.currentState!.validate();
                                        },
                                        controller: _expiryYearController,
                                        textInputType: TextInputType.datetime,
                                        validator: validateExpiryYear,
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
                                  onchnage: (value) {
                                    setState(() {
                                      hasError = false;
                                      _card = _card.copyWith(cvc: value);
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
                        padding: EdgeInsets.symmetric(horizontal: 17.w),
                        child: Align(
                          alignment: Alignment.center,
                          child: Button(
                              borderSide: BorderSide.none,
                              color: tPrimaryColor,
                              textcolor: tWhite,
                              bottonText:
                                  'Pay ${Secondarycurrency + widget.amount}',
                              onTap:
                                  (startLoading, stopLoading, btnState) async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  loader(true);
                                  print(_card);
                                  print(_card.number);
                                  var ccNumResults = _ccValidator
                                      .validateCCNum(_card.number.toString());
                                  var expDateResults =
                                      _ccValidator.validateExpDate(
                                          _card.expirationYear.toString());
                                  var cvvResults = _ccValidator.validateCVV(
                                      _card.cvc.toString(),
                                      ccNumResults.ccType);
                                  print(ccNumResults.isPotentiallyValid);
                                  print(ccNumResults.ccType);

                                  // if (ccNumResults.isPotentiallyValid) {
                                  // //startLoading();
                                  print(_card);
                                  print(widget.amount);
                                  var amount = await Twl.calculateAmount(
                                      widget.amount.toString());
                                  try {
                                    await Stripe.instance
                                        .dangerouslyUpdateCardDetails(_card);

                                    try {
                                      // 1. Gather customer billing information (ex. email)
                                      SharedPreferences sharedPrefs =
                                          await SharedPreferences.getInstance();
                                      var authCode =
                                          sharedPrefs.getString('authCode');
                                      var checkApi =
                                          await UserAPI().checkApi(authCode);
                                      print(checkApi);
                                      if (checkApi != null &&
                                          checkApi['status'] == 'OK') {
                                        var billingDetails = BillingDetails();
                                        setState(() {
                                          billingDetails =
                                              billingDetails.copyWith(
                                                  name: _nameController.text,
                                                  phone: checkApi['detail']
                                                      ['username'],
                                                  email: checkApi['detail']
                                                      ['email'],
                                                  address: Address.fromJson({
                                                    'city': checkApi['detail']
                                                            ['delivery_address']
                                                        ['city'],
                                                    'country': 'US',
                                                    'line1': checkApi['detail']
                                                            ['delivery_address']
                                                        ['address_line_one'],
                                                    'line2': checkApi['detail']
                                                            ['delivery_address']
                                                        ['address_line_two'],
                                                    // 'state': 'Texas',
                                                    'postalCode': checkApi[
                                                                'detail']
                                                            ['delivery_address']
                                                        ['post_code'],
                                                  }));
                                        });

                                        // mocked data for tests
                                        try {
                                          // 2. Create payment method
                                          final paymentMethod = await Stripe
                                              .instance
                                              .createPaymentMethod(
                                                  params:
                                                      PaymentMethodParams.card(
                                            paymentMethodData:
                                                PaymentMethodData(
                                              billingDetails: billingDetails,
                                            ),
                                          ));
                                          print("paymentMethod>>>>>>>>>>>");
                                          print(paymentMethod);
                                          print(checkApi);
                                          var cardType =
                                              paymentMethod.card.brand;
                                          // if (checkApi['detail']['stripe_cus_id'] != null &&
                                          //     checkApi['detail']['stripe_cus_id'] != '') {
                                          var cusID;
                                          if (checkApi['detail']
                                                      ['stripe_cus_id'] ==
                                                  null ||
                                              checkApi['detail']
                                                      ['stripe_cus_id'] ==
                                                  "") {
                                            print("dibdsn");
                                            var customerRes = await UserAPI()
                                                .createCustomer(context);
                                            print(customerRes);
                                            if (customerRes != null &&
                                                customerRes['status'] == "OK") {
                                              setState(() {
                                                cusID = customerRes['details']
                                                    ['stripe_cus_id'];
                                              });
                                              sharedPrefs.setString(
                                                  'cusId', cusID);
                                            }
                                          } else {
                                            setState(() {
                                              cusID = checkApi['detail']
                                                  ['stripe_cus_id'];
                                            });
                                          }
                                          print("cusID>>>>>>>>>>>>>>");
                                          print(cusID);
                                          sharedPrefs.setString('cusId', cusID);
                                          // var attachCard =
                                          //     await StripePaymentApi()
                                          //         .addPaymentCardDetails(
                                          //             context,
                                          //             paymentMethod.id,
                                          //             cusID);
                                          // print("attachCard>>>>>>>>>>>>>");
                                          // print(attachCard);
                                          // if (attachCard != null &&
                                          //     attachCard['status'] == 'OK') {
                                          // var cvcToken = await Stripe.instance
                                          //     .createTokenForCVCUpdate(
                                          //         _cvvController.text);

                                          var paymentIntentResult =
                                              await StripePaymentApi()
                                                  .createPaymentIntent(
                                                      context,
                                                      amount.toString(),
                                                      currency,
                                                      paymentMethod.id,
                                                      '',
                                                      false,
                                                      '');
                                          print('Paymentintet2>>>>>>>>>>>>>>>');
                                          print(paymentIntentResult);
                                          if (paymentIntentResult['status'] ==
                                              "OK") {
                                            print(paymentIntentResult['details']
                                                ['client_secret']);
                                            // var updateres =
                                            //     await StripePaymentApi()
                                            //         .updateCustomer(
                                            //             paymentMethod.id,
                                            //             cusID);
                                            // print("updateres>>>>>>>>>>>");
                                            // print('updateres>>>>>>>>>>>' +
                                            //     updateres.toString());

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
                                                  paymentMethodId:
                                                      paymentMethod.id,
                                                  // cvc: _cvvController
                                                  //     .text
                                                )),
                                              );
                                              print(res);
                                              if (res.status ==
                                                  PaymentIntentsStatus
                                                      .Succeeded) {
                                                var res = await OrderAPI()
                                                    .buyGold(
                                                        context,
                                                        paymentIntentResult[
                                                            'details']['id']);
                                                print(res);
                                                if (res != null &&
                                                    res['status'] == 'OK') {
                                                  loader(false);
                                                  print('buy gold');
                                                  final facebookAppEvents =
                                                      FacebookAppEvents();
                                                  facebookAppEvents.logEvent(
                                                    name: 'Purchase made',
                                                    // parameters: {
                                                    //   'Sign up_id':
                                                    //       'the_clickme_button',
                                                    // },
                                                  );
                                                  Twl.navigateTo(context,
                                                      PurchesedConfirmSucessful());
                                                } else {
                                                  loader(false);

                                                  // Twl.createAlert(
                                                  //     context, 'error', res['error']);
                                                }
                                              } else {
                                                loader(false);
                                                print(
                                                    'Paymentintet3>>>>>>>>>>>>>>>');
                                                setState(() {
                                                  hasError = true;
                                                });
                                                _formKey.currentState!
                                                    .validate();
                                                // Twl.createAlert(
                                                //     context, 'error', res.status);
                                              }
                                            } catch (e) {
                                              loader(false);
                                              print(
                                                  'Paymentintet1>>>>>>>>>>>>>>>');
                                              print('Paymentintet1' +
                                                  e.toString());
                                              if (e is StripeException) {
                                                setState(() {
                                                  loadingPaymentStatus = false;
                                                });
                                                print(
                                                    "Error from Stripe: ${e.error.localizedMessage}");
                                                // if (e.error
                                                //         .localizedMessage ==
                                                //     'Your card was declined.') {
                                                if (e.error.localizedMessage ==
                                                    null) {
                                                } else if ((e.error
                                                            .localizedMessage ==
                                                        ("Your card's security code is invalid.")) ||
                                                    (e.error.localizedMessage ==
                                                        "Your card's security code is invalid") ||
                                                    (e.error.localizedMessage ==
                                                        "Your card's security code is incorrect.")) {
                                                  // setState(() {
                                                  //   loadingPaymentStatus =
                                                  //       false;
                                                  // });
                                                  declinedAlert(
                                                    context,
                                                    e.error.localizedMessage,
                                                    "Ok",
                                                  );
                                                  setState(() {
                                                    hasError = true;
                                                  });
                                                  _formKey.currentState!
                                                      .validate();
                                                } else {
                                                  // setState(() {
                                                  //   loadingPaymentStatus =
                                                  //       false;
                                                  // });
                                                  // Twl.navigateBack(context);
                                                  declinedAlert(
                                                    context,
                                                    e.error.localizedMessage,
                                                    "Ok",
                                                  );
                                                }
                                              } else {
                                                setState(() {
                                                  hasError = true;
                                                });
                                                _formKey.currentState!
                                                    .validate();
                                              }
                                            }
                                            // await confirmIntent(paymentIntent.id);
                                            // } else {
                                            //   loader(false);
                                            //   // Payment succedeed
                                            //   ScaffoldMessenger.of(context)
                                            //       .showSnackBar(SnackBar(
                                            //           content: Text(
                                            //               'Error: ${paymentIntentResult['error']}')));
                                            // }
                                          }

                                          // print(paymentIntentResult['details']
                                          //     ['clientSecret']);
                                          // if (paymentIntentResult['details']
                                          //             ['clientSecret'] !=
                                          //         null
                                          //     //  &&
                                          //     //     paymentIntentResult['requiresAction'] == true
                                          //     ) {
                                          //   print('hiii');
                                          //   // 4. if payment requires action calling handleNextAction
                                          //   // final paymentIntent = await Stripe
                                          //   //     .instance
                                          //   //     .handleNextAction(paymentIntentResult[
                                          //   //         'clientSecret']);
                                          //   // print(paymentIntent.status);
                                          //   // if (paymentIntent.status ==
                                          //   //     PaymentIntentsStatus
                                          //   //         .RequiresConfirmation) {

                                          //   // 5. Call API to confirm intent
                                          //   var res = await Stripe.instance
                                          //       .confirmPayment(
                                          //     paymentIntentResult[
                                          //         'clientSecret'],
                                          //     PaymentMethodParams.cardFromMethodId(
                                          //         paymentMethodData:
                                          //             PaymentMethodDataCardFromMethod(
                                          //                 paymentMethodId:
                                          //                     paymentMethod.id,
                                          //                 cvc: _card.cvc
                                          //                     .toString())),
                                          //   );
                                          //   print(
                                          //       "PaymentInsssssstentsStatus>>>>>>>>>>>>>>");
                                          //   print(res);
                                          //   if (res.status ==
                                          //       PaymentIntentsStatus
                                          //           .Succeeded) {
                                          //     loader(false);
                                          //     Twl.navigateTo(context,
                                          //         PurchesedConfirmSucessful());
                                          //   } else {
                                          //     loader(false);
                                          //     print(
                                          //         "PaymentIntentsStatus>>>>>>>>>>>>>>");
                                          //     print(res.status);
                                          //     // Twl.createAlert(
                                          //     //     context, 'error', res.status);
                                          //   }
                                          //   // await confirmIntent(paymentIntent.id);
                                          //   // } else {
                                          //   //   loader(false);
                                          //   //   // Payment succedeed
                                          //   //   ScaffoldMessenger.of(context)
                                          //   //       .showSnackBar(SnackBar(
                                          //   //           content: Text(
                                          //   //               'Error: ${paymentIntentResult['error']}')));
                                          //   // }
                                          // }
                                          // } else {
                                          //   print(
                                          //       "Your card was declined.>>>>>>>");
                                          //   print(attachCard['error'] ==
                                          //       'Your card was declined.');
                                          //   if (attachCard['error'] ==
                                          //       'Your card was declined.') {
                                          //     loader(false);
                                          //     declinedAlert(
                                          //       context,
                                          //       attachCard['error'],
                                          //       "Ok",
                                          //     );
                                          //   } else {
                                          //     loader(false);
                                          //     setState(() {
                                          //       hasError = true;
                                          //     });
                                          //     _formKey.currentState!.validate();
                                          //   }

                                          //   // setState(() {
                                          //   //   hasError = true;
                                          //   // });
                                          //   // _formKey.currentState!.validate();
                                          //   // print(attachCard['error']);
                                          // }
                                        } catch (e) {
                                          // print(e.toString());
                                          print("failed1");
                                          setState(() {
                                            loadingPaymentStatus = false;
                                          });
                                          if (e is StripeException) {
                                            print(
                                                "Error from Stripe: ${e.error.localizedMessage}");
                                            // if (e.error
                                            //         .localizedMessage ==
                                            //     'Your card was declined.') {
                                            if (e.error.localizedMessage ==
                                                null) {
                                            } else if ((e.error
                                                        .localizedMessage ==
                                                    ("Your card's security code is invalid.")) ||
                                                (e.error.localizedMessage ==
                                                    "Your card's security code is invalid") ||
                                                (e.error.localizedMessage ==
                                                    "Your card's security code is incorrect.")) {
                                              print("dfvfdvfdvdf");
                                              // setState(() {
                                              //   loadingPaymentStatus =
                                              //       false;
                                              // });
                                              declinedAlert(
                                                context,
                                                e.error.localizedMessage,
                                                "Ok",
                                              );
                                              setState(() {
                                                hasError = true;
                                              });
                                              _formKey.currentState!.validate();
                                            } else {
                                              // setState(() {
                                              //   loadingPaymentStatus =
                                              //       false;
                                              // });
                                              // Twl.navigateBack(context);
                                              declinedAlert(
                                                context,
                                                e.error.localizedMessage,
                                                "Ok",
                                              );
                                            }
                                          } else {
                                            setState(() {
                                              hasError = true;
                                            });
                                            _formKey.currentState!.validate();
                                          }
                                          // setState(() {
                                          //   hasError = true;
                                          // });
                                          // print(e);
                                          // loader(false);
                                          // stopLoading();
                                          // _formKey.currentState!.validate();
                                        }
                                      }
                                    } catch (e) {
                                      print("failed2");
                                      setState(() {
                                        hasError = true;
                                      });
                                      loader(false);
                                      stopLoading();
                                      _formKey.currentState!.validate();
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(content: Text('Error: $e')));
                                      rethrow;
                                    }
                                  } catch (e) {
                                    print("inittal fail");
                                    // setState(() {
                                    //   hasError = true;
                                    // });
                                  }
                                  stopLoading();
                                  // } else {
                                  //   loader(false);
                                  //   print("invalid>>>>>>>>>>>>");
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //       SnackBar(
                                  //           content: Text('Invalid card details')));
                                  // }
                                  stopLoading();
                                }
                              }),
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

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return "";
    }
    return null;
  }

  String? validateCard(String? value) {
    if (value!.isEmpty || hasError) {
      return "";
    }
    return null;
  }

  String? validateExpiryMonth(String? value) {
    if (value!.isEmpty || double.parse(value) > 12 || hasError) {
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

// getImageFile() {
//   return '';
// }

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = new StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: new TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}

class SortCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    var inputText = nextValue.text;

    if (nextValue.selection.baseOffset == 0) {
      return nextValue;
    }

    var bufferString = new StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 2 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write('-');
      }
    }

    var string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: new TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
