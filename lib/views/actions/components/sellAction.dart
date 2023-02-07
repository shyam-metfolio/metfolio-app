import 'dart:async';

import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';

import 'package:base_project_flutter/constants/imageConstant.dart';
import '../../../api_services/orderApi.dart';
import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/button.dart';
import '../../../provider/actionProvider.dart';
import '../../../responsive.dart';
import '../../bottomNavigation.dart/bottomNavigation.dart';
import '../../homePage/components/dashBoardPage.dart';
import '../../nameyourgoal/GoalAmount.dart';

import '../../revivewPaymentDetails/revivewPaymentDetails.dart';

class SellActionPage extends StatefulWidget {
  const SellActionPage({Key? key, this.goldType, this.totalGold, this.loader})
      : super(key: key);
  final goldType;
  final totalGold;
  final loader;
  @override
  State<SellActionPage> createState() => _SellActionPageState();
}

class _SellActionPageState extends State<SellActionPage> {
  Timer? timer;
  void initState() {
    ActionProvider _data = Provider.of<ActionProvider>(context, listen: false);
    setState(() {
      print('_data.navGoldType>>>>>>>>>>');
      print(_data.navGoldType);
      goldType = _data.navGoldType;
    });
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => getGoldPrice());
    super.initState();
    // checkGold(physicalGold.toString());
    getGoldPrice();
    e();
  }

  e() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "sell_page",
      parameters: {
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'sell_page',
      properties: {"clicked": true},
    );

    mixpanel.track('sell_page', properties: {
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
  // var totalGold = '0';
  // checkGold(String goldType) async {
  //   var res = await UserAPI().checkAvaliableGold(context, goldType);
  //   if (res != null && res['status'] == "OK") {
  //     setState(() {
  //       totalGold = res['details']['availableGold'].toString();
  //     });
  //   } else {}
  // }

  var res;
  var priceDetails;
  var goldPrice;
  var verifStatus;
  getGoldPrice() async {
    // var status = await checkVeriffStatus(context);
    // setState(() {
    //   verifStatus = status;
    //   print(verifStatus.runtimeType);
    // });
    res = await UserAPI().getGoldPrice(context);
    setState(() {
      priceDetails = res['details'];
      goldPrice = priceDetails['price_gram_24k'];
      _priceController
        ..text =
            // Secondarycurrency +
            (_currentSliderValue * priceDetails['price_gram_24k'])
                .toStringAsFixed(2);
      _qtyController..text = _currentSliderValue.toString();
    });
    print('getGoldPrice');
    print(res);
  }

  TextEditingController _priceController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  double _currentSliderValue = 1;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(
      context,
    );
    return SingleChildScrollView(
      child: Container(
        child: priceDetails == null
            ? Container(
                alignment: Alignment.center,
                width: 10.w,
                height: 60.h,
                padding: EdgeInsets.symmetric(vertical: 27.h),
                child: Center(
                  child: CircularProgressIndicator(
                    color: tPrimaryColor,
                  ),
                ),
              )
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      'Sell Gold for GBP',
                      style: TextStyle(
                          fontFamily: "Signika",
                          color: tTextSecondary,
                          fontSize: isTab(context) ? 15.sp : 16.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Text(
                      'Available to sell: ${(widget.totalGold.toStringAsFixed(3))}g',
                      style: TextStyle(
                          color: tTextSecondary,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Text(
                      'Type amount or use the slider',
                      style: TextStyle(
                          color: tTextSecondary,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Container(
                      height: 40,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _qtyController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                          // FilteringTextInputFormatter.deny(
                          //   RegExp(r'^0'), //users can't type 0 at 1st position
                          // ),
                          LengthLimitingTextFieldFormatterFixed(1000),
                          DecimalTextInputFormatter(decimalRange: 3)
                        ],
                        validator: (value) {
                          if (value!.isEmpty || (double.parse(value) <= 0)) {
                            return "";
                            // return "Postcode can't be empty";
                          } else if ((double.parse(value) > 1000)) {
                            return "";
                          } else {
                            return null;
                          }
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
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
                          _formKey.currentState!.validate();
                          if (value != '') {
                            if (value[0] == "0") if (value[1] == "0")
                              _qtyController.text = value.substring(1, 2);

                            _qtyController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _qtyController.text.length));

                            // if (double.parse(value) >= 100) {
                            //   setState(() {
                            //     _currentSliderValue = 100;
                            //   });
                            // }

                            // if (_formKey.currentState!.validate()) {
                            if (double.parse(value) <= 1000) {
                              setState(() {
                                _currentSliderValue = double.parse(value);
                                _priceController
                                  ..text =
                                      //  Secondarycurrency +
                                      (double.parse(value) *
                                              priceDetails['price_gram_24k'])
                                          .toStringAsFixed(2);
                              });
                            } else if ((double.parse(value)) >= 1000) {
                              setState(() {
                                _currentSliderValue = 100;
                                _priceController
                                  ..text =
                                      //  Secondarycurrency +
                                      (double.parse(value) *
                                              priceDetails['price_gram_24k'])
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
                            fontSize: isTab(context) ? 13.sp : 16.sp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          errorStyle: TextStyle(height: 0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: SizedBox(
                            child: Center(
                              widthFactor: 1.5,
                              child: Text('Grams:',
                                  style: TextStyle(
                                      fontFamily: 'Signika',
                                      color: tTextSecondary,
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                      fontWeight: FontWeight.w400)),
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
                              color: tSecondaryColor.withOpacity(0.3),
                              fontSize: isTab(context) ? 9.sp : 12.sp),
                          // hintText: 'Enter Your Mobile Number',
                          fillColor: tPrimaryTextformfield,
                          // contentPadding:
                          //     EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.symmetric(vertical: 8),
                    //   decoration: BoxDecoration(
                    //       color: tTextformfieldColor,
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Center(
                    //     child: Text(
                    //       Secondarycurrency +
                    //           (priceDetails['price_gram_24k'] * _currentSliderValue)
                    //               .toString(),
                    //       style: TextStyle(
                    //           fontFamily: 'Signika',
                    //           color: tTextSecondary,
                    //           fontSize: isTab(context) ? 12.sp : 15.sp,
                    //           fontWeight: FontWeight.w400),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      width: double.infinity,
                      child: CupertinoSlider(
                        thumbColor: tTextSecondary,
                        activeColor: tTextSecondary,
                        divisions: 5000,
                        max: 5000,
                        min: 0.0,
                        // double.parse(totalGold) ,
                        value: _currentSliderValue,
                        onChanged: (value) {
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
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    // Text(
                    //   'Available to move: 50g',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w400,
                    //       color: tSecondaryColor,
                    //       fontSize: isTab(context) ? 10.sp : 13.sp),
                    // ),
                    // SizedBox(
                    //   height: 6.1.h,
                    // ),
                    // Text(
                    //   'This amount will be moved to your goal balance',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w400,
                    //       color: tSecondaryColor,
                    //       fontSize: isTab(context) ? 10.sp : 13.sp),
                    // )
                    Container(
                      // height: 40,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '';
                            // return "Postcode can't be empty";
                          } else if (double.parse(value) < 0) {
                            return '';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        controller: _priceController,
                        // keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                          FilteringTextInputFormatter.deny(
                            RegExp(r'^0'), //users can't type 0 at 1st position
                          ),
                          LengthLimitingTextFieldFormatterFixed(50000),
                          DecimalTextInputFormatter(decimalRange: 2)
                        ],
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        // onTap: () => TextSelection(
                        //       baseOffset: 0,
                        //       extentOffset:
                        //           _priceController.value.text.length - 1,
                        //     ),
                        onChanged: (value) {
                          _formKey.currentState!.validate();
                          if (value != '') {
                            // if ((double.parse(value) ) >=
                            //     5000) {

                            // }
                            if ((double.parse(value)) <= 5000) {
                              setState(() {
                                // var price =double.parse(value).toStringAsFixed(0);
                                if (double.parse(value) /
                                        priceDetails['price_gram_24k'] >=
                                    1) {
                                  _currentSliderValue = double.parse(value) /
                                      priceDetails['price_gram_24k'];
                                }

                                if (value != '') {
                                  _qtyController
                                    ..text = (double.parse(value) /
                                            priceDetails['price_gram_24k'])
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
                                        priceDetails['price_gram_24k'])
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
                            fontSize: isTab(context) ? 13.sp : 16.sp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.red,
                            ),
                          ),
                          errorStyle: TextStyle(height: 0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              width: 1,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: SizedBox(
                            child: Center(
                              widthFactor: 1.5,
                              child: Text('GBP ($Secondarycurrency):',
                                  style: TextStyle(
                                      fontFamily: 'Signika',
                                      color: tTextSecondary,
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                      fontWeight: FontWeight.w400)),
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
                              color: tSecondaryColor.withOpacity(0.3),
                              fontSize: isTab(context) ? 9.sp : 12.sp),
                          // hintText: 'Enter Your Mobile Number',
                          fillColor: tPrimaryTextformfield,
                          contentPadding: EdgeInsets.only(
                            right: 21.w,
                            left: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          isDense: true,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   padding: EdgeInsets.symmetric(vertical: 8),
                    //   decoration: BoxDecoration(
                    //       color: tTextformfieldColor,
                    //       borderRadius: BorderRadius.circular(12)),
                    //   child: Center(
                    //     child: Text(
                    //       _currentSliderValue.toString() + "g",
                    //       style: TextStyle(
                    //           fontFamily: 'Signika',
                    //           color: tTextSecondary,
                    //           fontSize: isTab(context) ? 12.sp : 15.sp,
                    //           fontWeight: FontWeight.w400),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "The prices above refresh every 60 seconds to reflect the live gold price.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 5.sp : 8.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17.w),
                      child: Container(
                        height: 40,
                        width: 230,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: tPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text('Continue',
                                style: TextStyle(
                                  color: tBlue,
                                )),
                            onPressed: () async {
                              setState(() {
                                print('_data.navGoldType>>>>>>>>>>');
                                print(_data.navGoldType);
                                goldType = _data.navGoldType;
                              });
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                // if (verifStatus) {
                                // var price = _priceController.text;
                                // var qty = _qtyController.text;
                                var price;
                                var qty;
                                setState(() {
                                  var qtyFormate =
                                      num.parse(_qtyController.text).toDouble();
                                  var priceFormate =
                                      num.parse(_priceController.text)
                                          .toDouble();
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
                                widget.loader(true);
                                var amount;
                                setState(() {
                                  amount = priceDetails['price_gram_24k'] *
                                      _currentSliderValue;
                                });
                                var deleteCart =
                                    await OrderAPI().deleteCart(context);
                                if (deleteCart != null) {
                                  var addTocart = await OrderAPI().addToCart(
                                      context,
                                      Sell.toString(),
                                      qty.replaceAll(RegExp('g'), ''),
                                      price.replaceAll(
                                          RegExp(Secondarycurrency), ''),
                                      goldType);
                                  if (addTocart != null &&
                                      addTocart['status'] == 'OK') {
                                    widget.loader(false);
                                    var timeNow = DateTime.now();
                                    sharedPreferences.setString(
                                        "cartCreatedTime", timeNow.toString());
                                    Twl.navigateTo(
                                        context,
                                        RevivewPaymentDetails(
                                          qty: qty.replaceAll(RegExp('g'), ''),
                                          price: price.replaceAll(
                                              RegExp(Secondarycurrency), ''),
                                          type: Sell,
                                          goldType: goldType,
                                        ));
                                  } else {
                                    widget.loader(false);
                                    showDialog(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: tTextformfieldColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
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
                                                      color:
                                                          tTextformfieldColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Container(
                                                        height: 350,
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      30,
                                                                  vertical: 10),
                                                          child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        'You do not have enough gold to complete this sale.',
                                                                        style: TextStyle(
                                                                            color:
                                                                                tSecondaryColor,
                                                                            fontSize: isTab(context)
                                                                                ? 13.sp
                                                                                : 16.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        ' Not to worry just select an amount within your available balance!',
                                                                        style: TextStyle(
                                                                            color:
                                                                                tSecondaryColor,
                                                                            fontSize: isTab(context)
                                                                                ? 10.sp
                                                                                : 13.sp,
                                                                            fontWeight: FontWeight.w400),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ]),
                                                                Column(
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Center(
                                                                      child:
                                                                          Container(
                                                                        width: double
                                                                            .infinity,
                                                                        child:
                                                                            ArgonButton(
                                                                          highlightElevation:
                                                                              0,
                                                                          elevation:
                                                                              0,
                                                                          height: isTab(context)
                                                                              ? 70
                                                                              : 40,
                                                                          width:
                                                                              90.w,
                                                                          color:
                                                                              tPrimaryColor,
                                                                          borderRadius:
                                                                              15,
                                                                          child:
                                                                              Text(
                                                                            'Okay',
                                                                            style:
                                                                                TextStyle(
                                                                              color: tSecondaryColor,
                                                                              fontSize: 13.sp,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          loader:
                                                                              Container(
                                                                            // height: 40,
                                                                            // width: double.infinity,
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 0),
                                                                            child:
                                                                                Lottie.asset(
                                                                              Loading.LOADING,
                                                                              // width: 50.w,
                                                                            ),
                                                                          ),
                                                                          onTap: (startLoading,
                                                                              stopLoading,
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
                                  widget.loader(false);
                                }
                                widget.loader(false);
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

                              await FirebaseAnalytics.instance.logEvent(
                                name: "sell_gold",
                                parameters: {
                                  "price": num.parse(_priceController.text)
                                      .toDouble(),
                                  "qty":
                                      num.parse(_qtyController.text).toDouble(),
                                  "button_clicked": true,
                                },
                              );

                              Segment.track(
                                eventName: 'sell_gold',
                                properties: {
                                  "price": num.parse(_priceController.text)
                                      .toDouble(),
                                  "qty":
                                      num.parse(_qtyController.text).toDouble(),
                                  "clicked": true
                                },
                              );

                              mixpanel.track('sell_gold', properties: {
                                "price":
                                    num.parse(_priceController.text).toDouble(),
                                "qty":
                                    num.parse(_qtyController.text).toDouble(),
                                "button_clicked": true,
                              });
                            }
                            // stopLoading();
                            // }
                            ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
