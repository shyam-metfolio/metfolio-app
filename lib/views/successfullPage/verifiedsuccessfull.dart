import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/button.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../loginPassCodePages/createYourPasscode.dart';

class VerifiedSucessful extends StatelessWidget {
  final int index;
  VerifiedSucessful({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tWhite,
        // leading: GestureDetector(
        //   onTap: () {
        //     Twl.navigateBack(context);
        //   },
        //   child: Image.asset(
        //     Images.NAVBACK,
        //     scale: 4,
        //   ),
        // ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Successful',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: tPrimaryColor,
                            fontFamily: "Signika",
                            fontSize: isTab(context) ? 18.sp : 21.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 19),
                      child: Image.asset(
                        Images.SUCESSFULL,
                        scale: 4,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Text(
                        ' Your identity is verified!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: tSecondaryColor,
                            fontFamily: "Signika",
                            fontSize: isTab(context) ? 13.sp : 16.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 20.w),
          //   child: Button(
          //       borderSide: BorderSide(
          //         color: tPrimaryColor,
          //       ),
          //       color: tPrimaryColor,
          //       textcolor: tWhite,
          //       bottonText: 'Continue',
          //       onTap: (startLoading, stopLoading, btnState) async {
          //         if (index == 1) {
          //           Twl.navigateTo(context, CreateYourPassCode());
          //         }
          //       }),
          // ),
          // SizedBox(
          //   height: 3.h,
          // )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () {
          Twl.navigateTo(
              context,
              CreateYourPassCode(
                loginFlow: false,
              ));
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Container(
          // height: 10.h,
          width: 40.w,
          child: Center(
            child: Text(
              'Home',
              style: TextStyle(
                  color: tSecondaryColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            ),
          ),
        ),
        backgroundColor: tPrimaryColor,
      ),
    );
  }
}
