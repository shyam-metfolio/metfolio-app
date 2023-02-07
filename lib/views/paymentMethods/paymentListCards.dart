import 'dart:async';

import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/views/components/alertPage.dart';
import 'package:base_project_flutter/views/paymentMethods/paymentCardDetails.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/orderApi.dart';
import '../../api_services/stripeApi.dart';
import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';

import '../../responsive.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../paymentdetails/paymentdetails.dart';
import '../profilePage/profilepaymentDetails.dart';
import '../successfullPage/PurchesedConfirmSucessfull.dart';
import '../successfullPage/changesSavesSucessfull.dart';
import '../successfullPage/thanksForStaetingGoalSucessfull.dart';

class PaymentListCards extends StatefulWidget {
  const PaymentListCards({Key? key, this.amount, required this.paymentType})
      : super(key: key);
  final amount;
  final paymentType;

  @override
  State<PaymentListCards> createState() => _PaymentListCardsState();
}

class _PaymentListCardsState extends State<PaymentListCards>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // WidgetsBinding.instance!.addObserver(this);
    super.initState();
    getCardDeatils();
  }

  @override
  void dispose() {
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

  var authCode;
  var cusId;
  var cardDetails = [];
  bool isLoading = false;
  bool loadingPaymentStatus = false;
  bool hasError = false;
  loader(value) {
    setState(() {
      loadingPaymentStatus = value;
    });
  }

  hasErrorCheck(value) {
    setState(() {
      if (value) {
        print(loadingPaymentStatus);
        // loadingPaymentStatus = false;
        print(loadingPaymentStatus);
        hasError = value;
      } else {
        hasError = value;
      }
    });
  }

  getCardDeatils() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      authCode = sharedPreferences.getString(
        "authCode",
      );
    });
    setState(() {
      isLoading = true;
    });
    var check = await UserAPI().checkApi(authCode);

    if (check != null && check['status'] == 'OK') {
      setState(() {
        cusId = check['detail']['stripe_cus_id'];
      });
      if (cusId != null) {
        var res = await StripePaymentApi().getCustomerCards(context, cusId);
        print("cardlist>>>>>>>>");
        print(res);
        if (res != null) {
          for (var i = 0; i < res['data'].length; i++) {
            if (res['data'][i]['wallet'] != null) {
              if (res['data'][i]['card']['wallet']['type'] != 'apple_pay' &&
                  res['data'][i]['card']['wallet']['type'] != 'google_pay') {
                // if (res['data'][i]['card']['checks']['cvc_check'] == 'pass') {
                setState(() {
                  cardDetails.add(res['data'][i]);
                });
                // }
              }
            } else {
              if (res['data'][i]['card']['checks']['cvc_check'] == 'pass') {
                setState(() {
                  cardDetails.add(res['data'][i]);
                });
              }
            }
          }
          setState(() {
            isLoading = false;
          });
          print(cardDetails);
          print(cardDetails.length);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }

    // var cusDetails =
    //     await StripePaymentApi().getCustomerPaymentDetails(context, cusId);
    // if (cusDetails != null) {
    //   setState(() {
    //     defPmId = cusDetails['invoice_settings']['default_payment_method'];
    //   });
    //   print(defPmId);
    // }
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  TextEditingController _cvvController = TextEditingController();
  bool defPaymentLoader = false;
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
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay using a card',
                    style: TextStyle(
                        fontFamily: "Signika",
                        color: tPrimaryColor,
                        fontSize: isTab(context) ? 18.sp : 21.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: tPrimaryColor,
                      ),
                    ),
                  if (cardDetails != null)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: cardDetails.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var paymentMethodId = cardDetails[index]['id'];
                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              _cvvController..text = '';
                            });

                            if (widget.paymentType == Buy) {
                              _cvcDialog(cardDetails[index], paymentMethodId,
                                  widget.amount, loadingPaymentStatus);
                              // cvcAlert(cardDetails[index], paymentMethodId);
                            } else if (widget.paymentType == myGoal) {
                              print("sdcbd");
                              _goalDialog(cardDetails[index], paymentMethodId,
                                  widget.amount);
                            } else if (widget.paymentType ==
                                GoldType().EditGoal) {
                              setState(() {
                                defPaymentLoader = true;
                              });
                              print(cusId);
                              var res = await StripePaymentApi().updateCustomer(
                                  cardDetails[index]['id'], cusId);
                              if (res != null) {
                                setState(() {
                                  defPaymentLoader = false;
                                });
                                Twl.navigateTo(
                                  context,
                                  ChangesSavedSucessful(),
                                );
                              } else {
                                setState(() {
                                  defPaymentLoader = false;
                                });
                              }
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              minVerticalPadding: 0,
                              dense: true,
                              // enabled: false,
                              title: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          Images.PAYMENTCARDICON,
                                          scale: 3.5,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cardDetails[index]
                                                          ['billing_details']
                                                      ['name'] ??
                                                  '',
                                              style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: isTab(context)
                                                      ? 8.sp
                                                      : 11.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 0.5.h,
                                            ),
                                            Text(
                                              "Card ending ${cardDetails[index]['card']['last4']}",
                                              style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: isTab(context)
                                                      ? 7.sp
                                                      : 10.sp,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Image.asset(
                                      Images.NEXTICON,
                                      scale: 4,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: () async {
                        SharedPreferences sharedPrefs =
                            await SharedPreferences.getInstance();
                        if (widget.paymentType == Buy) {
                          Twl.navigateTo(
                              context,
                              PaymentCardDetails(
                                amount: widget.amount,
                              ));
                        } else if (widget.paymentType == myGoal) {
                          Twl.navigateTo(
                              context,
                              ProfilePaymentDetails(
                                type: widget.paymentType,
                              ));
                        } else if (widget.paymentType == GoldType().EditGoal) {
                          // var cusID = cusId;
                          Twl.navigateTo(
                              context,
                              ProfilePaymentDetails(
                                type: widget.paymentType,
                              ));
                          // if (cusId == null || cusId == '') {
                          //   print("dcndscds");
                          //   var customerRes =
                          //       await UserAPI().createCustomer(context);
                          //   print(customerRes);
                          //   if (customerRes != null &&
                          //       customerRes['status'] == "OK") {
                          //     setState(() {
                          //       cusId = customerRes['details']['stripe_cus_id'];
                          //     });
                          //     sharedPrefs.setString('cusId', cusId);
                          //     Twl.navigateTo(
                          //         context,
                          //         PaymentDetails(
                          //           customerId: cusId,
                          //         ));
                          //   }
                          // } else {
                          //   Twl.navigateTo(
                          //       context,
                          //       PaymentDetails(
                          //         customerId: cusId,
                          //       ));
                          // }
                        }
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        minVerticalPadding: 0,
                        dense: true,
                        title: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Images.ADDCARD,
                                    scale: 3.5,
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    "Add a new card",
                                    style: TextStyle(
                                        color: tSecondaryColor,
                                        fontSize: isTab(context) ? 8.sp : 11.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Image.asset(
                                Images.NEXTICON,
                                scale: 4,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (defPaymentLoader)
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

  void _cvcDialog(card, paymentMethodId, amount, loadingstart) {
    showGeneralDialog(
      barrierDismissible: true,
      context: context,
      barrierLabel: '',
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: cvcAlert(card, paymentMethodId, amount, loadingstart),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void _goalDialog(card, paymentMethodId, amount) {
    showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: true,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: goalCvcAlert(card, paymentMethodId, amount),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  final _formKey = new GlobalKey<FormState>();
  Widget cvcAlert(card, paymentMethodId, amount, loadingstart) {
    // return showDialog(
    //   context: context,
    //   barrierDismissible: false, // user must tap button!
    //   builder: (BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            AlertDialog(
              backgroundColor: tTextformfieldColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              actions: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          color: tTextformfieldColor,
                          child: Container(
                            color: tTextformfieldColor,
                            height: 240,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      Images.PAYMENTCARDICON,
                                                      scale: 3.5,
                                                    ),
                                                    SizedBox(
                                                      width: 2.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          card['billing_details']
                                                                  ['name'] ??
                                                              '',
                                                          style: TextStyle(
                                                              color:
                                                                  tSecondaryColor,
                                                              fontSize:
                                                                  isTab(context)
                                                                      ? 8.sp
                                                                      : 11.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Text(
                                                          "Card ending ${card['card']['last4']}",
                                                          style: TextStyle(
                                                              color:
                                                                  tSecondaryColor,
                                                              fontSize:
                                                                  isTab(context)
                                                                      ? 7.sp
                                                                      : 10.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "CVV",
                                            style: TextStyle(
                                                color: tSecondaryColor,
                                                fontSize: isTab(context)
                                                    ? 10.sp
                                                    : 14.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 97,
                                            height: 44,
                                            child: TextFormField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      4)
                                                ],
                                                onChanged: (e) {
                                                  hasErrorCheck(false);
                                                  _formKey.currentState!
                                                      .validate();
                                                },
                                                textAlign: TextAlign.center,
                                                controller: _cvvController,
                                                autofocus: true,
                                                keyboardType:
                                                    TextInputType.phone,
                                                validator: (v) {
                                                  if (hasError) {
                                                    return "";
                                                    // return "Name cant't be empty";
                                                  }
                                                  return null;
                                                },
                                                style: TextStyle(
                                                    fontFamily: 'Signika',
                                                    color: tTextSecondary,
                                                    fontSize: isTab(context)
                                                        ? 12.sp
                                                        : 15.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: tSecondaryColor
                                                          .withOpacity(0.3),
                                                      fontSize: isTab(context)
                                                          ? 9.sp
                                                          : 12.sp),
                                                  // hintText: 'Enter Your Mobile Number',
                                                  fillColor: tWhite,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    top: 2,
                                                    bottom: 2,
                                                  ),
                                                  filled: true,
                                                  errorStyle:
                                                      TextStyle(height: 0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      width: 0, color: tBlack,
                                                      // style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: tWhite),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 1,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ]),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        Center(
                                          child: Container(
                                            width: double.infinity,
                                            child: ArgonButton(
                                              highlightElevation: 0,
                                              elevation: 0,
                                              height: isTab(context) ? 70 : 40,
                                              width: 192,
                                              color: tPrimaryColor,
                                              borderRadius: 15,
                                              child: Text(
                                                'Pay ${Secondarycurrency + amount}',
                                                style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              loader: Container(
                                                  // height: 40,
                                                  // width: double.infinity,
                                                  // padding: EdgeInsets.symmetric(
                                                  //     horizontal: 0),
                                                  // child: Lottie.asset(
                                                  //   loading.LOADING,
                                                  //   // width: 50.w,
                                                  // ),
                                                  ),
                                              onTap: loadingPaymentStatus
                                                  ? null
                                                  : (startLoading, stopLoading,
                                                      btnState) async {
                                                      var cvc =
                                                          _cvvController.text;
                                                      print(
                                                          "cvc >>>>>>> " + cvc);
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      var amount = await Twl
                                                          .calculateAmount(
                                                              widget.amount);
                                                      // //startLoading();
                                                      loader(true);
                                                      // print("sjdbcd");
                                                      SharedPreferences
                                                          sharedPrefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      var authCode =
                                                          sharedPrefs.getString(
                                                              'authCode');
                                                      var checkApi =
                                                          await UserAPI()
                                                              .checkApi(
                                                                  authCode);
                                                      print(checkApi);
                                                      if (checkApi != null &&
                                                          checkApi['status'] ==
                                                              'OK') {
                                                        var cusID;
                                                        if (checkApi['detail'][
                                                                    'stripe_cus_id'] ==
                                                                null ||
                                                            checkApi['detail'][
                                                                    'stripe_cus_id'] ==
                                                                "") {
                                                          print("dibdsn");
                                                          var customerRes =
                                                              await UserAPI()
                                                                  .createCustomer(
                                                                      context);
                                                          print(customerRes);
                                                          if (customerRes !=
                                                                  null &&
                                                              customerRes[
                                                                      'status'] ==
                                                                  "OK") {
                                                            setState(() {
                                                              cusID = customerRes[
                                                                      'details']
                                                                  [
                                                                  'stripe_cus_id'];
                                                            });
                                                          } else {
                                                            loader(false);
                                                          }
                                                        } else {
                                                          setState(() {
                                                            cusID = checkApi[
                                                                    'detail'][
                                                                'stripe_cus_id'];
                                                          });
                                                        }
                                                        print(
                                                            "cusID>>>>>>>>>>>>>>");
                                                        print(cusID);
                                                        // var cvcRes =
                                                        //     await StripePaymentApi()
                                                        //         .createCvcToken(
                                                        //             context,
                                                        //             _cvvController
                                                        //                 .text);
                                                        // print(
                                                        //     'cvcRes>>>>>>>>>>>>>>>>');
                                                        // print(cvcRes);
                                                        // if (cvcRes != null &&
                                                        //     cvcRes['status'] ==
                                                        //         'OK') {
                                                        var cvcUpdateRes =
                                                            await Stripe
                                                                .instance
                                                                .createTokenForCVCUpdate(
                                                                    cvc);
                                                        print('cvcUpdateRes>>>' +
                                                            cvcUpdateRes
                                                                .toString());
                                                        var cvcToken =
                                                            cvcUpdateRes;
                                                        print("cvc token>>>>>>" +
                                                            cvcToken
                                                                .toString());
                                                        var paymentIntentResult =
                                                            await StripePaymentApi()
                                                                .createPaymentIntent(
                                                                    context,
                                                                    amount,
                                                                    currency,
                                                                    paymentMethodId,
                                                                    '',
                                                                    false,
                                                                    cvcToken);
                                                        print(
                                                            paymentIntentResult);
                                                        if (paymentIntentResult[
                                                                'status'] ==
                                                            "OK") {
                                                          print(
                                                              'Paymentintet>>>>>>>>>>>>>>>');
                                                          print(
                                                              paymentIntentResult);
                                                          print(paymentIntentResult[
                                                                  'details'][
                                                              'client_secret']);
                                                          // final paymentIntent = await Stripe
                                                          //     .instance
                                                          //     .handleNextAction(
                                                          //         paymentIntentResult[
                                                          //                 'details']
                                                          //             [
                                                          //             'client_secret']);
                                                          // print(paymentIntent
                                                          //     .status);
                                                          // if (paymentIntent
                                                          //         .status ==
                                                          //     PaymentIntentsStatus
                                                          //         .RequiresConfirmation) {
                                                          stopLoading();
                                                          // 5. Call API to confirm intent
                                                          try {
                                                            var retrivepaymentIntentet = await Stripe
                                                                .instance
                                                                .retrievePaymentIntent(
                                                                    paymentIntentResult[
                                                                            'details']
                                                                        [
                                                                        'client_secret']);
                                                            print("retrivepa" +
                                                                retrivepaymentIntentet
                                                                    .toString());
                                                            print("retrivepa" +
                                                                retrivepaymentIntentet
                                                                    .status
                                                                    .toString());
                                                            if (retrivepaymentIntentet
                                                                    .status ==
                                                                PaymentIntentsStatus
                                                                    .Succeeded) {
                                                              var res = await OrderAPI().buyGold(
                                                                  context,
                                                                  paymentIntentResult[
                                                                          'details']
                                                                      ['id']);
                                                              print(res);
                                                              if (res != null &&
                                                                  res['status'] ==
                                                                      'OK') {
                                                                final facebookAppEvents =
                                                                    FacebookAppEvents();
                                                                facebookAppEvents
                                                                    .logEvent(
                                                                  name:
                                                                      'Purchase made',
                                                                  // parameters: {
                                                                  //   'Sign up_id':
                                                                  //       'the_clickme_button',
                                                                  // },
                                                                );
                                                                loader(false);
                                                                print(
                                                                    'buy gold');
                                                                Twl.navigateTo(
                                                                    context,
                                                                    PurchesedConfirmSucessful());
                                                              } else {
                                                                loader(false);
                                                                // Twl.createAlert(
                                                                //     context,
                                                                //     'error',
                                                                //     res['error']);
                                                              }
                                                            } else if ((retrivepaymentIntentet
                                                                        .status !=
                                                                    PaymentIntentsStatus
                                                                        .Canceled) &&
                                                                (retrivepaymentIntentet
                                                                        .status !=
                                                                    PaymentIntentsStatus
                                                                        .Processing)) {
                                                              var res = await Stripe
                                                                  .instance
                                                                  .confirmPayment(
                                                                paymentIntentClientSecret:
                                                                    paymentIntentResult[
                                                                            'details']
                                                                        [
                                                                        'client_secret'],
                                                                data: PaymentMethodParams
                                                                    .cardFromMethodId(
                                                                        paymentMethodData:
                                                                            PaymentMethodDataCardFromMethod(
                                                                  paymentMethodId:
                                                                      paymentMethodId,
                                                                  cvc: cvc,
                                                                )),
                                                              );
                                                              if (res.status ==
                                                                  PaymentIntentsStatus
                                                                      .Succeeded) {
                                                                var res = await OrderAPI().buyGold(
                                                                    context,
                                                                    paymentIntentResult[
                                                                            'details']
                                                                        ['id']);
                                                                print(res);
                                                                if (res !=
                                                                        null &&
                                                                    res['status'] ==
                                                                        'OK') {
                                                                  loader(false);
                                                                  print(
                                                                      'buy gold');
                                                                  final facebookAppEvents =
                                                                      FacebookAppEvents();
                                                                  facebookAppEvents
                                                                      .logEvent(
                                                                    name:
                                                                        'Purchase made',
                                                                    // parameters: {
                                                                    //   'Sign up_id':
                                                                    //       'the_clickme_button',
                                                                    // },
                                                                  );
                                                                  Twl.navigateTo(
                                                                      context,
                                                                      PurchesedConfirmSucessful());
                                                                } else {
                                                                  loader(false);
                                                                  // Twl.createAlert(
                                                                  //     context,
                                                                  //     'error',
                                                                  //     res['error']);
                                                                }
                                                                // } else {
                                                                //   loader(false);
                                                                //   // Twl.createAlert(
                                                                //   //     context,
                                                                //   //     'error',
                                                                //   //     res.status);
                                                                // }
                                                              } else if (res
                                                                      .status ==
                                                                  PaymentIntentsStatus
                                                                      .Processing) {
                                                                loader(false);
                                                              } else {
                                                                hasErrorCheck(
                                                                    true);
                                                                setState(() {
                                                                  loadingPaymentStatus =
                                                                      false;
                                                                });
                                                                _formKey
                                                                    .currentState!
                                                                    .validate();
                                                              }
                                                            } else if ((retrivepaymentIntentet
                                                                    .status !=
                                                                PaymentIntentsStatus
                                                                    .Processing)) {
                                                              loader(false);
                                                            } else {
                                                              loader(false);
                                                            }
                                                          } catch (e) {
                                                            if (e
                                                                is StripeException) {
                                                              print(
                                                                  "Error from Stripe: ${e.error.localizedMessage}");
                                                              if (e.error
                                                                      .localizedMessage ==
                                                                  null) {
                                                                setState(() {
                                                                  loadingPaymentStatus =
                                                                      false;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  loadingPaymentStatus =
                                                                      false;
                                                                });
                                                                Twl.navigateBack(
                                                                    context);
                                                                declinedAlert(
                                                                  context,
                                                                  e.error
                                                                      .localizedMessage,
                                                                  "Ok",
                                                                );
                                                              }
                                                            } else {
                                                              setState(() {
                                                                loadingPaymentStatus =
                                                                    false;
                                                              });
                                                              hasErrorCheck(
                                                                  true);
                                                              _formKey
                                                                  .currentState!
                                                                  .validate();
                                                            }
                                                            // } else {
                                                            //   setState(() {
                                                            //     loadingPaymentStatus =
                                                            //         false;
                                                            //   });
                                                            //   hasErrorCheck(
                                                            //       true);
                                                            //   _formKey
                                                            //       .currentState!
                                                            //       .validate();
                                                            //   print(
                                                            //       "Unforeseen error: $e");
                                                            // }
                                                          }
                                                          // } else {
                                                          //   stopLoading();
                                                          //   // Twl.createAlert(
                                                          //   //     context,
                                                          //   //     'error',
                                                          //   //     paymentIntentResult[
                                                          //   //         'error']);
                                                          // }
                                                        } else {
                                                          stopLoading();
                                                          loader(false);
                                                          if ((paymentIntentResult['error'] == "Your card's security code is invalid.") ||
                                                              (paymentIntentResult[
                                                                      'error'] ==
                                                                  "Your card's security code is invalid") ||
                                                              (paymentIntentResult[
                                                                      'error'] ==
                                                                  "Your card's security code is incorrect.")) {
                                                            declinedAlert(
                                                              context,
                                                              paymentIntentResult[
                                                                  'error'],
                                                              "Ok",
                                                            );
                                                            hasErrorCheck(true);
                                                            setState(() {
                                                              loadingPaymentStatus =
                                                                  false;
                                                            });
                                                            _formKey
                                                                .currentState!
                                                                .validate();
                                                            print(
                                                                "sbvjsdsdds11");
                                                          } else {
                                                            declinedAlert(
                                                              context,
                                                              paymentIntentResult[
                                                                  'error'],
                                                              "Ok",
                                                            );
                                                            print(
                                                                "sbvjsdsdds11ww");
                                                          }

                                                          stopLoading();
                                                          // Twl.createAlert(
                                                          //     context,
                                                          //     'error',
                                                          //     cvcRes['error']);
                                                        }
                                                        // } else {
                                                        //   stopLoading();
                                                        //   // Twl.createAlert(
                                                        //   //     context,
                                                        //   //     'error',
                                                        //   //     checkApi['error']);
                                                        // }
                                                      } else {
                                                        stopLoading();
                                                        // Twl.createAlert(
                                                        //     context,
                                                        //     'error',
                                                        //     checkApi['error']);
                                                      }
                                                      stopLoading();
                                                    },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
            if (loadingPaymentStatus == true)
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
      },
    );
  }

  goalCvcAlert(card, paymentMethodId, amount) {
    // return showDialog(
    //   context: context,
    //   barrierDismissible: false, // user must tap button!
    //   builder: (BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return Stack(
          children: [
            AlertDialog(
              backgroundColor: tTextformfieldColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              actions: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          color: tTextformfieldColor,
                          child: Container(
                            color: tTextformfieldColor,
                            height: 240,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      Images.PAYMENTCARDICON,
                                                      scale: 3.5,
                                                    ),
                                                    SizedBox(
                                                      width: 2.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          card['billing_details']
                                                                  ['name'] ??
                                                              '',
                                                          style: TextStyle(
                                                              color:
                                                                  tSecondaryColor,
                                                              fontSize:
                                                                  isTab(context)
                                                                      ? 8.sp
                                                                      : 11.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Text(
                                                          "Card ending ${card['card']['last4']}",
                                                          style: TextStyle(
                                                              color:
                                                                  tSecondaryColor,
                                                              fontSize:
                                                                  isTab(context)
                                                                      ? 7.sp
                                                                      : 10.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "CVV",
                                            style: TextStyle(
                                                color: tSecondaryColor,
                                                fontSize: isTab(context)
                                                    ? 10.sp
                                                    : 14.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 100,
                                            height: 40,
                                            child: TextFormField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                    4,
                                                  )
                                                ],
                                                textAlign: TextAlign.center,
                                                controller: _cvvController,
                                                autofocus: true,
                                                onChanged: (e) {
                                                  hasErrorCheck(false);
                                                  _formKey.currentState!
                                                      .validate();
                                                },
                                                validator: (v) {
                                                  if (hasError) {
                                                    return "";
                                                    // return "Name cant't be empty";
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.phone,
                                                style: TextStyle(
                                                    fontFamily: 'Signika',
                                                    color: tTextSecondary,
                                                    fontSize: isTab(context)
                                                        ? 12.sp
                                                        : 15.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: tSecondaryColor
                                                          .withOpacity(0.3),
                                                      fontSize: isTab(context)
                                                          ? 9.sp
                                                          : 12.sp),
                                                  // hintText: 'Enter Your Mobile Number',
                                                  fillColor: tWhite,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    top: 2,
                                                    bottom: 2,
                                                  ),

                                                  filled: true,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      width: 0, color: tBlack,
                                                      // style: BorderStyle.none,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: tWhite),
                                                  ),
                                                  errorStyle:
                                                      TextStyle(height: 0),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 1,
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ]),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Column(
                                      children: [
                                        Center(
                                          child: Container(
                                            width: double.infinity,
                                            child: ArgonButton(
                                              elevation: 0,
                                              // focusElevation: 0,
                                              highlightElevation: 0,
                                              // hoverElevation: 0,
                                              // disabledElevation: 0,
                                              height: isTab(context) ? 70 : 40,
                                              width: 90.w,
                                              color: tPrimaryColor,
                                              borderRadius: 15,
                                              child: Text(
                                                'Continue',
                                                // 'Pay ${Secondarycurrency + amount}',
                                                style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              loader: Container(
                                                  // height: 40,
                                                  // width: double.infinity,
                                                  // padding: EdgeInsets.symmetric(
                                                  //     horizontal: 0),
                                                  // child: Lottie.asset(
                                                  //   loading.LOADING,
                                                  //   // width: 50.w,
                                                  // ),
                                                  ),
                                              onTap: (startLoading, stopLoading,
                                                  btnState) async {
                                                var cvc = _cvvController.text;
                                                FocusScope.of(context)
                                                    .unfocus();
                                                var amount =
                                                    await Twl.calculateAmount(
                                                        widget.amount);
                                                // //startLoading();
                                                // print("sjdbcd");
                                                loader(true);
                                                SharedPreferences
                                                    sharedPreferences =
                                                    await SharedPreferences
                                                        .getInstance();
                                                var authCode = sharedPreferences
                                                    .getString('authCode');
                                                var checkApi = await UserAPI()
                                                    .checkApi(authCode);
                                                print(checkApi);
                                                if (checkApi != null &&
                                                    checkApi['status'] ==
                                                        'OK') {
                                                  var cusID;
                                                  if (checkApi['detail'][
                                                              'stripe_cus_id'] ==
                                                          null ||
                                                      checkApi['detail'][
                                                              'stripe_cus_id'] ==
                                                          "") {
                                                    print("dibdsn");
                                                    var customerRes =
                                                        await UserAPI()
                                                            .createCustomer(
                                                                context);
                                                    print(customerRes);
                                                    if (customerRes != null &&
                                                        customerRes['status'] ==
                                                            "OK") {
                                                      setState(() {
                                                        cusID = customerRes[
                                                                'details']
                                                            ['stripe_cus_id'];
                                                      });
                                                    } else {
                                                      loader(false);
                                                    }
                                                  } else {
                                                    setState(() {
                                                      cusID = checkApi['detail']
                                                          ['stripe_cus_id'];
                                                    });
                                                  }
                                                  print("cusID>>>>>>>>>>>>>>");
                                                  print(cusID);
                                                  // var cvcRes =
                                                  //     await StripePaymentApi()
                                                  //         .createCvcToken(
                                                  //             context,
                                                  //             _cvvController
                                                  //                 .text);
                                                  // print(
                                                  //     'cvcRes>>>>>>>>>>>>>>>>');
                                                  // print(cvcRes);
                                                  // if (cvcRes != null &&
                                                  //     cvcRes['status'] ==
                                                  //         'OK') {
                                                  var cvcUpdateRes = await Stripe
                                                      .instance
                                                      .createTokenForCVCUpdate(
                                                          cvc);
                                                  print('cvcUpdateRes>>>' +
                                                      cvcUpdateRes.toString());
                                                  var cvcToken = cvcUpdateRes;
                                                  var paymentIntentResult =
                                                      await StripePaymentApi()
                                                          .createPaymentIntent(
                                                              context,
                                                              '100',
                                                              currency,
                                                              paymentMethodId,
                                                              '',
                                                              false,
                                                              cvcToken);
                                                  // await createPaymentIntent('1', currency, cusID,
                                                  //     res['details']['id']);

                                                  print(
                                                      "paymentIntentData>>>>>>>>>");
                                                  print(paymentIntentResult);

                                                  if (paymentIntentResult !=
                                                          null &&
                                                      paymentIntentResult[
                                                              'status'] ==
                                                          'OK') {
                                                    print(paymentIntentResult[
                                                        'details']['id']);
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
                                                    //         paymentIntentResult[
                                                    //                 'details'][
                                                    //             'client_secret']);
                                                    // print(paymentIntent.status);
                                                    // if (paymentIntent.status ==
                                                    //     PaymentIntentsStatus
                                                    //         .RequiresConfirmation) {
                                                    // 5. Call API to confirm intent
                                                    try {
                                                      var retrivepaymentIntentet = await Stripe
                                                          .instance
                                                          .retrievePaymentIntent(
                                                              paymentIntentResult[
                                                                      'details']
                                                                  [
                                                                  'client_secret']);
                                                      print("retrivepa" +
                                                          retrivepaymentIntentet
                                                              .toString());
                                                      print("retrivepa" +
                                                          retrivepaymentIntentet
                                                              .status
                                                              .toString());
                                                      if (retrivepaymentIntentet
                                                              .status ==
                                                          PaymentIntentsStatus
                                                              .Succeeded) {
                                                        var goalName;
                                                        var amount;
                                                        var date;
                                                        setState(() {
                                                          goalName =
                                                              sharedPreferences
                                                                  .getString(
                                                                      "goalName");
                                                          amount = sharedPreferences
                                                              .getString(
                                                                  "goalAmount");
                                                          date = sharedPreferences
                                                              .getString(
                                                                  "goalDate");
                                                        });
                                                        print(goalName);
                                                        print(amount);
                                                        print(date);
                                                        var addGoalRes =
                                                            await OrderAPI()
                                                                .addGoal(
                                                                    context,
                                                                    goalName,
                                                                    amount,
                                                                    date,
                                                                    paymentMethodId,
                                                                    currency);
                                                        print(
                                                            'addGoalRes??????');
                                                        print(addGoalRes);
                                                        if (addGoalRes !=
                                                                null &&
                                                            addGoalRes[
                                                                    'status'] ==
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
                                                          // sharedPreferences
                                                          //     .remove(
                                                          //         "goalName");
                                                          sharedPreferences
                                                              .remove(
                                                                  "goalAmount");
                                                          sharedPreferences
                                                              .remove(
                                                                  "goalDate");
                                                          stopLoading();
                                                          loader(false);
                                                          Twl.navigateTo(
                                                              context,
                                                              ThanksForStartingGoalSucessful());
                                                        } else {
                                                          loader(false);
                                                          stopLoading();
                                                          // Twl.createAlert(
                                                          //     context,
                                                          //     'error',
                                                          //     addGoalRes[
                                                          //             'error']
                                                          //         ['message']);
                                                        }
                                                      } else if ((retrivepaymentIntentet
                                                                  .status !=
                                                              PaymentIntentsStatus
                                                                  .Canceled) &&
                                                          (retrivepaymentIntentet
                                                                  .status !=
                                                              PaymentIntentsStatus
                                                                  .Processing)) {
                                                        var res = await Stripe
                                                            .instance
                                                            .confirmPayment(
                                                          paymentIntentClientSecret:
                                                              paymentIntentResult[
                                                                      'details']
                                                                  [
                                                                  'client_secret'],
                                                          data: PaymentMethodParams.cardFromMethodId(
                                                              paymentMethodData:
                                                                  PaymentMethodDataCardFromMethod(
                                                                      paymentMethodId:
                                                                          paymentMethodId,
                                                                      cvc:
                                                                          cvc)),
                                                        );
                                                        if (res.status ==
                                                            PaymentIntentsStatus
                                                                .Succeeded) {
                                                          // if (_formKey.currentState!.validate() &&
                                                          //     monthsSelectedValue != null) {
                                                          var goalName;
                                                          var amount;
                                                          var date;
                                                          setState(() {
                                                            goalName =
                                                                sharedPreferences
                                                                    .getString(
                                                                        "goalName");
                                                            amount =
                                                                sharedPreferences
                                                                    .getString(
                                                                        "goalAmount");
                                                            date = sharedPreferences
                                                                .getString(
                                                                    "goalDate");
                                                          });
                                                          print(goalName);
                                                          print(amount);
                                                          print(date);
                                                          var addGoalRes =
                                                              await OrderAPI()
                                                                  .addGoal(
                                                                      context,
                                                                      goalName,
                                                                      amount,
                                                                      date,
                                                                      paymentMethodId,
                                                                      currency);
                                                          print(
                                                              'addGoalRes??????');
                                                          print(addGoalRes);
                                                          if (addGoalRes !=
                                                                  null &&
                                                              addGoalRes[
                                                                      'status'] ==
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
                                                            // sharedPreferences
                                                            //     .remove(
                                                            //         "goalName");
                                                            sharedPreferences
                                                                .remove(
                                                                    "goalAmount");
                                                            sharedPreferences
                                                                .remove(
                                                                    "goalDate");
                                                            stopLoading();
                                                            loader(false);
                                                            Twl.navigateTo(
                                                                context,
                                                                ThanksForStartingGoalSucessful());
                                                          } else {
                                                            loader(false);
                                                            stopLoading();
                                                            // Twl.createAlert(
                                                            //     context,
                                                            //     'error',
                                                            //     addGoalRes[
                                                            //             'error']
                                                            //         ['message']);
                                                          }
                                                        } else if (res.status ==
                                                            PaymentIntentsStatus
                                                                .Processing) {
                                                          loader(false);
                                                        }
                                                      } else if ((retrivepaymentIntentet
                                                              .status !=
                                                          PaymentIntentsStatus
                                                              .Processing)) {
                                                        loader(false);
                                                      } else {
                                                        loader(false);
                                                        // hasErrorCheck(true);
                                                        // setState(() {
                                                        //   loadingPaymentStatus =
                                                        //       false;
                                                        // });
                                                        // _formKey.currentState!
                                                        //     .validate();
                                                      }
                                                    } catch (e) {
                                                      if (e
                                                          is StripeException) {
                                                        print(
                                                            "Error from Stripe: ${e.error.localizedMessage}");
                                                        if (e.error
                                                                .localizedMessage ==
                                                            null) {
                                                          setState(() {
                                                            loadingPaymentStatus =
                                                                false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            loadingPaymentStatus =
                                                                false;
                                                          });
                                                          Twl.navigateBack(
                                                              context);
                                                          declinedAlert(
                                                            context,
                                                            e.error
                                                                .localizedMessage,
                                                            "Ok",
                                                          );
                                                        }
                                                      } else {
                                                        setState(() {
                                                          loadingPaymentStatus =
                                                              false;
                                                        });
                                                        hasErrorCheck(true);
                                                        _formKey.currentState!
                                                            .validate();
                                                      }
                                                      // } else {
                                                      //   setState(() {
                                                      //     loadingPaymentStatus =
                                                      //         false;
                                                      //   });
                                                      //   hasErrorCheck(true);
                                                      //   _formKey.currentState!
                                                      //       .validate();
                                                      //   print(
                                                      //       "Unforeseen error: $e");
                                                      // }
                                                      // print("error");
                                                      // print(e);
                                                      // setState(() {
                                                      //   loadingPaymentStatus =
                                                      //       false;
                                                      // });
                                                      // hasErrorCheck(true);
                                                      // _formKey.currentState!
                                                      //     .validate();
                                                    }
                                                  } else {
                                                    loader(false);
                                                    stopLoading();
                                                    if ((paymentIntentResult['error'] == "Your card's security code is invalid.") ||
                                                        (paymentIntentResult[
                                                                'error'] ==
                                                            "Your card's security code is invalid") ||
                                                        (paymentIntentResult[
                                                                'error'] ==
                                                            "Your card's security code is incorrect.")) {
                                                      declinedAlert(
                                                        context,
                                                        paymentIntentResult[
                                                            'error'],
                                                        "Ok",
                                                      );
                                                      hasErrorCheck(true);
                                                      setState(() {
                                                        loadingPaymentStatus =
                                                            false;
                                                      });
                                                      _formKey.currentState!
                                                          .validate();
                                                    } else {
                                                      declinedAlert(
                                                        context,
                                                        paymentIntentResult[
                                                            'error'],
                                                        "Ok",
                                                      );
                                                    }
                                                    // Twl.createAlert(
                                                    //     context,
                                                    //     'error',
                                                    //     paymentIntentResult[
                                                    //         'error']);
                                                  }
                                                  // } else {
                                                  //   loader(false);
                                                  //   stopLoading();
                                                  //   // Twl.createAlert(
                                                  //   //     context,
                                                  //   //     'error',
                                                  //   //     paymentIntentResult[
                                                  //   //         'error']);
                                                  // }
                                                  // } else {
                                                  //   loader(false);
                                                  //   hasErrorCheck(true);
                                                  //   setState(() {
                                                  //     loadingPaymentStatus =
                                                  //         false;
                                                  //   });
                                                  //   _formKey.currentState!
                                                  //       .validate();
                                                  //   stopLoading();
                                                  //   // Twl.createAlert(context,
                                                  //   //     'error', cvcRes['error']);
                                                  // }
                                                } else {
                                                  loader(false);
                                                  stopLoading();
                                                  // Twl.createAlert(context,
                                                  //     'error', checkApi['error']);
                                                }
                                                stopLoading();
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          )),
                    ],
                  ),
                )
              ],
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
      },
    );
  }
}
