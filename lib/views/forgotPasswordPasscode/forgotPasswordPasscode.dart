// ignore_for_file: unused_field, override_on_non_overriding_member

import 'dart:async';
import 'dart:math';

import 'package:base_project_flutter/globalWidgets/button.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';

import '../keypad/keypad.dart';

class ForgotPasswordPasscode extends StatefulWidget {
  const ForgotPasswordPasscode({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPasscode> createState() => _ForgotPasswordPasscodeState();
}

class _ForgotPasswordPasscodeState extends State<ForgotPasswordPasscode> {
  @override
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  late String displayCode;
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayCode = getNextCode();
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  bool hasError = false;
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
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Passcode lock",
                    style: TextStyle(
                        fontFamily: 'signika',
                        color: tPrimaryColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500
                        // fontFamily: AppTextStyle.robotoBold
                        ),
                  ),
                ),
                SizedBox(height: 60),
                Center(
                  child: Text(
                    "Enter New Passcode",
                    style: TextStyle(
                        fontFamily: 'Signika',
                        color: tSecondaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400
                        // fontFamily: AppTextStyle.robotoBold
                        ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 70,
                  ),
                  child: PinCodeTextField(
                    //backgroundColor: Colors.white,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    obscureText: false,
                    obscuringCharacter: '*',

                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v!.length < 4 || v.length == 0) {
                        return "Otp length did not match";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      activeColor: hasError ? Colors.red : tlightGrayblue,
                      selectedColor: hasError ? Colors.red : tlightGrayblue,
                      selectedFillColor: tlightGrayblue,
                      inactiveFillColor: tlightGrayblue,
                      inactiveColor: hasError ? Colors.red : tlightGrayblue,
                      borderRadius: BorderRadius.circular(12),
                      borderWidth: 0,
                      fieldHeight: isTab(context) ? 10.w : 13.w,
                      fieldWidth: isTab(context) ? 10.w : 12.w,
                      activeFillColor: tlightGrayblue,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    //errorAnimationController: errorController,
                    controller: pinController,
                    keyboardType: TextInputType.none,
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
                ),
                KeyPad(
                  pinController: pinController,
                  isPinLogin: false,
                  onChange: (String pin) {
                    pinController.text = pin;
                    print('${pinController.text}');
                    setState(() {});
                  },
                  onSubmit: (String pin) {
                    print('object');
                    if (pin.length != 4) {
                      (pin.length == 0)
                          ? showInSnackBar('Please Enter Pin')
                          : showInSnackBar('Wrong Pin');
                      return;
                    } else {
                      pinController.text = pin;

                      if (pinController.text == displayCode) {
                        showInSnackBar('Pin Match');
                        setState(() {
                          displayCode = getNextCode();
                        });
                      } else {
                        showInSnackBar('Wrong pin');
                      }
                      print('Pin is ${pinController.text}');
                    }
                  },
                ),
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
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
                        // if(_formKey.currentState!.validate()){

                        // }
                        Twl.navigateTo(context, BottomNavigation());
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          ),
        ));
  }

  void showInSnackBar(String value) {
    print('error' + value);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(new SnackBar(content: new Text(value)));
  }

  getNextCode() {
    pinController.text = '';
    var rng = new Random();
    var code = (rng.nextInt(9000) + 1000).toString();
    print('Random No is : $code');
    return code;
  }
}
