import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:base_project_flutter/api_services/stripeApi.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/views/Splash2/Splash2.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/profilePage/profileBankDetails.dart';
import 'package:base_project_flutter/views/profilePage/profileOriginalPassCode.dart';
import 'package:base_project_flutter/views/profilePage/profilepaymentDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../logiPage/loginPage.dart';
import '../loginPassCodePages/createYourPasscode.dart';
import '../paymentdetails/paymentdetails.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  void initState() {
    checkLoginStatus();
    super.initState();

    // getCardDeatils();
  }

  int? groupValue;
  String? ischeced;
  bool isFaceId = true;
  bool isNotifications = false;
  var authCode;
  var cardDetails;
  var cusId;
  var defPmId;
  var notificationValue = 0;

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    authCode = sharedPreferences.getString('authCode');
    var res =
        await UserAPI().checkApi(sharedPreferences.getString('authCode')!);
    print(res);
    if (res != null && res['status'] == 'OK') {
      setState(() {
        if (res['detail']['notification_status'] != null) {
          notificationValue = res['detail']['notification_status'];
        } else {
          notificationValue = 0;
        }
      });
    }
  }
  // getCardDeatils() async {
  //   getBankDetails();
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     authCode = sharedPreferences.getString(
  //       "authCode",
  //     );
  //   });

  //   var check = await UserAPI().checkApi(authCode);

  //   if (check != null && check['status'] == 'OK') {
  //     setState(() {
  //       cusId = check['detail']['stripe_cus_id'];
  //     });
  //     var res = await StripePaymentApi().getCustomerCards(context, cusId);

  //     if (res != null) {
  //       setState(() {
  //         cardDetails = res['data'];
  //       });
  //       print(cardDetails);
  //       print(cardDetails.length);
  //     }
  //   }

  //   var cusDetails =
  //       await StripePaymentApi().getCustomerPaymentDetails(context, cusId);
  //   if (cusDetails != null) {
  //     setState(() {
  //       defPmId = cusDetails['invoice_settings']['default_payment_method'];
  //     });
  //     print(defPmId);
  //   }
  // }

  // var bankDetails;
  // getBankDetails() async {
  //   var res = await UserAPI().getBankDetails(context);
  //   print('getBankDetails >>>>>>>>>>>>>>>');
  //   print(res);
  //   if (res != null && res['status'] == 'OK') {
  //     setState(() {
  //       bankDetails = res['details'];
  //     });
  //   }
  //   // else {
  //   //   Twl.createAlert(context, 'error', res['error']);
  //   // }
  // }

  var selectedIndex = 0;
  var btnColor = tTextformfieldColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.h),
            Text(
              'Settings',
              style: TextStyle(
                color: tPrimaryColor,
                fontSize: isTab(context) ? 18.sp : 21.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Signika',
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Security',
              style: TextStyle(
                color: tSecondaryColor,
                fontSize: isTab(context) ? 13.sp : 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Signika',
              ),
            ),
            // faceId
            SizedBox(height: 2.h),
            // if (!Platform.isIOS)
            //   Container(
            //     decoration: BoxDecoration(
            //       color: tTextformfieldColor,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Expanded(
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             children: [
            //               Image.asset(
            //                 Images.FACEID,
            //                 height: 30,
            //               ),
            //               SizedBox(width: 3.w),
            //               Text(
            //                 'Face ID lock',
            //                 style: TextStyle(
            //                   color: tSecondaryColor,
            //                   fontSize: isTab(context) ? 9.sp : 12.sp,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Transform.scale(
            //           scale: 0.8,
            //           child: CupertinoSwitch(
            //             activeColor: tSecondaryColor,
            //             value: isFaceId,
            //             onChanged: (value) {
            //               setState(() {
            //                 isFaceId = value;
            //               });
            //             },
            //           ),
            //         )
            //       ],
            //     ),
            //   ),
            // toggleWidget(isFaceId, Images.FACEID, 'Face ID lock', 1),
            // changePassCode
            SizedBox(height: 1.5.h),
            GestureDetector(
              onTapDown: (v) {
                setState(() {
                  selectedvalue = 1;
                  btnColor = tTabColor.withOpacity(0.8);
                });
              },
              onTapUp: (v) {
                Timer(Duration(milliseconds: 100), () {
                  setState(() {
                    selectedvalue = null;
                    btnColor = tTextformfieldColor;
                  });
                });
              },
              onTap: () async {
                SharedPreferences sharedPrefs =
                    await SharedPreferences.getInstance();
                var userId = sharedPrefs.getString('userId');
                FirebaseFirestore.instance
                    .collection('users')
                    .where('userId', isEqualTo: userId.toString())
                    .get()
                    .then((QuerySnapshot snapshot) async {
                  // print("isPasscodeExist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
                  // print(userData.data()?['userId']);
                  if (snapshot.docs.length > 0) {
                    if (snapshot.docs[0].data() != null) {
                      Twl.navigateTo(context, ProfileOriginalPasscode());
                    } else {
                      Twl.navigateTo(
                          context,
                          CreateYourPassCode(
                            loginFlow: false,
                          ));
                    }
                    // print(snapshot.docs[0].data());
                  } else {
                    Twl.navigateTo(
                        context,
                        CreateYourPassCode(
                          loginFlow: false,
                        ));
                  }
                });
                // FirebaseFirestore.instance
                //     .collection('users')
                //     .doc(userId.toString())
                //     .snapshots()
                //     .listen((userData) {
                //   setState(() {
                //     if (userData.data()?['userId'] != null) {
                //       Twl.navigateTo(context, ProfileOriginalPasscode());
                //     } else {
                //       Twl.navigateTo(context, CreateYourPassCode(loginFlow: false,));
                //     }
                //   });
                // });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedvalue == 1 ? btnColor : tTextformfieldColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      Images.PASSCODE,
                      height: 25,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Change Passcode',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.5.h),
            Container(
              decoration: BoxDecoration(
                color: tTextformfieldColor,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          Images.NOTIFICATION,
                          height: 25,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Notifications',
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      activeColor: tSecondaryColor,
                      value: notificationValue == 0 ? isNotifications : true,
                      onChanged: (value) async {
                        var res = await UserAPI().enableOrDisableNotification(
                            context,
                            notificationValue == 0
                                ? 1.toString()
                                : 0.toString());
                        print(res);
                        if (res['status'] == 'OK' && res != null) {
                          print(res['details']['notification_status']
                              .runtimeType);
                          setState(() {
                            notificationValue =
                                res['details']['notification_status'];
                          });
                        } else {}
                        // setState(() {
                        //   isNotifications = value;
                        // });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            if (Platform.isIOS)
              GestureDetector(
                onTapDown: (v) {
                  setState(() {
                    selectedvalue = 2;
                    btnColor = tTabColor.withOpacity(0.8);
                  });
                },
                onTapUp: (v) {
                  Timer(Duration(milliseconds: 100), () {
                    setState(() {
                      selectedvalue = null;
                      btnColor = tTextformfieldColor;
                    });
                  });
                },
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: tTextformfieldColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        // title: const Text('Are you sure you want to exit?'),
                        // content: SingleChildScrollView(
                        //   child: ListBody(
                        //     children: const <Widget>[
                        //       Text('This is a demo alert dialog.'),
                        //       Text('Would you like to approve of this message?'),
                        //     ],
                        //   ),
                        // ),
                        actions: <Widget>[
                          Column(
                            children: [
                              Center(
                                child: Card(
                                    elevation: 0,
                                    color: tTextformfieldColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height: 290,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  'Are you sure you want to delete your account',
                                                  style: TextStyle(
                                                      color: tSecondaryColor,
                                                      fontSize: isTab(context)
                                                          ? 13.sp
                                                          : 18.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  'If you have assets in your account, we will contact you within 24 hours of requesting deletion',
                                                  style: TextStyle(
                                                      color: tSecondaryColor,
                                                      fontSize: isTab(context)
                                                          ? 8.sp
                                                          : 10.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    SharedPreferences
                                                        sharedPreferences =
                                                        await SharedPreferences
                                                            .getInstance();

                                                    var res = await UserAPI()
                                                        .deleteUser(softDelete);
                                                    print(res);
                                                    if (res != null &&
                                                        res['status'] == 'OK') {
                                                      await sharedPreferences
                                                          .clear();
                                                      sharedPreferences
                                                          .remove(authCode);
                                                      Twl.navigateTo(context,
                                                          MyHomePage());
                                                    } else {
                                                      AwesomeDialog(
                                                          context: context,
                                                          dialogType:
                                                              DialogType.ERROR,
                                                          animType: AnimType
                                                              .RIGHSLIDE,
                                                          headerAnimationLoop:
                                                              true,
                                                          title:
                                                              'Logout Failed',
                                                          desc: 'Please retry',
                                                          btnOkOnPress: () {},
                                                          btnOkIcon:
                                                              Icons.cancel,
                                                          btnOkColor:
                                                              Colors.red);
                                                    }
                                                  },
                                                  child: Container(
                                                    width: 40.w,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        color: tPrimaryColor,
                                                        // gradient: tPrimaryGradientColor,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                tPrimaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color:
                                                              tSecondaryColor),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Twl.navigateBack(context);
                                                  },
                                                  child: Container(
                                                    width: 40.w,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        // gradient: tPrimaryGradientColor,
                                                        color: tPrimaryColor,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                tPrimaryColor),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Text(
                                                      'Keep my account',
                                                      style: TextStyle(
                                                          color:
                                                              tSecondaryColor),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [],
                                              )
                                            ]),
                                      ),
                                    )),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedvalue == 2 ? btnColor : tTextformfieldColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Image.asset(
                      //   Images.PASSCODE,
                      //   height: 25,
                      // ),
                      SizedBox(width: 3.w),
                      Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 4.h),
            // Text(
            //   "To delete your Metfolio account, please click on 'help' in the 'Dashboard' or 'Profile' section and process your request on live chat.",
            //   style: TextStyle(
            //     color: tSecondaryColor,
            //     fontSize: isTab(context) ? 8.sp : 9.5.sp,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            // SizedBox(height: 2.h),
            // Text(
            //   "We will be happy to process your request.",
            //   style: TextStyle(
            //     color: tSecondaryColor,
            //     fontSize: isTab(context) ? 8.sp : 9.5.sp,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            // // toggleWidget(isNotifications, Images.FACEID, 'Notifications', 2),
            // SizedBox(height: 4.h),
            // Text(
            //   'Connected payment methods',
            //   style: TextStyle(
            //     color: tSecondaryColor,
            //     fontSize: isTab(context) ? 13.sp : 16.sp,
            //     fontWeight: FontWeight.w400,
            //     fontFamily: 'Signika',
            //   ),
            // ),
            // SizedBox(height: 1.h),
            // Text(
            //   'The checked payment method is used by default for all purchasing on Metfolio',
            //   style: TextStyle(
            //     color: tSecondaryColor,
            //     fontSize: isTab(context) ? 6.sp : 9.sp,
            //     fontWeight: FontWeight.w400,
            //   ),
            //   maxLines: 2,
            // ),
            // SizedBox(height: 2.h),
            // if (cardDetails != null)
            //   MediaQuery.removePadding(
            //     context: context,
            //     removeBottom: true,
            //     child: ListView.builder(
            //       itemCount: cardDetails.length,
            //       shrinkWrap: true,
            //       scrollDirection: Axis.vertical,
            //       physics: ScrollPhysics(),
            //       itemBuilder: (context, index) {
            //         return paymentMethodWidget(cardDetails[index]['id'],
            //             cardDetails[index]['card']['last4'], defPmId);
            //       },
            //     ),
            //   ),
            // SizedBox(height: 1.5.h),
            // Align(
            //   alignment: Alignment.center,
            //   child: Container(
            //     width: double.infinity,
            //     child: Button(
            //         borderSide: BorderSide.none,
            //         color: tTextformfieldColor,
            //         // textcolor: tWhite,
            //         bottonText: 'Add new payment method',
            //         onTap: (startLoading, stopLoading, btnState) async {
            //           var cusID = cusId;
            //           if (cusId == null || cusId == '') {
            //             var customerRes =
            //                 await UserAPI().createCustomer(context);
            //             print(customerRes);
            //             if (customerRes != null &&
            //                 customerRes['status'] == "OK") {
            //               setState(() {
            //                 cusId = customerRes['details']['stripe_cus_id'];
            //               });

            //               Twl.navigateTo(
            //                   context,
            //                   PaymentDetails(
            //                     customerId: cusID,
            //                     // pmId: cardDetails['id'].toString(),
            //                   ));
            //             }else{
            //               Twl.createAlert(context, 'error', customerRes['error']);
            //             }
            //           }
            //           // //startLoading();
            //         }),
            //   ),
            // ),
            // SizedBox(height: 4.h),
            // Text(
            //   'Connected bank account',
            //   style: TextStyle(
            //     color: tSecondaryColor,
            //     fontSize: isTab(context) ? 13.sp : 16.sp,
            //     fontWeight: FontWeight.w600,
            //     fontFamily: 'Signika',
            //   ),
            // ),
            // SizedBox(height: 1.h),
            // Text(
            //   'When selling gold on Metfolio, we will deposit your funds into the bank account selected',
            //   style: TextStyle(
            //     color: tSecondaryColor,
            //     fontSize: isTab(context) ? 6.sp : 9.sp,
            //     fontWeight: FontWeight.w400,
            //   ),
            //   maxLines: 2,
            // ),
            // SizedBox(height: 1.h),
            // if (bankDetails != null)
            //   MediaQuery.removePadding(
            //     context: context,
            //     removeBottom: true,
            //     child: ListView.builder(
            //       itemCount: bankDetails.length,
            //       shrinkWrap: true,
            //       scrollDirection: Axis.vertical,
            //       physics: ScrollPhysics(),
            //       itemBuilder: (context, index) {
            //         return bankAccountWidget(
            //             '${bankDetails[index]['full_name']} \n ${bankDetails[index]['bank_name']} \n Sort Code : ${bankDetails[index]['short_code']} \n Account Number: ${bankDetails[index]['account_number']}');
            //       },
            //     ),
            //   ),
            // SizedBox(height: 1.5.h),
            // Align(
            //   alignment: Alignment.center,
            //   child: Container(
            //     width: double.infinity,
            //     child: Button(
            //         borderSide: BorderSide.none,
            //         color: tTextformfieldColor,
            //         // textcolor: tWhite,
            //         bottonText: 'Add a new bank account',
            //         onTap: (startLoading, stopLoading, btnState) async {
            //           // //startLoading();
            //           Twl.navigateTo(context, ProfileBankDetails());
            //         }),
            //   ),
            // ),
            // SizedBox(
            //   height: 2.h,
            // )
          ],
        ),
      ),
    );
  }

  Widget bankAccountWidget(String accountDetails) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: tTextformfieldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Radio<int>(
                    value: 1,
                    toggleable: true,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value;
                      });
                    },
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    accountDetails,
                    style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w500,
                        wordSpacing: -2),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Delete'),
          )
        ],
      ),
    );
  }

  int radioButtonValue = 0;
  Widget paymentMethodWidget(String pmId, String lastDigits, String defPmId) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: tTextformfieldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Radio<String>(
                    value: pmId,
                    toggleable: defPmId == pmId ? true : false,
                    groupValue: defPmId,
                    onChanged: (String? value) async {
                      print(pmId);
                      print(cusId);
                      var res =
                          await StripePaymentApi().updateCustomer(pmId, cusId);
                      if (res != null) {
                        Twl.navigateTo(
                            context,
                            BottomNavigation(
                              actionIndex: 0,
                              tabIndexId: 0,
                            ));
                      }
                      print(res);

                      setState(() {
                        ischeced = value;
                      });
                    },
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  'Card ending in(*****$lastDigits)',
                  style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 9.sp : 12.sp,
                      fontWeight: FontWeight.w500,
                      wordSpacing: -2),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: cardDetails.length == 1
                ? null
                : () async {
                    if (defPmId != pmId) {
                      print(pmId);
                      var detachRes = await StripePaymentApi()
                          .detachCardDetails(context, pmId);
                      print(detachRes);
                      if (detachRes != null) {
                        Twl.navigateTo(
                            context,
                            BottomNavigation(
                              actionIndex: 0,
                              tabIndexId: 0,
                            ));
                      }
                    } else {
                      Twl.createAlert(context, 'error',
                          "This card is set as deafult payment method. you can't delete");
                    }
                  },
            child: Text(
              'Delete',
              style: TextStyle(
                  color: cardDetails.length == 1 ? tGray : tSecondaryColor),
            ),
          )
        ],
      ),
    );
  }

  Widget toggleWidget(bool isTrue, String img, String title, int index) {
    return Container(
      decoration: BoxDecoration(
        color: tTextformfieldColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  img,
                  height: 30,
                ),
                SizedBox(width: 3.w),
                Text(
                  title,
                  style: TextStyle(
                    color: tSecondaryColor,
                    fontSize: isTab(context) ? 9.sp : 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              activeColor: tSecondaryColor,
              value: isTrue,
              onChanged: (value) {
                setState(() {
                  isTrue = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
