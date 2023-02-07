// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/accountNotExist/changedPasscode.dart';
import 'package:base_project_flutter/views/successfullPage/SaleIsConfirmSucessfull.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as ency;

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';

import '../bottomNavigation.dart/bottomNavigation.dart';
import '../keypad/keypad.dart';
// import 'KeyPad.dart';

class ProfileConfirmPasscode extends StatefulWidget {
  const ProfileConfirmPasscode({Key? key, this.newpasscode}) : super(key: key);
  final newpasscode;
  @override
  State<ProfileConfirmPasscode> createState() => _ProfileConfirmPasscodeState();
}

class _ProfileConfirmPasscodeState extends State<ProfileConfirmPasscode> {
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  late String displayCode;
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // displayCode = getNextCode();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> updatePasscode(String passcode) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var authCode = sharedPrefs.getString('authCode');
    // var checkApi = await UserAPI().checkApi(authCode);
    // print(checkApi);
    // if (checkApi != null && checkApi['status'] == 'OK') {
    // var userId = checkApi['detail']['userId'].toString();
    var userId = sharedPrefs.getString('userId');
    // _collectionReference = FirebaseFirestore.instance
    //     // .collection('Users')
    //     // .doc('98')
    //     .collection('98');

    // final plainText = '1234';
    final key = ency.Key.fromUtf8('my 32 length key................');
    final iv = ency.IV.fromLength(16);

    final encrypter = ency.Encrypter(ency.AES(key));

    final encrypted = encrypter.encrypt(passcode, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    // print(decrypted);
    // print(encrypted.base64);
    var collectionReference = _firestore.collection('users');
    collectionReference.doc(userId).update(
      {
        'userId': userId,
        'passcode': encrypted.base64,
      },
    ).then((value) {
      print("passcode data saved");
      setState(() {
        sharedPrefs.setInt("passcodeAttempts", 0);
      });
      startLoader(false);
      Twl.navigateTo(context, ChangedPasscode());
      // Twl.navigateTo(context, BottomNavigation());
    }).catchError((error) {
      startLoader(false);
      print("passcode couldn't be saved.");
    });

    // } else {
    //   Twl.createAlert(context, 'error', checkApi['error']);
    // }
    // Calling the collection to add a new user
  }

  var passcodeError = '';
  bool loading = false;
  // bool isLoading = true;

  startLoader(value) {
    setState(() {
      loading = value;
    });
  }

  bool hasError = false;
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
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Expanded(
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
                              SizedBox(height: 60),
                              Center(
                                child: Text(
                                  "Confirm New Passcode",
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                      fontWeight: FontWeight.w500
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
                                  obscureText: true,
                                  // obscuringCharacter: '*',
                                  errorTextSpace: 0,
                                  blinkWhenObscuring: true,
                                  animationType: AnimationType.fade,
                                  validator: (v) {
                                    if (v!.length < 4 || v.length == 0) {
                                      return "";
                                    } else {
                                      return null;
                                    }
                                  },
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    activeColor:
                                        hasError ? Colors.red : tlightGrayblue,
                                    selectedColor:
                                        hasError ? Colors.red : tlightGrayblue,
                                    selectedFillColor: tlightGrayblue,
                                    inactiveFillColor: tlightGrayblue,
                                    inactiveColor:
                                        hasError ? Colors.red : tlightGrayblue,
                                    borderRadius: BorderRadius.circular(12),
                                    borderWidth: 1,
                                    fieldHeight: isTab(context) ? 10.w : 13.w,
                                    fieldWidth: isTab(context) ? 10.w : 12.w,
                                    activeFillColor: tlightGrayblue,
                                  ),
                                  cursorColor: Colors.black,
                                  animationDuration:
                                      Duration(milliseconds: 300),
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
                              // Center(
                              //     child: Text(
                              //   passcodeError,
                              //   style: TextStyle(color: Colors.red),
                              // )),
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
                              // SizedBox(height: 110),

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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 2.h),
                        child: Align(
                          alignment: Alignment.center,
                          child: Button(
                            borderSide: BorderSide.none,
                            color: tPrimaryColor,
                            textcolor: tWhite,
                            bottonText: 'Continue',
                            onTap: (startLoading, stopLoading, btnState) async {
                              print(widget.newpasscode);
                              print(pinController.text);

                              if (_formKey.currentState!.validate()) {
                                startLoader(true);
                                if (widget.newpasscode == pinController.text) {
                                  await updatePasscode(pinController.text);
                                } else {
                                  startLoader(false);
                                  setState(() {
                                    hasError = true;
                                    passcodeError = 'Incorrect Passcode';
                                  });
                                  // Twl.createAlert(context, 'error',
                                  //     'passcode does not match');
                                }
                                // Twl.navigateTo(context, SalesConfirmSucessful());
                              } else {
                                setState(() {
                                  hasError = true;
                                });
                              }
                              startLoader(false);
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
              ),
            ),
          ),
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
            ),
          )
      ],
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
