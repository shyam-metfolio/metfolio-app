import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../logiPage/loginPage.dart';

class ChangedPasscode extends StatefulWidget {
  const ChangedPasscode({Key? key}) : super(key: key);

  @override
  State<ChangedPasscode> createState() => _ChangedPasscodeState();
}

class _ChangedPasscodeState extends State<ChangedPasscode> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:(){
        return Twl.navigateTo(context, BottomNavigation());
      } ,
      child: Scaffold(
        backgroundColor: tWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: tWhite,
          // leading: false,
          automaticallyImplyLeading: false,
          // leading: GestureDetector(
          //   onTap: () {
          //     Twl.navigateBack(context);
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 18),
          //     child: Image.asset(
          //       Images.NAVBACK,
          //       scale: 4,
          //     ),
          //   ),
          // ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text("Your passcode has\nbeen changed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Signika',
                            color: tPrimaryColor,
                            fontSize: isTab(context) ? 18.sp : 21.sp,
                            fontWeight: FontWeight.w700)),
                    // SizedBox(
                    //   height: 5.h,
                    // ),
                    // Center(
                    //   child: Text(
                    //     'Click continue to log in',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //         color: tSecondaryColor,
                    //         fontSize: isTab(context) ? 9.sp : 12.sp,
                    //         fontWeight: FontWeight.w400),
                    //   ),
                    // ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Image.asset(
                      Images.ACCOUNTEXISTS,
                      scale: 4,
                    )
                  ],
                )),
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
                      Twl.navigateTo(context, BottomNavigation());
                      // Twl.navigateTo(context, LoginPage());
                    }),
              ),
              SizedBox(
                height: 1.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
