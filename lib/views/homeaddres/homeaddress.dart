import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../conformdelivarydetails/conformdeliverydetails.dart';

class HomeAdress extends StatefulWidget {
  const HomeAdress({Key? key}) : super(key: key);

  @override
  State<HomeAdress> createState() => _HomeAdressState();
}

var btnColor = tIndicatorColor;
var selectedvalue;

class _HomeAdressState extends State<HomeAdress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1.2.h,
                    ),
                    Text(
                      'Home Address',
                      style: TextStyle(
                          color: tPrimaryColor,
                          fontSize: isTab(context) ? 20.sp : 23.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        'Postcode*',
                        style: TextStyle(
                            color: tTextSecondary,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 1.4.h,
                    ),
                    Container(
                      child: TextFormField(

                          //_phoneNumberController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                              fontSize: isTab(context) ? 10.sp : 14.sp),
                          decoration: InputDecoration(
                            // prefix: Text('+91 ',style: TextStyle(color: tBlack),),

                            hintStyle: TextStyle(
                                fontSize: isTab(context) ? 10.sp : 14.sp),
                            // hintText: 'Enter Your Mobile Number',
                            fillColor: tPrimaryTextformfield,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 2.4.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        'Address line 1*',
                        style: TextStyle(
                            color: tTextSecondary,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 1.4.h,
                    ),
                    Container(
                      child: TextFormField(
                        //_phoneNumberController,
                        keyboardType: TextInputType.text,
                        style:
                            TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
                        decoration: InputDecoration(
                          // prefix: Text('+91 ',style: TextStyle(color: tBlack),),

                          hintStyle: TextStyle(
                              fontSize: isTab(context) ? 10.sp : 14.sp),
                          // hintText: 'Enter Your Mobile Number',
                          fillColor: tPrimaryTextformfield,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
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
              onPressed: () async {
                //  Twl.navigateTo(context, ConfirmDeliveryDetails());
              }),
          SizedBox(
            height: 6.h,
          )
        ],
      ),
    );
  }
}
