// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/accountNotExist/changedPasscode.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as ency;
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';

import '../faceIdPage/faceId.dart';
import '../keypad/keypad.dart';
import '../notificationPage/notification.dart';
import '../term&ConditionPage/term&condition.dart';
import 'mobileNumber.dart';

class ConfirmYourPassCode extends StatefulWidget {
  const ConfirmYourPassCode({Key? key, this.passcode, required this.loginFlow})
      : super(key: key);
  final passcode;
  final loginFlow;
  @override
  State<ConfirmYourPassCode> createState() => _ConfirmYourPassCodeState();
}

class _ConfirmYourPassCodeState extends State<ConfirmYourPassCode> {
  // final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  late String displayCode;
  TextEditingController pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // displayCode = getNextCode();
  }

  // Reference? _storageReference;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // TextEditingController? _messageController;
  // CollectionReference passcode = FirebaseFirestore.instance.collection('Users');
  // CollectionReference? _collectionReference;
  // Future<void>
  addNewPasscode(String passcode) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var authCode;
    // var checkApi = await UserAPI().checkApi(authCode);
    // print(checkApi);
    // if (checkApi != null && checkApi['status'] == 'OK') {
    // var userId = checkApi['detail']['userId'].toString();
    var userId;
    setState(() {
      userId = sharedPrefs.getString('userId');
      authCode = sharedPrefs.getString('authCode');
    });
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
    collectionReference.doc(userId).set({
      'userId': userId,
      'passcode': encrypted.base64,
    }, SetOptions(merge: true)).then((value) {
      print("passcode data saved");
      if (widget.loginFlow == true) {
        final facebookAppEvents = FacebookAppEvents();
        facebookAppEvents.logEvent(
          name: 'Sign up',
        );
        // if (Platform.isIOS) {
        //   loader(false);
        //   Twl.navigateTo(context, FaceIdScreen());
        // } else {
        //   loader(false);
        Twl.navigateTo(context, NotificationPage());
        // Twl.navigateTo(context, TermAndConditionPage());
        // }
      } else {
        loader(false);
        Twl.navigateTo(context, ChangedPasscode());
      }

      // Twl.navigateTo(context, ChangedPasscode());
    }).catchError((error) {
      loader(false);
      print("passcode couldn't be saved.");
    });
    // } else {
    //   Twl.createAlert(context, 'error', checkApi['error']);
    // }
    // Calling the collection to add a new user
  }

  bool loading = false;
  bool hasError = false;
  loader(value) {
    setState(() {
      loading = value;
    });
  }

  x() async {
    //startLoading();
    loader(true);
    var passcode = pinController.text;
    if (_formKey.currentState!.validate() && (widget.passcode == passcode)) {
      setState(() {
        hasError = false;
      });
      loader(false);

      print("dcdbc");
      addNewPasscode(passcode);
    } else if ((widget.passcode != passcode)) {
      setState(() {
        hasError = true;
      });
      loader(false);

      // Twl.createAlert(context, 'error',
      //     'passcode does not match');
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
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
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500
                                  // fontFamily: AppTextStyle.robotoBold
                                  ),
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Center(
                            child: Text(
                              "Confirm your Passcode",
                              style: TextStyle(
                                  color: tSecondaryColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500
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
                                activeColor:
                                    hasError ? Colors.red : tlightGrayblue,
                                selectedColor:
                                    hasError ? Colors.red : tlightGrayblue,
                                selectedFillColor: tlightGrayblue,
                                inactiveFillColor: tlightGrayblue,
                                inactiveColor:
                                    hasError ? Colors.red : tlightGrayblue,
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
                              setState(() {
                                hasError = false;
                              });
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
