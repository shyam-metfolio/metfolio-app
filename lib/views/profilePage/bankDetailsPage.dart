import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:base_project_flutter/views/successfullPage/deliverySucessfull.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({Key? key}) : super(key: key);

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _banknameController = TextEditingController();
  TextEditingController _sortCodeController = TextEditingController();
  TextEditingController _accountController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                          Text(
                            "Bank Details",
                            style: TextStyle(
                              color: tPrimaryColor,
                              fontSize: isTab(context) ? 18.sp : 21.sp,
                              // fontWeight: FontWeight.w500,
                              fontFamily: 'Signika',
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            "When selling gold on Metfolio, we will deposit your funds into the bank account",
                            style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              // fontWeight: FontWeight.w500,
                              // fontFamily: 'Signika',
                            ),
                          ),
                          SizedBox(height: 3.h),
                          titleWidget(
                              'Full Name(as shown in your bank account)'),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: TwlNormalTextField(
                              controller: _nameController,
                              textInputType: TextInputType.name,
                              validator: usernameValidator,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          titleWidget('Bank Name'),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.only(right: 6.w),
                            child: TwlNormalTextField(
                              controller: _banknameController,
                              textInputType: TextInputType.name,
                              validator: banknameValidator,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          titleWidget('Sort Code'),
                          SizedBox(height: 1.h),
                          Padding(
                              padding: EdgeInsets.only(right: 40.w),
                              child: TwlNormalTextField(
                                controller: _sortCodeController,
                                textInputType: TextInputType.number,
                                validator: sortCodevalidate,
                              )),
                          SizedBox(height: 2.h),
                          titleWidget('Account Number'),
                          SizedBox(height: 1.h),
                          Padding(
                              padding: EdgeInsets.only(right: 40.w),
                              child: TwlNormalTextField(
                                controller: _accountController,
                                textInputType: TextInputType.number,
                                inputForamtters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: accountValidate,
                              )),
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
                            // //startLoading();
                            if (_formKey.currentState!.validate()) {
                              Twl.navigateTo(context, DeliverySucessful());
                            }

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

  String? usernameValidator(String? username) {
    if (username!.isEmpty || username == '') {
      return "";
    }
    return null;
  }

  String? banknameValidator(String? bankNme) {
    if (bankNme!.isEmpty) {
      return "";
    }
    return null;
  }

  String? sortCodevalidate(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
    }
    return null;
  }

  String? accountValidate(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
    }
    return null;
  }

  titleWidget(String title) {
    return Text(
      title,
      style: TextStyle(
        color: tSecondaryColor,
        fontSize: isTab(context) ? 9.sp : 12.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget textFormField(TextEditingController controller, TextInputType type,
      String Function(String?) validator) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator,
      style: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
      decoration: InputDecoration(
        // prefix: Text('+91 ',style: TextStyle(color: tBlack),),

        hintStyle: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
        // hintText: 'Enter Your Mobile Number',
        fillColor: tPrimaryTextformfield,
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
      ),
    );
  }
}
