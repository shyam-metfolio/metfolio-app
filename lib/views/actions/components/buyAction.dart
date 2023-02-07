import 'dart:async';
import 'dart:math';

import 'package:base_project_flutter/api_services/orderApi.dart';
import 'package:base_project_flutter/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/button.dart';
import '../../../provider/actionProvider.dart';
import '../../../responsive.dart';
import '../../nameyourgoal/GoalAmount.dart';
import '../../revivewPaymentDetails/revivewPaymentDetails.dart';

class BuyActionPage extends StatefulWidget {
  const BuyActionPage({Key? key, this.goldType, this.loader}) : super(key: key);
  final goldType;
  final loader;
  @override
  State<BuyActionPage> createState() => _BuyActionPageState();
}

class _BuyActionPageState extends State<BuyActionPage> {
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
    await FirebaseAnalytics.instance.logEvent(
      name: "buy_page",
      parameters: {
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'buy_page',
      properties: {"clicked": true},
    );

    mixpanel.track('buy_page', properties: {
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

  getGoldPrice() async {
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
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
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
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          'Buy Gold using GBP',
                          style: TextStyle(
                              fontFamily: "Signika",
                              color: tTextSecondary,
                              fontSize: isTab(context) ? 15.sp : 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 3.1.h,
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
                        // Container(
                        //   width: double.infinity,
                        //   padding: EdgeInsets.symmetric(vertical: 8),
                        //   decoration: BoxDecoration(
                        //       color: tTextformfieldColor,
                        //       borderRadius: BorderRadius.circular(10)),
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
                        // SizedBox(
                        //   height: 2.h,
                        // ),
                        Container(
                          height: 40,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: _priceController,

                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                                // return "Postcode can't be empty";
                              } else if (double.parse(value) < 1.0) {
                                return '';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp(
                                    r'^0'), //users can't type 0 at 1st position
                              ),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                              LengthLimitingTextFieldFormatterFixed(50000),
                              DecimalTextInputFormatter(decimalRange: 2)
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            // readOnly: true,
                            // keyboardType: TextInputType.phone,
                            onChanged: (value) async {
                              _formKey.currentState!.validate();

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
                                  } else if ((double.parse(value)) >= 50000) {
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
                                    _currentSliderValue = double.parse(value);
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
                                fontSize: isTab(context) ? 13.sp : 16.sp,
                                fontWeight: FontWeight.w400),
                            // maxLength: 4,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
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
                              prefixIcon: SizedBox(
                                child: Center(
                                  widthFactor: 1.5,
                                  child: Text('GBP ($Secondarycurrency):',
                                      style: TextStyle(
                                          fontFamily: 'Signika',
                                          color: tTextSecondary,
                                          fontSize:
                                              isTab(context) ? 13.sp : 16.sp,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
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
                                  fontSize: isTab(context) ? 13.sp : 16.sp,
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
                                  color: tSecondaryColor.withOpacity(0.3),
                                  fontSize: isTab(context) ? 9.sp : 12.sp),
                              // hintText: 'Enter Your Mobile Number',
                              fillColor: tPrimaryTextformfield,
                              // contentPadding: EdgeInsets.only(
                              // right: 21.w,
                              // left: 20,
                              //   top: 2,
                              //   bottom: 2,
                              // ),
                              filled: true,
                              // border: OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(10),
                              //   borderSide: BorderSide(
                              //     width: 0,
                              //     style: BorderStyle.none,
                              //   ),
                              // ),
                            ),
                          ),
                        ),
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
                              min: 1,
                              value: _currentSliderValue,
                              onChanged: (value) async {
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
                                  _priceController
                                    ..text = value.toStringAsFixed(0);
                                });
                              }),
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
                          height: 40,
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
                              DecimalTextInputFormatter(decimalRange: 3),
                              LengthLimitingTextFieldFormatterFixed(1000),
                            ],
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            // focusNode: FocusNode(),
                            // onTap: () => TextSelection(
                            //       baseOffset: 0,
                            //       extentOffset:
                            //           _qtyController.value.text.length - 1,
                            //     ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  ((1000 < double.parse(value)) &&
                                      double.parse(value) > 0)) {
                                return "";
                                // return "Postcode can't be empty";
                              }
                              return null;
                            },
                            onChanged: (value) async {
                              (_formKey.currentState!.validate());

                              if (value != '') {
                                // if (double.parse(value) != 1 ) {
                                setState(() {
                                  //     _qtyController
                                  //       ..text = num.parse(value)
                                  //           .toDouble()
                                  //           .toString();
                                  _qtyController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: _qtyController.text.length));
                                });
                                // }\

                                if ((1000 >= double.parse(value.toString()))) {
                                  var goldPrice =
                                      double.parse(value).toDouble() *
                                          priceDetails['price_gram_24k'];
                                  var finalBuyPrice =
                                      await finalBuyValuewithGrams(
                                          roundDouble(double.parse(value), 3),
                                          goldPrice);
                                  if (double.parse(value) < 100) {
                                    setState(() {
                                      if (double.parse(finalBuyPrice) <= 100 &&
                                          double.parse(finalBuyPrice) >= 1) {
                                        _currentSliderValue = double.parse(
                                            finalBuyPrice.toString());
                                        _priceController..text = finalBuyPrice;
                                      } else {
                                        _currentSliderValue = 100;
                                        _priceController..text = finalBuyPrice;
                                      }
                                    });
                                  } else {
                                    _currentSliderValue = 5000;
                                    _priceController..text = finalBuyPrice;
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
                                fontSize: isTab(context) ? 13.sp : 16.sp,
                                fontWeight: FontWeight.w400),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
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
                              prefixIcon: SizedBox(
                                child: Center(
                                  widthFactor: 1.5,
                                  child: Text('Grams:',
                                      style: TextStyle(
                                          fontFamily: 'Signika',
                                          color: tTextSecondary,
                                          fontSize:
                                              isTab(context) ? 13.sp : 16.sp,
                                          fontWeight: FontWeight.w400)),
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
                                  color: tSecondaryColor.withOpacity(0.3),
                                  fontSize: isTab(context) ? 9.sp : 12.sp),
                              // hintText: 'Enter Your Mobile Number',
                              fillColor: tPrimaryTextformfield,
                              contentPadding: EdgeInsets.only(
                                right: 20.w,
                                left: 20,
                                top: 9,
                                bottom: 9,
                              ),
                              filled: true,
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
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   padding: EdgeInsets.symmetric(vertical: 8),
                        //   decoration: BoxDecoration(
                        //       color: tTextformfieldColor,
                        //       borderRadius: BorderRadius.circular(12)),
                        //   child: Center(
                        //     child: Text(
                        //       Secondarycurrency +
                        //           (priceDetails['price_gram_24k'] *
                        //                   _currentSliderValue)
                        //               .toString(),
                        //       // _currentSliderValue.toString(),
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
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "The prices above refresh every 60 seconds to reflect the live gold price.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 5.sp : 8.sp,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     finalBuyValue('', '');
                        //   },
                        //   child: Text("chack"),
                        // ),
                        // SizedBox(
                        //   height: 3.h,
                        // ),
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
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    print('_data.navGoldType>>>>>>>>>>');
                                    print(_data.navGoldType);
                                    goldType = _data.navGoldType;
                                  });
                                  // if (verifStatus) {
                                  if (_formKey.currentState!.validate()) {
                                    var price;
                                    var qty;
                                    setState(() {
                                      var qtyFormate =
                                          num.parse(_qtyController.text)
                                              .toDouble();
                                      var priceFormate =
                                          num.parse(_priceController.text)
                                              .toDouble();
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
                                    widget.loader(true);
                                    // startLoader(true);
                                    // customAlert(
                                    //     context,
                                    //     'Would you like to continue with your purchase?',
                                    //     "Yes",
                                    //     'Do it later', (startLoading, stopLoading,
                                    //         btnState) async {
                                    var amount;
                                    setState(() {
                                      amount = priceDetails['price_gram_24k'] *
                                          _currentSliderValue;
                                    });
                                    var deleteCart =
                                        await OrderAPI().deleteCart(context);
                                    print(deleteCart);
                                    if (deleteCart != null) {
                                      var addTocart = await OrderAPI()
                                          .addToCart(
                                              context,
                                              Buy.toString(),
                                              qty.replaceAll(RegExp('g'), ''),
                                              price.toString().replaceAll(
                                                  RegExp(Secondarycurrency),
                                                  ''),
                                              goldType);
                                      if (addTocart != null &&
                                          addTocart['status'] == 'OK') {
                                        widget.loader(false);
                                        var timeNow = DateTime.now();
                                        sharedPreferences.setString(
                                            "cartCreatedTime",
                                            timeNow.toString());
                                        Twl.navigateTo(
                                            context,
                                            RevivewPaymentDetails(
                                              qty: qty.replaceAll(
                                                  RegExp('g'), ''),
                                              price: price.replaceAll(
                                                  RegExp(Secondarycurrency),
                                                  ''),
                                              type: Buy,
                                              goldType: goldType,
                                              liveGoldPrice: priceDetails[
                                                  'price_gram_24k'],
                                            ));
                                      } else {
                                        widget.loader(false);
                                        // Twl.createAlert(context, "error",
                                        //     addTocart['error']);
                                      }
                                      widget.loader(false);
                                    }
                                    widget.loader(false);
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
                                  }
                                  // stopLoading();
                                  // }

                                  await FirebaseAnalytics.instance.logEvent(
                                    name: "buy_gold",
                                    parameters: {
                                      "price": num.parse(_priceController.text)
                                          .toDouble(),
                                      "qty": num.parse(_qtyController.text)
                                          .toDouble(),
                                      "button_clicked": true,
                                    },
                                  );

                                  Segment.track(
                                    eventName: 'buy_gold',
                                    properties: {
                                      "price": num.parse(_priceController.text)
                                          .toDouble(),
                                      "qty": num.parse(_qtyController.text)
                                          .toDouble(),
                                      "clicked": true
                                    },
                                  );

                                  mixpanel.track('buy_gold', properties: {
                                    "price": num.parse(_priceController.text)
                                        .toDouble(),
                                    "qty": num.parse(_qtyController.text)
                                        .toDouble(),
                                    "button_clicked": true,
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}





// finalBuyValue(qty, goldPrice) async {
//     var mintingvalue = await getMintingvalue(qty, goldPrice);
//     var volatilityvalue = await getvolatilityvalue(qty, goldPrice);
//     print('qty');
//     print(qty);
//     print("goldPrice");
//     print(goldPrice);
//     print('mintingvalue');
//     print(mintingvalue);
//     print('volatilityvalue');
//     print(volatilityvalue);
//     print(qty);
//     for (var i = 0; i <= goldWeigthRange.length - 1; i++) {
//       if (qty >= goldWeigthRange[i]['gold_range_start'] &&
//           qty <= goldWeigthRange[i]['gold_range_end']) {
//         print('Between>>>>>>>');
//         // markupPercentage
//         var markupPercentage = goldWeigthRange[i]['markup_percentage'];

//         // TotalValueBeforeMarkup

//         var TotalValueBeforeMarkup = goldPrice +
//             double.parse(mintingvalue.toString()) +
//             double.parse(volatilityvalue.toString());

//         // FeesMarkup
//         var FeesMarkup =
//             (TotalValueBeforeMarkup) * goldWeigthRange[i]['markup_percentage'];
//         // finalBuyPrice
//         var finalBuyPrice = TotalValueBeforeMarkup + FeesMarkup;
//         print('markupPercentage');
//         print(markupPercentage);
//         print('FeesMarkup');
//         print(FeesMarkup);
//         print('finalBuyPrice');
//         print(finalBuyPrice.toString());
//         // print(roundOffToXDecimal(2.274, numberOfDecimal: 2));
//         setState(() {
//           _priceController
//             ..text =
//                 // Secondarycurrency +
//                 (finalBuyPrice.toStringAsFixed(2)).toString();
//         });
//         print(finalBuyPrice.toStringAsFixed(2));
//         return finalBuyPrice.toStringAsFixed(2);
//       } else {
//         if (qty == '0' || qty == 0) {
//           print('Not between');
//           setState(() {
//             _priceController..text = '0';
//           });
//           return '0';
//         }
//       }
//     }
//   }