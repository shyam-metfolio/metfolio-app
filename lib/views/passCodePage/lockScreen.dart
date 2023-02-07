// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/responsive.dart';
// import 'package:base_project_flutter/views/demo/demo1.dart';
import 'package:base_project_flutter/views/faceIdPage/faceId.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as ency;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';

import '../../globalWidgets/button.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../keypad/keypad.dart';
import '../loginPassCodePages/enterYourPasscode.dart';
import '../otpPage/otpPage.dart';
// import 'KeyPad.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key, required this.navigate}) : super(key: key);
  final navigate;
  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _otpCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  late String displayCode;
  TextEditingController pinController1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    // displayCode = getNextCode();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // TextEditingController? _messageController;
  // CollectionReference passcode = FirebaseFirestore.instance.collection('Users');
  // CollectionReference? _collectionReference;
  // Future<void>
  getPasscode(enteredPasscode) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var authCode = sharedPrefs.getString('authCode');
    // var checkApi = await UserAPI().checkApi(authCode);
    // print(checkApi);
    // if (checkApi != null && checkApi['status'] == 'OK') {
    // var userId = checkApi['detail']['userId'].toString();
    var userId = sharedPrefs.getString('userId');
    print('check passcode');
    var collectionReference = _firestore.collection('users');
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
          final iv = ency.IV.fromLength(16);
          final key = ency.Key.fromUtf8('my 32 length key................');
          final encrypter = ency.Encrypter(ency.AES(key));

          // final decrypted = encrypter.decrypt(userData.data()!['passcode'], iv: iv);
          final decrypted = encrypter.decrypt(
              ency.Encrypted.from64(snapshot.docs[0]['passcode']),
              iv: iv);
          print(decrypted);
          var attempts = sharedPrefs.getInt("passcodeAttempts");
          print(attempts);
          // if ((attempts ?? 0) <= 3) {
          if (enteredPasscode == decrypted) {
            setState(() {
              passcodeError = '';
            });
            loader(false);
            Twl.navigateTo(
                context,
                BottomNavigation(
                  actionIndex: 0,
                  tabIndexId: 0,
                ));

            await analytics.logEvent(
              name: "passCode_success",
              parameters: {
                "pass": enteredPasscode,
                "button_clicked": true,
              },
            );

            Segment.track(
              eventName: 'passCode_success',
              properties: {"pass": enteredPasscode, "clicked": true},
            );

            mixpanel.track(
              'passCode_success',
              properties: {"pass": enteredPasscode, "clicked": true},
            );

            await logEvent("passCode_success", {
              "pass": enteredPasscode,
              'clicked': true,
            });

            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text('your passcode verified'),
            // ));
          } else {
            loader(false);
            setState(() async {
              hasError = true;
              passcodeError = 'Incorrect passcode';

              await analytics.logEvent(
                name: "passCode_incorrect",
                parameters: {
                  "pass": enteredPasscode,
                  "button_clicked": true,
                },
              );

              Segment.track(
                eventName: 'passCode_incorrect',
                properties: {"pass": enteredPasscode, "clicked": true},
              );

              mixpanel.track(
                'passCode_incorrect',
                properties: {"pass": enteredPasscode, "clicked": true},
              );

              await logEvent("passCode_incorrect", {
                "pass": enteredPasscode,
                'clicked': true,
              });

              // if (sharedPrefs.getInt("passcodeAttempts") != null) {
              //   sharedPrefs.setInt("passcodeAttempts", ((attempts ?? 0) + 1));
              // } else {
              //   sharedPrefs.setInt("passcodeAttempts", 1);
              // }
              // print(sharedPrefs.getInt("passcodeAttempts"));
              // sharedPrefs.setInt("passcodeAttempts", 1);
            });

            // WidgetsBinding.instance!.addPostFrameCallback((_) async {
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text('Enter a valid passcode'),
            //   ));
            // });
          }
          // } else {
          //   loader(false);
          // Twl.navigateTo(
          //     context,
          //     PassCodeOtp(
          //       isDisableBack: true,
          //     ));
          // }
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
    //     print("passcode>>>2");
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
    //         passcodeError = '';
    //       });
    //       Twl.navigateTo(context, BottomNavigation());
    //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       //   content: Text('your passcode verified'),
    //       // ));
    //     } else {
    //       setState(() {
    //         passcodeError = 'Incorrect passcode';
    //       });
    //       // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //       //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       //     content: Text('Enter a valid passcode'),
    //       //   ));
    //       // });
    //     }
    //   });
    // });

    // } else {
    //   Twl.createAlert(context, 'error', checkApi['error']);
    // }
    // Calling the collection to add a new user
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;
  loader(value) {
    setState(() {
      isLoading = value;
    });
  }

  x() async {
    // if (_formKey.currentState!.validate()) {
    if (currentText.length != 4 || currentText.isEmpty) {
      setState(() {
        hasError = true;
      });
    } else {
      setState(() {
        hasError = false;
      });
      loader(true);
      print(currentText);
      getPasscode(currentText);
    }

    // }
  }

  bool hasError = false;
  var btnColor = tIndicatorColor;
  var selectedvalue;
  var passcodeError = '';
  String currentText = "";
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () {
            return Twl.willpopAlert(context);
          },
          child: Scaffold(
            backgroundColor: tWhite,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: tWhite,
              leading: GestureDetector(
                // change the back button shadow
                onTap: () {
                  if (widget.navigate == true) {
                    Twl.navigateBack(context);
                  } else {
                    Twl.willpopAlert(context);
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Builder(
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
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
                                "Enter your passcode",
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600
                                    // fontFamily: AppTextStyle.robotoBold
                                    ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 70,
                              ),
                              child: PinCodeTextField(
                                textInputAction: TextInputAction.previous,
                                //backgroundColor: Colors.white,
                                appContext: context,

                                pastedTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 4,
                                obscureText: true,
                                // obscuringCharacter: '*',

                                // blinkWhenObscuring: true,
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
                                  selectedColor: tlightGrayblue,
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
                                controller: pinController1,
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
                                  setState(() {
                                    currentText = value;
                                  });
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
                              pinController: pinController1,
                              isPinLogin: true,
                              onChange: (String pin) {
                                pinController1.text = pin;
                                print('${pinController1.text}');
                                setState(() {
                                  hasError = false;
                                });
                              },
                              onSubmit: (String pin) {
                                if (pin.length != 4) {
                                  (pin.length == 0)
                                      ? showInSnackBar('Please Enter Pin')
                                      : showInSnackBar('Wrong Pin');
                                  return;
                                } else {
                                  pinController1.text = pin;

                                  if (pinController1.text == displayCode) {
                                    showInSnackBar('Pin Match');
                                    setState(() {
                                      displayCode = getNextCode();
                                    });
                                  } else {
                                    showInSnackBar('Wrong pin');
                                  }
                                  print('Pin is ${pinController1.text}');
                                }
                              },
                            ),
                            // Passcode(
                            //   pinController: pinController1,
                            //   isPinLogin: false,
                            //   onChange: (String pin) {
                            //     pinController1.text = pin;
                            //     print('${pinController1.text}');
                            //     setState(() {});
                            //   },
                            //   onSubmit: (String pin) {
                            //     if (pin.length != 4) {
                            //       (pin.length == 0)
                            //           ? showInSnackBar('Please Enter Pin')
                            //           : showInSnackBar('Wrong Pin');
                            //       return;
                            //     } else {
                            //       pinController1.text = pin;

                            //       if (pinController1.text == displayCode) {
                            //         showInSnackBar('Pin Match');
                            //         setState(() {
                            //           displayCode = getNextCode();
                            //         });
                            //       } else {
                            //         showInSnackBar('Wrong pin');
                            //       }
                            //       print('Pin is ${pinController1.text}');
                            //     }
                            //   },
                            // )s
                            SizedBox(height: 60),
                            GestureDetector(
                              onTap: () {
                                Twl.navigateTo(context, PassCodeOtp());
                              },
                              child: Center(
                                child: Text(
                                  "Forgot Passcode?",
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  child: Text('Continue',
                                      style: TextStyle(
                                        color: tBlue,
                                      )),
                                  onPressed: x,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

  void showInSnackBar(String value) {
    print('error' + value);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(new SnackBar(content: new Text(value)));
  }

  getNextCode() {
    pinController1.text = '';
    var rng = new Random();
    var code = (rng.nextInt(9000) + 1000).toString();
    print('Random No is : $code');
    return code;
  }
}
