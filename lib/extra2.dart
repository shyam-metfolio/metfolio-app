import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/provider/actionProvider.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/actions/components/deliveryFromBottomSheet.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/listAddress/confirmAddress.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalAmount.dart';
import 'package:base_project_flutter/views/revivewPaymentDetails/revivewPaymentDetails.dart';
import 'package:base_project_flutter/views/veriffPage/veriffPage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as st;
import 'package:intl/intl.dart';
import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

import 'api_services/orderApi.dart';
import 'globalFuctions/globalFunctions.dart';
import 'globalWidgets/button.dart';
import 'views/loginPassCodePages/createYourPasscode.dart';

class Extra2 extends StatefulWidget {
  @override
  State<Extra2> createState() => Extraq();
}

class Extraq extends State<Extra2> {
  bool isBuy = true;
  bool loading = false;
  String pay = "bank";

  buy() async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
      print('_data.navGoldType>>>>>>>>>>');
      // print(_data.navGoldType);
      //  goldType = _data.navGoldType;
      print(goldType);
    });
    // if (verifStatus) {

    var price;
    var qty;
    setState(() {
      var qtyFormate = num.parse(_qtyController.text).toDouble();
      var priceFormate = num.parse(_priceController.text).toDouble();
      price = priceFormate.toStringAsFixed(2);
      qty = qtyFormate.toString();
    });

    print("price>>>>>>>>>>>>>");
    print(price);
    print(qty);

    // if (double.parse(
    //             qty.replaceAll(RegExp('g'), '')) <=
    //         100 &&
    //     qty != '') {

    // startLoader(true);
    // customAlert(
    //     context,
    //     'Would you like to continue with your purchase?',
    //     "Yes",
    //     'Do it later', (startLoading, stopLoading,
    //         btnState) async {
    var amount;
    setState(() {
      amount = priceDetails['price_gram_24k'] * _currentSliderValue;
    });
    var deleteCart = await OrderAPI().deleteCart(context);
    print(deleteCart);
    if (deleteCart != null) {
      var addTocart = await OrderAPI().addToCart(
          context,
          Buy.toString(),
          qty.replaceAll(RegExp('g'), ''),
          price.toString().replaceAll(RegExp(Secondarycurrency), ''),
          goldType);
      if (addTocart != null && addTocart['status'] == 'OK') {
        var timeNow = DateTime.now();
        sharedPreferences.setString("cartCreatedTime", timeNow.toString());
        Twl.navigateTo(
            context,
            RevivewPaymentDetails(
                qty: qty.replaceAll(RegExp('g'), ''),
                price: price.replaceAll(RegExp(Secondarycurrency), ''),
                type: Buy,
                goldType: goldType,
                liveGoldPrice: priceDetails['price_gram_24k'],
                payment: pay));
      } else {
        // Twl.createAlert(context, "error",
        //     addTocart['error']);
      }
    }

    // });
    // } else {
    // Twl.createAlert(context, "error",
    //     "you can buy max 100 grams");
    // }
    // } else {
    //   Twl.navigateTo(context, VeriffiPage());
    // }
    // Twl.navigateTo(context, PaymentDetails());
    // if (_formKey.currentState!.validate()) {
    //   Twl.navigateTo(
    //       context, PurchesedConfirmSucessful());
    // }
    // //startLoading();

    // stopLoading();
    // }

    await analytics.logEvent(
      name: "buy_gold",
      parameters: {
        "price": num.parse(_priceController.text).toDouble(),
        "qty": num.parse(_qtyController.text).toDouble(),
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'buy_gold',
      properties: {
        "price": num.parse(_priceController.text).toDouble(),
        "qty": num.parse(_qtyController.text).toDouble(),
        "clicked": true
      },
    );

    mixpanel.track('buy_gold', properties: {
      "price": num.parse(_priceController.text).toDouble(),
      "qty": num.parse(_qtyController.text).toDouble(),
      "button_clicked": true,
    });

    await logEvent("buy_gold", {
      "price": num.parse(_priceController.text).toDouble(),
      "qty": num.parse(_qtyController.text).toDouble(),
      "button_clicked": true,
    });

    setState(() {
      loading = false;
    });
  }

  sell() async {
    setState(() {
      loading = true;
      print('_data.navGoldType>>>>>>>>>>');
      //  print(_data.navGoldType);
      // goldType = _data.navGoldType;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    FocusScope.of(context).unfocus();
    // if (verifStatus) {
    // var price = _priceController.text;
    // var qty = _qtyController.text;
    var price;
    var qty;
    setState(() {
      var qtyFormate = num.parse(_qtyController.text).toDouble();
      var priceFormate = num.parse(_priceController.text).toDouble();
      price = priceFormate.toString();
      qty = qtyFormate.toString();
    });
    print("price>>>>>>>>>>>>>");
    print(price);
    print(qty);

    // if (double.parse(qty.replaceAll(RegExp('g'), '')) <=
    //         100 &&
    //     qty != '') {
    // customAlert(
    //     context,
    //     'Would you like to continue with your sale?',
    //     "Yes",
    //     'Do it later',
    //     (startLoading, stopLoading, btnState) async {

    var amount;
    setState(() {
      amount = priceDetails['price_gram_24k'] * _currentSliderValue;
    });
    var deleteCart = await OrderAPI().deleteCart(context);
    if (deleteCart != null) {
      var addTocart = await OrderAPI().addToCart(
          context,
          Sell.toString(),
          qty.replaceAll(RegExp('g'), ''),
          price.replaceAll(RegExp(Secondarycurrency), ''),
          goldType);
      if (addTocart != null && addTocart['status'] == 'OK') {
        var timeNow = DateTime.now();
        sharedPreferences.setString("cartCreatedTime", timeNow.toString());
        Twl.navigateTo(
            context,
            RevivewPaymentDetails(
                qty: qty.replaceAll(RegExp('g'), ''),
                price: price.replaceAll(RegExp(Secondarycurrency), ''),
                type: Sell,
                goldType: goldType,
                payment: pay));
      } else {
        showDialog(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: tTextformfieldColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              // title: const Text('Are you sure you want to exit?'),
              // content: SingleChildScrollView(
              //   child: ListBody(
              //     children: const <Widget>[
              //       Text('This is a demo alert dialog.'),
              //       Text('Would you like to approve of this message?'),
              //     ],
              //   ),
              // ),
              actions: <Widget>[
                Column(
                  children: [
                    Center(
                      child: Card(
                          elevation: 0,
                          color: tTextformfieldColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: 350,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'You do not have enough gold to complete this sale.',
                                        style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize:
                                                isTab(context) ? 13.sp : 16.sp,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        ' Not to worry just select an amount within your available balance!',
                                        style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize:
                                                isTab(context) ? 10.sp : 13.sp,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                                    Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Center(
                                          child: Container(
                                            width: double.infinity,
                                            child: ArgonButton(
                                              highlightElevation: 0,
                                              elevation: 0,
                                              height: isTab(context) ? 70 : 40,
                                              width: 90.w,
                                              color: tPrimaryColor,
                                              borderRadius: 15,
                                              child: Text(
                                                'Okay',
                                                style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              loader: Container(
                                                // height: 40,
                                                // width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 0),
                                                child: Lottie.asset(
                                                  Loading.LOADING,
                                                  // width: 50.w,
                                                ),
                                              ),
                                              onTap: (startLoading, stopLoading,
                                                  btnState) async {
                                                Twl.navigateBack(context);
                                                // Twl.navigateTo(context,
                                                //     BottomNavigation());
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ]),
                            ),
                          )),
                    ),
                  ],
                )
              ],
            );
          },
        );
        // Twl.createAlert(
        //     context, "error", addTocart['error']);
      }

      // });
      // } else {
      //   // Twl.createAlert(context, "error",
      //   //     "you can buy max 100 grams");
      // }
      // } else {
      //   Twl.navigateTo(context, VeriffiPage());
      // }
      // Twl.navigateTo(context, PaymentDetails());
      // if (_formKey.currentState!.validate()) {
      //   Twl.navigateTo(
      //       context, PurchesedConfirmSucessful());
      // }
      // //startLoading();
    }

    await analytics.logEvent(
      name: "sell_gold",
      parameters: {
        "price": num.parse(_priceController.text).toDouble(),
        "qty": num.parse(_qtyController.text).toDouble(),
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'sell_gold',
      properties: {
        "price": num.parse(_priceController.text).toDouble(),
        "qty": num.parse(_qtyController.text).toDouble(),
        "clicked": true
      },
    );

    mixpanel.track('sell_gold', properties: {
      "price": num.parse(_priceController.text).toDouble(),
      "qty": num.parse(_qtyController.text).toDouble(),
      "button_clicked": true,
    });

    await logEvent("sell_gold", {
      "price": num.parse(_priceController.text).toDouble(),
      "qty": num.parse(_qtyController.text).toDouble(),
      "button_clicked": true,
    });

    setState(() {
      loading = false;
    });
  }

  show() {
    showModalBottomSheet(
      context: context,
      elevation: 10,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          // UDE : SizedBox instead of Container for whitespaces
          return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            padding: EdgeInsets.only(left: 16, right: 16),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(height: 5),
                Center(
                    child: Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                      color: _getColorFromHex("#DEB14A"),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                )),
                Container(height: 20),
                Center(
                    child: Text("Type amount or use the slider",
                        style: TextStyle(
                            fontFamily: "Barlow",
                            fontWeight: FontWeight.w300,
                            color: tTextSecondary,
                            fontSize: 14))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("\n${(isBuy) ? "Buy" : "Sell"} Gold",
                        style: TextStyle(
                            fontFamily: "Barlow",
                            fontWeight: FontWeight.bold,
                            color: tTextSecondary,
                            fontSize: 31)),
                  ],
                ),
                Container(height: 10),
                (isBuy)
                    ? Container(
                        height: 40,
                        width: 360,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: _getColorFromHex("#1E365B"),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 99,
                                child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("GBP(£) ",
                                            style: TextStyle(
                                                fontFamily: "Barlow",
                                                fontWeight: FontWeight.w700,
                                                color: tTextSecondary,
                                                fontSize: 16)),
                                        Image.asset('images/euro.png',
                                            height: 20),
                                      ]),
                                )),
                            Container(
                              width: 1,
                              height: 40,
                              color: _getColorFromHex("#1E365B"),
                            ),
                            Container(
                                width: 226,
                                child: Center(
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: _priceController,

                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                        RegExp(
                                            r'^0'), //users can't type 0 at 1st position
                                      ),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                                      LengthLimitingTextFieldFormatterFixed(
                                          50000),
                                      DecimalTextInputFormatter(decimalRange: 2)
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    // readOnly: true,
                                    // keyboardType: TextInputType.phone,
                                    onChanged: (value) async {
                                      if (value != '') {
                                        var finalGrams = await finalBuyValue(
                                            double.parse(value),
                                            priceDetails['price_gram_24k']);
                                        if (double.parse(value) >= 1) {
                                          print((double.parse(value)) <= 100);
                                          print(finalGrams);
                                          if ((double.parse(value)) <= 5000) {
                                            setState(() {
                                              _currentSliderValue =
                                                  (double.parse(value));
                                              if (value != '') {
                                                // _qtyController..text = finalGrams;
                                              } else {
                                                _qtyController..text = '0';
                                              }
                                            });
                                          } else if ((double.parse(value)) >=
                                              50000) {
                                            print("objegfbfgbfct");
                                            setState(() {
                                              _currentSliderValue = 5000;
                                            });
                                          } else {
                                            setState(() {
                                              _currentSliderValue = 5000;
                                              _qtyController..text = finalGrams;
                                            });
                                          }
                                        } else {
                                          if (double.parse(value) >= 1) {
                                            _currentSliderValue =
                                                double.parse(value);
                                          }
                                          setState(() {
                                            _qtyController..text = '0';
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          _qtyController..text = '0';
                                        });
                                      }
                                    },
                                    style: TextStyle(
                                        fontFamily: 'Signika',
                                        color: tTextSecondary,
                                        fontSize:
                                            isTab(context) ? 13.sp : 16.sp,
                                        fontWeight: FontWeight.w400),
                                    // maxLength: 4,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      errorStyle: TextStyle(height: 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.red,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 1,
                                        ),
                                      ),

                                      // prefix: Text('+91 ',style: TextStyle(color: tBlack),),
                                      // prefixText: 'GBP ($Secondarycurrency):',

                                      counterText: "",
                                      // isDense: true,
                                      contentPadding: EdgeInsets.only(
                                        right: 21.w,
                                        left: 20,
                                        top: 9,
                                        bottom: 9,
                                      ),
                                      prefixStyle: TextStyle(
                                          fontFamily: 'Signika',
                                          color: tTextSecondary,
                                          fontSize:
                                              isTab(context) ? 13.sp : 16.sp,
                                          fontWeight: FontWeight.w400),
                                      // prefixIcon: Padding(
                                      //   padding: const EdgeInsets.only(
                                      //     top: 10,
                                      //     left: 20,
                                      //   ),
                                      //   child: Text(
                                      //     'GBP ($Secondarycurrency):',
                                      //     style: TextStyle(
                                      //       fontFamily: 'Signika',
                                      //       color: tTextSecondary,
                                      //       fontSize: isTab(context) ? 12.sp : 13.sp,
                                      //       fontWeight: FontWeight.w400,
                                      //     ),
                                      //     textAlign: TextAlign.center,
                                      //   ),
                                      // ),
                                      hintText: Secondarycurrency,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              tSecondaryColor.withOpacity(0.3),
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp),
                                      // hintText: 'Enter Your Mobile Number',
                                      fillColor: tPrimaryTextformfield,
                                      // contentPadding: EdgeInsets.only(
                                      // right: 21.w,
                                      // left: 20,
                                      //   top: 2,
                                      //   bottom: 2,
                                      // ),
                                      // filled: true,
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(10),
                                      //   borderSide: BorderSide(
                                      //     width: 0,
                                      //     style: BorderStyle.none,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ))
                          ],
                        ))
                    : Container(
                        height: 40,
                        width: 360,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: _getColorFromHex("#1E365B"),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 99,
                                child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Gold(g) ",
                                            style: TextStyle(
                                                fontFamily: "Barlow",
                                                fontWeight: FontWeight.w700,
                                                color: tTextSecondary,
                                                fontSize: 16)),
                                        Image.asset(Images.GOLD, height: 16),
                                      ]),
                                )),
                            Container(
                              width: 1,
                              height: 40,
                              color: _getColorFromHex("#1E365B"),
                            ),
                            Container(
                                width: 226,
                                child: Center(
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: _qtyController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                                      // FilteringTextInputFormatter.deny(
                                      //   RegExp(r'^0'), //users can't type 0 at 1st position
                                      // ),
                                      LengthLimitingTextFieldFormatterFixed(
                                          1000),
                                      DecimalTextInputFormatter(decimalRange: 3)
                                    ],

                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    // keyboardType: TextInputType.phone,
                                    // inputFormatters: [LengthLimitingTextInputFormatter(3)],
                                    // validator: (value) {
                                    //   if (double.parse(value.toString()) > 100) {
                                    //     return "max 100g";
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                    onChanged: (value) {
                                      if (value != '') {
                                        if (value[0] == "0") if (value[1] ==
                                            "0")
                                          _qtyController.text =
                                              value.substring(1, 2);

                                        _qtyController.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: _qtyController
                                                        .text.length));

                                        // if (double.parse(value) >= 100) {
                                        //   setState(() {
                                        //     _currentSliderValue = 100;
                                        //   });
                                        // }

                                        // if (_formKey.currentState!.validate()) {
                                        if (double.parse(value) <= 1000) {
                                          setState(() {
                                            _currentSliderValue =
                                                double.parse(value);
                                            _priceController
                                              ..text =
                                                  //  Secondarycurrency +
                                                  (double.parse(value) *
                                                          priceDetails[
                                                              'price_gram_24k'])
                                                      .toStringAsFixed(2);
                                          });
                                        } else if ((double.parse(value)) >=
                                            1000) {
                                          setState(() {
                                            _currentSliderValue = 100;
                                            _priceController
                                              ..text =
                                                  //  Secondarycurrency +
                                                  (double.parse(value) *
                                                          priceDetails[
                                                              'price_gram_24k'])
                                                      .toStringAsFixed(2);
                                          });
                                        } else {
                                          // setState(() {
                                          //   _priceController
                                          //     ..text =
                                          //         //  Secondarycurrency +
                                          //         (double.parse(value) *
                                          //                 priceDetails['price_gram_24k'])
                                          //             .toStringAsFixed(2);
                                          // });
                                          // Twl.createAlert(
                                          //     context, "error", "you can buy max 100 grams");
                                        }
                                      } else {
                                        setState(() {
                                          _priceController..text = '0';
                                        });
                                      }
                                    },
                                    style: TextStyle(
                                        fontFamily: 'Signika',
                                        color: tTextSecondary,
                                        fontSize:
                                            isTab(context) ? 13.sp : 16.sp,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.red,
                                        ),
                                      ),
                                      errorStyle: TextStyle(height: 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          style: BorderStyle.none,
                                        ),
                                      ),

                                      // prefix: Text('+91 ',style: TextStyle(color: tBlack),),
                                      // prefixText: 'Grams:',
                                      // prefixStyle: TextStyle(
                                      //     fontFamily: 'Signika',
                                      //     color: tTextSecondary,
                                      //     fontSize: isTab(context) ? 13.sp : 16.sp,
                                      //     fontWeight: FontWeight.w400),
                                      contentPadding: EdgeInsets.only(
                                        right: 21.w,
                                        left: 20,
                                        top: 0,
                                        bottom: 0,
                                      ),
                                      isDense: true,
                                      hintText: 'g',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              tSecondaryColor.withOpacity(0.3),
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp),
                                      // hintText: 'Enter Your Mobile Number',
                                      fillColor: tPrimaryTextformfield,
                                      // contentPadding:
                                      //     EdgeInsets.symmetric(horizontal: 10, vertical: 2),

                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        )),
                Container(height: 10),
                Container(
                  width: double.infinity,
                  child: CupertinoSlider(
                      thumbColor: tTextSecondary,
                      activeColor: tTextSecondary,
                      divisions: 5000,
                      max: 5000,
                      min: (isBuy) ? 1 : 0.0,
                      value: _currentSliderValue,
                      onChanged: (value) async {
                        if (isBuy == true) {
                          // var goldPrice =
                          //     value * priceDetails['price_gram_24k'];
                          var goldPrice = priceDetails['price_gram_24k'];
                          print(roundDouble(value, 0));
                          var finalBuyPrice = await finalBuyValue(
                              roundDouble(value, 0), goldPrice);
                          print(finalBuyPrice);
                          setState(() {
                            _currentSliderValue = value;
                            _qtyController..text = finalBuyPrice;
                            _priceController..text = value.toStringAsFixed(0);
                          });
                        } else {
                          setState(
                            () {
                              if (value >= 1) {
                                _currentSliderValue = value;
                                _priceController
                                  ..text = value.toStringAsFixed(0);
                                // .toStringAsFixed(3) ;

                                _qtyController
                                  ..text =
                                      //  Secondarycurrency +
                                      (value / priceDetails['price_gram_24k'])
                                          .toStringAsFixed(2);
                              }
                            },
                          );
                        }
                      }),
                ),
                Container(height: 10),
                (isBuy)
                    ? Container(
                        height: 40,
                        width: 360,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: _getColorFromHex("#1E365B"),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 99,
                                child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Gold(g) ",
                                            style: TextStyle(
                                                fontFamily: "Barlow",
                                                fontWeight: FontWeight.w700,
                                                color: tTextSecondary,
                                                fontSize: 16)),
                                        Image.asset(Images.GOLD, height: 16),
                                      ]),
                                )),
                            Container(
                              width: 1,
                              height: 40,
                              color: _getColorFromHex("#1E365B"),
                            ),
                            Container(
                                width: 226,
                                child: Center(
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: _qtyController,
                                    // keyboardType: TextInputType.phone,
                                    // readOnly: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                                      // FilteringTextInputFormatter.deny(
                                      //   RegExp(
                                      //       r'^0'), //users can't type 0 at 1st position
                                      // ),
                                      DecimalTextInputFormatter(
                                          decimalRange: 3),
                                      LengthLimitingTextFieldFormatterFixed(
                                          1000),
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    // focusNode: FocusNode(),
                                    // onTap: () => TextSelection(
                                    //       baseOffset: 0,
                                    //       extentOffset:
                                    //           _qtyController.value.text.length - 1,
                                    //     ),

                                    onChanged: (value) async {
                                      if (value != '') {
                                        // if (double.parse(value) != 1 ) {
                                        setState(() {
                                          //     _qtyController
                                          //       ..text = num.parse(value)
                                          //           .toDouble()
                                          //           .toString();
                                          _qtyController.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: _qtyController
                                                          .text.length));
                                        });
                                        // }\

                                        if ((1000 >=
                                            double.parse(value.toString()))) {
                                          var goldPrice = double.parse(value)
                                                  .toDouble() *
                                              priceDetails['price_gram_24k'];
                                          var finalBuyPrice =
                                              await finalBuyValuewithGrams(
                                                  roundDouble(
                                                      double.parse(value), 3),
                                                  goldPrice);
                                          if (double.parse(value) < 100) {
                                            setState(() {
                                              if (double.parse(finalBuyPrice) <=
                                                      100 &&
                                                  double.parse(finalBuyPrice) >=
                                                      1) {
                                                _currentSliderValue =
                                                    double.parse(finalBuyPrice
                                                        .toString());
                                                _priceController
                                                  ..text = finalBuyPrice;
                                              } else {
                                                _currentSliderValue = 100;
                                                _priceController
                                                  ..text = finalBuyPrice;
                                              }
                                            });
                                          } else {
                                            _currentSliderValue = 5000;
                                            _priceController
                                              ..text = finalBuyPrice;
                                            // Twl.createAlert(context, "error",
                                            //     "you can buy max 100 grams");
                                          }
                                        }
                                      } else {
                                        _priceController..text = '0';
                                      }
                                    },
                                    style: TextStyle(
                                        fontFamily: 'Signika',
                                        color: tTextSecondary,
                                        fontSize:
                                            isTab(context) ? 13.sp : 16.sp,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.red,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 1,
                                        ),
                                      ),

                                      // prefixText: 'Grams:',
                                      // prefixStyle: TextStyle(
                                      //   fontFamily: 'Signika',
                                      //   color: tTextSecondary,
                                      //   fontSize: isTab(context) ? 13.sp : 16.sp,
                                      //   fontWeight: FontWeight.w400,
                                      // ),
                                      // prefixIcon: Padding(
                                      //   padding: const EdgeInsets.only(
                                      //     top: 10,
                                      //     left: 20,
                                      //   ),
                                      //   child: Text(
                                      //     'Grams:',
                                      //     style: TextStyle(
                                      //       fontFamily: 'Signika',
                                      //       color: tTextSecondary,
                                      //       fontSize: isTab(context) ? 12.sp : 13.sp,
                                      //       fontWeight: FontWeight.w400,
                                      //     ),
                                      //     textAlign: TextAlign.center,
                                      //   ),
                                      // ),
                                      // prefix: Text('+91 ',style: TextStyle(color: tBlack),),
                                      hintText: 'g',
                                      errorStyle: TextStyle(height: 0),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              tSecondaryColor.withOpacity(0.3),
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp),
                                      // hintText: 'Enter Your Mobile Number',
                                      fillColor: tPrimaryTextformfield,
                                      contentPadding: EdgeInsets.only(
                                        right: 20.w,
                                        left: 20,
                                        top: 9,
                                        bottom: 9,
                                      ),
                                      filled: false,
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(10),
                                      //   borderSide: BorderSide(
                                      //     width: 0,
                                      //     style: BorderStyle.none,
                                      //   ),
                                      // ),
                                      isDense: true,
                                    ),
                                  ),
                                ))
                          ],
                        ))
                    : Container(
                        height: 40,
                        width: 360,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: _getColorFromHex("#1E365B"),
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 99,
                                child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("GBP(£) ",
                                            style: TextStyle(
                                                fontFamily: "Barlow",
                                                fontWeight: FontWeight.w700,
                                                color: tTextSecondary,
                                                fontSize: 16)),
                                        Image.asset('images/euro.png',
                                            height: 20),
                                      ]),
                                )),
                            Container(
                              width: 1,
                              height: 40,
                              color: _getColorFromHex("#1E365B"),
                            ),
                            Container(
                                width: 226,
                                child: Center(
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: _priceController,
                                    // keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                                      FilteringTextInputFormatter.deny(
                                        RegExp(
                                            r'^0'), //users can't type 0 at 1st position
                                      ),
                                      LengthLimitingTextFieldFormatterFixed(
                                          50000),
                                      DecimalTextInputFormatter(decimalRange: 2)
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    // onTap: () => TextSelection(
                                    //       baseOffset: 0,
                                    //       extentOffset:
                                    //           _priceController.value.text.length - 1,
                                    //     ),
                                    onChanged: (value) {
                                      if (value != '') {
                                        // if ((double.parse(value) ) >=
                                        //     5000) {

                                        // }
                                        if ((double.parse(value)) <= 5000) {
                                          setState(() {
                                            // var price =double.parse(value).toStringAsFixed(0);
                                            if (double.parse(value) /
                                                    priceDetails[
                                                        'price_gram_24k'] >=
                                                1) {
                                              _currentSliderValue =
                                                  double.parse(value) /
                                                      priceDetails[
                                                          'price_gram_24k'];
                                            }

                                            if (value != '') {
                                              _qtyController
                                                ..text = (double.parse(value) /
                                                        priceDetails[
                                                            'price_gram_24k'])
                                                    .toStringAsFixed(3);
                                            } else {
                                              _qtyController..text = '0';
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            _currentSliderValue = 5000;
                                          });
                                          _qtyController
                                            ..text = (double.parse(value) /
                                                    priceDetails[
                                                        'price_gram_24k'])
                                                .toStringAsFixed(3);
                                          // Twl.createAlert(context, "error",
                                          //     "you can buy max 100 grams");
                                        }
                                      } else {
                                        setState(() {
                                          _qtyController..text = '0';
                                        });
                                      }
                                    },
                                    style: TextStyle(
                                        fontFamily: 'Signika',
                                        color: tTextSecondary,
                                        fontSize:
                                            isTab(context) ? 13.sp : 16.sp,
                                        fontWeight: FontWeight.w400),
                                    decoration: InputDecoration(
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.red,
                                        ),
                                      ),
                                      errorStyle: TextStyle(height: 0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        borderSide: BorderSide(
                                          width: 1,
                                          style: BorderStyle.none,
                                        ),
                                      ),

                                      // prefixText: 'GBP ($Secondarycurrency):',
                                      // prefixStyle: TextStyle(
                                      //     fontFamily: 'Signika',
                                      //     color: tTextSecondary,
                                      //     fontSize: isTab(context) ? 13.sp : 16.sp,
                                      //     fontWeight: FontWeight.w400),
                                      // prefix: Text('+91 ',style: TextStyle(color: tBlack),),
                                      hintText: Secondarycurrency,
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              tSecondaryColor.withOpacity(0.3),
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp),
                                      // hintText: 'Enter Your Mobile Number',
                                      fillColor: tPrimaryTextformfield,
                                      contentPadding: EdgeInsets.only(
                                        right: 21.w,
                                        left: 20,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                      isDense: true,

                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        )),
                Container(height: 120),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )),
                              context: context,
                              builder: (ctx) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter
                                            setState /*You can rename this!*/) {
                                  // UDE : SizedBox instead of Container for whitespaces
                                  return Container(
                                      height: 1000,
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 24,
                                                        left: 8,
                                                        right: 16),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "${isBuy == true ? 'Paying with' : 'Receive with'}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Barlow",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      tTextSecondary,
                                                                  fontSize:
                                                                      26)),
                                                          GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                Navigator.of(
                                                                        context)
                                                                    .pop();

                                                                show();
                                                              },
                                                              child: Text(
                                                                  "Done",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "SignikaB",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: _getColorFromHex(
                                                                          "#2AB2BC"),
                                                                      fontSize:
                                                                          20)))
                                                        ])),
                                                Divider(
                                                    color: _getColorFromHex(
                                                        "#707070")),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 12, left: 12),
                                                    child: Text(
                                                        "${isBuy == true ? 'Pay with Bank' : 'Receive with Bank'}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Barlow",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                tTextSecondary,
                                                            fontSize: 15))),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 12),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: "Fee: ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Barlow",
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                tTextSecondary,
                                                            fontSize: 10),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: "No Fees ",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Barlow",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: _getColorFromHex(
                                                                    "#2AB2BC"),
                                                                fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                Container(
                                                  height: 15,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    //    Twl.navigateBack(context);
                                                    setState(() {
                                                      pay = "bank";
                                                    });
                                                  },
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12, right: 12),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "images/Bank.png",
                                                            height: 30,
                                                          ),
                                                          SizedBox(width: 15),
                                                          Text(
                                                            "${isBuy == true ? 'Pay with Bank' : 'Receive with Bank'}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Barlow',
                                                              fontSize:
                                                                  isTab(context)
                                                                      ? 10.sp
                                                                      : 12.sp,
                                                              color:
                                                                  tSecondaryColor,
                                                            ),
                                                          ),
                                                          Spacer(),

                                                          /*  Text(
                          '${physcialGold.toStringAsFixed(3)}g',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),*/

                                                          Image.asset(
                                                            (pay == "bank")
                                                                ? 'images/yes.png'
                                                                : 'images/no.png',
                                                            height: 20,
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 12,
                                                      top: 12,
                                                      bottom: 10,
                                                    ),
                                                    child: Container(
                                                        height: 0.6,
                                                        color: _getColorFromHex(
                                                            "#707070"))),
                                                //Pay with card
                                                if (isBuy)
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 12, left: 12),
                                                      child: Text(
                                                          'Pay with Card',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Barlow",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  tTextSecondary,
                                                              fontSize: 15))),
                                                if (isBuy)
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      child: RichText(
                                                        text: TextSpan(
                                                          text: "Fee: ",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Barlow",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  tTextSecondary,
                                                              fontSize: 10),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                              text:
                                                                  "2.7% + 20p (Card Processing Fee) ",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Barlow",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: _getColorFromHex(
                                                                      "#2AB2BC"),
                                                                  fontSize: 10),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                if (isBuy)
                                                  Container(
                                                    height: 15,
                                                  ),
                                                if (isBuy &&
                                                    Platform.isAndroid &&
                                                    !Platform.isIOS)
                                                  GestureDetector(
                                                    onTap: () async {
                                                      //    Twl.navigateBack(context);
                                                      setState(() {
                                                        pay = "google";
                                                      });
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12,
                                                                right: 12),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/gpay_Pay_Mark.png",
                                                              width: 30,
                                                            ),
                                                            SizedBox(width: 15),
                                                            Text(
                                                              "Google Pay",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontSize: isTab(
                                                                        context)
                                                                    ? 10.sp
                                                                    : 12.sp,
                                                                color:
                                                                    tSecondaryColor,
                                                              ),
                                                            ),
                                                            Spacer(),

                                                            /*  Text(
                          '${physcialGold.toStringAsFixed(3)}g',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),*/

                                                            Image.asset(
                                                              (pay == "google")
                                                                  ? 'images/yes.png'
                                                                  : 'images/no.png',
                                                              height: 20,
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                if (isBuy &&
                                                    Platform.isAndroid &&
                                                    !Platform.isIOS)
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 12,
                                                        top: 12,
                                                        bottom: 10,
                                                      ),
                                                      child: Container(
                                                          height: 0.6,
                                                          color:
                                                              _getColorFromHex(
                                                                  "#707070"))),
                                                if (isBuy &&
                                                    Platform.isAndroid &&
                                                    !Platform.isIOS)
                                                  Container(
                                                    height: 0,
                                                  ),
                                                //pay with apple
                                                if (isBuy &&
                                                    st
                                                        .Stripe
                                                        .instance
                                                        .isApplePaySupported
                                                        .value)
                                                  GestureDetector(
                                                    onTap: () async {
                                                      //    Twl.navigateBack(context);
                                                      setState(() {
                                                        pay = "apple";
                                                      });
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12,
                                                                right: 12),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/applePayBlack.png",
                                                              width: 30,
                                                            ),
                                                            SizedBox(width: 15),
                                                            Text(
                                                              "Apple Pay",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontSize: isTab(
                                                                        context)
                                                                    ? 10.sp
                                                                    : 12.sp,
                                                                color:
                                                                    tSecondaryColor,
                                                              ),
                                                            ),
                                                            Spacer(),

                                                            /*  Text(
                          '${physcialGold.toStringAsFixed(3)}g',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),*/

                                                            Image.asset(
                                                              (pay == "apple")
                                                                  ? 'images/yes.png'
                                                                  : 'images/no.png',
                                                              height: 20,
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                if (isBuy &&
                                                    st
                                                        .Stripe
                                                        .instance
                                                        .isApplePaySupported
                                                        .value)
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 12,
                                                        top: 12,
                                                        bottom: 10,
                                                      ),
                                                      child: Container(
                                                          height: 0.6,
                                                          color:
                                                              _getColorFromHex(
                                                                  "#707070"))),

                                                if (isBuy &&
                                                    st
                                                        .Stripe
                                                        .instance
                                                        .isApplePaySupported
                                                        .value)
                                                  Container(
                                                    height: 10,
                                                  ),
                                                //pay with debit
                                                if (isBuy)
                                                  GestureDetector(
                                                    onTap: () async {
                                                      //    Twl.navigateBack(context);
                                                      setState(() {
                                                        pay = "card";
                                                      });
                                                    },
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12,
                                                                right: 12),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(
                                                              "assets/icons/cardIcon.png",
                                                              width: 30,
                                                            ),
                                                            SizedBox(width: 15),
                                                            Text(
                                                              "Add debit/credit card",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Barlow',
                                                                fontSize: isTab(
                                                                        context)
                                                                    ? 10.sp
                                                                    : 12.sp,
                                                                color:
                                                                    tSecondaryColor,
                                                              ),
                                                            ),
                                                            Spacer(),

                                                            /*  Text(
                          '${physcialGold.toStringAsFixed(3)}g',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),*/

                                                            Image.asset(
                                                              (pay == "card")
                                                                  ? 'images/yes.png'
                                                                  : 'images/no.png',
                                                              height: 20,
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                                if (isBuy)
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 12,
                                                        top: 12,
                                                        bottom: 10,
                                                      ),
                                                      child: Container(
                                                          height: 0.6,
                                                          color:
                                                              _getColorFromHex(
                                                                  "#707070"))),
                                              ])));
                                });
                              });
                        },
                        child: Column(children: [
                          Row(children: [
                            Text((isBuy) ? "Paying with" : "Receive with",
                                style: TextStyle(
                                    fontFamily: "Barlow",
                                    fontWeight: FontWeight.w300,
                                    color: tTextSecondary,
                                    fontSize: 12)),
                            Container(width: 50)
                          ]),
                          Transform.translate(
                              offset: Offset(
                                  (pay == "card" || pay == "bank") ? -17 : 0,
                                  2),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    (pay == "bank")
                                        ? Image.asset('images/Bank.png',
                                            height: 25)
                                        : (pay == "card")
                                            ? Image.asset(
                                                'assets/icons/cardIcon.png',
                                                width: 25)
                                            : (pay == "apple")
                                                ? Image.asset(
                                                    'assets/icons/applePayBlack.png',
                                                    width: 25)
                                                : Image.asset(
                                                    'assets/icons/gpay_Pay_Mark.png',
                                                    width: 25),
                                    Text(
                                        (pay == "bank")
                                            ? " Bank "
                                            : (pay == "card")
                                                ? " Card "
                                                : (pay == "apple")
                                                    ? " Apple Pay "
                                                    : " Google Pay ",
                                        style: TextStyle(
                                            fontFamily: "Barlow",
                                            fontWeight: FontWeight.w700,
                                            color: tTextSecondary,
                                            fontSize: 14)),
                                    Image.asset('assets/icons/expandmore.png',
                                        height: 11),
                                  ]))
                        ])),
                    GestureDetector(
                        onTap: () async {
                          diplayBottomSheet(isBuy);
                        },
                        child: Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text((isBuy) ? "Buying for" : "Selling from",
                                    style: TextStyle(
                                        fontFamily: "Barlow",
                                        fontWeight: FontWeight.w300,
                                        color: tTextSecondary,
                                        fontSize: 12)),
                                Container(width: 110)
                              ]),
                          Row(children: [
                            Container(
                                height: 25,
                                child: Center(
                                    child:
                                        Image.asset(Images.GOLD, height: 11))),
                            Text(" $deliverFromValue ",
                                style: TextStyle(
                                    fontFamily: "Barlow",
                                    fontWeight: FontWeight.w700,
                                    color: tTextSecondary,
                                    fontSize: 14)),
                            Image.asset('assets/icons/expandmore.png',
                                height: 11),
                          ])
                        ]))
                  ],
                ),
                Container(height: 20),
                Container(
                    height: 40,
                    width: 356,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: _getColorFromHex("#E5B02C"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (isBuy == true)
                          buy();
                        else
                          sell();
                      },
                      child: Text("Continue",
                          style: TextStyle(
                              fontFamily: "Barlow",
                              fontWeight: FontWeight.w700,
                              color: tTextSecondary,
                              fontSize: 20)),
                    )),
                Container(height: 5),
              ],
            ),
          );
        });
      },
    );
  }

  Timer? timer;
  @override
  void initState() {
    getGoldPrice();
    // getGoldWeigthRange();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => getGoldPrice());
    ActionProvider _data = Provider.of<ActionProvider>(context, listen: false);
    setState(() {
      print('_data.navGoldType>>>>>>>>>>');
      print(_data.navGoldType);
      goldType = _data.navGoldType;
    });
    // TODO: implement initState
    super.initState();
    e();
  }

  e() async {
    await analytics.logEvent(
      name: "buy_page",
      parameters: {
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'invest_page',
      properties: {"clicked": true},
    );

    mixpanel.track('invest_page', properties: {
      "button_clicked": true,
    });

    await logEvent("invest_page", {
      "button_clicked": true,
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  var goldType = '1';
  bool loadingPaymentStatus = false;
  // loader(value) {
  //   setState(() {
  //     loadingPaymentStatus = value;
  //   });
  // }

  var goldWeigthRange;
  var res;
  var goldPrice;
  var priceDetails;
  var verifStatus;
  getGoldWeigthRange() async {
    // var weigthRange = await UserAPI().goldWeightRange(context);
    // if (weigthRange != null && weigthRange['status'] == 'OK') {
    //   setState(() {
    //     goldWeigthRange = weigthRange['details'];
    //     print(goldWeigthRange);
    //   });
    // }
  }

  List<ChartData> chartData = [], chartData1 = [];
  String pr = "1g", ti = "1d";
  num x = 0;
  getGoldPrice() async {
    setState(() {
      //  loading = true;
    });
    // var status = await checkVeriffStatus(context);
    // setState(() {
    //   verifStatus = status;
    //   print(verifStatus.runtimeType);
    // });
    print("getGoldPrice");
    print('getGoldPrice' + DateTime.now().toString());
    sharedPreferences = await SharedPreferences.getInstance();

    res = await UserAPI().getGoldPrice(context);

    /*  showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Image.asset('images/logo.png', height: 25),
            content: Text("$res",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Poppins-Regular",
                    color: _getColorFromHex("#1E365B"))),
          );
        });*/

    if (res != null && res['status'] == 'OK') {
      setState(() {
        priceDetails = res['details'];

        goldWeigthRange = res['details']['gold_weight_ranges'];
        // print(goldWeigthRange);

        // _priceController
        //   ..text = Secondarycurrency +
        //       (_currentSliderValue * priceDetails['price_gram_24k']).toString();
        _priceController..text = _currentSliderValue.toString();
        finalBuyValue(_currentSliderValue, priceDetails['price_gram_24k']);
      });
      // print('getGoldPrice');
      // print(res);
    } else {
      print(res['error']);
    }

    setState(() {
      chartData = [];
      chartData1 = [];

      if (pr == "1g")
        x = priceDetails['price_gram_24k'];
      else if (pr == "10g")
        x = priceDetails['price_gram_24k'] * 10;
      else if (pr == "1oz")
        x = priceDetails['price_gram_24k'];
      else if (pr == "50g")
        x = priceDetails['price_gram_24k'] * 31.1;
      else if (pr == "100g")
        x = priceDetails['price_gram_24k'] * 100;
      else if (pr == "1kg") x = priceDetails['price_gram_24k'] * 1000;

      if (ti == "1d") {
        chartData = [
          ChartData("12:30", x - 5),
          ChartData("12:45", x - 4.2),
          ChartData("13:00", x - 4),
          ChartData("13:15", x - 3.5),
          ChartData("13:30", x - 3.3),
          ChartData("13:45", x - 2),
          ChartData("14:00", x - 4),
          ChartData("14:15", x),
        ];

        chartData1 = [
          ChartData("12:30", x),
          ChartData("13:00", x),
          ChartData("13:30", x),
          ChartData("14:00", x),
          ChartData("14:30", x),
        ];
      } else if (ti == "1w") {
        chartData = [
          //  ChartData("12:30", x - 5),
          ChartData("Day 7", x - 5),
          ChartData("Day 6", x - 4),
          ChartData("Day 5", x - 3.5),
          ChartData("Day 4", x - 3.3),
          ChartData("Day 3", x - 2),
          ChartData("Day 2", x - 1.2),
          ChartData("Day 1", x),
        ];

        chartData1 = [
          ChartData("Day 7", x),
          ChartData("Day 6", x),
          ChartData("Day 4", x),
          ChartData("Day 2", x),
          ChartData("Day 1", x),
        ];
      } else if (ti == "1m") {
        chartData = [
          ChartData("Week 5", x - 5),
          ChartData("Week 4", x - 4.2),
          ChartData("Week 3.5", x - 4),
          ChartData("Week 3", x - 3.5),
          ChartData("Week 2.5", x - 3.3),
          ChartData("Week 2", x - 2),
          ChartData("Week 1.5", x - 1.2),
          ChartData("Week 1", x),
        ];

        chartData1 = [
          ChartData("Week 5", x),
          ChartData("Week 4", x),
          ChartData("Week 3", x),
          ChartData("Week 2", x),
          ChartData("Week 1", x),
        ];
      } else if (ti == "3m") {
        chartData = [
          ChartData("Week 12", x - 5),
          ChartData("Week 10", x - 4.2),
          ChartData("Week 8", x - 4),
          ChartData("Week 6", x - 3.5),
          ChartData("Week 4", x - 3.3),
          ChartData("Week 3", x - 2),
          ChartData("Week 2", x - 1.2),
          ChartData("Week 1", x),
        ];

        chartData1 = [
          ChartData("Week 12", x),
          ChartData("Week 9", x),
          ChartData("Week 6", x),
          ChartData("Week 3", x),
          ChartData("Week 1", x),
        ];
      } else if (ti == "1y") {
        chartData = [
          ChartData("Feb", x - 3.3),
          ChartData("Mar", x + 2),
          ChartData("Apr", x - 1.2),
          ChartData("May", x),
          ChartData("Jun", x - 5),
          ChartData("Jul", x - 4.2),
          ChartData("Aug", x - 4),
          ChartData("Sep", x - 3.5),
          ChartData("Oct", x - 3.3),
          ChartData("Nov", x - 2),
          ChartData("Dec", x - 1.2),
          ChartData("Jan", x),
        ];

        chartData1 = [
          ChartData("Feb", x),
          ChartData("Jun", x),
          ChartData("Aug", x),
          ChartData("Sep", x),
          ChartData("Nov", x),
          ChartData("Jan", x),
        ];
      } else if (ti == "max") {
        chartData = [
          ChartData("2008", x - 5),
          ChartData("2009", x - 4.2),
          ChartData("2010", x + 4),
          ChartData("2011", x - 3.5),
          ChartData("2012", x - 3.3),
          ChartData("2013", x - 2),
          ChartData("2014", x - 1.2),
          ChartData("2015", x),
          ChartData("2016", x - 5),
          ChartData("2017", x - 4.2),
          ChartData("2018", x - 4),
          ChartData("2019", x - 3.5),
          ChartData("2020", x - 3.3),
          ChartData("2021", x - 2),
          ChartData("2022", x - 1.2),
          ChartData("2023", x),
        ];

        chartData1 = [
          ChartData("2008", x),
          ChartData("2016", x),
          ChartData("2018", x),
          ChartData("2020", x),
          ChartData("2022", x),
          ChartData("2023", x),
        ];
      }
      loading = false;
    });
  }

  late SharedPreferences sharedPreferences;
  getMintingvalue(goldPrice) async {
    var mintingPercent;
    var mintingValue;
    print("minivallll");
    print(double.parse(sharedPreferences.getString('minting').toString()));
    setState(() {
      mintingPercent = sharedPreferences.getString('minting');
      mintingValue = (double.parse(mintingPercent) / 100);
      // *
      //     double.parse(goldPrice.toStringAsFixed(3));
    });
    // print(gram);
    // print(livePrice);
    // print('mintingPercent');
    // print(goldPrice.toStringAsFixed(3));
    // print(mintingPercent);
    // print(mintingValue);
    return mintingValue;
  }

  getvolatilityvalue(goldPrice) async {
    var volatilityPercent;
    var volatilityValue;
    setState(() {
      volatilityPercent = sharedPreferences.getString('volatility');
      volatilityValue = (double.parse(volatilityPercent) / 100);
      //  *
      //     double.parse(goldPrice.toStringAsFixed(3));
    });
    return volatilityValue;
  }

  double roundDouble(double value, int places) {
    var mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  finalBuyValue(amount, liveGoldPrice) async {
    // var amount = 1132.96;
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
    // var goldQuantityBeforeAddingTaxes = amount / liveGoldPrice;
    // print('goldQuantityBeforeAddingTaxes ' +
    //     goldQuantityBeforeAddingTaxes.toString());
    // print(qty);
    var markupPercentage;
    var totalValueBeforeMarkup;
    for (var i = 0; i <= goldWeigthRange.length - 1; i++) {
      var goldValue = (oneGram * liveGoldPrice).toStringAsFixed(4);
      // print('goldValue  ' + goldValue.toString());
      var barMinting =
          (double.parse(goldValue) * mintingvalue).toStringAsFixed(4);
      var volatilityFees =
          (double.parse(goldValue) * volatilityvalue).toStringAsFixed(4);
      // print("barMinting " + barMinting.toString());
      // print("volatilityFees " + volatilityFees.toString());
      totalValueBeforeMarkup = (double.parse(goldValue.toString()) +
              double.parse(barMinting.toString()) +
              double.parse(volatilityFees.toString()))
          .toStringAsFixed(4);
      print('totalValueBeforeMarkup' + totalValueBeforeMarkup.toString());

      if (amount >= goldWeigthRange[i]['range_price_start'] &&
          amount <= goldWeigthRange[i]['range_orice_end']) {
        markupPercentage =
            (goldWeigthRange[i]['markup_percentage']).toStringAsFixed(2);
        print('markupPercentage ' + markupPercentage.toString());
        // var FeesMarkup =
        //     (double.parse(markupPercentage) * totalValueBeforeMarkup)
        //         .toStringAsFixed(4);
        // print('FeesMarkup ' + FeesMarkup.toString());
        // var buyPrice = (double.parse(FeesMarkup.toString()) +
        //         double.parse(totalValueBeforeMarkup.toString()))
        //     .toStringAsFixed(4);
        // print('buyPrice ' + buyPrice.toString());
        // finalBuyPrice = (double.parse(buyPrice)).toStringAsFixed(3);
        // print(finalBuyPrice);
        // print('finalBuyPrice ' + finalBuyPrice.toString());
        // break
      }
      //  else {
      //   markupPercentage = (goldWeigthRange[goldWeigthRange.length - 1]
      //           ['markup_percentage'])
      //       .toStringAsFixed(2);
      //   // print('markupPercentage ' + markupPercentage.toString());
      //   // var FeesMarkup =
      //   //     (double.parse(markupPercentage) * totalValueBeforeMarkup)
      //   //         .toStringAsFixed(4);
      //   // // print('FeesMarkup ' + FeesMarkup.toString());
      //   // var buyPrice = (double.parse(FeesMarkup.toString()) +
      //   //         double.parse(totalValueBeforeMarkup.toString()))
      //   //     .toStringAsFixed(4);
      //   // // print('buyPrice ' + buyPrice.toString());
      //   // finalBuyPrice = (double.parse(buyPrice)).toStringAsFixed(3);
      //   // print(finalBuyPrice);
      // }

    }
    print(markupPercentage);
    var feesMarkup =
        (double.parse(markupPercentage) * double.parse(totalValueBeforeMarkup))
            .toStringAsFixed(4);
    print('FeesMarkup ' + feesMarkup.toString());
    var buyPrice = (double.parse(feesMarkup.toString()) +
            double.parse(totalValueBeforeMarkup.toString()))
        .toStringAsFixed(4);
    print('buyPrice ' + buyPrice.toString());
    finalBuyPrice = (double.parse(buyPrice)).toStringAsFixed(3);
    print(finalBuyPrice);
    print('finalBuyPrice ' + finalBuyPrice.toString());
    print("asdbcsa");
    print(finalBuyPrice);
    print(double.parse(finalBuyPrice).toStringAsFixed(3));
    var goldUnits = (amount / double.parse(finalBuyPrice)).toStringAsFixed(3);
    print('goldUnits ' + goldUnits);
    setState(() {
      _qtyController..text = goldUnits;
    });
    return goldUnits;
  }
  // double roundOffToXDecimal(double number, {int numberOfDecimal = 2}) {
  //   // To prevent number that ends with 5 not round up correctly in Dart (eg: 2.275 round off to 2.27 instead of 2.28)
  //   String numbersAfterDecimal = number.toString().split('.')[1];
  //   if (numbersAfterDecimal != '0') {
  //     int existingNumberOfDecimal = numbersAfterDecimal.length;
  //     number += 1 / (10 * pow(10, existingNumberOfDecimal));
  //     print("dsnsd" +number.toString());
  //   }

  //   return double.parse(number.toStringAsFixed(numberOfDecimal));
  // }

  finalBuyValuewithGrams(qty, goldPrice) async {
    var mintingvalue;
    var mintingvaluebefore = await getMintingvalue(
      qty,
    );
    mintingvalue =
        mintingvaluebefore * double.parse(goldPrice.toStringAsFixed(3));
    var volatilityvalue;
    var volatilityvaluebefore = await getvolatilityvalue(
      qty,
    );
    volatilityvalue =
        volatilityvaluebefore * double.parse(goldPrice.toStringAsFixed(3));
    print('qty');
    print(qty);
    print("goldPrice");
    print(goldPrice);
    print('mintingvalue');
    print(mintingvalue);
    print('volatilityvalue');
    print(volatilityvalue);
    print(qty);
    var finalBuyPrice;
    for (var i = 0; i <= goldWeigthRange.length - 1; i++) {
      if (qty >= goldWeigthRange[i]['gold_range_start'] &&
          qty <= goldWeigthRange[i]['gold_range_end']) {
        print('Between>>>>>>>');
        // markupPercentage
        var markupPercentage = goldWeigthRange[i]['markup_percentage'];

        // TotalValueBeforeMarkup

        var TotalValueBeforeMarkup = goldPrice +
            double.parse(mintingvalue.toString()) +
            double.parse(volatilityvalue.toString());

        // FeesMarkup
        var FeesMarkup =
            (TotalValueBeforeMarkup) * goldWeigthRange[i]['markup_percentage'];
        // finalBuyPrice
        finalBuyPrice = TotalValueBeforeMarkup + FeesMarkup;
        print('markupPercentage');
        print(markupPercentage);
        print('FeesMarkup');
        print(FeesMarkup);
        print('finalBuyPrice');
        print(finalBuyPrice.toString());
        // print(roundOffToXDecimal(2.274, numberOfDecimal: 2));
        setState(() {
          _priceController
            ..text =
                // Secondarycurrency +
                (finalBuyPrice.toStringAsFixed(2)).toString();
        });
        print(finalBuyPrice.toStringAsFixed(2));

        break;
      }
      // else {
      //   // if (qty == '0' || qty == 0) {
      //   //   print('Not between');
      //   //   setState(() {
      //   //     _priceController..text = '0';
      //   //   });
      //   //   return '0';
      //   // }
      // }
    }
    return finalBuyPrice.toStringAsFixed(2);
  }

  double _currentSliderValue = 1;
  bool isZoom = false;
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(
      context,
    );

    return Stack(children: [
      GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              backgroundColor: tWhite,
              appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: tWhite,
                  title: Text("\nInvest",
                      style: TextStyle(
                          fontFamily: "Barlow",
                          fontWeight: FontWeight.bold,
                          color: tTextSecondary,
                          fontSize: 31))),
              body: ListView(
                children: [
                  Divider(color: _getColorFromHex("#707070")),
                  (x == 0 || ((x != 0) && (loading == true)))
                      ? Center(
                          child: Container(
                            color: Colors.white,
                            // padding:
                            //     EdgeInsets.only(top: 100),

                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              color: tPrimaryColor,
                            ),
                          ),
                        )
                      : Stack(children: [
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.only(top: 4, left: 0),
                              // height: 28,
                              child: Image.asset(
                                Images.GOLD,
                                height: 29,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Container(
                                padding: EdgeInsets.only(left: 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Gold",
                                              style: TextStyle(
                                                  fontFamily: "SignikaB",
                                                  fontWeight: FontWeight.w700,
                                                  color: tTextSecondary,
                                                  fontSize: 11)),
                                          Text("Metfolio Physical Gold",
                                              style: TextStyle(
                                                  fontFamily: "Signika",
                                                  fontWeight: FontWeight.w400,
                                                  color: tTextSecondary,
                                                  fontSize: 11)),
                                          Text(
                                              (pr == "1g")
                                                  ? "£${priceDetails['price_gram_24k'].toStringAsFixed(2)}"
                                                  : (pr == "10g")
                                                      ? "£${(priceDetails['price_gram_24k'] * 10).toStringAsFixed(2)}"
                                                      : (pr == "1oz")
                                                          ? "£${(priceDetails['price_gram_24k'] * 31.1).toStringAsFixed(2)}"
                                                          : (pr == "50g")
                                                              ? "£${(priceDetails['price_gram_24k'] * 50).toStringAsFixed(2)}"
                                                              : (pr == "100g")
                                                                  ? "£${(priceDetails['price_gram_24k'] * 100).toStringAsFixed(2)}"
                                                                  : "£${(priceDetails['price_gram_24k'] * 1000).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontFamily: "SignikaB",
                                                  fontWeight: FontWeight.w700,
                                                  color: tTextSecondary,
                                                  fontSize: 22)),
                                          RichText(
                                            text: TextSpan(
                                              text: '+2.4% ',
                                              style: TextStyle(
                                                  fontFamily: "Signika",
                                                  fontWeight: FontWeight.w400,
                                                  color: _getColorFromHex(
                                                      "#3D795B"),
                                                  fontSize: 10),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'last 24 hours',
                                                    style: TextStyle(
                                                        fontFamily: "Signika",
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: tTextSecondary,
                                                        fontSize: 10)),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ])),
                          ),
                          ListTile(
                            trailing: Container(
                                padding: EdgeInsets.only(top: 12, left: 0),
                                child: Container(
                                    height: 30,
                                    width: 150,
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _getColorFromHex("#9EDBDD"),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Center(
                                        child: RichText(
                                      text: TextSpan(
                                        text: 'Market ',
                                        style: TextStyle(
                                            fontFamily: "Barlow",
                                            fontWeight: FontWeight.w400,
                                            color: tTextSecondary,
                                            fontSize: 14),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Open ',
                                              style: TextStyle(
                                                  fontFamily: "Barlow",
                                                  fontWeight: FontWeight.w400,
                                                  color: _getColorFromHex(
                                                      "#E5B02C"),
                                                  fontSize: 14)),
                                          TextSpan(
                                              text: '24 hours ',
                                              style: TextStyle(
                                                  fontFamily: "Barlow",
                                                  fontWeight: FontWeight.w400,
                                                  color: tTextSecondary,
                                                  fontSize: 14)),
                                        ],
                                      ),
                                    )))),
                          )
                        ]),
                  Container(
                    height: 30,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 40,
                          width: 145,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: (isBuy)
                                    ? _getColorFromHex("#E5B02C")
                                    : _getColorFromHex("#F9DDA5"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _currentSliderValue = 1;
                                  priceDetails = res['details'];

                                  goldWeigthRange =
                                      res['details']['gold_weight_ranges'];
                                  // print(goldWeigthRange);

                                  // _priceController
                                  //   ..text = Secondarycurrency +
                                  //       (_currentSliderValue * priceDetails['price_gram_24k']).toString();
                                  _priceController
                                    ..text = _currentSliderValue.toString();
                                  finalBuyValue(_currentSliderValue,
                                      priceDetails['price_gram_24k']);
                                });

                                setState(() {
                                  isBuy = true;
                                });

                                show();
                              },
                              child: Text(
                                "Buy",
                                style: TextStyle(
                                  fontFamily: "Barlow",
                                  fontSize: 25,
                                  color: _getColorFromHex("#1E365B"),
                                ),
                              )),
                        ),
                        Container(
                          height: 40,
                          width: 145,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: (isBuy == false)
                                    ? _getColorFromHex("#E5B02C")
                                    : _getColorFromHex("#F9DDA5"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _currentSliderValue = 1;
                                  priceDetails = res['details'];
                                  goldPrice = priceDetails['price_gram_24k'];
                                  _priceController
                                    ..text =
                                        // Secondarycurrency +
                                        (_currentSliderValue *
                                                priceDetails['price_gram_24k'])
                                            .toStringAsFixed(2);
                                  _qtyController
                                    ..text = _currentSliderValue.toString();
                                });

                                setState(() {
                                  isBuy = false;
                                });
                                show();
                              },
                              child: Text(
                                "Sell",
                                style: TextStyle(
                                  fontFamily: "Barlow",
                                  fontSize: 25,
                                  color: _getColorFromHex("#1E365B"),
                                ),
                              )),
                        )
                      ]),
                  Container(
                    height: 30,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Price per:",
                                style: TextStyle(
                                  fontFamily: "Barlow",
                                  fontWeight: FontWeight.w700,
                                  color: tTextSecondary,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pr = "1g";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 17,
                                      width: 23,
                                      decoration: BoxDecoration(
                                          color: (pr == "1g")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "1g",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pr = "10g";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 17,
                                      width: 25,
                                      decoration: BoxDecoration(
                                          color: (pr == "10g")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "10g",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pr = "1oz";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 17,
                                      width: 23,
                                      decoration: BoxDecoration(
                                          color: (pr == "1oz")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "1oz",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pr = "50g";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 17,
                                      width: 23,
                                      decoration: BoxDecoration(
                                          color: (pr == "50g")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "50g",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pr = "100g";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 17,
                                      width: 29,
                                      decoration: BoxDecoration(
                                          color: (pr == "100g")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "100g",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pr = "1kg";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 17,
                                      width: 23,
                                      decoration: BoxDecoration(
                                          color: (pr == "1kg")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "1kg",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              Text(
                                "          ",
                                style: TextStyle(
                                  fontFamily: "SignikaR",
                                  color: tTextSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: tTextSecondary, width: 2.0)),
                          ),
                          Container(
                              height: 260,
                              width: 280,
                              child: Stack(children: [
                                SfCartesianChart(
                                    onMarkerRender: (MarkerRenderArgs args) {
                                      final point = args.pointIndex;
                                      if (point == null) return;
                                      if (chartData[point] == chartData.last) {
                                        args.markerWidth = 5;
                                        args.markerHeight = 5;
                                        args.borderWidth = 0;
                                        args.color =
                                            _getColorFromHex("#E5B02C");
                                        args.borderColor =
                                            _getColorFromHex("#E5B02C");
                                      } else {
                                        args.markerWidth = 0;
                                        args.markerHeight = 0;
                                        args.color = Colors.transparent;
                                      }
                                    },
                                    zoomPanBehavior: ZoomPanBehavior(
                                      enablePanning: true,
                                      maximumZoomLevel: 4,
                                    ),
                                    plotAreaBorderWidth: 0,
                                    primaryYAxis: NumericAxis(
                                        // X axis will be opposed
                                        majorTickLines: MajorTickLines(
                                            color: _getColorFromHex("#1F365B")),
                                        interval: 1,
                                        //  desiredIntervals: 7,
                                        labelStyle: TextStyle(
                                            color: _getColorFromHex("#1F365B")),
                                        minimum: x - 5,
                                        maximum: x + 5,
                                        numberFormat: NumberFormat("£"),
                                        //   plotOffset: 10,
                                        majorGridLines:
                                            MajorGridLines(width: 0),
                                        axisLine: AxisLine(
                                            color: _getColorFromHex("#1F365B")),
                                        opposedPosition: true),
                                    primaryXAxis: CategoryAxis(
                                        // X axis will be opposed

                                        autoScrollingDelta: 7,
                                        majorTickLines: MajorTickLines(
                                            color: _getColorFromHex("#1F365B")),
                                        labelPlacement: LabelPlacement.onTicks,
                                        labelStyle: TextStyle(
                                            color: _getColorFromHex("#1F365B")),
                                        //  plotOffset: 10,
                                        majorGridLines:
                                            MajorGridLines(width: 0),
                                        axisLine: AxisLine(
                                            color: _getColorFromHex("#1F365B")),
                                        opposedPosition: false),
                                    series: <ChartSeries>[
                                      // Renders line chart
                                      LineSeries<ChartData, String>(
                                        color: _getColorFromHex("#1F365B"),
                                        width: 1,
                                        dataSource: chartData,
                                        markerSettings:
                                            MarkerSettings(isVisible: true),
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y == 0 ? null : data.y,
                                      ),
                                      LineSeries<ChartData, String>(
                                        color: _getColorFromHex("#DEB14A"),
                                        width: 1,
                                        dataSource: chartData1,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y == 0 ? null : data.y,
                                      )
                                    ]),
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 178, top: 180),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isZoom = !isZoom;
                                          });
                                        },
                                        child: Image.asset(
                                            "assets/icons/nexticon.png",
                                            height: 14)))
                              ])),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ti = "1d";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 16,
                                      width: 32,
                                      decoration: BoxDecoration(
                                          color: (ti == "1d")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "1D",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ti = "1w";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 16,
                                      width: 32,
                                      decoration: BoxDecoration(
                                          color: (ti == "1w")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "1W",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ti = "1m";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 16,
                                      width: 32,
                                      decoration: BoxDecoration(
                                          color: (ti == "1m")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "1M",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ti = "3m";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 16,
                                      width: 32,
                                      decoration: BoxDecoration(
                                          color: (ti == "3m")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "3M",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ti = "1y";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 16,
                                      width: 32,
                                      decoration: BoxDecoration(
                                          color: (ti == "1y")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "1Y",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ti = "max";
                                    });
                                    getGoldPrice();
                                  },
                                  child: Container(
                                      height: 16,
                                      width: 32,
                                      decoration: BoxDecoration(
                                          color: (ti == "max")
                                              ? _getColorFromHex("#DEB14A")
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "MAX",
                                        style: TextStyle(
                                          fontFamily: "SignikaR",
                                          color: tTextSecondary,
                                          fontSize: 14,
                                        ),
                                      ))),
                              Row(children: [
                                Image.asset("images/30m1.png", width: 17),
                                Padding(
                                    padding: EdgeInsets.only(left: 1, right: 1),
                                    child: Text(
                                      "30 mins",
                                      style: TextStyle(
                                        fontFamily: "SignikaR",
                                        color: tTextSecondary,
                                        fontSize: 14,
                                      ),
                                    )),
                                Image.asset("images/30m2.png", width: 17),
                              ]),
                              Text(
                                "      ",
                                style: TextStyle(
                                  fontFamily: "SignikaR",
                                  color: tTextSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Container(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: tTextSecondary, width: 2.0)),
                          )
                        ],
                      ))
                ],
              )))
    ]);
  }

  String deliverFromValue = 'Physical Gold Account';
  var totalGold = 0.0;
  selectDeliverFrom(String value, double goldqty, String goldTypes) {
    print(value);
    print(goldqty);
    setState(() {
      deliverFromValue = value;
      totalGold = goldqty;
      goldType = goldTypes;
      print(goldType);
    });
    // checkGold(goldType);
  }

  diplayBottomSheet(isBuy) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      )),
      context: context,
      builder: (ctx) {
        return DeliveryFromBottomSheet(
          selected: deliverFromValue,
          type: isBuy,
          title: 'Performing action for:',
          selectDelivery: selectDeliverFrom,
        );
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final num y;
}

change(x) {
  return x.substring(0, 2) + ":" + x.substring(2);
}

_getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
}
