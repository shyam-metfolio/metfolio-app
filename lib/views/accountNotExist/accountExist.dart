import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../logiPage/loginPage.dart';

class AccountExists extends StatefulWidget {
  const AccountExists({Key? key}) : super(key: key);

  @override
  State<AccountExists> createState() => _AccountExistsState();
}

var btnColor = tIndicatorColor;
var selectedvalue;

class _AccountExistsState extends State<AccountExists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tWhite,
        leading: GestureDetector(
          // change the back button shadow
          onTap: () {
            Twl.navigateBack(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 18, top: 10, bottom: 10),
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Text(
                      "There is already an account\nassociated with this number",
                      style: TextStyle(
                          fontFamily: 'Signika',
                          color: tPrimaryColor,
                          fontSize: isTab(context) ? 18.sp : 21.sp,
                          fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Center(
                    child: Text(
                      'Click continue to log in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),
                  Image.asset(
                    Images.ACCOUNTEXISTS,
                    scale: 4,
                  )
                ],
              )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Button(
                  borderSide: BorderSide(
                    color: tPrimaryColor,
                  ),
                  color: tPrimaryColor,
                  textcolor: tWhite,
                  bottonText: 'Continue',
                  onTap: (startLoading, stopLoading, btnState) async {
                    Twl.navigateTo(context, LoginMobileNumber1());
                  }),
            ),
            SizedBox(
              height: 2.h,
            )
          ],
        ),
      ),
    );
  }
}
