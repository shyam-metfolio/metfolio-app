// ignore_for_file: unused_field

import 'dart:async';
import 'dart:math';
import 'package:base_project_flutter/responsive.dart';
// import 'package:base_project_flutter/views/demo/demo1.dart';
import 'package:base_project_flutter/views/faceIdPage/faceId.dart';
import 'package:base_project_flutter/views/successfullPage/SaleIsConfirmSucessfull.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as ency;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/orderApi.dart';
import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';

import '../../globalWidgets/button.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../components/alertPage.dart';
import '../keypad/keypad.dart';
import '../otpPage/otpPage.dart';
import '../paymentMethods/PaymentBankMethods.dart';
import '../selectAddress/selectAddress.dart';
import '../successfullPage/PurchesedConfirmSucessfull.dart';
import '../successfullPage/changesSavesSucessfull.dart';
import '../successfullPage/deliverySucessfull.dart';
// import 'KeyPad.dart';

class EnterYourPasscode extends StatefulWidget {
  const EnterYourPasscode(
      {Key? key,
      this.type,
      this.goalId,
      this.goalName,
      this.amount,
      this.date,
      this.currentStatus,
      this.addDetailsId,
      this.bankId})
      : super(key: key);
  final type;
  final goalId;
  final goalName;
  final amount;
  final date;
  final currentStatus;
  final addDetailsId;
  final bankId;
  @override
  State<EnterYourPasscode> createState() => _EnterYourPasscodeState();
}

class _EnterYourPasscodeState extends State<EnterYourPasscode> {
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
          setState(() {
            // print(userData.data()!['userId']);
            print("passcode>>>3");
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
            if ((attempts ?? 0) <= 3) {
              if (enteredPasscode == decrypted) {
                setState(() {
                  passcodeError = '';
                });
                Twl.navigateTo(context, BottomNavigation());
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text('your passcode verified'),
                // ));
              } else {
                setState(() {
                  passcodeError = 'Incorrect passcode';
                  if (sharedPrefs.getInt("passcodeAttempts") != null) {
                    sharedPrefs.setInt(
                        "passcodeAttempts", ((attempts ?? 0) + 1));
                  } else {
                    sharedPrefs.setInt("passcodeAttempts", 1);
                  }
                  print(sharedPrefs.getInt("passcodeAttempts"));
                });
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text('Enter a valid passcode'),
                // ));
              }
            } else {
              // Twl.navigateTo(
              //     context,
              //     PassCodeOtp(
              //       isDisableBack: true,
              //     ));
            }
          });
        }
      } else {}
    });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId.toString())
    //     .snapshots()
    //     .listen((userData) {
    //   setState(() {
    //     // print(userData.data()!['userId']);
    //     print("passcode>>>3");
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
    //       Twl.navigateTo(context, BottomNavigation());
    //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       //   content: Text('your passcode verified'),
    //       // ));
    //     } else {
    //       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       //   content: Text('Enter a valid passcode'),
    //       // ));
    //     }
    //   });
    // });
    // } else {
    //   Twl.createAlert(context, 'error', checkApi['error']);
    // }
    // Calling the collection to add a new user
  }

  var passcodeError = '';
  @override
  void dispose() {
    super.dispose();
  }

  String currentText = "";

  bool loading = false;
  loader(value) {
    setState(() {
      loading = value;
    });
  }

  x() async {
    loader(true);
    setState(() {
      passcodeError = '';
    });
    // //startLoading();
    // if (_formKey.currentState!.validate()) {
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
          print("passcode>>>");
          print(snapshot.docs[0].data());
          print(snapshot.docs[0]['userId']);
          print(snapshot.docs[0]['passcode']);
          print("passcode>>>2");
          print(snapshot.docs[0]['passcode']);
          print(snapshot.docs[0]['passcode']);
          final iv = ency.IV.fromLength(16);
          final key = ency.Key.fromUtf8('my 32 length key................');
          final encrypter = ency.Encrypter(ency.AES(key));

          // final decrypted = encrypter.decrypt(userData.data()!['passcode'], iv: iv);
          final decrypted = encrypter.decrypt(
              ency.Encrypted.from64(snapshot.docs[0]['passcode']),
              iv: iv);
          print(decrypted);
          if (pinController1.text == decrypted) {
            // Twl.navigateTo(context, BottomNavigation());
            if (widget.type == GoldType().Sell) {
              var sellRes =
                  await OrderAPI().sellGold(context, widget.bankId.toString());
              print(sellRes);
              if (sellRes != null && sellRes['status'] == 'OK') {
                // WidgetsBinding
                //     .instance!
                //     .addPostFrameCallback((_) async {
                loader(false);
                // });
                Twl.navigateTo(context, SalesConfirmSucessful());
              } else {
                // WidgetsBinding
                //     .instance!
                //     .addPostFrameCallback((_) async {
                loader(false);
                // });

                // Twl.createAlert(context, 'error',
                //     sellRes['error']);
              }
              // Twl.navigateTo(
              //     context,
              //     PaymentBankMethods(
              //       amount: widget.amount,
              //     ));
              // var cashModeRes =
              //     await OrderAPI().CashMode(context);
              // print(cashModeRes);
              // if (cashModeRes != null &&
              //     cashModeRes['status'] == "OK") {
              //   stopLoading();
              //   Twl.navigateTo(context,
              //       PurchesedConfirmSucessful());
              // } else {
              //   stopLoading();
              //   Twl.createAlert(context, 'error',
              //       cashModeRes['error']);
              // }
            } else if (widget.type == GoldType().EditGoal) {
              customAlert(
                  context,
                  'Would you like to save your changes?',
                  "Confirm",
                  'Discard',
                  null, (startLoading, stopLoading, btnState) async {
                loader(true);
                //startLoading();
                // var goalName;
                // var amount;
                // var date;
                // print(amount);
                // setState(() {
                //   goalName = _nameGoalController.text;
                //   amount = (_amountController.text);
                //   date = monthsSelectedValue;
                // });
                var res = await OrderAPI().editGoal(
                    context,
                    widget.goalId,
                    widget.goalName,
                    widget.amount.replaceAll(RegExp(Secondarycurrency), ''),
                    widget.date,
                    '1',
                    widget.currentStatus.toString());
                if (res != null && res['status'] == 'OK') {
                  stopLoading();
                  loader(false);
                  Twl.navigateTo(context, ChangesSavedSucessful());
                } else {
                  loader(false);
                  stopLoading();
                  // Twl.createAlert(context, 'error',
                  //     res['error']);
                }
                loader(false);
                stopLoading();
              });
            } else if (widget.type == GoldType().EndGoal) {
              var res = await OrderAPI().editGoal(
                  context,
                  widget.goalId,
                  widget.goalName,
                  widget.amount,
                  widget.date,
                  '2',
                  widget.currentStatus.toString());
              print(res);
              if (res != null && res['status'] == 'OK') {
                loader(false);
                Twl.navigateTo(context, BottomNavigation());
              } else {
                loader(false);
                // Twl.createAlert(
                //     context, 'error', res['error']);
              }
            } else if (widget.type == GoldType().Deliver) {
              var res = await UserAPI().goldDelivery(context, '50',
                  widget.currentStatus, widget.addDetailsId.toString());
              print(res);
              if (res != null && res['status'] == 'OK') {
                loader(false);
                loader(false);
                var delivryQty;
                setState(() {
                  delivryQty =
                      double.parse(res['details']['order']['quantity']);
                });
                print('delivryQty>>>>>>>>>>>');
                print(delivryQty);

                loader(false);
                Twl.navigateTo(
                    context, DeliverySucessful(delivryQty: delivryQty));
              } else {
                loader(false);

                // Twl.createAlert(
                //     context, 'error', res['error']);
              }
              // Twl.navigateTo(
              //     context,
              //     SelectAddress(
              //       goldType: widget.currentStatus,
              //       qty: 50,
              //     ));
            }
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(
            //   content: Text('your passcode verified'),
            // ));
          } else {
            loader(false);

            setState(() {
              passcodeError = 'Incorrect passcode';
            });
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(
            //   content: Text('Enter a valid passcode'),
            // ));
          }
        }
      } else {}
    });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId.toString())
    //     .snapshots()
    //     .listen((userData) async {
    //   // setState(() async {
    //   // print(userData.data()!['userId']);
    //   print("passcode>>>");
    //   print(userData.data()!['passcode']);
    //   final iv = ency.IV.fromLength(16);
    //   final key = ency.Key.fromUtf8(
    //       'my 32 length key................');
    //   final encrypter = ency.Encrypter(ency.AES(key));

    //   // final decrypted = encrypter.decrypt(userData.data()!['passcode'], iv: iv);
    //   final decrypted = encrypter.decrypt(
    //       ency.Encrypted.from64(
    //           userData.data()!['passcode']),
    //       iv: iv);
    //   print(decrypted);
    //   if (pinController1.text == decrypted) {
    //     // Twl.navigateTo(context, BottomNavigation());
    //     if (widget.type == GoldType().Sell) {
    //       Twl.navigateTo(
    //           context,
    //           PaymentBankMethods(
    //             amount: widget.amount,
    //           ));
    //       // var cashModeRes =
    //       //     await OrderAPI().CashMode(context);
    //       // print(cashModeRes);
    //       // if (cashModeRes != null &&
    //       //     cashModeRes['status'] == "OK") {
    //       //   stopLoading();
    //       //   Twl.navigateTo(context,
    //       //       PurchesedConfirmSucessful());
    //       // } else {
    //       //   stopLoading();
    //       //   Twl.createAlert(context, 'error',
    //       //       cashModeRes['error']);
    //       // }
    //     } else if (widget.type == GoldType().EditGoal) {
    //       customAlert(
    //           context,
    //           'Would you like to save your changes?',
    //           "Confirm",
    //           'Discard',
    //           null, (startLoading, stopLoading,
    //               btnState) async {
    //         //startLoading();
    //         // var goalName;
    //         // var amount;
    //         // var date;
    //         // print(amount);
    //         // setState(() {
    //         //   goalName = _nameGoalController.text;
    //         //   amount = (_amountController.text);
    //         //   date = monthsSelectedValue;
    //         // });
    //         var res = await OrderAPI().editGoal(
    //             context,
    //             widget.goalId,
    //             widget.goalName,
    //             widget.amount.replaceAll(
    //                 RegExp(Secondarycurrency), ''),
    //             widget.date,
    //             '1',
    //             widget.currentStatus.toString());
    //         if (res != null && res['status'] == 'OK') {
    //           stopLoading();
    //           Twl.navigateTo(
    //               context, ChangesSavedSucessful());
    //         } else {
    //           stopLoading();
    //           Twl.createAlert(
    //               context, 'error', res['error']);
    //         }
    //         stopLoading();
    //       });
    //     } else if (widget.type == GoldType().EndGoal) {
    //       var res = await OrderAPI().editGoal(
    //           context,
    //           widget.goalId,
    //           widget.goalName,
    //           widget.amount,
    //           widget.date,
    //           '2',
    //           widget.currentStatus.toString());
    //       print(res);
    //       if (res != null && res['status'] == 'OK') {
    //         Twl.navigateTo(context, BottomNavigation());
    //       } else {
    //         Twl.createAlert(
    //             context, 'error', res['error']);
    //       }
    //     } else if (widget.type == GoldType().Deliver) {
    //       Twl.navigateTo(
    //           context,
    //           SelectAddress(
    //             goldType: widget.currentStatus,
    //             qty: 50,
    //           ));
    //     }
    //     // ScaffoldMessenger.of(context)
    //     //     .showSnackBar(SnackBar(
    //     //   content: Text('your passcode verified'),
    //     // ));
    //   } else {
    //     stopLoading();
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(
    //       content: Text('Enter a valid passcode'),
    //     ));
    //   }
    //   // });
    // });
    // Twl.navigateTo(context, ConfirmYourPassCode());
    // }
    loader(false);
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
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
              body: SingleChildScrollView(
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
                        SizedBox(height: 10.h),
                        Center(
                          child: Text(
                            "Enter your Passcode",
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
                            // obscuringCharacter: '',

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
                              errorBorderColor: Colors.red,
                              borderRadius: BorderRadius.circular(15),
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
                            setState(() {});
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
                        SizedBox(height: 70),
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
                        )
                      ],
                    ),
                  ),
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
    );
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  getNextCode() {
    pinController1.text = '';
    var rng = new Random();
    var code = (rng.nextInt(9000) + 1000).toString();
    print('Random No is : $code');
    return code;
  }
}





// // ignore_for_file: unused_field

// import 'dart:math';
// import 'package:base_project_flutter/responsive.dart';
// import 'package:base_project_flutter/views/loginPassCodePages/confirmYourPasscode.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:encrypt/encrypt.dart' as ency;
// import 'package:flutter/material.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';

// import '../../api_services/orderApi.dart';
// import '../../constants/constants.dart';
// import '../../constants/imageConstant.dart';
// import '../../globalFuctions/globalFunctions.dart';
// import '../../globalWidgets/button.dart';

// import '../bottomNavigation.dart/bottomNavigation.dart';
// import '../components/alertPage.dart';
// import '../keypad/keypad.dart';
// import '../sorryscreen/goalEnded.dart';
// import '../successfullPage/PurchesedConfirmSucessfull.dart';
// import '../successfullPage/changesSavesSucessfull.dart';

// class EnterYourPasscode extends StatefulWidget {
//   const EnterYourPasscode(
//       {Key? key,
//       this.type,
//       this.goalId,
//       this.goalName,
//       this.amount,
//       this.date,
//       this.currentStatus})
//       : super(key: key);
//   final type;
//   final goalId;
//   final goalName;
//   final amount;
//   final date;
//   final currentStatus;
//   @override
//   State<EnterYourPasscode> createState() => _EnterYourPasscodeState();
// }

// class _EnterYourPasscodeState extends State<EnterYourPasscode> {
//   final TextEditingController _otpCodeController = TextEditingController();
//   final _formKey = new GlobalKey<FormState>();

//   late String displayCode;
//   TextEditingController pinController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     displayCode = getNextCode();
//   }

//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   // TextEditingController? _messageController;
//   // CollectionReference passcode = FirebaseFirestore.instance.collection('Users');
//   // CollectionReference? _collectionReference;
//   // Future<void>

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: tWhite,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: tWhite,
//           leading: GestureDetector(
//             onTap: () {
//               Twl.navigateBack(context);
//             },
//             child: Image.asset(
//               Images.NAVBACK,
//               scale: 4,
//             ),
//           ),
//         ),
//         body: SafeArea(
//           child: Form(
//             key: _formKey,
//             child: Builder(
//               builder: (context) => Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 20),
//                       // IconButton(
//                       //     onPressed: () {
//                       //       Twl.navigateBack(context);
//                       //     },
//                       //     icon: Icon(Icons.arrow_back_ios, color: tPrimaryColor)),
//                       Center(
//                         child: Text(
//                           "Passcode lock",
//                           style: TextStyle(
//                               fontFamily: 'signika',
//                               color: tPrimaryColor,
//                               fontSize: 20.sp,
//                               fontWeight: FontWeight.w500
//                               // fontFamily: AppTextStyle.robotoBold
//                               ),
//                         ),
//                       ),
//                       SizedBox(height: 60),
//                       Center(
//                         child: Text(
//                           "Enter your Passcode",
//                           style: TextStyle(
//                               fontFamily: 'Signika',
//                               color: tSecondaryColor,
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w500
//                               // fontFamily: AppTextStyle.robotoBold
//                               ),
//                         ),
//                       ),
//                       SizedBox(height: 40),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 70,
//                         ),
//                         child: PinCodeTextField(
//                           //backgroundColor: Colors.white,
//                           appContext: context,
//                           pastedTextStyle: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           length: 4,
//                           obscureText: false,
//                           obscuringCharacter: '*',
                
//                           blinkWhenObscuring: true,
//                           animationType: AnimationType.fade,
//                           validator: (v) {
//                             if (v!.length < 4 || v.length == 0) {
//                               return "Otp length did not match";
//                             } else {
//                               return null;
//                             }
//                           },
//                           pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             activeColor: tlightGrayblue,
//                             selectedColor: tlightGrayblue,
//                             selectedFillColor: tlightGrayblue,
//                             inactiveFillColor: tlightGrayblue,
//                             inactiveColor: tlightGrayblue,
//                             borderRadius: BorderRadius.circular(12),
//                             borderWidth: 0,
//                             fieldHeight: isTab(context) ? 10.w : 13.w,
//                             fieldWidth: isTab(context) ? 10.w : 12.w,
//                             activeFillColor: tlightGrayblue,
//                           ),
//                           cursorColor: Colors.black,
//                           animationDuration: Duration(milliseconds: 300),
//                           enableActiveFill: true,
//                           //errorAnimationController: errorController,
//                           controller: pinController,
//                           keyboardType: TextInputType.none,
//                           // boxShadows: [tBoxShadow],
//                           onCompleted: (v) {
//                             print("Completed");
//                           },
//                           onTap: () {
//                             print("Pressed");
//                           },
//                           onChanged: (value) {
//                             print(value);
//                             // setState(() {
//                             //   currentText = value;
//                             // });
//                           },
//                           beforeTextPaste: (text) {
//                             print("Allowing to paste $text");
                
//                             return true;
//                           },
//                         ),
//                       ),
//                       KeyPad(
//                         pinController: pinController,
//                         isPinLogin: false,
//                         onChange: (String pin) {
//                           pinController.text = pin;
//                           print('${pinController.text}');
//                           setState(() {});
//                         },
//                         onSubmit: (String pin) {
//                           if (pin.length != 4) {
//                             (pin.length == 0)
//                                 ? showInSnackBar('Please Enter Pin')
//                                 : showInSnackBar('Wrong Pin');
//                             return;
//                           } else {
//                             pinController.text = pin;
                
//                             if (pinController.text == displayCode) {
//                               showInSnackBar('Pin Match');
//                               setState(() {
//                                 displayCode = getNextCode();
//                               });
//                             } else {
//                               showInSnackBar('Wrong pin');
//                             }
//                             print('Pin is ${pinController.text}');
//                           }
//                         },
//                       ),
//                       // Spacer(),
//                       // SizedBox(height: 110),
//                       Padding(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Button(
//                             borderSide: BorderSide.none,
//                             color: tPrimaryColor,
//                             textcolor: tWhite,
//                             bottonText: 'Continue',
//                             onTap: (startLoading, stopLoading, btnState) async {
//                               //startLoading();
//                               if (_formKey.currentState!.validate()) {
//                                 SharedPreferences sharedPrefs =
//                                     await SharedPreferences.getInstance();
//                                 var authCode = sharedPrefs.getString('authCode');
//                                 // var checkApi = await UserAPI().checkApi(authCode);
//                                 // print(checkApi);
//                                 // if (checkApi != null && checkApi['status'] == 'OK') {
//                                 // var userId = checkApi['detail']['userId'].toString();
//                                 var userId = sharedPrefs.getString('userId');
//                                 print('check passcode');
//                                 var collectionReference =
//                                     _firestore.collection('users');
//                                 FirebaseFirestore.instance
//                                     .collection('users')
//                                     .doc(userId.toString())
//                                     .snapshots()
//                                     .listen((userData) {
//                                   setState(() async {
//                                     // print(userData.data()!['userId']);
//                                     print("passcode>>>");
//                                     print(userData.data()!['passcode']);
//                                     final iv = ency.IV.fromLength(16);
//                                     final key = ency.Key.fromUtf8(
//                                         'my 32 length key................');
//                                     final encrypter =
//                                         ency.Encrypter(ency.AES(key));
                
//                                     // final decrypted = encrypter.decrypt(userData.data()!['passcode'], iv: iv);
//                                     final decrypted = encrypter.decrypt(
//                                         ency.Encrypted.from64(
//                                             userData.data()!['passcode']),
//                                         iv: iv);
//                                     print(decrypted);
//                                     if (pinController.text == decrypted) {
//                                       // Twl.navigateTo(context, BottomNavigation());
//                                       if (widget.type == GoldType().Sell) {
//                                         var cashModeRes =
//                                             await OrderAPI().CashMode(context);
//                                         print(cashModeRes);
//                                         if (cashModeRes != null &&
//                                             cashModeRes['status'] == "OK") {
//                                           stopLoading();
//                                           Twl.navigateTo(context,
//                                               PurchesedConfirmSucessful());
//                                         } else {
//                                           stopLoading();
//                                           Twl.createAlert(context, 'error',
//                                               cashModeRes['error']);
//                                         }
//                                       } else if (widget.type ==
//                                           GoldType().EditGoal) {
//                                         customAlert(
//                                             context,
//                                             'Would you like to save your changes?',
//                                             "Confirm",
//                                             'Discard',
//                                             null, (startLoading, stopLoading,
//                                                 btnState) async {
//                                           //startLoading();
//                                           // var goalName;
//                                           // var amount;
//                                           // var date;
//                                           // print(amount);
//                                           // setState(() {
//                                           //   goalName = _nameGoalController.text;
//                                           //   amount = (_amountController.text);
//                                           //   date = monthsSelectedValue;
//                                           // });
//                                           var res = await OrderAPI().editGoal(
//                                               context,
//                                               widget.goalId,
//                                               widget.goalName,
//                                               widget.amount.replaceAll(
//                                                   RegExp(Secondarycurrency), ''),
//                                               widget.date,
//                                               '1',
//                                               widget.currentStatus.toString());
//                                           if (res != null &&
//                                               res['status'] == 'OK') {
//                                             stopLoading();
//                                             Twl.navigateTo(
//                                                 context, ChangesSavedSucessful());
//                                           } else {
//                                             stopLoading();
//                                             Twl.createAlert(
//                                                 context, 'error', res['error']);
//                                           }
//                                           stopLoading();
//                                         });
//                                       } else if (widget.type ==
//                                           GoldType().EndGoal) {
//                                         var res = await OrderAPI().editGoal(
//                                             context,
//                                             widget.goalId,
//                                             widget.goalName,
//                                             widget.amount,
//                                             widget.date,
//                                             '2',
//                                             widget.currentStatus.toString());
//                                         print(res);
//                                         if (res != null &&
//                                             res['status'] == 'OK') {
//                                           Twl.navigateTo(
//                                               context, BottomNavigation());
//                                         } else {
//                                           Twl.createAlert(
//                                               context, 'error', res['error']);
//                                         }
//                                       }
//                                       // ScaffoldMessenger.of(context)
//                                       //     .showSnackBar(SnackBar(
//                                       //   content: Text('your passcode verified'),
//                                       // ));
//                                     } else {
//                                       stopLoading();
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                         content: Text('Enter a valid passcode'),
//                                       ));
//                                     }
//                                   });
//                                 });
//                                 // Twl.navigateTo(context, ConfirmYourPassCode());
//                               }
//                               stopLoading();
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }

//   void showInSnackBar(String value) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(new SnackBar(content: new Text(value)));
//   }

//   getNextCode() {
//     pinController.text = '';
//     var rng = new Random();
//     var code = (rng.nextInt(9000) + 1000).toString();
//     print('Random No is : $code');
//     return code;
//   }
// }
