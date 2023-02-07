import 'dart:async';

import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/sorryscreen/areYouSureScreen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';

class Sorry extends StatefulWidget {
  const Sorry({Key? key}) : super(key: key);

  @override
  State<Sorry> createState() => _SorryState();
}

class _SorryState extends State<Sorry> {
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.2.h,
                    ),
                    Center(
                      child: Text(
                        'Sorry, you can only\ncreate one goal at a time. ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Signika",
                            color: tPrimaryColor,
                            fontSize: isTab(context) ? 18.sp : 21.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Image.asset(
                      Images.GOLDS,
                      scale: 4,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Button(
                borderSide: BorderSide(
                  color: tPrimaryColor,
                ),
                color: tPrimaryColor,
                textcolor: tWhite,
                bottonText: 'Home',
                onTap: (startLoading, stopLoading, btnState) async {
                  Twl.navigateBack(context);
                  // Twl.navigateTo(context, BottomNavigation());
                }),
          ),
          SizedBox(
            height: 3.h,
          )
        ],
      ),
    );
  }
}
