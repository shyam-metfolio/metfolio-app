import 'dart:async';

import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../components/alertPage.dart';
import 'GoalPaymentDate.dart';

class GoalAmount extends StatefulWidget {
  const GoalAmount({Key? key}) : super(key: key);

  @override
  State<GoalAmount> createState() => _EditGoalAmountState();
}

class _EditGoalAmountState extends State<GoalAmount> {
  createGoalAction() {
    return customAlert(
        context,
        'Continue creating your Goal?',
        "Yes",
        'Do it later',
        (Images.NEWGOAL), (startLoading, stopLoading, btnState) async {
      //startLoading();
      Twl.navigateBack(context);
      stopLoading();
    });
  }

  final _formKey = new GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _amountController..text = _currentSliderValue.toStringAsFixed(0);
  }

  double _currentSliderValue = 1.0;
  double goalAmount = 1.0;
  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return createGoalAction();
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (de) {
          return createGoalAction();
        },
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: tWhite,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: tWhite,
            leading: GestureDetector(
              // change backbutton
              onTap: () {
                createGoalAction();
                // Twl.navigateBack(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Decide your amount ',
                              style: TextStyle(
                                color: tPrimaryColor,
                                fontFamily: "Signika",
                                fontSize: isTab(context) ? 18.sp : 21.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Type or use the slider',
                            style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 7.sp : 12.sp,
                            ),
                          ),
                          SizedBox(height: 2.5.h),
                          TwlNormalTextField(
                            errorBorder: new OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: Colors.red, width: 1),
                            ),
                            validator: (v) {
                              // validateDecideGoal(v);
                              if (v!.isEmpty || double.parse(v) < 1.0) {
                                return "";
                                // return "Postcode can't be empty";
                              }
                              return null;
                            },
                            prefixText: 'GBP ($Secondarycurrency):',
                            inputForamtters: [
                              FilteringTextInputFormatter.deny(
                                RegExp(
                                    r'^0'), //users can't type 0 at 1st position
                              ),
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]+[.]{0,1}[0-9]*'),
                              ),
                              LengthLimitingTextFieldFormatterFixed(5000),
                              DecimalTextInputFormatter(decimalRange: 2)
                            ],
                            textInputType:
                                TextInputType.numberWithOptions(decimal: true),
                            contentPadding: EdgeInsets.only(
                              right: 15.w,
                              left: 20,
                              top: 2,
                              bottom: 2,
                            ),
                            prefixStyle: TextStyle(
                                fontFamily: 'Signika',
                                color: tTextSecondary,
                                fontSize: isTab(context) ? 12.sp : 13.sp,
                                fontWeight: FontWeight.w400),
                            controller: _amountController,
                            // intialValue: 'value',
                            onchnage: (v) {
                              // print(v);
                              if (double.parse(
                                      v.replaceAll(Secondarycurrency, '')) >=
                                  0) {
                                print("sddscd");
                                setState(
                                  () {
                                    if (double.parse(v.replaceAll(
                                            Secondarycurrency.toString(),
                                            '')) <=
                                        1000) {
                                      print(v);
                                      var price =
                                          double.parse((v)).toStringAsFixed(0);
                                      if (int.parse(price) >= 10) {
                                        _currentSliderValue =
                                            double.parse((price)) / 10;
                                      } else {
                                        _currentSliderValue =
                                            double.parse((price));
                                      }

                                      // // .replaceAll(Secondarycurrency, '')
                                      // print('_currentSliderValue' +
                                      //     _currentSliderValue.toString());
                                    }

                                    goalAmount = double.parse(
                                        v.replaceAll(Secondarycurrency, ''));
                                  },
                                );
                                // } else {
                                // setState(() {
                                //   goalAmount = double.parse(
                                //       v.replaceAll(Secondarycurrency, ''));
                                // });
                                // Twl.createAlert(context, 'error',
                                //     "you can set your goal amount more then 5000");
                              }
                            },

                            // textInputType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 12.sp : 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.5.h),
                          Container(
                            width: double.infinity,
                            child: CupertinoSlider(
                              thumbColor: tTextSecondary,
                              activeColor: tTextSecondary,
                              divisions: 99,
                              max: 100,
                              min: 1,
                              value: _currentSliderValue,
                              onChanged: (value) async {
                                // var goldPrice = value * priceDetails['price_gram_24k'];
                                // var finalBuyPrice = await finalBuyValue(
                                //     roundDouble(value, 3), goldPrice);
                                if (value >= 2) {
                                  setState(
                                    () {
                                      _currentSliderValue = value;
                                      goalAmount = (value * 10);
                                      _amountController
                                        ..text =
                                            // Secondarycurrency +
                                            (_currentSliderValue * 10)
                                                .toStringAsFixed(2);
                                    },
                                  );
                                } else {
                                  setState(
                                    () {
                                      _currentSliderValue = value;
                                      goalAmount = value;
                                      _amountController
                                        ..text =
                                            // Secondarycurrency +
                                            (_currentSliderValue)
                                                .toStringAsFixed(2);
                                    },
                                  );
                                }

                                // _currentSliderValue = roundDouble(value, 3);
                                // _qtyController
                                //   ..text = roundDouble(value, 3).toString() + 'g';
                                // _priceController
                                //   ..text = Secondarycurrency +
                                //       (finalBuyPrice).toString();
                              },
                            ),
                          ),
                          SizedBox(height: 2.5.h),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Text(
                                'Choose any amount over £1 to be converted into gold every month',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: tSecondaryColor,
                                  fontSize: isTab(context) ? 7.sp : 12.sp,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 3.h),
                  child: Button(
                    borderSide: BorderSide.none,
                    color: tPrimaryColor,
                    textcolor: tWhite,
                    bottonText: 'Continue',
                    onTap: (startLoading, stopLoading, btnState) async {
                      // var amount = goalAmount;
                      print(goalAmount);
                      if (_formKey.currentState!.validate()) {
                        if (goalAmount != null && goalAmount != 0
                            // &&
                            // goalAmount <= 5000
                            ) {
                          print(goalAmount);
                          Twl.navigateTo(
                            context,
                            GoalPaymentDate(
                                goalAmount: goalAmount.toStringAsFixed(2)),
                          );
                        } else {
                          // if (goalAmount == 0) {
                          //   Twl.createAlert(
                          //       context, 'error', 'Drag your goal amount');
                          // } else {
                          //   Twl.createAlert(context, 'error',
                          //       "you can set your goal amount more then 5000");
                          // }
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateDecideGoal(String? value) {
    if (value!.isEmpty || double.parse(value) > 1.0) {
      return "scdasd";
      // return "Postcode can't be empty";
    }
    return null;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;
      print("value" + value + "value");
      print(value.substring(value.indexOf(".") + 1).length > decimalRange);
      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;

        // return TextEditingValue(
        //   text: truncated,
        //   selection: newSelection,
        //   composing: TextRange.empty,
        // );

        if (num.parse(truncated).toDouble() == 0) {
          print("statement11");
          return TextEditingValue(
            text: truncated,
            selection: newSelection,
            composing: TextRange.empty,
          );
        } else {
          print("statement12");
          return TextEditingValue(
            text: num.parse(truncated).toDouble().toString(),
            selection: newSelection,
            composing: TextRange.empty,
          );
        }

        //  &&
        //   double.parse(value) <= 5000
      } else if (value == ".") {
        print("statement21");
        truncated = "0.";
        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );

        // var split = truncated.split('.');
        // print("narsa" + split.toString());
        // if (split[1] == '') {
        return TextEditingValue(
          text: truncated,
          selection: newSelection,
          composing: TextRange.empty,
        );
        // } else {
        //   return TextEditingValue(
        //     text: num.parse(truncated).toDouble().toString(),
        //     selection: newSelection,
        //     composing: TextRange.empty,
        //   );
        // }
      } else {
        if (value == '') {
          print("statement31");
          // return TextEditingValue(
          //   text: truncated,
          //   selection: newSelection,
          //   composing: TextRange.empty,
          // );
        } else {
          print("statement32");
          if (value.contains('.')) {
            var split = truncated.split('.');
            print("statement32" + split.toString());
            if (split[1] == '') {
              print("statement321");
              return TextEditingValue(
                text: truncated,
                selection: newSelection,
                composing: TextRange.empty,
              );
            } else {
              print("statement322");
              return TextEditingValue(
                text: truncated,
                //  num.parse(truncated).toDouble().toString(),
                selection: newSelection,
                composing: TextRange.empty,
              );
            }
          } else {
            return TextEditingValue(
              text: num.parse(truncated).toInt().toString(),
              selection: newSelection,
              composing: TextRange.empty,
            );
          }
        }
      }

      // if (truncated.contains('.')) {
      //   var split = truncated.split('.');
      //   print("narsa" + split.toString());
      //   if (split[1] == '') {
      //     return TextEditingValue(
      //       text: truncated,
      //       selection: newSelection,
      //       composing: TextRange.empty,
      //     );
      //   } else {
      //     return TextEditingValue(
      //       text: num.parse(truncated).toDouble().toString(),
      //       selection: newSelection,
      //       composing: TextRange.empty,
      //     );
      //   }
      // } else if (num.parse(truncated).toDouble() == 0) {
      //   return TextEditingValue(
      //     text: num.parse(truncated).toInt().toString(),
      //     selection: newSelection,
      //     composing: TextRange.empty,
      //   );
      // } else {
      //   return TextEditingValue(
      //     text: num.parse(truncated).toInt().toString(),
      //     selection: newSelection,
      //     composing: TextRange.empty,
      //   );
      // }

    }
    return newValue;
  }
}

class LengthLimitingTextFieldFormatterFixed
    extends LengthLimitingTextInputFormatter {
  LengthLimitingTextFieldFormatterFixed(int maxLength) : super(maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.contains(RegExp(r'[0-9]+[.]{0,1}[0-9]*'))) {
      if (maxLength != null &&
          maxLength! > 0 &&
          double.parse(newValue.text) > maxLength!) {
        // If already at the maximum and tried to enter even more, keep the old value.
        if (oldValue.text.characters.length == maxLength) {
          return oldValue;
        }

        // ignore: invalid_use_of_visible_for_testing_member
        // return LengthLimitingTextInputFormatter.truncate(newValue, maxLength!);
        return oldValue;
      }
    }
    return newValue;
    // return newValue;
  }
}
