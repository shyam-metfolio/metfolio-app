import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/button.dart';
import 'package:base_project_flutter/views/term&ConditionPage/term&condition.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../responsive.dart';

class FaceIdScreen extends StatefulWidget {
  const FaceIdScreen({Key? key}) : super(key: key);

  @override
  State<FaceIdScreen> createState() => _FaceIdScreenState();
}

class _FaceIdScreenState extends State<FaceIdScreen> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: tDefaultPadding * 2),
          child: Column(children: [
            Align(
                alignment: Alignment.center,
                child: Text(
                  'User Face ID?',
                  style: TextStyle(
                      fontFamily: 'signika',
                      color: tPrimaryColor,
                      fontSize: isTab(context) ? 18.sp : 21.sp,
                      fontWeight: FontWeight.w500),
                )),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  Images.FACEIDIMG,
                  scale: 4,
                ),
                SizedBox(
                  height: 35.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: tDefaultPadding * 2),
                  child: Container(
                    child: Button(
                        borderSide: BorderSide(
                          color: tPrimaryColor,
                        ),
                        color: tPrimaryColor,
                        textcolor: tBlack,
                        bottonText: 'Yes',
                        onTap: (startLoading, stopLoading, btnState) {
                          Twl.navigateTo(context, TermAndConditionPage());
                          // if (_formKey.currentState!.validate()) {
                          // Twl.navigateTo(context, FaceIdScreen());
                          // }
                          // stopLoading();
                        }),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: tDefaultPadding * 2),
                  child: Container(
                    child: Button(
                        borderSide: BorderSide(
                          color: tPrimaryColor,
                        ),
                        color: tPrimaryColor,
                        textcolor: tBlack,
                        bottonText: 'May be Later',
                        onTap: (startLoading, stopLoading, btnState) {
                          // if (_formKey.currentState!.validate()) {
                          Twl.navigateTo(context, TermAndConditionPage());
                          // }
                          // stopLoading();
                        }),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
