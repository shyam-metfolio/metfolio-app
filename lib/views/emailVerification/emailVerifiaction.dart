import 'dart:async';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/PersonalDetails/PersonalDetails.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/forgotPasswordPasscode/forgotPasswordPasscode.dart';
import 'package:base_project_flutter/views/homePage/components/dashBoardPage.dart';
import 'package:base_project_flutter/views/homeaddres/homeaddress.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../main.dart';
import '../HomeAddress/HomeAddress.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({
    Key? key,
    this.firstName,
    this.lastName,
    this.emailId,
    this.selectedDate,
    // this.otp
  }) : super(key: key);

  final firstName;
  final lastName;
  final emailId;
  final selectedDate;
  // final otp;

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  // late String username;
  // bool hasError = false;
  late String otpCode;
  @override
  void initState() {
    getMailId();
    // setState(() {
    //   _otpCodeController..text = widget.otp.toString();
    // });
    // TODO: implement initState
    super.initState();
  }

  getMailId() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    emailId = sharedPrefs.getString('emailId');
  }

  var emailId;
  bool loading = false;

  startLoader(value) {
    setState(() {
      loading = value;
    });
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.willpopAlert(context);
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                backgroundColor: tWhite,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: tWhite,
                  leading: GestureDetector(
                    // change the back button shadow
                    onTap: () {
                      Twl.willpopAlert(context);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Please Verify your Email",
                                          style: TextStyle(
                                              fontFamily: 'Signika',
                                              color: tPrimaryColor,
                                              fontSize: isTab(context)
                                                  ? 18.sp
                                                  : 21.sp,
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(height: 25),
                                      Text(
                                          "Please enter the six digit code which we sent to your email address",
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
                                        animationType: AnimationType.fade,
                                        validator: (v) {
                                          if (v!.length < 6 || v.length == 0) {
                                            return "";
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderWidth: 0,
                                          fieldHeight:
                                              isTab(context) ? 10.w : 13.w,
                                          fieldWidth:
                                              isTab(context) ? 9.w : 12.w,
                                          activeFillColor: tlightGrayblue,
                                        ),
                                        cursorColor: tlightGrayblue,
                                        animationDuration:
                                            Duration(milliseconds: 300),
                                        enableActiveFill: true,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
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
                                      GestureDetector(
                                        onTap: () async {
                                          var emailRes = await UserAPI()
                                              .sendEmailOtp(
                                                  context, emailId.toString());
                                          print(emailRes);
                                          if (emailRes != null &&
                                              emailRes['status'] == 'OK') {
                                            // setState(() {
                                            //   _otpCodeController
                                            //     ..text = emailRes['details']['user_details']
                                            //             ['email_otp']
                                            //         .toString();
                                            // });
                                          } else {
                                            // Twl.createAlert(context, 'error',
                                            //     emailRes['error']);
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            "Re-send verification code",
                                            style: TextStyle(
                                                color: tSecondaryColor,
                                                fontSize: isTab(context)
                                                    ? 9.sp
                                                    : 12.sp,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
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
                                onPressed: () async {
                                  // if (_formKey.currentState!.validate() && widget.index == 2) {
                                  startLoader(true);
                                  if (_formKey.currentState!.validate()) {
                                    otpCode = _otpCodeController.text;
                                    print(otpCode);
                                    var verifyEmailRes = await UserAPI()
                                        .verifyEmail(context, otpCode);
                                    print(verifyEmailRes);
                                    if (verifyEmailRes != null &&
                                        verifyEmailRes['status'] == 'OK') {
                                      // stopLoading();
                                      startLoader(false);
                                      Twl.navigateTo(
                                          context,
                                          HomeAddress(
                                            firstName: widget.firstName,
                                            // lastName: widget.lastName,
                                            // email: widget.emailId,
                                            // dob: widget.selectedDate,
                                            isLoginFlow: true,
                                          ));

                                      await FirebaseAnalytics.instance.logEvent(
                                        name: "emailverif_signup",
                                        parameters: {
                                          "otp": otpCode,
                                          "button_clicked": true,
                                        },
                                      );

                                      Segment.track(
                                        eventName: 'emailverif_signup',
                                        properties: {
                                          "otp": otpCode,
                                          "clicked": true
                                        },
                                      );
                                    } else {
                                      // stopLoading();
                                      startLoader(false);
                                      // Twl.createAlert(context, 'error',
                                      //     verifyEmailRes['error']);
                                    }
                                    startLoader(false);

                                    // Twl.navigateTo(context, PersonalDetails());
                                  }
                                  // else if (_formKey.currentState!.validate() &&
                                  //     widget.index == 1) {
                                  else {
                                    // Twl.navigateTo(context, ForgotPasswordPasscode());
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20)
                        ]),
                  ),
                )),
          ),
          if (loading)
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
      ),
    );
  }
}

class EmailNotVerified extends StatefulWidget {
  EmailNotVerified({Key? key}) : super(key: key);

  @override
  State<EmailNotVerified> createState() => _EmailNotVerifiedState();
}

class _EmailNotVerifiedState extends State<EmailNotVerified> {
  @override
  void initState() {
    getMailId();
    // TODO: implement initState
    super.initState();
  }

  late SharedPreferences sharedPrefs;
  getMailId() async {
    startLoader(true);
    sharedPrefs = await SharedPreferences.getInstance();
    emailId = sharedPrefs.getString('emailId');
    var authCode = sharedPrefs.getString('authCode');
    emailRes = await UserAPI().sendEmailOtp(context, emailId.toString());
    print(emailRes);
    if (emailRes != null && emailRes['status'] == 'OK') {
      startLoader(false);
    } else {
      startLoader(false);
      print(emailRes['error']);
    }
  }

  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  var emailRes;
  var emailId;
  bool hasError = false;
  bool loading = false;

  startLoader(value) {
    setState(() {
      loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.willpopAlert(context);
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                backgroundColor: tWhite,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: tWhite,
                  leading: GestureDetector(
                    onTap: () {
                      // Twl.navigateBack(context);
                      Twl.willpopAlert(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Image.asset(
                        Images.NAVBACK,
                        scale: 4,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Verify your Email",
                                          style: TextStyle(
                                              fontFamily: 'Signika',
                                              color: tPrimaryColor,
                                              fontSize: isTab(context)
                                                  ? 18.sp
                                                  : 21.sp,
                                              fontWeight: FontWeight.w700)),
                                      SizedBox(height: 25),
                                      Text(
                                          "Please enter the six digit code which we sent to your email address",
                                          style: TextStyle(
                                              color: tSecondaryColor,
                                              fontSize:
                                                  isTab(context) ? 9.sp : 12.sp,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(height: 40),
                                      PinCodeTextField(
                                        appContext: context,
                                        pastedTextStyle: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        length: 6,
                                        obscureText: false,
                                        obscuringCharacter: '*',

                                        // blinkWhenObscuring: true,
                                        animationType: AnimationType.fade,
                                        validator: (v) {
                                          if (v!.length < 6 || v.length == 0) {
                                            return "Otp length did not match";
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
                                          inactiveColor:
                                              //  Colors.red,
                                              hasError
                                                  ? Colors.red
                                                  : tlightGrayblue,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderWidth: 0,
                                          fieldHeight:
                                              isTab(context) ? 10.w : 13.w,
                                          fieldWidth:
                                              isTab(context) ? 9.w : 12.w,
                                          activeFillColor: tlightGrayblue,
                                        ),
                                        cursorColor: tlightGrayblue,
                                        animationDuration:
                                            Duration(milliseconds: 300),
                                        enableActiveFill: true,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
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
                                      GestureDetector(
                                        onTap: () async {
                                          startLoader(true);
                                          emailRes = await UserAPI()
                                              .sendEmailOtp(
                                                  context, emailId.toString());
                                          print(emailRes);
                                          if (emailRes != null &&
                                              emailRes['status'] == 'OK') {
                                            startLoader(false);
                                            // setState(() {
                                            //   _otpCodeController
                                            //     ..text = emailRes['details']['user_details']
                                            //             ['email_otp']
                                            //         .toString();
                                            // });
                                          } else {
                                            startLoader(false);
                                            // Twl.createAlert(
                                            //     context, 'error', emailRes['error']);
                                          }
                                        },
                                        child: Center(
                                          child: Text(
                                            "Re-send verification code",
                                            style: TextStyle(
                                                color: tSecondaryColor,
                                                fontSize: isTab(context)
                                                    ? 14.sp
                                                    : 16.sp,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 0),
                          //   child: Align(
                          //     alignment: Alignment.center,
                          //     child: Button(
                          //       borderSide: BorderSide.none,
                          //       color: tPrimaryColor,
                          //       textcolor: tWhite,
                          //       bottonText: 'Send Otp',
                          //       onTap: (startLoading, stopLoading, btnState) async {
                          //         // if (_formKey.currentState!.validate() && widget.index == 2) {
                          //         //startLoading();
                          //         emailRes = await UserAPI()
                          //             .sendEmailOtp(context, emailId.toString());
                          //         print(emailRes);
                          //         if (emailRes != null && emailRes['status'] == 'OK') {
                          //           stopLoading();
                          //           // setState(() {
                          //           //   _otpCodeController
                          //           //     ..text = emailRes['details']['user_details']
                          //           //             ['email_otp']
                          //           //         .toString();
                          //           // });
                          //         } else {
                          //           stopLoading();
                          //           Twl.createAlert(context, 'error', emailRes['error']);
                          //         }
                          //       },
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          if (emailRes != null)
                            Column(children: [
                              if (emailRes['status'] == 'OK')
                                Text('otp Sent to your mail ${emailId}'),
                              if (emailRes['status'] == 'OK')
                                SizedBox(
                                  height: 20,
                                ),
                            ]),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0),
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
                                onPressed: () async {
                                  // if (_formKey.currentState!.validate() && widget.index == 2) {
                                  if (_formKey.currentState!.validate()) {
                                    startLoader(true);
                                    setState(() {
                                      hasError = false;
                                    });
                                    var otpCode = _otpCodeController.text;
                                    // print(otpCode);
                                    var verifyEmailRes = await UserAPI()
                                        .verifyEmail(context, otpCode);
                                    print(verifyEmailRes);
                                    if (verifyEmailRes != null &&
                                        verifyEmailRes['status'] == 'OK') {
                                      var check = await UserAPI().checkApi(
                                          sharedPrefs.getString('authCode'));
                                      if (check != null &&
                                          check['status'] == 'OK') {
                                        startLoader(false);
                                        await checkverification(
                                            context,
                                            check['detail']
                                                ['verification_status']);
                                      } else {
                                        startLoader(false);
                                      }
                                      // stopLoading();
                                      // Twl.navigateTo(context, BottomNavigation());
                                    } else {
                                      startLoader(false);
                                      setState(() {
                                        hasError = true;
                                      });

                                      print(verifyEmailRes['error']);
                                      // Twl.createAlert(
                                      //     context, 'error', verifyEmailRes['error']);
                                    }

                                    // Twl.navigateTo(context, PersonalDetails());
                                  }
                                  // else if (_formKey.currentState!.validate() &&
                                  //     widget.index == 1) {
                                  else {
                                    setState(() {
                                      hasError = true;
                                    });
                                    // Twl.navigateTo(context, ForgotPasswordPasscode());
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20)
                        ]),
                  ),
                )),
          ),
          if (loading)
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
      ),
    );
  }
}
