// ignore_for_file: unused_field

import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/conformdelivarydetails/conformdeliverydetails.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../PersonalDetails/PersonalDetails.dart';

class DeliveryHomeAddress extends StatefulWidget {
  const DeliveryHomeAddress({Key? key}) : super(key: key);

  @override
  State<DeliveryHomeAddress> createState() => _DeliveryHomeAddressState();
}

class _DeliveryHomeAddressState extends State<DeliveryHomeAddress> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _postCodeControlller = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Twl.navigateTo(
                              context,
                              PersonalDetails(
                                isLoadingFlow: true,
                              ));
                        },
                        child: Text(
                          "Home Address",
                          style: TextStyle(
                              color: tPrimaryColor,
                              fontSize: isTab(context) ? 18.sp : 21.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Signika'),
                        ),
                      ),
                      // SizedBox(height: 25),
                      // Text("We require your home address to open your account",
                      //     style: TextStyle(
                      //         color: tSecondaryColor,
                      //         fontSize: isTab(context) ? 10.sp : 13.sp,
                      //         fontWeight: FontWeight.w400)),
                      SizedBox(height: 20),
                      Text('Post Code*',
                          style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w400)),
                      SizedBox(height: 10),

                      // SizedBox(
                      //   height: tDefaultPadding * 2,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: TwlNormalTextField(
                          controller: _postCodeControlller,
                          textInputType: TextInputType.number,
                          inputForamtters: [
                            LengthLimitingTextInputFormatter(6)
                          ],
                          validator: validatepostCode,
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
                          controller: _addressLineController,
                          textInputType: TextInputType.streetAddress,
                          validator: validateAddress,
                        ),
                      ),
                    ],
                  ))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Align(
                      alignment: Alignment.center,
                      child: Button(
                        borderSide: BorderSide.none,
                        color: tPrimaryColor,
                        textcolor: tWhite,
                        bottonText: 'Continue',
                        onTap: (startLoading, stopLoading, btnState) async {
                          if (_formKey.currentState!.validate()) {
                            // Twl.navigateTo(context, ConfirmDeliveryDetails());
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
      ),
    );
  }

  String? validatepostCode(String? value) {
    if (value!.isEmpty) {
      return "";
      // return "Postcode can't be empty";
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value!.isEmpty) {
      return "";
      // return "Address can't be empty";

    }
    return null;
  }
}
