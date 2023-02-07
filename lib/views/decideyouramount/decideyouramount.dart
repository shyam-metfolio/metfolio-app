import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/button.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/chooseyourfrequency/chooseyourfrequency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/imageConstant.dart';


class DecideYourPayment extends StatefulWidget {
  const DecideYourPayment({Key? key}) : super(key: key);

  @override
  State<DecideYourPayment> createState() => _DecideYourPaymentState();
}

class _DecideYourPaymentState extends State<DecideYourPayment> {
  double _currentSliderValue = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: tWhite,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Twl.navigateBack(context);
      //     },
      //     child: Image.asset(
      //       Images.NAVBACK,
      //       scale: 3.5,
      //     ),
      //   ),
      // ),
      body: Form(
        // key: ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 6.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: GestureDetector(
                onTap: () {
                  Twl.navigateBack(context);
                },
                child: Image.asset(
                  Images.NAVBACK,
                  scale: 4,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 1.2.h,
                      ),
                      Text(
                        'Decide your amount',
                        style: TextStyle(
                            fontFamily: "Signika",
                            color: tPrimaryColor,
                            fontSize: isTab(context) ? 18.sp : 21.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 3.2.h,
                      ),
                      Text(
                        'Type or use the slider',
                        style: TextStyle(
                            color: tText,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 2.9.h,
                      ),
                      Text(
                        'Quantity',
                        style: TextStyle(
                            fontFamily: "Signika",
                            color: tTextSecondary,
                            fontSize: isTab(context) ? 15.sp : 16.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 3.7.h,
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 53),
                        padding: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: tTextformfieldColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            Secondarycurrency + _currentSliderValue.toString(),
                            style: TextStyle(
                                color: tTextSecondary,
                                fontSize: isTab(context) ? 15.sp : 16.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3.9.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        width: double.infinity,
                        child: CupertinoSlider(
                            thumbColor: tTextSecondary,
                            activeColor: tTextSecondary,
                            divisions: 5,
                            max: 100.0,
                            value: _currentSliderValue,
                            onChanged: (value) {
                              setState(() {
                                _currentSliderValue = value;
                              });
                            }),
                      ),
                      SizedBox(
                        height: 6.1.h,
                      ),
                      Text(
                        'This amount will be converted into gold every\n month and go towards your goal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: tText,
                            fontSize: isTab(context) ? 10.sp : 12.sp),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.center,
                child: Button(
                    borderSide: BorderSide(
                      color: tPrimaryColor,
                    ),
                    color: tPrimaryColor,
                    textcolor: tWhite,
                    bottonText: 'Continue',
                    onTap: (startLoading, stopLoading, btnState) async {
                      
                      Twl.navigateTo(context, ChooseYourFrequency());
                    }),
              ),
            ),
            SizedBox(
              height: 1.5.h,
            )
          ],
        ),
      ),
    );
  }
  String? validateDecideGoal(String? value) {
    if (value!.isEmpty || int.parse(value) < 1.0) {
      return "";
      // return "Postcode can't be empty";
    }
    return null;
  }
}
