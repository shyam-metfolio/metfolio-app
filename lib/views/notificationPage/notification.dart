import 'dart:async';

import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/button.dart';
// import 'package:base_project_flutter/views/faceIdPage/faceId.dart';
// import 'package:base_project_flutter/views/selectandupdatedocPage/selectandUpdate.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../responsive.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = false;
  loader(value) {
    setState(() {
      isLoading = value;
    });
  }
var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                padding: const EdgeInsets.only(left: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Notifications',
                    style: TextStyle(
                        fontFamily: 'signika',
                        color: tPrimaryColor,
                        fontSize: isTab(context) ? 18.sp : 21.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Our app uses notifications to keep youup-to-date",
                      style: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w500,
                          color: tSecondaryColor),
                    )),
              ),
              Column(
                children: [
                  SizedBox(height: 17.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Button(
                        borderSide: BorderSide(
                          color: tPrimaryColor,
                        ),
                        color: tPrimaryColor,
                        textcolor: tBlack,
                        bottonText: 'Allow notifications',
                        onTap: (startLoading, stopLoading, btnState) async {
                          loader(true);
                          var res = await UserAPI()
                              .enableOrDisableNotification(context, '1');
                          print(res);
                          if (res['status'] == 'OK' && res != null) {
                            loader(false);
                            print(res['details']['notification_status']
                                .runtimeType);
                            Twl.navigateTo(
                                context,
                                BottomNavigation(
                                  actionIndex: 0,
                                  tabIndexId: 0,
                                ));
                          } else {
                            loader(false);
                          }
                        }),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Button(
                        borderSide: BorderSide(
                          color: tTextformfieldColor,
                        ),
                        color: tTextformfieldColor,
                        textcolor: tBlack,
                        bottonText: 'Maybe Later',
                        onTap: (startLoading, stopLoading, btnState) {
                          Twl.navigateTo(context, BottomNavigation());
                        }),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 16.h, right: 25),
                child: Image.asset(
                  "assets/icons/notificationicon.png",
                  // scale: 1.5.w,
                ),
              ),
            ]),
          ),
        ),
        if (isLoading)
          Center(
              child: Container(
            color: tBlack.withOpacity(0.3),
            // padding:
            //     EdgeInsets.only(top: 100),
            height: 100.h,
            width: 100.w,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: tPrimaryColor,
            ),
          ))
      ],
    );
  }
}
