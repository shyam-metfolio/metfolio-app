import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../Splash2/Splash2.dart';
import '../loginPassCodePages/mobileNumber.dart';

class AccountNotExist extends StatefulWidget {
  const AccountNotExist({Key? key}) : super(key: key);

  @override
  State<AccountNotExist> createState() => _NoAccountScreenState();
}

class _NoAccountScreenState extends State<AccountNotExist> {
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
          // change the back button shadow
          onTap: () {
            Twl.navigateTo(context, MyHomePage());
            // Twl.navigateBack(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'There is no account associated\nwith this phone number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Signika',
                          color: tPrimaryColor,
                          fontSize: isTab(context) ? 17.sp : 20.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Center(
                      child: Text(
                        'Not to worry, just sign up for an account below, and\nyou’ll be up and running in no time!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    Image.asset(
                      Images.GOLDS,
                      scale: 4,
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Button(
                  borderSide: BorderSide(
                    color: tPrimaryColor,
                  ),
                  color: tPrimaryColor,
                  textcolor: tWhite,
                  bottonText: 'Sign up',
                  onTap: (startLoading, stopLoading, btnState) async {
                    Twl.navigateTo(context, LoginMobileNumber());
                  }),
            ),
            SizedBox(
              height: 1.h,
            )
          ],
        ),
      ),
    );
  }
}
