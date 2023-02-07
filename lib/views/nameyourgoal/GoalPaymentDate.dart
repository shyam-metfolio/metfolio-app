import 'dart:async';

import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import 'GoalName.dart';

class GoalPaymentDate extends StatefulWidget {
  const GoalPaymentDate({Key? key, this.goalAmount}) : super(key: key);
  final goalAmount;
  @override
  State<GoalPaymentDate> createState() => _EditGoalPaymentDateState();
}

class _EditGoalPaymentDateState extends State<GoalPaymentDate> {
  List<String> _items = [
    "1st of every month",
    "7th of every month",
    "14th of every month",
    "28th of every month",
  ];

  List<DropdownMenuItem<String>> months = [
    DropdownMenuItem(
        child: Text("1st of every month"), value: "1st of every month"),
    DropdownMenuItem(
        child: Text("7th of every month"), value: "7th of every month"),
    DropdownMenuItem(
        child: Text("14th  of every month"), value: "14th of every month"),
    DropdownMenuItem(
        child: Text("28th of every month"), value: "28th of every month"),
  ];

  String selectedDate = '1st of every month';
  bool isExpanded = false;
  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'Select your payment date ',
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
                      'Use the drop down menu to select',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 7.sp : 12.sp,
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!isExpanded) {
                            isExpanded = true;
                          } else {
                            isExpanded = false;
                          }
                        });
                      },
                      child: Container(
                        // height: 5.5.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: tPrimaryTextformfield,
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate != ''
                                  ? selectedDate
                                  : 'Select your date',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: selectedDate == ''
                                    ? tSecondaryColor.withOpacity(0.3)
                                    : tSecondaryColor,
                                fontSize: isTab(context) ? 9.sp : 12.sp,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Image.asset(
                                Images.EXPANDMORE,
                                scale: 3.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    if (isExpanded)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: tPrimaryTextformfield,
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.only(bottom: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(
                              _items.length,
                              (index) => Container(
                                height: 30,
                                child: ListTile(
                                  onTap: () {
                                    setState(() {
                                      selectedDate = _items[index];
                                      isExpanded = false;
                                    });
                                  },
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  title: Text(
                                    _items[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 9.sp : 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    SizedBox(height: 2.5.h),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80.w,
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Text(
                          'Your money will be converted into gold on this day of every month, and added to your balance',
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 7.sp : 12.sp,
                          ),
                          textAlign: TextAlign.center,
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
                  if (selectedDate != '') {
                    Twl.navigateTo(
                        context,
                        GoalName(
                            goalDate: selectedDate,
                            goalAmount: widget.goalAmount));
                  } else {
                    // Twl.createAlert(
                    //     context, 'error', 'select your Goal payment date.');
                  }
                }),
          )
        ],
      ),
    );
  }
}
