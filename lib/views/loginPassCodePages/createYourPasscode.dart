// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';

import '../keypad/keypad.dart';
import 'confirmPasscode.dart';
import 'confirmYourPasscode.dart';

class CreateYourPassCode extends StatefulWidget {
  const CreateYourPassCode({Key? key, required this.loginFlow})
      : super(key: key);
  final loginFlow;
  @override
  State<CreateYourPassCode> createState() => _CreateYourPassCodeState();
  // @override
  // _CreateYourPassCodeState createState() => _CreateYourPassCodeState();
}

class _CreateYourPassCodeState extends State<CreateYourPassCode> {
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  late String displayCode;
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // displayCode = getNextCode();
  }

  x() async {
    if (_formKey.currentState!.validate()) {
      Twl.navigateTo(
          context,
          ConfirmYourPassCode(
            passcode: pinController.text,
            loginFlow: widget.loginFlow,
          ));
    }
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(false);
      },
      child: Scaffold(
          backgroundColor: tWhite,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: tWhite,
            automaticallyImplyLeading: widget.loginFlow ? false : true,
            leading: widget.loginFlow
                ? Container()
                : GestureDetector(
                    // change the back button shadow
                    onTap: () {
                      if (widget.loginFlow == true) {
                        Twl.willpopAlert(context);
                      } else {
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
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Builder(
                builder: (context) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: SingleChildScrollView(
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
                                fontSize: isTab(context) ? 18.sp : 21.sp,
                                fontWeight: FontWeight.w500
                                // fontFamily: AppTextStyle.robotoBold
                                ),
                          ),
                        ),
                        SizedBox(height: 7.h),
                        Center(
                          child: Text(
                            "Create your Passcode",
                            style: TextStyle(
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 13.sp : 16.sp,
                                fontWeight: FontWeight.w400
                                // fontFamily: AppTextStyle.robotoBold
                                ),
                          ),
                        ),
                        SizedBox(height: 5.h),
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
                            blinkDuration: Duration(milliseconds: 200),
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            // validator: (v) {
                            //   if (v!.length < 4 || v.length == 0) {
                            //     return "passcode length did not match";
                            //   } else {
                            //     return null;
                            //   }
                            // },
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
                        // Spacer(),
                        SizedBox(height: 13.h),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 2.h),
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
                        //   GestureDetector(
                        //     onTap: () {
                        //       // if (_formKey.currentState!.validate()) {
                        //         Twl.navigateTo(context, BottomNavigation());
                        //  //   }
                        //     },
                        //     child: Center(
                        //       child: Container(
                        //         width: 200,
                        //         height: 40,
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(15),
                        //             color: tPrimaryColor),
                        //         child: Center(
                        //             child: Text('Continue',
                        //                 style: TextStyle( fontFamily: 'Signika',color: tSecondaryColor, fontSize: 13.sp))),
                        //       ),
                        //     ),
                        //   ),SizedBox(height:20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
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
