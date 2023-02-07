import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';

class ProfileMobileNumber extends StatefulWidget {
  const ProfileMobileNumber({Key? key}) : super(key: key);

  @override
  State<ProfileMobileNumber> createState() => _ProfileMobileNumberState();
}

class _ProfileMobileNumberState extends State<ProfileMobileNumber> {
  final TextEditingController _mobileNumberController = TextEditingController();
  // final TextEditingController _countryCodeController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  String dropdownValue = '+44';
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
            padding: EdgeInsets.only(left: 20),
            child: Image.asset(
              Images.NAVBACK,
              scale: 4,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile Number",
                          style: TextStyle(
                            color: tPrimaryColor,
                            fontSize: isTab(context) ? 18.sp : 21.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Signika',
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: Row(
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
                                  items: <String>["+91", "+44", "+90", "+21"]
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: tSecondaryColor,
                                            fontSize:
                                                isTab(context) ? 13.sp : 16.sp),
                                      ),
                                    );
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
                                  padding: EdgeInsets.only(right: 30),
                                  child: Container(
                                    child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "number should be entered";
                                          } else {
                                            return null;
                                          }
                                        },
                                        controller: _mobileNumberController,
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
                                              fontSize: isTab(context)
                                                  ? 10.sp
                                                  : 14.sp),
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
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
                  child: Align(
                    alignment: Alignment.center,
                    child: Button(
                      borderSide: BorderSide.none,
                      color: tPrimaryColor,
                      textcolor: tWhite,
                      bottonText: 'Continue',
                      onTap: (startLoading, stopLoading, btnState) async {
                        if (_mobileNumberController.text.isEmpty &&
                            _mobileNumberController.text == '') {
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
                        } else if (_mobileNumberController.text.length < 10) {
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
                          Twl.navigateBack(context);
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
    );
  }

  String mobileNumberValidator(String? value) {
    if (value!.isEmpty && value == '') {
      return "MobileNumber can't be empty";
    } else if (value.length > 10 && value.length < 10) {
      return "MobileNumber must be be 10 digits";
    }
    return '';
  }
}
