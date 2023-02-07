import 'dart:io';

import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/Splash2/Splash2.dart';
import 'package:base_project_flutter/views/veriffPage/veriffPage.dart';
import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/imageConstant.dart';
import '../../extra.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../logiPage/loginPage.dart';
import '../yourDetails/yourDetails.dart';
import 'profilePrivacyPolicy.dart';
import 'profileTermsConditins.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late SharedPreferences sharedPreferences;
  var mobileNo;
  var email;
  var firstname;
  var check;
  var profileImage;
  var authCode;
  var details;
  var lastName;
  @override
  void initState() {
    checkLoginStatus();
    // TODO: implement initState
    super.initState();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    authCode = sharedPreferences.getString('authCode');
    check = await UserAPI().checkApi(sharedPreferences.getString('authCode')!);
    print(check);
    if (check != null && check['status'] == 'OK') {
      setState(() {
        details = check['detail'];
      });
      sharedPreferences.setString(
          'contactnumber', check['detail']['contact_no'].toString());
      sharedPreferences.setString('email', check['detail']['email'].toString());

      sharedPreferences.setString(
          'username', check['detail']['first_name'].toString());
      sharedPreferences.setString('lastName', check['detail']['last_name']);
      if (check['detail']['profile_image'] != null) {
        sharedPreferences.setString(
            "profile_image", check['detail']['profile_image']);
      }
    }

    setState(() {
      mobileNo = sharedPreferences.getString("contactnumber") != null
          ? sharedPreferences.getString("contactnumber")
          : ' ';
      print(mobileNo);
      email = sharedPreferences.getString('email') != null
          ? sharedPreferences.getString('email')
          : ' ';
      firstname = sharedPreferences.getString('username') != null
          ? sharedPreferences.getString('username')
          : ' ';
      lastName = sharedPreferences.getString('lastName') != null
          ? sharedPreferences.getString('lastName')
          : '';
      profileImage = sharedPreferences.getString('profile_image') != null
          ? sharedPreferences.getString('profile_image')
          : 'https://img.icons8.com/bubbles/50/000000/user.png';
    });
  }

  var btnColor = tTextformfieldColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (firstname ?? '') + ' ' + (lastName ?? ''),
                  style: TextStyle(
                    color: tPrimaryColor,
                    fontSize: isTab(context) ? 18.sp : 21.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Signika',
                  ),
                ),
                if (firstname != null && lastName != null)
                  CircleAvatar(
                    backgroundColor: tPrimaryColor,
                    radius: isTab(context) ? 50 : 40,
                    child: Center(
                      child: Text(
                        (firstname[0].toUpperCase() ?? '') +
                            (lastName[0].toUpperCase() ?? ''),
                        style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 19.sp : 22.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(height: 3.h),
            ArgonButton(
              // height: 40,
              // focusElevation: 0,
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              // : BoxDecoration(

              //     borderRadius: BorderRadius.circular(10)),
              // padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              // onTapDown: (v) {
              //   setState(() {
              //     selectedvalue = 1;
              //     btnColor = tTabColor.withOpacity(0.8);
              //   });
              // },
              // onTapUp: (v) {
              //   Timer(Duration(milliseconds: 100), () {
              //     setState(() {
              //       selectedvalue = null;
              //       btnColor = Colors.transparent;
              //     });
              //   });
              // },

              onTap: (startLoading, stopLoading, btnState) async {
                // print("asdcsa");
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                var userId = sharedPreferences.getString('userId');
                await Intercom.instance.loginIdentifiedUser(userId: userId);
                await Intercom.instance.updateUser(
                    name: details['first_name'] + ' ' + details['last_name'],
                    phone: details['username'].toString(),
                    email: details['email']);
                await Intercom.instance.displayMessenger();
                // Twl.navigateTo(context, Sorry());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    Images.PHELP,
                    scale: isTab(context) ? 3 : 4,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Help',
                    style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 9.sp : 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              // optionsWidget('Help', Images.PHELP, 1, context)
            ),
            SizedBox(height: 3.h),
            Text(
              'Profile',
              style: TextStyle(
                color: tSecondaryColor,
                fontSize: isTab(context) ? 13.sp : 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Signika',
              ),
            ),
            SizedBox(height: 1.5.h),
            ArgonButton(
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              onTap: (startLoading, stopLoading, btnState) {
                Twl.navigateTo(
                    context,
                    YourDetails(
                      details: details,
                    ));
              },
              child: Container(
                // height: isTab(context) ? 50 : 35,
                // decoration: BoxDecoration(
                //     color: selectedvalue == 2 ? btnColor : tTextformfieldColor,
                //     borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.PDEATILS,
                      scale: isTab(context) ? 3 : 4,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Personal Details',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 3.h),
            Text(
              'Verification',
              style: TextStyle(
                color: tSecondaryColor,
                fontSize: isTab(context) ? 13.sp : 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Signika',
              ),
            ),
            SizedBox(height: 1.5.h),
            ArgonButton(
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              onTap: (startLoading, stopLoading, btnState) {
                if (verificationStatus == 3) Twl.navigateTo(context, Extra());
              },
              child: Container(
                // height: isTab(context) ? 50 : 35,
                // decoration: BoxDecoration(
                //     color: selectedvalue == 2 ? btnColor : tTextformfieldColor,
                //     borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/ID.png',
                          scale: isTab(context) ? 3 : 4,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          verificationStatus == 3
                              ? 'Verify my ID'
                              : 'Verification Complete!!!',
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    verificationStatus == 3
                        ? Image.asset(
                            Images.NEXTICON,
                            scale: isTab(context) ? 3 : 4,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            // optionsWidget('Personal Details', Images.PDEATILS, 2, context,),
            SizedBox(height: 4.h),
            Text(
              'About Us',
              style: TextStyle(
                color: tSecondaryColor,
                fontSize: isTab(context) ? 13.sp : 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Signika',
              ),
            ),
            SizedBox(height: 1.5.h),
            ArgonButton(
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              onTap: (startLoading, stopLoading, btnState) {
                if (Platform.isIOS) {
                  Twl.launchURL(context, appStoreUrl);
                } else {
                  Twl.launchURL(context, playStoreUrl);
                }
              },
              child: Container(
                // height: isTab(context) ? 50 : 35,
                // decoration: BoxDecoration(
                //     color: selectedvalue == 3 ? btnColor : tTextformfieldColor,
                //     borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.RATEUS,
                      scale: isTab(context) ? 3 : 4,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Rate us on the ${Platform.isIOS ? 'App ' : 'Play '}Store',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ArgonButton(
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              onTap: (startLoading, stopLoading, btnState) {
                Twl.launchURL(context, facebookUrl);
              },
              child: Container(
                // height: isTab(context) ? 50 : 35,
                // decoration: BoxDecoration(
                //     color: selectedvalue == 4 ? btnColor : tTextformfieldColor,
                //     borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.FACEBOOK,
                      scale: isTab(context) ? 3 : 4,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Follow us on Facebook',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ArgonButton(
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              onTap: (startLoading, stopLoading, btnState) {
                Twl.launchURL(context, tikTokUrl);
              },
              child: Container(
                // height: isTab(context) ? 50 : 35,
                // decoration: BoxDecoration(
                //     color: selectedvalue == 5 ? btnColor : tTextformfieldColor,
                //     borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.TIKTOK,
                      scale: isTab(context) ? 3 : 4,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Follow us on TikTok',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ArgonButton(
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              onTap: (startLoading, stopLoading, btnState) {
                Twl.launchURL(context, instaGramUrl);
              },
              child: Container(
                // height: isTab(context) ? 50 : 35,
                // decoration: BoxDecoration(
                //     color: selectedvalue == 6 ? btnColor : tTextformfieldColor,
                //     borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.INSTA,
                      scale: isTab(context) ? 3 : 4,
                    ),
                    SizedBox(width: 4.5.w),
                    Text(
                      'Follow us on Instagram',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ArgonButton(
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              onTap: (startLoading, stopLoading, btnState) {
                Twl.launchURL(context, privacyUrl);
              },
              child: Container(
                // height: isTab(context) ? 50 : 35,
                // decoration: BoxDecoration(
                //     color: selectedvalue == 7 ? btnColor : tTextformfieldColor,
                //     borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.PRIVACY,
                      scale: isTab(context) ? 3 : 4,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            ArgonButton(
              highlightElevation: 0,
              width: 80.w,
              color: tTextformfieldColor,
              elevation: 0,
              borderRadius: 10,
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
              height: isTab(context) ? 50 : 35,
              // highlightColor: btnColor,
              onTap: (startLoading, stopLoading, btnState) {
                Twl.launchURL(context, termsAndConditonsUrl);
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.TERMS,
                      scale: isTab(context) ? 3 : 4,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Align(
                alignment: Alignment.center,
                child: Button(
                  borderSide: BorderSide.none,
                  color: tPrimaryColor,
                  textcolor: tWhite,
                  bottonText: 'Log out',
                  onTap: (startLoading, stopLoading, btnState) async {
                    if (check != null && check['status'] == 'OK') {
                      showDialog(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: tlightGrayblue,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            // title: const Text(
                            //     'Are you sure you want to Logout..?'),
                            actions: <Widget>[
                              Center(
                                child: Card(
                                    elevation: 0,
                                    color: tlightGrayblue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height: 350,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Are you sure you want to log out?",
                                                  style: TextStyle(
                                                      color: tSecondaryColor,
                                                      fontSize: isTab(context)
                                                          ? 13.sp
                                                          : 16.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      SharedPreferences
                                                          sharedPreferences =
                                                          await SharedPreferences
                                                              .getInstance();

                                                      var res = await UserAPI()
                                                          .logout(context);
                                                      print(res);
                                                      if (res != null &&
                                                          res['status'] ==
                                                              'OK') {
                                                        await sharedPreferences
                                                            .clear();
                                                        sharedPreferences
                                                            .remove(authCode);
                                                        Twl.navigateTo(context,
                                                            MyHomePage());
                                                      } else {
                                                        // Twl.navigateTo(context, LoginPage());
                                                        AwesomeDialog(
                                                            context: context,
                                                            dialogType:
                                                                DialogType
                                                                    .ERROR,
                                                            animType: AnimType
                                                                .RIGHSLIDE,
                                                            headerAnimationLoop:
                                                                true,
                                                            title:
                                                                'Logout Failed',
                                                            desc:
                                                                'Please retry',
                                                            btnOkOnPress: () {
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (context) => MainScreen()));
                                                            },
                                                            btnOkIcon:
                                                                Icons.cancel,
                                                            btnOkColor:
                                                                Colors.red);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: 150,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: tPrimaryColor,
                                                      ),
                                                      child: Center(
                                                          child: Text('Logout',
                                                              style: TextStyle(
                                                                  color:
                                                                      tSecondaryColor,
                                                                  fontSize: isTab(
                                                                          context)
                                                                      ? 9.sp
                                                                      : 12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400))),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Twl.navigateBack(context);
                                                    },
                                                    child: Container(
                                                      width: 150,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: tPrimaryColor),
                                                      child: Center(
                                                          child: Text(
                                                              'Stay signed in',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color:
                                                                    tSecondaryColor,
                                                                fontSize: isTab(
                                                                        context)
                                                                    ? 9.sp
                                                                    : 12.sp,
                                                              ))),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2.h,
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    )),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     GestureDetector(
                              //       onTap: () {
                              //         Twl.navigateBack(context);
                              //       },
                              //       child: Container(
                              //         alignment: Alignment.center,
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 4, horizontal: 10),
                              //         decoration: BoxDecoration(
                              //             // gradient: tPrimaryGradientColor,
                              //             border: Border.all(
                              //                 width: 1, color: tPrimaryColor),
                              //             borderRadius:
                              //                 BorderRadius.circular(6)),
                              //         child: Text(
                              //           'Cancel',
                              //           style: TextStyle(color: tPrimaryColor),
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 30,
                              //     ),
                              //     GestureDetector(
                              //       onTap: () async {
                              //         SharedPreferences sharedPreferences =
                              //             await SharedPreferences.getInstance();

                              //         var res = await UserAPI().logout(context);
                              //         print(res);
                              //         if (res != null &&
                              //             res['status'] == 'OK') {
                              //           await sharedPreferences.clear();
                              //           sharedPreferences.remove(authCode);
                              //           Twl.navigateTo(context, LoginPage());
                              //         } else {
                              //           // Twl.navigateTo(context, LoginPage());
                              //           AwesomeDialog(
                              //               context: context,
                              //               dialogType: DialogType.ERROR,
                              //               animType: AnimType.RIGHSLIDE,
                              //               headerAnimationLoop: true,
                              //               title: 'Logout Failed',
                              //               desc: 'Please retry',
                              //               btnOkOnPress: () {
                              //                 // Navigator.push(
                              //                 //     context,
                              //                 //     MaterialPageRoute(
                              //                 //         builder: (context) => MainScreen()));
                              //               },
                              //               btnOkIcon: Icons.cancel,
                              //               btnOkColor: Colors.red);
                              //         }
                              //       },
                              //       child: Container(
                              //         alignment: Alignment.center,
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 4, horizontal: 10),
                              //         decoration: BoxDecoration(
                              //             // gradient: tPrimaryGradientColor,
                              //             border: Border.all(
                              //                 width: 1, color: tPrimaryColor),
                              //             borderRadius:
                              //                 BorderRadius.circular(6)),
                              //         child: Text(
                              //           'OK',
                              //           style: TextStyle(color: tPrimaryColor),
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // )
                            ],
                          );
                        },
                      );
                    } else {
                      Twl.navigateTo(context, MyHomePage());
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            )
          ],
        ),
      ),
    );
  }

  Widget optionsWidget(
      String title, String imgUrl, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 8) {
          Twl.navigateTo(context, ProfileTermsAndConditions());
        } else if (index == 2) {
          Twl.navigateTo(context, YourDetails());
        } else if (index == 7) {
          Twl.navigateTo(context, ProfilePrivacyPolicy());
        }
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            color: tTextformfieldColor,
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              imgUrl,
              scale: 4,
            ),
            SizedBox(width: 4.5.w),
            Text(
              title,
              style: TextStyle(
                color: tSecondaryColor,
                fontSize: isTab(context) ? 9.sp : 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
