// ignore_for_file: unused_field

import 'dart:async';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/HomeAddress/HomeAddress.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/emailVerification/emailVerifiaction.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalName.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:veriff_flutter/veriff_flutter.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../globalWidgets/twlTextField.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key, required this.isLoadingFlow})
      : super(key: key);
  final isLoadingFlow;
  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userLatNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userDateofBirthController =
      TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  var dob;
  var selectedDate;
  var yearDiff;
  @override
  void initState() {
    setState(() {
      selectedDate = '1';
    });
    getUserDetials();
    super.initState();
  }

  getUserDetials() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.getString(
      "authCode",
    );
    if (sharedPreferences.getString('authCode') != null) {
      var check = await UserAPI().checkApi(
        sharedPreferences.getString(
          "authCode",
        ),
      );
      print('checkkkk');

      print(check);

      if (check != null && check['status'] == 'OK') {
        setState(() {
          if (check['detail']['first_name'] != null) {
            _userNameController..text = check['detail']['first_name'];
          }
          if (check['detail']['last_name'] != null) {
            _userLatNameController..text = check['detail']['last_name'];
          }
          if (check['detail']['email'] != null) {
            _userEmailController..text = check['detail']['email'];
          }
          if (check['detail']['date_of_birth'] != null) {
            selectedDate = check['detail']['date_of_birth'];
          }
        });
      }
    }
  }

  bool loading = false;

  startLoader(value) {
    setState(() {
      loading = value;
    });
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  bool dobError = false;
  @override
  Widget build(BuildContext context) {
    // loading = false;
    return WillPopScope(
      onWillPop: () {
        if (widget.isLoadingFlow == true) {
          return Twl.willpopAlert(context);
        } else {
          return Twl.navigateBack(context);
        }
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
                    // Twl.willpopAlert(context);
                    if (widget.isLoadingFlow == true) {
                      return Twl.willpopAlert(context);
                    } else {
                      return Twl.navigateBack(context);
                    }
                    //  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Personal Details",
                                style: TextStyle(
                                    fontFamily: 'Signika',
                                    color: tPrimaryColor,
                                    fontSize: isTab(context) ? 18.sp : 21.sp,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: 10),
                            Text(
                                "We require your personal details in order to open an account on Metfolio",
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 8.sp : 11.sp,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 30),
                            Text('First name*',
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 10.sp : 12.sp,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 10),

                            // SizedBox(
                            //   height: tDefaultPadding * 2,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: TwlNormalTextField(
                                // errorBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(12),
                                //   borderSide: BorderSide(color: Colors.red)
                                // ),
                                inputForamtters: <TextInputFormatter>[
                                  UpperCaseFormatter()
                                ],
                                // focusedBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(12),
                                // ),
                                controller: _userNameController,
                                textInputType: TextInputType.text,
                                validator: usernameValidator,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text('Last name*',
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 10.sp : 12.sp,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 10),

                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: TwlNormalTextField(
                                inputForamtters: <TextInputFormatter>[
                                  UpperCaseFormatter()
                                ],
                                //  errorBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(12),
                                //   borderSide: BorderSide(color: Colors.red)
                                // ),
                                controller: _userLatNameController,
                                textInputType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Text('Email Address*',
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 10.sp : 12.sp,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 10),

                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: TwlNormalTextField(
                                // errorBorder: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(12),
                                //     borderSide: BorderSide(color: Colors.red)
                                //   ),

                                controller: _userEmailController,
                                textInputType: TextInputType.text,
                                validator: emailValidator,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text('Date of Birth*',
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 10.sp : 12.sp,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 10),

                            Padding(
                              padding: EdgeInsets.only(right: 15.w),
                              child: GestureDetector(
                                onTap: () async {
                                  // showModalBottomSheet(
                                  //     context: context,
                                  //     builder: (context) {
                                  //       return Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.center,
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           Expanded(
                                  //             child: CupertinoDatePicker(
                                  //               mode: CupertinoDatePickerMode
                                  //                   .date,
                                  //               dateOrder:
                                  //                   DatePickerDateOrder.dmy,
                                  //               initialDateTime: DateTime.now(),
                                  //               onDateTimeChanged:
                                  //                   (DateTime dateTime) {
                                  //                 // tbd
                                  //               },
                                  //             ),
                                  //           ),
                                  //           ElevatedButton(
                                  //               onPressed: () {},
                                  //               child: Text("save"))
                                  //         ],
                                  //       );
                                  //     });
                                  DatePicker.showDatePicker(
                                    context,
                                    // pickerModel:  CustomPicker(currentTime: DateTime.now()),
                                    showTitleActions: true,
                                    currentTime: DateTime.now(),
                                    minTime: DateTime(1930, 1, 1),
                                    // maxTime: DateTime.now(),
                                    theme: DatePickerTheme(
                                        headerColor: tPrimaryColor,
                                        itemStyle: TextStyle(

                                            // color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                        cancelStyle: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        doneStyle: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    onChanged: (date) {
                                      if (date.compareTo(DateTime.now()) > 0) {
                                        setState(() {
                                          dobError = true;
                                        });
                                      } else {
                                        setState(() {
                                          dobError = false;
                                        });
                                      }
                                      print("dobError" + dobError.toString());
                                      print('change $date in time zone ' +
                                          date.toString());
                                      dob = Twl.dateFormate(date)!.toString();
                                      setState(() {
                                        selectedDate = dob;
                                        print('_selectedDate');
                                        print(selectedDate);
                                        // var formattedTemporaryDate = '2022-06-07';
                                        DateTime dt =
                                            DateTime.parse(selectedDate);
                                        print('dt');
                                        print(dt);
                                        var dateNow = new DateTime.now();

                                        var givenDateFormat = selectedDate;
                                        print(givenDateFormat);
                                        var diff = dateNow.difference(dt);
                                        yearDiff =
                                            ((diff.inDays) / 365).round();
                                        print(yearDiff);
                                        // var givenDateFormat = selectedDate;
                                        print('givenDateFormat');
                                        print(givenDateFormat);
                                      });
                                      print('dateOfBirth');
                                      print(dob);
                                    },
                                    onConfirm: (date) {
                                      if (date.compareTo(DateTime.now()) > 0) {
                                        setState(() {
                                          dobError = true;
                                        });
                                      } else {
                                        setState(() {
                                          dobError = false;
                                        });
                                      }
                                      print("dobError" + dobError.toString());
                                      print('confirm $date');
                                      dob = Twl.dateFormate(date)!.toString();
                                      setState(() {
                                        selectedDate = dob;
                                        print('_selectedDate');
                                        print(selectedDate);
                                        // var formattedTemporaryDate = '2022-06-07';
                                        DateTime dt = date;
                                        // DateTime.parse(selectedDate);
                                        print('dt');
                                        print(dt);
                                        var dateNow = new DateTime.now();
                                        var givenDateFormat = selectedDate;
                                        print(givenDateFormat);
                                        var diff = dateNow.difference(dt);
                                        yearDiff =
                                            ((diff.inDays) / 365).round();
                                        print('yearDiff');
                                        print(yearDiff);
                                        print('givenDateFormat');
                                        print(givenDateFormat);
                                      });
                                      print('dateOfBirth');
                                      print(dob);
                                    },
                                  );
                                  // print("sdhbv");
                                  // DateTime? date = DateTime.now();
                                  // FocusScope.of(context)
                                  //     .requestFocus(new FocusNode());
                                  // date = await showDatePicker(
                                  //     context: context,
                                  //     builder: (BuildContext context, child) {
                                  //       return Theme(
                                  //         data: ThemeData.light().copyWith(
                                  //           colorScheme: ColorScheme.light(
                                  //             primary: tPrimaryColor,
                                  //             onPrimary: tWhite,
                                  //             onSurface: tBlack,
                                  //           ),
                                  //           dialogBackgroundColor: Colors.white,
                                  //         ),
                                  //         child: child!,
                                  //       );
                                  //     },
                                  //     initialDate: DateTime.now(),
                                  //     firstDate: DateTime(1930),
                                  //     lastDate: DateTime.now());
                                  // dob = Twl.dateFormate(date)!.toString();
                                  // setState(() {
                                  //   selectedDate = dob;
                                  //   print('_selectedDate');
                                  //   print(selectedDate);
                                  //   // var formattedTemporaryDate = '2022-06-07';
                                  //   DateTime dt = DateTime.parse(selectedDate);
                                  //   print('dt');
                                  //   print(dt);
                                  //   var dateNow = new DateTime.now();

                                  //   var givenDateFormat = selectedDate;
                                  //   print(givenDateFormat);
                                  // });
                                  // print('dateOfBirth');
                                  // print(dob);
                                },
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 15),
                                  decoration: BoxDecoration(
                                    color: tPrimaryTextformfield,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 1,
                                      color: (selectedDate == null ||
                                              selectedDate == '' ||
                                              dobError)
                                          ? Colors.red
                                          : tPrimaryTextformfield,
                                      style: (selectedDate == null ||
                                              selectedDate == '' ||
                                              dobError)
                                          ? BorderStyle.solid
                                          : BorderStyle.none,
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      (selectedDate != null &&
                                              selectedDate != '1')
                                          ? selectedDate
                                          : '',
                                      // dateFormate(dob != null ? dob : ''),
                                      // '',
                                      style: TextStyle(
                                          fontSize: isTab(context) ? 8 : 15),
                                    ),
                                  ),
                                  // TwlNormalTextField(
                                  //   // readOnly: true,
                                  //   controller: _userDateofBirthController..text=selectedDate.toString(),
                                  //   textInputType: TextInputType.phone,
                                  //   inputForamtters: [LengthLimitingTextInputFormatter(10)],
                                  //   validator: dateofbirthValidator,
                                  // ),
                                ),
                              ),
                            ),
                            SizedBox(height: 35),
                            Text("By proceeding, you also agree to our",
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 8.sp : 11.sp,
                                    fontWeight: FontWeight.w400)),
                            GestureDetector(
                              onTap: () {
                                Twl.launchURL(context, termsAndConditonsUrl);
                              },
                              child: Text("terms and conditions",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 8.sp : 11.sp,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ))),
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 15.w),
                        //   child: Align(
                        //     alignment: Alignment.center,
                        //     child: Button(
                        //       borderSide: BorderSide.none,
                        //       color: tPrimaryColor,
                        //       textcolor: tWhite,
                        //       bottonText: 'Continue',
                        //       onTap: (startLoading, stopLoading, btnState) async {
                        //         if (_formKey.currentState!.validate()) {
                        //           Twl.navigateTo(context, HomeAddress());
                        //         }
                        //       },
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),

                        //   ],
                        // ))),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Button(
                              borderSide: BorderSide.none,
                              color: tPrimaryColor,
                              textcolor: tWhite,
                              bottonText: 'Continue',
                              onTap:
                                  (startLoading, stopLoading, btnState) async {
                                FocusScope.of(context).unfocus();
                                if (selectedDate == '1') {
                                  setState(() {
                                    selectedDate = '';
                                  });
                                }
                                if (_formKey.currentState!.validate()
                                    //  &&(yearDiff > 18)
                                    ) {
                                  if (selectedDate == null ||
                                      selectedDate == '' ||
                                      dobError) {
                                    final snackBar = SnackBar(
                                      content:
                                          Text('Please select Date of Birth'),
                                      action: SnackBarAction(
                                        label: 'Ok',
                                        onPressed: () {
                                          Twl.navigateBack(context);
                                        },
                                      ),
                                    );
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                  } else {
                                    startLoader(true);
                                    var firstName = _userNameController.text;
                                    var lastName = _userLatNameController.text;
                                    var emailId = _userEmailController.text;
                                    var countryCode;
                                    print(firstName);
                                    print(lastName);
                                    print(emailId);
                                    print(selectedDate);
                                    SharedPreferences sharedPreferences =
                                        await SharedPreferences.getInstance();
                                    setState(() {
                                      sharedPreferences.setString(
                                          'firstName', firstName);
                                      sharedPreferences.setString(
                                          'lastName', lastName);
                                      sharedPreferences.setString(
                                          'email', emailId);
                                      sharedPreferences.setString('dob', dob);
                                      countryCode = sharedPreferences
                                          .getString('countryCode');
                                    });
                                    print('signup api>>>>>>>>>>>>');
                                    // //startLoading();

                                    var signUpRes =
                                        await UserAPI().updateProfile(
                                      context,
                                      firstName,
                                      lastName,
                                      emailId,
                                      selectedDate,
                                      countryCode,
                                      // pincode,
                                      // address
                                    );
                                    print(signUpRes);

                                    if (signUpRes['status'] == 'OK' &&
                                        signUpRes != null) {
                                      if (widget.isLoadingFlow == true) {
                                        var emailRes = await UserAPI()
                                            .sendEmailOtp(
                                                context, emailId.toString());
                                        print('emailRes>>>>>>>>>>>>>');
                                        print(emailRes);
                                        if (emailRes != null &&
                                            emailRes['status'] == 'OK') {
                                          var otpcode = emailRes['details']
                                              ['user_details']['email_otp'];
                                          SharedPreferences sharedPrefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var authCode =
                                              sharedPrefs.getString('authCode');

                                          var check = await UserAPI().checkApi(
                                              sharedPrefs
                                                  .getString('authCode'));
                                          print("authCode>>>>> " +
                                              authCode.toString());
                                          print(check);
                                          print("CheckAuthcode");
                                          if (check != null &&
                                              check['status'] == 'OK') {
                                            // setState(() {
                                            sharedPrefs.setString(
                                                'userId',
                                                check['detail']['userId']
                                                    .toString());
                                            sharedPrefs.setString('emailId',
                                                check['detail']['email']);

                                            sharedPrefs.setString(
                                                'stripePublicKey',
                                                check['detail']
                                                    ['stripe_publishable_key']);
                                            sharedPrefs.setString(
                                                'stripesecretKey',
                                                check['detail']
                                                    ['stripe_secret_Key']);
                                            print(otpcode);
                                            // stopLoading();
                                            startLoader(false);
                                            Twl.navigateTo(
                                                context,
                                                EmailVerification(
                                                  firstName: firstName,
                                                  lastName: lastName,
                                                  emailId: emailId,
                                                  selectedDate: selectedDate,
                                                  // otp: otpcode
                                                ));

                                            await analytics.logEvent(
                                              name: "personal_details",
                                              parameters: {
                                                'email': emailId,
                                                'firstName': firstName,
                                                'lastName': lastName,
                                                'phone': sharedPrefs
                                                    .getString('userName'),
                                                "date_of_birth": selectedDate,
                                                "button_clicked": true,
                                              },
                                            );

                                            Segment.track(
                                              eventName: 'PersonalDetails',
                                              properties: {
                                                'email': emailId,
                                                'companyName': 'Metfolio',
                                                'firstName': firstName,
                                                'lastName': lastName,
                                                'phone': sharedPrefs
                                                    .getString('userName'),
                                                'streetAddress': 'streetName',
                                                'city': 'cityName',
                                                'state': 'stateName',
                                                'country': 'counName',
                                                'website':
                                                    'https://www.google.com',
                                                'postalCode': '123456',
                                                'clicked': true,
                                              },
                                            );

                                            mixpanel.track(
                                              'PersonalDetails',
                                              properties: {
                                                'email': emailId,
                                                'companyName': 'Metfolio',
                                                'firstName': firstName,
                                                'lastName': lastName,
                                                'phone': sharedPrefs
                                                    .getString('userName'),
                                                'streetAddress': 'streetName',
                                                'city': 'cityName',
                                                'state': 'stateName',
                                                'country': 'counName',
                                                'website':
                                                    'https://www.google.com',
                                                'postalCode': '123456',
                                                'clicked': true,
                                              },
                                            );

                                            await logEvent("PersonalDetails", {
                                              'email': emailId,
                                              'companyName': 'Metfolio',
                                              'firstName': firstName,
                                              'lastName': lastName,
                                              'phone': sharedPrefs
                                                  .getString('userName'),
                                              'streetAddress': 'streetName',
                                              'city': 'cityName',
                                              'state': 'stateName',
                                              'country': 'counName',
                                              'website':
                                                  'https://www.google.com',
                                              'postalCode': '123456',
                                              'clicked': true,
                                            });
                                          }
                                        } else {
                                          // stopLoading();
                                          startLoader(false);
                                          // Twl.createAlert(context, 'error',
                                          //     emailRes['error']);
                                        }
                                      } else {
                                        startLoader(false);
                                        Twl.navigateTo(
                                            context, BottomNavigation());
                                      }

                                      // stopLoading();
                                      startLoader(false);
                                      // Twl.navigateTo(context, HomeAddress());
                                    } else {
                                      stopLoading();
                                      startLoader(false);
                                      // Twl.createAlert(
                                      //     context, 'error', signUpRes['error']);
                                    }
                                  }

                                  // } else {
                                  //   if ((yearDiff < 18)) {
                                  //     return ScaffoldMessenger.of(context)
                                  //         .showSnackBar(SnackBar(
                                  //       content: Text(
                                  //           'Your age must be greater then 18 years.'),
                                  //     ));
                                  //   }
                                }
                              },
                            ),
                          ),
                        ),
                      ]),
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
            ))
        ],
      ),
    );
  }

  String? usernameValidator(String? username) {
    if (username!.isEmpty) {
      return "";
    }
    return null;
  }

  String? emailValidator(String? email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    if (email!.isEmpty) {
      return "";
    } else if (!regExp.hasMatch(email)) {
      return '';
    } else {
      return null;
    }
  }

  String? dateofbirthValidator(String? dateofbirth) {
    if (dateofbirth!.isEmpty) {
      return "";
    }
    return null;
  }
}

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     return TextEditingValue(
//       text: capitalize(newValue.text),
//       selection: newValue.selection,
//     );
//   }
// }

// String capitalize(String value) {
//   if (value.trim().isEmpty) return "";
//   return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
// }

class CustomPicker extends CommonPickerModel {
  String digits(value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.day);
    this.setMiddleIndex(this.currentTime.month);
    this.setRightIndex(this.currentTime.year);
  }
  List<String> listOfMonths = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  @override
  String? leftStringAtIndex(int index) {
    if (index >= 1 && index <= 31) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 1 && index <= 11) {
      return this.digits(listOfMonths[index], 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < 10000) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  // @override
  // String leftDivider() {
  //   return "|";
  // }

  // @override
  // String rightDivider() {
  //   return "|";
  // }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
