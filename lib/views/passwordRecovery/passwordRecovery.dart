// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';

import '../DigitCode/DigitCode.dart';

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({Key? key}) : super(key: key);

  @override
  State<PasswordRecovery> createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userLatNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userDateofBirthController =
      TextEditingController();
  String dropdownValue = '+44';
  final _formKey = new GlobalKey<FormState>();
  var btnColor = tIndicatorColor;
  var selectedvalue;

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
      body: Form(
        key: _formKey,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 2, right: 20, top: 0, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IconButton(
              //     onPressed: () {
              //       Twl.navigateBack(context);
              //     },
              //     icon: Icon(Icons.arrow_back_ios, color: tPrimaryColor)),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Password recovery",
                            style: TextStyle(
                                fontFamily: 'Signika',
                                color: tPrimaryColor,
                                fontSize: isTab(context) ? 18.sp : 20.sp,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 2.h),
                        Text("Mobile Number",
                            style: TextStyle(
                                color: tSecondaryColor,
                                fontFamily: 'Signika',
                                fontSize: isTab(context) ? 13.sp : 16.sp,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 2.h),
                        Text(
                            "We may store and send a verification\ncode to this number",
                            style: TextStyle(
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 9.sp : 12.sp,
                                fontWeight: FontWeight.w400)),
                        SizedBox(height: 3.h),

                        // SizedBox(
                        //   height: tDefaultPadding * 2,
                        // ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: tlightGrayblue),
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                items: <String>[
                                  "+91",
                                  "+44",
                                  "+90",
                                  "+21"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: tSecondaryColor,
                                            fontSize:
                                                isTab(context) ? 13.sp : 16.sp),
                                      ));
                                }).toList(),
                                underline:
                                    Container(color: tTextformfieldColor),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: Container(
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "number should be entered";
                                        } else {
                                          return null;
                                        }
                                      },
                                      controller: _userLatNameController,
                                      //_phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(11)
                                      ],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: tSecondaryColor,
                                          fontSize:
                                              isTab(context) ? 13.sp : 16.sp),
                                      decoration: InputDecoration(
                                        // prefix: Text('+91 ',style: TextStyle(color: tBlack),),

                                        hintStyle: TextStyle(
                                            fontSize:
                                                isTab(context) ? 10.sp : 14.sp),
                                        // hintText: 'Enter Your Mobile Number',
                                        fillColor: tlightGrayblue,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 2),
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),

                                        // border: OutlineInputBorder(

                                        //   borderRadius: BorderRadius.all(
                                        //     Radius.circular(10.0),
                                        //   ),
                                        // ),

                                        // enabledBorder: OutlineInputBorder(
                                        //     borderSide: BorderSide(color: tlightGray, width: 1.5),
                                        //     borderRadius: BorderRadius.circular(10)),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_userLatNameController.text.isEmpty &&
                      _userLatNameController.text == '') {
                    final snackBar = SnackBar(
                      content: const Text('please select country'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (_userLatNameController.text.length < 10) {
                    final snackBar = SnackBar(
                      content: const Text('number must be 10 digits'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    Twl.navigateTo(context, DigitCode(index: 1));
                  }
                },
                child: Center(
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: tPrimaryColor,
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
