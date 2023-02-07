import 'dart:async';
import 'dart:convert';

import 'package:base_project_flutter/api_services/orderApi.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import 'dart:math';
import '../../constants/imageConstant.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../loginPassCodePages/enterYourPasscode.dart';
import '../paymentMethods/PaymentBankMethods.dart';
import '../paymentMethods/paymentMethod.dart';
import '../successfullPage/PurchesedConfirmSucessfull.dart';

class RevivewPaymentDetails extends StatefulWidget {
  RevivewPaymentDetails(
      {Key? key,
      this.qty,
      this.price,
      this.type,
      this.goldType,
      this.liveGoldPrice,
      this.payment})
      : super(key: key);
  final qty;
  final price;
  final type;
  final goldType;
  final liveGoldPrice;
  final payment;

  @override
  State<RevivewPaymentDetails> createState() => _revivewPaymentDetailsState();
}

class _revivewPaymentDetailsState extends State<RevivewPaymentDetails>
    with WidgetsBindingObserver {
  @override
  void initState() {
    setState(() {
      if (widget.liveGoldPrice != null) {
        goldprice = widget.liveGoldPrice;
      }
    });
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      buyingPrice = widget.price;
      buyingQty = widget.qty;
    });
    checkCartCreatedTime(
      true,
    );
    // print(widget.price);
    super.initState();

    // checkPassodeStatus();

    tot();
  }

  tot() {
    setState(() {
      if (widget.payment == "bank")
        total = ((double.parse(buyingQty) * goldprice * 0.04) +
                (double.parse(buyingQty) * goldprice))
            .toStringAsFixed(2);
      else
        total = ((double.parse(buyingQty) * goldprice * 0.04 * 0.027) +
                0.2 +
                (double.parse(buyingQty) * goldprice * 0.04) +
                (double.parse(buyingQty) * goldprice))
            .toStringAsFixed(2);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    checkCartCreatedTime(false);
  }

  var goldprice;
  var buyingPrice = '';
  var buyingQty = '';
  var total = '';
  // bool isPasscodeExist = false;
  // checkPassodeStatus() async {
  //   SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  //   var userId = sharedPrefs.getString('userId');
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId.toString())
  //       .snapshots()
  //       .listen((userData) {
  //     setState(() {
  //       if (userData.data()?['userId'] != null) {
  //         isPasscodeExist = true;
  //       }
  //     });
  //   });
  // }
  var cartCreateTime;
  // var msgTime;
  var finalMsgTime;
  var finalTime;
  var initialDuration;
  Timer? timer;
  checkCartCreatedTime(isinit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var time = sharedPreferences.getString('cartCreatedTime');
    cartCreateTime = DateTime.parse(time.toString());
    finalMsgTime = cartCreateTime.add(const Duration(seconds: 300));
    print('11111111111111111111111');
    print(cartCreateTime);
    print(finalMsgTime);
    print('11111111111111111111111');
    DateTime endTime = finalMsgTime;
    DateTime currentTime = DateTime.now();
    finalTime = endTime.difference(currentTime).inSeconds;
    initialDuration = 300 - finalTime;
    print(finalTime);
    print(initialDuration);
    //  print(object);
    print('endTime ' + endTime.toString());
    print('currentTime ' + currentTime.toString());

    print('finalTime ' + finalTime.toString());
    print('initialDuration ' + initialDuration.toString());
    if (isinit == true) {
      print("time init done");
      timer = Timer.periodic(Duration(seconds: int.parse(finalTime.toString())),
          (Timer t) {
        print("review payment details>>>>>>>>>>>>>>>>");
        getGoldPrice();

        // else {
        //
        // }
        // Twl.navigateTo(
        //     context,
        //     BottomNavigation(
        //       actionIndex: 0,
        //       tabIndexId: 0,
        //     ));
      });
      // Future.delayed(Duration(seconds: int.parse(finalTime.toString())), () {
      //   Twl.navigateTo(
      //       context,
      //       BottomNavigation(
      //         actionIndex: 0,
      //         tabIndexId: 0,
      //       ));
      //   // loader(false);
      // });
    } else if (initialDuration > 0 &&
        initialDuration != null &&
        initialDuration <= 300) {
      print("time not done");
      // loader(false);
    } else {
      loader(true);
      print("time done");
      // if (widget.type == '1' || widget.type == 1) {
      getGoldPrice();
      // } else {}
      // Twl.navigateTo(
      //     context,
      //     BottomNavigation(
      //       actionIndex: 0,
      //       tabIndexId: 0,
      //     ));
    }
  }

  var res;
  var priceDetails;
  var goldWeigthRange;
  SharedPreferences? sharedPreferences;
  getGoldPrice() async {
    loader(true);
    // var status = await checkVeriffStatus(context);
    // setState(() {
    //   verifStatus = status;
    //   print(verifStatus.runtimeType);
    // });
    print("getGoldPrice");
    print('getGoldPrice' + DateTime.now().toString());
    sharedPreferences = await SharedPreferences.getInstance();

    res = await UserAPI().getGoldPrice(context);
    if (res != null && res['status'] == 'OK') {
      setState(() {
        priceDetails = res['details'];

        goldWeigthRange = res['details']['gold_weight_ranges'];
        print(goldWeigthRange);

        // _priceController
        //   ..text = Secondarycurrency +
        //       (_currentSliderValue * priceDetails['price_gram_24k']).toString();
        // _priceController..text = _currentSliderValue.toString();
      });
      if (widget.type == '1' || widget.type == 1) {
        setState(() {
          goldprice = priceDetails['price_gram_24k'];
        });

        finalBuyValue(buyingPrice, priceDetails['price_gram_24k']);
      } else {
        buyingPrice = (double.parse(buyingQty) * priceDetails['price_gram_24k'])
            .toString();
      }
      print('getGoldPrice');
      print(res);
    } else {
      loader(false);
      print(res['error']);
    }
  }

  getMintingvalue(goldPrice) async {
    var mintingPercent;
    var mintingValue;
    print("minivallll");
    print(double.parse(sharedPreferences!.getString('minting').toString()));
    setState(() {
      mintingPercent = sharedPreferences!.getString('minting');
      mintingValue = (double.parse(mintingPercent) / 100);
      // *
      //     double.parse(goldPrice.toStringAsFixed(3));
    });
    return mintingValue;
  }

  getvolatilityvalue(goldPrice) async {
    var volatilityPercent;
    var volatilityValue;
    setState(() {
      volatilityPercent = sharedPreferences!.getString('volatility');
      volatilityValue = (double.parse(volatilityPercent) / 100);
      //  *
      //     double.parse(goldPrice.toStringAsFixed(3));
    });
    return volatilityValue;
  }

  finalBuyValue(amount, liveGoldPrice) async {
    // var amount = 405.6900;
    // var liveGoldPrice = 47.4700;
    var mintingvalue = await getMintingvalue(liveGoldPrice);
    var volatilityvalue = await getvolatilityvalue(liveGoldPrice);
    print('amount');
    print(amount);
    print("liveGoldPrice");
    print(liveGoldPrice);
    print('mintingvalue');
    print(mintingvalue);
    print('volatilityvalue');
    print(volatilityvalue);
    var finalBuyPrice;
    var oneGram = 1;
    var goldQuantityBeforeAddingTaxes = double.parse(amount) / liveGoldPrice;
    // print('goldQuantityBeforeAddingTaxes ' +
    //     goldQuantityBeforeAddingTaxes.toString());
    // print(qty);
    var markupPercentage;
    var goldValue = (oneGram * liveGoldPrice).toStringAsFixed(4);
    // print('goldValue  ' + goldValue.toString());
    var barMinting =
        (double.parse(goldValue) * mintingvalue).toStringAsFixed(4);
    var volatilityFees =
        (double.parse(goldValue) * volatilityvalue).toStringAsFixed(4);
    // print("barMinting " + barMinting.toString());
    // print("volatilityFees " + volatilityFees.toString());
    var totalValueBeforeMarkup = double.parse(goldValue.toString()) +
        double.parse(barMinting.toString()) +
        double.parse(volatilityFees.toString());
    // var totalValueBeforeMarkup
    for (var i = 0; i <= goldWeigthRange.length - 1; i++) {
      // print('totalValueBeforeMarkup' + totalValueBeforeMarkup.toString());
      if (goldQuantityBeforeAddingTaxes >=
              goldWeigthRange[i]['gold_range_start'] &&
          goldQuantityBeforeAddingTaxes <=
              goldWeigthRange[i]['gold_range_end']) {
        markupPercentage =
            (goldWeigthRange[i]['markup_percentage']).toStringAsFixed(2);
        // print('markupPercentage ' + markupPercentage.toString());

        // print('finalBuyPrice ' + finalBuyPrice.toString());
      }
      // else {
      //   var markupPercentage = (goldWeigthRange[goldWeigthRange.length - 1]
      //           ['markup_percentage'])
      //       .toStringAsFixed(2);
      //   // print('markupPercentage ' + markupPercentage.toString());
      //   var FeesMarkup =
      //       (double.parse(markupPercentage) * totalValueBeforeMarkup)
      //           .toStringAsFixed(4);
      //   // print('FeesMarkup ' + FeesMarkup.toString());
      //   var buyPrice = (double.parse(FeesMarkup.toString()) +
      //           double.parse(totalValueBeforeMarkup.toString()))
      //       .toStringAsFixed(4);
      //   // print('buyPrice ' + buyPrice.toString());
      //   finalBuyPrice = (double.parse(buyPrice)).toStringAsFixed(3);
      //   print('finalBuyPrice2' + finalBuyPrice.toString());
      // }
    }
    var FeesMarkup = (double.parse(markupPercentage) * totalValueBeforeMarkup)
        .toStringAsFixed(4);
    // print('FeesMarkup ' + FeesMarkup.toString());
    var buyPrice = (double.parse(FeesMarkup.toString()) +
            double.parse(totalValueBeforeMarkup.toString()))
        .toStringAsFixed(4);
    // print('buyPrice ' + buyPrice.toString());
    finalBuyPrice = (double.parse(buyPrice)).toStringAsFixed(3);
    print('finalBuyPrice1' + finalBuyPrice.toString());
    print("asdbcsa");
    print(finalBuyPrice);
    print(double.parse(finalBuyPrice).toStringAsFixed(3));
    var goldUnits =
        (double.parse(amount) / double.parse(finalBuyPrice)).toStringAsFixed(3);
    print('goldUnits ' + goldUnits);
    var timeNow = DateTime.now();
    setState(() {
      buyingQty = goldUnits;
      sharedPreferences!.setString("cartCreatedTime", timeNow.toString());
    });

    var deleteCart = await OrderAPI().deleteCart(context);
    print(deleteCart);
    if (deleteCart != null) {
      var addTocart = await OrderAPI().addToCart(context, Buy.toString(),
          buyingQty.toString(), buyingPrice.toString(), widget.goldType);
      if (addTocart != null && addTocart['status'] == 'OK') {
        var timeNow = DateTime.now();
        sharedPreferences!.setString("cartCreatedTime", timeNow.toString());
        loader(false);
        setState(() {
          loadingPaymentStatus = false;
        });
      } else {
        loader(false);
        setState(() {
          loadingPaymentStatus = false;
        });
        // Twl.createAlert(context, "error", addTocart['error']);
      }
    } else {
      loader(false);
      setState(() {
        loadingPaymentStatus = false;
      });
    }

    // return goldUnits;
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  // bool paymentLoading = false;

  bool loadingPaymentStatus = false;
  loader(value) {
    setState(() {
      loadingPaymentStatus = value;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: _getColorFromHex("#E5B02C"),
          body: Center(
              child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Container(
                      decoration: BoxDecoration(
                          color: tWhite,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      height: 584,
                      width: 361,
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 25,
                          //     vertical: 20,
                          //   ),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       GestureDetector(
                          //         onTap: () {
                          //           // createGoalAction();
                          //           Twl.navigateBack(context);
                          //         },
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //               color: selectedvalue == 1 ? btnColor : tWhite,
                          //               borderRadius: BorderRadius.circular(10)),
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal: 10, vertical: 5),
                          //           child: Image.asset(
                          //             Images.NAVBACK,
                          //             scale: 4,
                          //           ),
                          //         ),
                          //       ),
                          //       Image.asset(
                          //         Images.GOLD,
                          //         scale: 5,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Stack(children: [
                                  Padding(
                                      padding: EdgeInsets.only(left: 16),
                                      child: GestureDetector(
                                        onTap: () {
                                          // createGoalAction();
                                          Twl.navigateBack(context);
                                        },
                                        child: Image.asset("images/close.png",
                                            height: 20),
                                      )),
                                  Center(
                                      child: Image.asset(
                                    Images.GOLD,
                                    scale: 4,
                                  ))
                                ]),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "${widget.type == 1 ? 'Payment' : 'Sale'} Summary",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            isTab(context) ? 13.sp : 16.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Signika',
                                        color: tSecondaryColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 24, right: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Buying For",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                        Text(
                                          widget.goldType == '1'
                                              ? 'Physical Gold Account'
                                              : 'My Goal',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 24,
                                      top: 3,
                                      bottom: 10,
                                    ),
                                    child: Container(
                                        height: 0.6,
                                        color: _getColorFromHex("#707070"))),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 24, right: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Order Type",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                        Text(
                                          "${widget.type == 1 ? 'Buy' : 'Sell'}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 24,
                                      top: 3,
                                      bottom: 10,
                                    ),
                                    child: Container(
                                        height: 0.6,
                                        color: _getColorFromHex("#707070"))),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 24, right: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Gold Value",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                        Text(
                                          "${Secondarycurrency + (double.parse(buyingQty) * goldprice).toStringAsFixed(2)} ",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 24,
                                      top: 3,
                                      bottom: 10,
                                    ),
                                    child: Container(
                                        height: 0.6,
                                        color: _getColorFromHex("#707070"))),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 24, right: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Gold Weight",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                        Text(
                                          "${buyingQty.toString()} grams",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                      ],
                                    )),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 24,
                                      top: 3,
                                      bottom: 10,
                                    ),
                                    child: Container(
                                        height: 0.6,
                                        color: _getColorFromHex("#707070"))),
                                if (widget.type == 1)
                                  Column(children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 24, right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Metfolio Fixed Fee (4%)",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: isTab(context)
                                                      ? 13.sp
                                                      : 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Signika',
                                                  color: tSecondaryColor),
                                            ),
                                            Text(
                                              "${Secondarycurrency + (double.parse(buyingQty) * goldprice * 0.04).toStringAsFixed(2)} ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: isTab(context)
                                                      ? 13.sp
                                                      : 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Signika',
                                                  color: tSecondaryColor),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 24,
                                          top: 3,
                                          bottom: 10,
                                        ),
                                        child: Container(
                                            height: 0.6,
                                            color:
                                                _getColorFromHex("#707070"))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 24, right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Payment Method",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: isTab(context)
                                                      ? 13.sp
                                                      : 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Signika',
                                                  color: tSecondaryColor),
                                            ),
                                            Text(
                                              (widget.payment == "bank")
                                                  ? "Bank"
                                                  : (widget.payment == "card")
                                                      ? 'Credit/Debit Card'
                                                      : (widget.payment ==
                                                              "apple")
                                                          ? "Apple Pay"
                                                          : "Google Pay",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: isTab(context)
                                                      ? 13.sp
                                                      : 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Signika',
                                                  color: tSecondaryColor),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 24,
                                          top: 3,
                                          bottom: 10,
                                        ),
                                        child: Container(
                                            height: 0.6,
                                            color:
                                                _getColorFromHex("#707070"))),
                                    if (widget.payment != "bank")
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 24, right: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Card Fees (2.7% +20p)",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: isTab(context)
                                                        ? 13.sp
                                                        : 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Signika',
                                                    color: tSecondaryColor),
                                              ),
                                              Text(
                                                "${Secondarycurrency + ((double.parse(buyingQty) * goldprice * 0.04 * 0.027) + 0.2).toStringAsFixed(2)} ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: isTab(context)
                                                        ? 13.sp
                                                        : 16.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Signika',
                                                    color: tSecondaryColor),
                                              ),
                                            ],
                                          )),
                                    if (widget.payment != "bank")
                                      Padding(
                                          padding: EdgeInsets.only(
                                            left: 24,
                                            top: 3,
                                            bottom: 10,
                                          ),
                                          child: Container(
                                              height: 0.6,
                                              color:
                                                  _getColorFromHex("#707070"))),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 24, right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: isTab(context)
                                                      ? 13.sp
                                                      : 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Signika',
                                                  color: tSecondaryColor),
                                            ),
                                            Text(
                                              "${Secondarycurrency + total} ",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: isTab(context)
                                                      ? 13.sp
                                                      : 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Signika',
                                                  color: tSecondaryColor),
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          left: 24,
                                          top: 3,
                                          bottom: 10,
                                        ),
                                        child: Container(
                                            height: 0.6,
                                            color:
                                                _getColorFromHex("#707070"))),
                                  ]),
                                SizedBox(height: 10),
                                Spacer(),
                                Padding(
                                    padding: EdgeInsets.only(left: 4, right: 4),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                            height: 40,
                                            width: 280,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  primary: _getColorFromHex(
                                                      "#E5B02C"),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                ),
                                                onPressed: () async {
                                                  print(widget.type);
                                                  print(
                                                      widget.type.runtimeType);
                                                  var type = widget.type;
                                                  //startLoading();
                                                  loader(true);
                                                  // var res = await OrderAPI().CashMode(context);
                                                  // if (res != null && res["status"] == "OK") {

                                                  if (widget.type == '1' ||
                                                      widget.type == 1) {
                                                    Twl.navigateTo(
                                                        context,
                                                        PaymentMethodPage(
                                                          amount: buyingPrice,
                                                          type: Buy,
                                                          payment:
                                                              widget.payment,
                                                        ));
                                                    // SharedPreferences sharedPrefs =
                                                    //     await SharedPreferences.getInstance();
                                                    // var authCode =
                                                    //     sharedPrefs.getString('authCode');
                                                    // var checkApi =
                                                    //     await UserAPI().checkApi(authCode);
                                                    // print(checkApi);
                                                    // if (checkApi != null &&
                                                    //     checkApi['status'] == "OK") {
                                                    //   // if (checkApi['detail']['stripe_cus_id'] != null &&
                                                    //   //     checkApi['detail']['stripe_cus_id'] != '') {
                                                    //   var cusID;
                                                    //   if (checkApi['detail']
                                                    //               ['stripe_cus_id'] ==
                                                    //           null ||
                                                    //       checkApi['detail']
                                                    //               ['stripe_cus_id'] ==
                                                    //           "") {
                                                    //     var customerRes = await UserAPI()
                                                    //         .createCustomer(context);
                                                    //     print(customerRes);
                                                    //     if (customerRes != null &&
                                                    //         customerRes['status'] == "OK") {
                                                    //       setState(() {
                                                    //         cusID = customerRes['details']
                                                    //             ['stripe_cus_id'];
                                                    //       });
                                                    //       await makePayment(
                                                    //           amount: (widget.price),
                                                    //           currency: 'INR',
                                                    //           cusID: cusID);
                                                    //     } else {
                                                    //       Twl.createAlert(context, 'error',
                                                    //           customerRes['error']);
                                                    //     }
                                                    //   } else {
                                                    //     setState(() {
                                                    //       cusID = checkApi['detail']
                                                    //           ['stripe_cus_id'];
                                                    //     });
                                                    //     await makePayment(
                                                    //         amount: (widget.price),
                                                    //         currency: 'INR',
                                                    //         cusID: cusID);
                                                    //   }
                                                    // }
                                                  } else {
                                                    // if (isPasscodeExist) {
                                                    //   Twl.navigateTo(
                                                    //       context,
                                                    //       EnterYourPasscode(
                                                    //           type: GoldType().Sell,
                                                    //           amount: widget.price));
                                                    // } else {
                                                    Twl.navigateTo(
                                                        context,
                                                        PaymentBankMethods(
                                                            amount:
                                                                buyingPrice));
                                                    // var cashModeRes =
                                                    //     await OrderAPI().CashMode(context);
                                                    // print(cashModeRes);
                                                    // if (cashModeRes != null &&
                                                    //     cashModeRes['status'] == "OK") {
                                                    //   Twl.navigateTo(context,
                                                    //       PurchesedConfirmSucessful());
                                                    // } else {
                                                    //   Twl.createAlert(context, 'error',
                                                    //       cashModeRes['error']);
                                                    // }
                                                    // }
                                                  }

                                                  // } else {
                                                  //   stopLoading();
                                                  //   Twl.createAlert(context, 'error', res["error"]);
                                                  // }
                                                  loader(false);

                                                  await analytics.logEvent(
                                                    name: "payment_summary",
                                                    parameters: {
                                                      "phy_gold_quantity":
                                                          "${buyingQty.toString()} g",
                                                      "phy_gold_price":
                                                          "${Secondarycurrency + (double.parse(buyingQty) * goldprice).toStringAsFixed(2)} ",
                                                      "fees":
                                                          "${Secondarycurrency + (double.parse(widget.price) - (double.parse(buyingQty) * goldprice)).toStringAsFixed(2)}",
                                                      "total_price":
                                                          "${Secondarycurrency + buyingPrice}",
                                                      "button_clicked": true,
                                                    },
                                                  );

                                                  Segment.track(
                                                    eventName:
                                                        'payment_summary',
                                                    properties: {
                                                      "phy_gold_quantity":
                                                          "${buyingQty.toString()} g",
                                                      "phy_gold_price":
                                                          "${Secondarycurrency + (double.parse(buyingQty) * goldprice).toStringAsFixed(2)} ",
                                                      "fees":
                                                          "${Secondarycurrency + (double.parse(widget.price) - (double.parse(buyingQty) * goldprice)).toStringAsFixed(2)}",
                                                      "total_price":
                                                          "${Secondarycurrency + buyingPrice}",
                                                      "clicked": true
                                                    },
                                                  );

                                                  mixpanel.track(
                                                      'payment_summary',
                                                      properties: {
                                                        "phy_gold_quantity":
                                                            "${buyingQty.toString()} g",
                                                        "phy_gold_price":
                                                            "${Secondarycurrency + (double.parse(buyingQty) * goldprice).toStringAsFixed(2)} ",
                                                        "fees":
                                                            "${Secondarycurrency + (double.parse(widget.price) - (double.parse(buyingQty) * goldprice)).toStringAsFixed(2)}",
                                                        "total_price":
                                                            "${Secondarycurrency + buyingPrice}",
                                                        "button_clicked": true,
                                                      });

                                                  await logEvent(
                                                      "payment_summary", {
                                                    "phy_gold_quantity":
                                                        "${buyingQty.toString()} g",
                                                    "phy_gold_price":
                                                        "${Secondarycurrency + (double.parse(buyingQty) * goldprice).toStringAsFixed(2)} ",
                                                    "fees":
                                                        "${Secondarycurrency + (double.parse(widget.price) - (double.parse(buyingQty) * goldprice)).toStringAsFixed(2)}",
                                                    "total_price":
                                                        "${Secondarycurrency + buyingPrice}",
                                                    "button_clicked": true,
                                                  });
                                                },
                                                child: Text(
                                                    widget.type == 1
                                                        ? "Buy ${Secondarycurrency + ((double.parse(buyingQty) * goldprice * 0.04 * 0.027) + 0.2 + (double.parse(buyingQty) * goldprice * 0.04) + (double.parse(buyingQty) * goldprice)).toStringAsFixed(2)}"
                                                        : "Sell ${buyingQty.toString()} grams",
                                                    style: TextStyle(
                                                        color: tSecondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24)))))),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.type == 1
                                        ? 'You will receive a receipt via email for your purchase'
                                        : 'You will receive the credit from your sale within 3 business days, and a receipt has been sent to you via email ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Barlow",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: tSecondaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ],
                      )))),
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
    );
  }

  final billingDetails = BillingDetails(
    email: 'email@stripe.com',
    phone: '+48888000888',
    name: 'narasimhaa',
    address: Address(
      city: 'Houston',
      country: 'India',
      line1: '1459  Circle Drive',
      line2: '',
      state: 'Texas',
      postalCode: '77063',
    ),
  );
  // Map<String, dynamic>?
  var paymentIntentData;
  Future<void> makePayment(
      {required amount,
      required String currency,
      required String cusID}) async {
    print(amount);
    try {
      paymentIntentData = await createPaymentIntent(amount, currency, cusID);
      print("paymentIntentData>>>>>>>>>>>>>>>>>>");
      print(paymentIntentData);
      print(paymentIntentData!['customer']);
      print(
        paymentIntentData!['client_secret'],
      );
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          //  applePay: true,
          applePay: PaymentSheetApplePay(
            merchantCountryCode: 'IN',
          ),
          googlePay: PaymentSheetGooglePay(merchantCountryCode: 'IN'),
          style: ThemeMode.dark,
          // testEnv: true,
          // merchantCountryCode: 'US',
          // billingDetails: billingDetails,
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret:
              // 'sk_test_51LaF4HSAI1ruU8VXz0icwliEHR1e7xABvGF8lHjZ4kC390JAPVYVW5IS6q5tX0tyi5ba3hcclmRg3Y66hm8HVBc300nhO6THsE',
              paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],
          appearance: PaymentSheetAppearance(
            // colors: PaymentSheetAppearanceColors(

            //   background: Colors.lightBlue,
            //   primary: Colors.blue,
            //   componentBorder: Colors.red,
            // ),

            shapes: PaymentSheetShape(
              borderWidth: 50,
              borderRadius: 50,
              shadow: PaymentSheetShadowParams(color: Colors.red),
            ),
            // primaryButton: PaymentSheetPrimaryButtonAppearance(
            //   shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
            //   colors: PaymentSheetPrimaryButtonTheme(
            //     light: PaymentSheetPrimaryButtonThemeColors(
            //       background: Color.fromARGB(255, 231, 235, 30),
            //       text: Color.fromARGB(255, 235, 92, 30),
            //       border: Color.fromARGB(255, 235, 92, 30),
            //     ),
            //   ),
            // ),
          ),
        ));

        displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  createPaymentIntent(String amount, String currency, String cusID) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId;
    setState(() {
      userId = sharedPreferences.getString('userId');
    });
    var orderId = userId + '_' + getRandomString(15);
    print(userId);
    print(orderId);
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'metadata[userid]': userId,
        'metadata[orderid]': orderId,
        'metadata[gold_type]': widget.goldType.toString(),
        'customer': cusID
        // 'type': 'card',
        // 'card[number]': '4242424242424242',
        // 'card[exp_month]': '8',
        // 'card[exp_year]': '2023',
        // 'card[cvc]': '123',
        // 'billing_details[address][city]': 'hydetabad',
        // 'billing_details[address][country]': 'In',
        // 'billing_details[address][line1]': 'test line one',
        // 'billing_details[address][line2]': 'test line Two',
        // 'billing_details[address][postal_code]': '500072',
        // 'billing_details[address][state]': 'Telangana',
        // 'billing_details[email]': 'spvn81@gmail.com',
        // 'billing_details[name]': 'sai pavan',
        // 'billing_details[phone]': '6300565084'
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

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          // ignore: deprecated_member_use
          );
      setState(() {
        loadingPaymentStatus = true;
      });
      var res = await OrderAPI().buyGold(context, paymentIntentData['id']);
      print(res);
      if (res != null && res['status'] == 'OK') {
        setState(() {
          loadingPaymentStatus = false;
        });
        print('buy gold');
        Twl.navigateTo(context, PurchesedConfirmSucessful());
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text('Payment Successful!'),
      // ));
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

_getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
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
