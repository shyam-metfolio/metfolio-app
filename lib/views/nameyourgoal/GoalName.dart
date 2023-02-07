import 'dart:async';

import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:base_project_flutter/views/profilePage/profilepaymentDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/orderApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../components/alertPage.dart';
import '../paymentMethods/paymentMethod.dart';
import '../successfullPage/PurchesedConfirmSucessfull.dart';
import '../successfullPage/thanksForStaetingGoalSucessfull.dart';

class UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: capitalizeAllWordsInFullSentence(newValue.text),
        selection: newValue.selection);
  }
}

String capitalizeAllWordsInFullSentence(String str) {
  int i;
  String constructedString = "";
  for (i = 0; i < str.length; i++) {
    if (i == 0) {
      constructedString += str[0].toUpperCase();
    } else if (str[i - 1] == ' ') {
      // mandatory to have index>1 !
      constructedString += str[i].toUpperCase();
    } else {
      constructedString += str[i];
    }
  }
  // print('constructed: $constructedString');
  return constructedString;
}

class GoalName extends StatefulWidget {
  const GoalName({Key? key, this.goalDate, this.goalAmount}) : super(key: key);
  final goalDate;
  final goalAmount;
  @override
  State<GoalName> createState() => _EditGoalNameState();
}

class _EditGoalNameState extends State<GoalName> {
  TextEditingController _editGoalNameController = TextEditingController();
  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: tWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: tWhite,
          leading: GestureDetector(
            onTap: () {
              // createGoalAction();
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Name your Goal',
                          style: TextStyle(
                            color: tPrimaryColor,
                            fontFamily: "Signika",
                            fontSize: isTab(context) ? 18.sp : 21.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'Personalise your goal with something meaningful!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 7.sp : 12.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 2.5.h),
                      TwlNormalTextField(
                        textCapitalization: TextCapitalization.words,
                        inputForamtters: [UpperCaseFormatter()],
                        // inputForamtters: [LengthLimitingTextInputFormatter(10)],
                        maxlength: 10,
                        controller: _editGoalNameController,
                      ),
                      SizedBox(height: 2.5.h),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: tSecondaryColor,
                        ),
                        onPressed: () async {
                          var goalName;
                          var amount;
                          var date;
                          setState(() {
                            goalName = _editGoalNameController.text;
                            amount = widget.goalAmount.toString();
                            date = widget.goalDate;
                          });
                          Twl.navigateTo(
                              context,
                              GoalSummary(
                                  goalName: 'My Goal',
                                  goalAmount: amount,
                                  goalDate: date));
                          // var res = await OrderAPI()
                          //     .addGoal(context, 'My goal', amount, date);
                          // if (res != null && res['status'] == 'OK') {
                          //   Twl.navigateTo(
                          //       context, ThanksForStartingGoalSucessful());
                          //   // Twl.navigateTo(context, PaymentDetails());
                          // } else {
                          //   Twl.createAlert(context, 'error', res['error']);
                          // }
                        },
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 3.h),
              child: Button(
                  borderSide: BorderSide.none,
                  color: tPrimaryColor,
                  textcolor: tWhite,
                  bottonText: 'Continue',
                  onTap: (startLoading, stopLoading, btnState) async {
                    // if (_formKey.currentState!.validate() &&
                    //     monthsSelectedValue != null) {
                    var goalName;
                    var amount;
                    var date;
                    setState(() {
                      goalName = _editGoalNameController.text;
                      amount = widget.goalAmount.toString();
                      date = widget.goalDate;
                    });
                    Twl.navigateTo(
                        context,
                        GoalSummary(
                            goalName: goalName,
                            goalAmount: amount,
                            goalDate: date));
                    // Twl.navigateTo(
                    //     context,
                    //     ProfilePaymentDetails(
                    //         goalName: goalName, amount: amount, date: date));

                    // //startLoading();
                    // var goalName;
                    // var amount;
                    // var date;
                    // setState(() {
                    //   goalName = _editGoalNameController.text;
                    //   amount = widget.goalAmount.toString();
                    //   date = widget.goalDate;
                    // });
                    // var res = await OrderAPI()
                    //     .addGoal(context, goalName, amount, date);
                    // if (res != null && res['status'] == 'OK') {
                    //   stopLoading();
                    //   Twl.navigateTo(context, ThanksForStartingGoalSucessful());
                    //   // Twl.navigateTo(context, PaymentDetails());
                    // } else {
                    //   stopLoading();
                    //   Twl.createAlert(context, 'error', res['error']);
                    // }
                    // stopLoading();

                    // } else {
                    //   if (monthsSelectedValue == null) {
                    //     Twl.createAlert(context, 'warning', 'select your day');
                    //   }
                    // }
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class GoalSummary extends StatefulWidget {
  GoalSummary({Key? key, this.goalName, this.goalAmount, this.goalDate})
      : super(key: key);
  final goalName;
  final goalAmount;
  final goalDate;
  @override
  State<GoalSummary> createState() => _GoalSummaryState();
}

var btnColor = tIndicatorColor;
var selectedvalue;

class _GoalSummaryState extends State<GoalSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tWhite,
        leading: GestureDetector(
          onTap: () {
            // createGoalAction();
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Goal Summary',
                        style: TextStyle(
                          color: tPrimaryColor,
                          fontFamily: "Signika",
                          fontSize: isTab(context) ? 18.sp : 21.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Center(
                      child: Text(
                        'Please confirm your details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 7.sp : 12.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Goal Name',
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 7.sp : 12.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: tPrimaryTextformfield,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10.w),
                          child: Text(
                            widget.goalName != '' ? widget.goalName : 'My Goal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Monthly amount',
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 7.sp : 12.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: tPrimaryTextformfield,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10.w),
                          child: Text(
                            Secondarycurrency + ' ' + widget.goalAmount,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Payment Date',
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 7.sp : 12.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: tPrimaryTextformfield,
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10.w),
                          child: Text(
                            widget.goalDate,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // TwlNormalTextField(
                    //   controller: _editGoalNameController,
                    // ),
                    SizedBox(height: 2.5.h),
                    // TextButton(
                    //   style: TextButton.styleFrom(
                    //     primary: tSecondaryColor,
                    //   ),
                    //   onPressed: () async {
                    //     var goalName;
                    //     var amount;
                    //     var date;
                    //     setState(() {
                    //       goalName = widget.goalName;
                    //       amount = widget.goalAmount;
                    //       date = widget.goalDate;
                    //     });
                    //     Twl.navigateTo(
                    //         context,
                    //         ProfilePaymentDetails(
                    //             goalName: 'My goal',
                    //             amount: amount,
                    //             date: date));
                    //     // var res = await OrderAPI()
                    //     //     .addGoal(context, 'My goal', amount, date);
                    //     // if (res != null && res['status'] == 'OK') {
                    //     //   Twl.navigateTo(
                    //     //       context, ThanksForStartingGoalSucessful());
                    //     //   // Twl.navigateTo(context, PaymentDetails());
                    //     // } else {
                    //     //   Twl.createAlert(context, 'error', res['error']);
                    //     // }
                    //   },
                    //   child: Text(
                    //     'Skip for now',
                    //     style: TextStyle(
                    //       fontSize: isTab(context) ? 10.sp : 12.sp,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 3.h),
            child: Button(
                borderSide: BorderSide.none,
                color: tPrimaryColor,
                textcolor: tWhite,
                bottonText: 'Confirm',
                onTap: (startLoading, stopLoading, btnState) async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();

                  // if (_formKey.currentState!.validate() &&
                  //     monthsSelectedValue != null) {
                  var goalName;
                  var amount;
                  var date;
                  setState(() {
                    goalName =
                        widget.goalName != '' ? widget.goalName : 'My Goal';
                    amount = widget.goalAmount;
                    date = widget.goalDate;
                    sharedPreferences.setString("goalName", goalName);
                    sharedPreferences.setString("goalAmount", amount);
                    sharedPreferences.setString("goalDate", date);
                  });
                  Twl.navigateTo(
                      context,
                      PaymentMethodPage(
                        amount: amount,
                        type: myGoal,
                        payment: "",
                      ));
                  // Twl.navigateTo(
                  //     context,
                  //     ProfilePaymentDetails(
                  //         goalName: widget.goalName != '' ? widget.goalName : 'myGoal', amount: amount, date: date));
                  // //startLoading();
                  // var goalName;
                  // var amount;
                  // var date;
                  // setState(() {
                  //   goalName = _editGoalNameController.text;
                  //   amount = widget.goalAmount.toString();
                  //   date = widget.goalDate;
                  // });
                  // var res = await OrderAPI()
                  //     .addGoal(context, goalName, amount, date);
                  // if (res != null && res['status'] == 'OK') {
                  //   stopLoading();
                  //   Twl.navigateTo(context, ThanksForStartingGoalSucessful());
                  //   // Twl.navigateTo(context, PaymentDetails());
                  // } else {
                  //   stopLoading();
                  //   Twl.createAlert(context, 'error', res['error']);
                  // }
                  // stopLoading();

                  // } else {
                  //   if (monthsSelectedValue == null) {
                  //     Twl.createAlert(context, 'warning', 'select your day');
                  //   }
                  // }
                }),
          )
        ],
      ),
    );
  }
}

extension CapExtension on String {
  String capitalizeSentence() {
    // Each sentence becomes an array element
    var sentences = this.split('.');
    // Initialize string as empty string
    var output = '';
    // Loop through each sentence
    for (var sen in sentences) {
      // Trim leading and trailing whitespace
      var trimmed = sen.trim();
      // Capitalize first letter of current sentence
      var capitalized = "${trimmed[0].toUpperCase() + trimmed.substring(1)}";
      // Add current sentence to output with a period
      output += capitalized + ". ";
    }
    return output;
  }
}

class CapitalCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.capitalizeSentence.toString(),
      selection: newValue.selection,
    );
  }
}
