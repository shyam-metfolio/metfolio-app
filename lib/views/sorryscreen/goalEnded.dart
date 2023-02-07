import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../nameyourgoal/nameyourgoal.dart';

class GoalEndedScreen extends StatefulWidget {
  const GoalEndedScreen({Key? key}) : super(key: key);

  @override
  State<GoalEndedScreen> createState() => _GoalEndedScreenState();
}

class _GoalEndedScreenState extends State<GoalEndedScreen> {
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
                        'Goal ended',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: tPrimaryColor,
                            fontSize: isTab(context) ? 18.sp : 21.sp,
                            fontFamily: 'Signika',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Center(
                      child: Text(
                        'your gold has been added to your physical gold\nbalance',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
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
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Button(
                borderSide: BorderSide(
                  color: tPrimaryColor,
                ),
                color: tPrimaryColor,
                textcolor: tWhite,
                bottonText: 'Home',
                onTap: (startLoading, stopLoading, btnState) async {
                  Twl.navigateTo(
                      context,
                      BottomNavigation(
                        actionIndex: 0,
                        tabIndexId: 0,
                      ));
                }),
          ),
          SizedBox(
            height: 1.h,
          )
        ],
      ),
    );
  }
}
