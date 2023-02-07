// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/profilePage/profileNewPassCode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as ency;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';

import '../bottomNavigation.dart/bottomNavigation.dart';
import '../keypad/keypad.dart';

// import 'KeyPad.dart';

class ProfileOriginalPasscode extends StatefulWidget {
  @override
  _ProfileOriginalPasscodeState createState() =>
      _ProfileOriginalPasscodeState();
}

class _ProfileOriginalPasscodeState extends State {
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  late String displayCode;
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // displayCode = getNextCode();
  }

  checkPasscode(enteredPasscode) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var authCode = sharedPrefs.getString('authCode');
    // var checkApi = await UserAPI().checkApi(authCode);
    // print(checkApi);
    // if (checkApi != null && checkApi['status'] == 'OK') {
    var userId = sharedPrefs.getString('userId');
    print('check passcode');
    await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId.toString())
        .get()
        .then((QuerySnapshot snapshot) async {
      print("isPasscodeExist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      // print(userData.data()?['userId']);
      if (snapshot.docs.length > 0) {
        if (snapshot.docs[0].data() != null) {
          var details = snapshot.docs[0].data();
          print(snapshot.docs[0].data());
          print(snapshot.docs[0]['userId']);
          print(snapshot.docs[0]['passcode']);
          print("passcode>>>2");
          print(snapshot.docs[0]['passcode']);
          setState(() {
            // print(userData.data()!['userId']);
            print("passcode>>>1");
            print(snapshot.docs[0]['passcode']);
            final iv = ency.IV.fromLength(16);
            final key = ency.Key.fromUtf8('my 32 length key................');
            final encrypter = ency.Encrypter(ency.AES(key));

            // final decrypted = encrypter.decrypt(userData.data()!['passcode'], iv: iv);
            final decrypted = encrypter.decrypt(
                ency.Encrypted.from64(snapshot.docs[0]['passcode']),
                iv: iv);
            print(decrypted);
            if (enteredPasscode == decrypted) {
              setState(() {
                hasError = false;
                passcodeError = '';
              });
              Twl.navigateTo(context, ProfileNewPasscode());
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text('your passcode verified'),
              // ));
            } else {
              setState(() {
                hasError = true;
                passcodeError = ' Incorrect passcode';
              });
              // WidgetsBinding.instance!.addPostFrameCallback((_) async {
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text('Enter a valid passcode'),
              //   ));
              // });
            }
          });
        }
      } else {
        setState(() {
          hasError = false;
        });
      }
    });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId.toString())
    //     .snapshots()
    //     .listen((userData) {
    //   setState(() {
    //     // print(userData.data()!['userId']);
    //     print("passcode>>>1");
    //     print(userData.data()!['passcode']);
    //     final iv = ency.IV.fromLength(16);
    //     final key = ency.Key.fromUtf8('my 32 length key................');
    //     final encrypter = ency.Encrypter(ency.AES(key));

    //     // final decrypted = encrypter.decrypt(userData.data()!['passcode'], iv: iv);
    //     final decrypted = encrypter.decrypt(
    //         ency.Encrypted.from64(userData.data()!['passcode']),
    //         iv: iv);
    //     print(decrypted);
    //     if (enteredPasscode == decrypted) {
    //       setState(() {
    //         passcodeError ='';
    //       });
    //       Twl.navigateTo(context, ProfileNewPasscode());
    //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       //   content: Text('your passcode verified'),
    //       // ));
    //     } else {
    //       setState(() {
    //         passcodeError =' Incorrect passcode';
    //       });
    //       // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       //     content: Text('Enter a valid passcode'),
    //       //   ));
    //       // });
    //     }
    //   });
    // });
  }

  bool hasError = false;
  var btnColor = tIndicatorColor;
  var selectedvalue;
  var passcodeError = '';
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
                                "Enter your original Passcode ",
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

                                blinkWhenObscuring: true,
                                animationType: AnimationType.fade,
                                validator: (v) {
                                  // if (v!.length < 4 || v.length == 0) {
                                  //   return "Passcode length did not match";
                                  // } else {
                                  //   return null;
                                  // }
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
                                  setState(() {
                                    hasError = false;
                                  });
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
                                  // (pin.length == 0)
                                  //     ? showInSnackBar('Please Enter Pin')
                                  //     : showInSnackBar('Wrong Pin');
                                  return;
                                } else {
                                  pinController.text = pin;

                                  if (pinController.text == displayCode) {
                                    // showInSnackBar('Pin Match');
                                    setState(() {
                                      displayCode = getNextCode();
                                    });
                                  } else {
                                    // showInSnackBar('Wrong pin');
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                      child: Align(
                        alignment: Alignment.center,
                        child: Button(
                          borderSide: BorderSide.none,
                          color: tPrimaryColor,
                          textcolor: tWhite,
                          bottonText: 'Continue',
                          onTap: (startLoading, stopLoading, btnState) async {
                            if (_formKey.currentState!.validate()) {
                              checkPasscode(pinController.text);
                            } else {
                              setState(() {
                                hasError = true;
                              });
                            }
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
