// ignore_for_file: unused_field

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';

import '../keypad/keypad.dart';

class ChangePassCode extends StatefulWidget {
  const ChangePassCode({Key? key}) : super(key: key);

  @override
  State<ChangePassCode> createState() => _ChangePassCodeState();
}

class _ChangePassCodeState extends State<ChangePassCode> {
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  late String displayCode;
  TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tWhite,
        centerTitle: true,
        elevation: 1,
        // title: Text("Profile"),
        // actions: [
        //   Padding(
        //       padding: EdgeInsets.all(15),
        //       child: Image.asset("assets/icons/appbar_notification.png"))
        // ],
        leading: IconButton(
            onPressed: () {
              Twl.navigateBack(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: tPrimaryColor)),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Passcode Lock",
                style: TextStyle(
                    color: tPrimaryColor,
                    fontSize: 23.sp,
                    fontWeight: FontWeight.w500
                    // fontFamily: AppTextStyle.robotoBold
                    ),
              ),
              Spacer(),
              Text(
                "Enter your original passcode",
                style: TextStyle(
                    color: tSecondaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400
                    // fontFamily: AppTextStyle.robotoBold
                    ),
              ),
              SizedBox(height: 30),
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
                  obscureText: true,
                  // obscuringCharacter: '*',

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
                    activeColor: tlightGrayblue,
                    selectedColor: tlightGrayblue,
                    selectedFillColor: tlightGrayblue,
                    inactiveFillColor: tlightGrayblue,
                    inactiveColor: tlightGrayblue,
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
                isPinLogin: true,
                onChange: (String pin) {
                  pinController.text = pin;
                  print('${pinController.text}');
                  setState(() {});
                },
                onSubmit: (String pin) {
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
              SizedBox(height: 90),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    // Twl.navigateTo(
                    //   context,
                    //   PassCode(),
                    // );
                  }
                },
                child: Center(
                  child: Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: tPrimaryColor),
                    child: Center(
                        child: Text('Continue',
                            style: TextStyle(color: tBlack, fontSize: 13.sp))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
