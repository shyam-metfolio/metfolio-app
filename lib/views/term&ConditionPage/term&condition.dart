import 'dart:async';

import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/button.dart';
import 'package:base_project_flutter/views/notificationPage/notification.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../responsive.dart';

class TermAndConditionPage extends StatefulWidget {
  const TermAndConditionPage({Key? key}) : super(key: key);

  @override
  State<TermAndConditionPage> createState() => _TermAndConditionPageState();
}

bool isChecked = false;
int val = -1;
var btnColor = tIndicatorColor;
  var selectedvalue;
class _TermAndConditionPageState extends State<TermAndConditionPage> {
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
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Term & Conditions',
                  style: TextStyle(
                      fontFamily: 'signika',
                      color: tPrimaryColor,
                      fontSize: isTab(context) ? 18.sp : 21.sp,
                      fontWeight: FontWeight.w500),
                )),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: tDefaultPadding + 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui.',
                  style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 9.sp : 12.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'Lorem Ipsum',
                  style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 9.sp : 12.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  'Blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi.Lorem ipsum dolor sit amet, cons ectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.',
                  style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 9.sp : 12.sp,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 1.h,
                ),
                // Text(
                //   "Lorem Ipsum",
                //   style: TextStyle(
                //       color: tBlack,
                //       fontSize: 15.sp,
                //       fontWeight: FontWeight.w500),
                // ),
                SizedBox(
                  height: 14.h,
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: tPrimaryColor,
                      checkColor: tBlack,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Text(
                      "By Checking this box, you agree to the metfolio term.",
                      style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 6.sp : 9.sp,
                          fontWeight: FontWeight.w400,
                          wordSpacing: -1),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Button(
                        borderSide: BorderSide(
                          color: tPrimaryColor,
                        ),
                        color: tPrimaryColor,
                        textcolor: tBlack,
                        bottonText: 'Continue',
                        onTap: (startLoading, stopLoading, btnState) {
                          // if (_formKey.currentState!.validate()) {
                          Twl.navigateTo(context, NotificationPage());
                          // }
                          // stopLoading();
                        }),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
