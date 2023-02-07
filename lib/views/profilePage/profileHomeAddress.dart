// ignore_for_file: unused_field

import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';

class ProfileHomeAddress extends StatefulWidget {
  const ProfileHomeAddress({Key? key}) : super(key: key);

  @override
  State<ProfileHomeAddress> createState() => _ProfileHomeAddressState();
}

class _ProfileHomeAddressState extends State<ProfileHomeAddress> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Home Address",
                            style: TextStyle(
                                color: tPrimaryColor,
                                fontSize: isTab(context) ? 18.sp : 21.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Signika'),
                          ),
                          SizedBox(height: 45),
                          Text(
                            'Post Code*',
                            style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: TwlNormalTextField(
                              controller: _postCodeController,
                              validator: postCodeValidator,
                              textInputType: TextInputType.number,
                              inputForamtters: [
                                LengthLimitingTextInputFormatter(6)
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Address line 1*',
                            style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: TwlNormalTextField(
                              controller: _addressController,
                              validator: adressValidator,
                              textInputType: TextInputType.streetAddress,
                            ),
                          ),
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
                          bottonText: 'Confirm',
                          onTap: (startLoading, stopLoading, btnState) async {
                            if (_formKey.currentState!.validate()) {
                              Twl.navigateBack(context);
                            }
                            // _formKey.currentState!.validate();
                            // Twl.navigateBack(context);
                            // if (_formKey.currentState!.validate()) {
                            //   Twl.navigateTo(context, OtpPage());

                            // var res =await  UserAPI.sendOtp(context,_userNameController.text);
                            // if (res != null && res['status'] == 'OK'){ Twl.navigateTo(context, OtpPage());}
                          }
                          // stopLoading();
                          // }
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
    );
  }

  String? postCodeValidator(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
    }
    return null;
  }

  String? adressValidator(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
    }
    return null;
  }
}
