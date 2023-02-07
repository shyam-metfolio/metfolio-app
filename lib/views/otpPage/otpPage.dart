import 'dart:async';

import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/PersonalDetails/PersonalDetails.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/forgotPasswordPasscode/forgotPasswordPasscode.dart';
import 'package:base_project_flutter/views/passCodePage/lockScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../profilePage/profileNewPassCode.dart';

class PassCodeOtp extends StatefulWidget {
  const PassCodeOtp({Key? key, this.isDisableBack}) : super(key: key);
  final isDisableBack;
  @override
  State<PassCodeOtp> createState() => _DigitCodeState();
}

class _DigitCodeState extends State<PassCodeOtp> {
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  // late String username;
  // bool hasError = false;
  late String otpCode;

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  var sessionId;
  // var username = '';
  var authCode;
  late SharedPreferences sharedPreferences;
  bool hasError = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    sendOtp('');
  }

  var res;
  var userName = '';
  sendOtp(type) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("userName").toString();
    });
    var res = await UserAPI.sendOtp(context, userName);
    print(res);
    print(userName);
    if (res != null && res['status'] == 'OK') {
      if (type == 1) Twl.navigateTo(context, PassCodeOtp());
    } else {
      // Twl.createAlert(context, 'error', res['error']);
    }
  }

  x() async {
    // if (_formKey.currentState!.validate() && widget.index == 2) {

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      // //startLoading();
      otpCode = _otpCodeController.text;
      print(otpCode);
      print('here');
      FocusScope.of(context).requestFocus(new FocusNode());
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

      var res = await UserAPI().verifyPasscodeOtp(context, userName, otpCode);
      print(res);

      if (res != null && res['status'] == 'OK') {
        setState(() {
          isLoading = false;
        });
        Twl.navigateTo(context, ProfileNewPasscode());
      } else {
        setState(() {
          isLoading = false;
        });

        displayDialog(
          context,
          'error',
          res['error'],
        );
      }
      // stopLoading();
    }
    // else if (_formKey.currentState!.validate() &&
    //     widget.index == 1) {
    else {
      setState(() {
        isLoading = false;
        hasError = true;
      });

      // Twl.navigateTo(context, ForgotPasswordPasscode());
    }
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: tWhite,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: tWhite,
              leading: GestureDetector(
                // change the back button shadow
                onTap: () {
                  if (widget.isDisableBack == null) {
                    Twl.navigateBack(context);
                  }
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
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 25, top: 0, bottom: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("6-digit code",
                                      style: TextStyle(
                                          fontFamily: 'Signika',
                                          color: tPrimaryColor,
                                          fontSize:
                                              isTab(context) ? 18.sp : 21.sp,
                                          fontWeight: FontWeight.w700)),
                                  SizedBox(height: 25),
                                  Text(
                                      "Please enter the one time password we sent to your number ending with *********${(userName.substring(userName.length - (2)))}",
                                      style: TextStyle(
                                          color: tSecondaryColor,
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp,
                                          fontWeight: FontWeight.w400)),
                                  SizedBox(height: 40),
                                  PinCodeTextField(
                                    //backgroundColor: Colors.white,
                                    appContext: context,
                                    pastedTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    length: 6,
                                    obscureText: false,
                                    obscuringCharacter: '*',

                                    // blinkWhenObscuring: true,
                                    // obscureText: false,
                                    // obscuringCharacter: '*',

                                    // blinkWhenObscuring: true,
                                    animationType: AnimationType.fade,
                                    validator: (v) {
                                      if (v!.length < 6 || v.length == 0) {
                                        return "";
                                        // return "Otp length did not match";
                                      } else {
                                        return null;
                                      }
                                    },
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      activeColor: hasError
                                          ? Colors.red
                                          : tlightGrayblue,
                                      selectedColor: hasError
                                          ? Colors.red
                                          : tlightGrayblue,
                                      selectedFillColor: tlightGrayblue,
                                      inactiveFillColor: tlightGrayblue,
                                      inactiveColor: hasError
                                          ? Colors.red
                                          : tlightGrayblue,
                                      borderRadius: BorderRadius.circular(15),
                                      borderWidth: 1,
                                      fieldHeight: isTab(context) ? 10.w : 13.w,
                                      fieldWidth: isTab(context) ? 9.w : 12.w,
                                      activeFillColor: tlightGrayblue,
                                    ),
                                    cursorColor: tlightGrayblue,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    enableActiveFill: true,
                                    //errorAnimationController: errorController,
                                    controller: _otpCodeController,
                                    keyboardType: TextInputType.number,
                                    // boxShadows: [tBoxShadow],
                                    onCompleted: (v) {
                                      print("Completed");
                                    },
                                    onTap: () {
                                      print("Pressed");
                                    },
                                    onChanged: (value) {
                                      print(value);
                                      // setState(() {
                                      //   currentText = value;
                                      // });
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");

                                      return true;
                                    },
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    decoration: BoxDecoration(
                                        // color: tSecondaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: ArgonTimerButton(
                                        initialTimer: 30,
                                        elevation: 0,
                                        height: isTab(context) ? 50 : 30,
                                        width: isTab(context) ? (100.w) : 100.w,
                                        borderRadius: isTab(context) ? 90 : 30,
                                        color: tWhite,
                                        minWidth: 100.w,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Re-send verification code',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: tSecondaryColor,
                                                    fontSize: isTab(context)
                                                        ? 9.sp
                                                        : 12.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ],
                                        ),
                                        loader: (timeLeft) {
                                          return Text(
                                            "Re-send verification code $timeLeft",
                                            style: TextStyle(
                                                color: tSecondaryColor,
                                                fontSize: isTab(context)
                                                    ? 9.sp
                                                    : 12.sp,
                                                fontWeight: FontWeight.normal),
                                          );
                                        },
                                        onTap: (startTimer, btnState) async {
                                          sendOtp(1);
                                        }),
                                  ),
                                  // GestureDetector(
                                  //   onTap: (() => {sendOtp()}),
                                  //   child: Center(
                                  //     child: Text(
                                  //       "Re-send verification code",
                                  //       style: TextStyle(
                                  //           color: tSecondaryColor,
                                  //           fontSize: isTab(context) ? 14.sp : 16.sp,
                                  //           fontWeight: FontWeight.w400),
                                  //       textAlign: TextAlign.center,
                                  //     ),
                                  //   ),
                                  // )
                                ]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                            onPressed: x,
                          ),
                        ),
                      ),
                      SizedBox(height: 20)
                    ]),
              ),
            )),
        if (isLoading)
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
}
