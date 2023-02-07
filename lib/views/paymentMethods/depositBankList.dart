import 'dart:async';

import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/api_services/orderApi.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/profilePage/profileBankDetails.dart';
import 'package:base_project_flutter/views/successfullPage/SaleIsConfirmSucessfull.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';
import '../loginPassCodePages/enterYourPasscode.dart';

class DePositBankList extends StatefulWidget {
  const DePositBankList({Key? key, this.amount}) : super(key: key);
  final amount;
  @override
  State<DePositBankList> createState() => _DePositBankListState();
}

class _DePositBankListState extends State<DePositBankList> {
  @override
  void initState() {
    super.initState();
  }

  var bankDetails;
  getBankDetails() async {
    var res = await UserAPI().getBankDetails(context);
    print('getBankDetails >>>>>>>>>>>>>>>');
    print(res);
    if (res != null && res['status'] == 'OK') {
      setState(() {
        bankDetails = res['details'];
      });
    }
    // else {
    //   Twl.createAlert(context, 'error', res['error']);
    // }
  }

  @override
  void didChangeDependencies() {
    getBankDetails();
    checkPassodeStatus();
    super.didChangeDependencies();
  }

  bool isPasscodeExist = false;
  checkPassodeStatus() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var userId = sharedPrefs.getString('userId');
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId.toString())
        .snapshots()
        .listen((userData) {
      setState(() {
        if (userData.data()?['userId'] != null) {
          isPasscodeExist = true;
        }
      });
    });
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  bool isLoading = false;
  bool loadingPaymentStatus = false;
  loader(value) {
    setState(() {
      loadingPaymentStatus = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isLoading == false) {
          return Twl.navigateBack(context);
          // return null;
        } else {
          return Future.value(true);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: tWhite,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: tWhite,
              leading: GestureDetector(
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
            body:
                // isLoading
                //     ? Center(
                //         child: CircularProgressIndicator(
                //         color: tPrimaryColor,
                //       ))
                //     :
                Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deposit into your bank',
                      style: TextStyle(
                          fontFamily: "Signika",
                          color: tPrimaryColor,
                          fontSize: isTab(context) ? 18.sp : 21.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    if (bankDetails != null)
                      ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: bankDetails.length,
                          itemBuilder: (BuildContext context, int index) {
                            var bankList = bankDetails[index];
                            return GestureDetector(
                              onTap: () {
                                showGeneralDialog(
                                  barrierLabel: '',
                                  barrierDismissible: true,
                                  context: context,
                                  pageBuilder: (ctx, a1, a2) {
                                    return Container();
                                  },
                                  transitionBuilder: (ctx, a1, a2, child) {
                                    var curve =
                                        Curves.easeInOut.transform(a1.value);
                                    return Transform.scale(
                                        scale: curve,
                                        child: StatefulBuilder(
                                            builder: (context, setState) {
                                          return Stack(
                                            children: [
                                              AlertDialog(
                                                backgroundColor:
                                                    tTextformfieldColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.0))),
                                                actions: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        color:
                                                            tTextformfieldColor,
                                                        child: Container(
                                                            color:
                                                                tTextformfieldColor,
                                                            height: 243,
                                                            width: 243,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 20,
                                                                      bottom:
                                                                          20,
                                                                      left: 5,
                                                                      right: 5),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    // child: Row(
                                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                                    // children: [
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          Images
                                                                              .BANKICON,
                                                                          scale:
                                                                              4,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2.w,
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Bank Deposit",
                                                                                style: TextStyle(color: tSecondaryColor, fontSize: isTab(context) ? 8.sp : 11.sp, fontWeight: FontWeight.w600),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 0.5.h,
                                                                              ),
                                                                              Text(
                                                                                bankList['bank_name'],
                                                                                maxLines: 3,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(color: tSecondaryColor, fontSize: isTab(context) ? 7.sp : 10.sp, fontWeight: FontWeight.w400),
                                                                              ),
                                                                              Text(
                                                                                "Sort Code: ${bankList['short_code']}",
                                                                                maxLines: 3,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(color: tSecondaryColor, fontSize: isTab(context) ? 7.sp : 10.sp, fontWeight: FontWeight.w400),
                                                                              ),
                                                                              Container(
                                                                                width: 48.w,
                                                                                child: Text(
                                                                                  "Account Number:  ${bankList['account_number']}",
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(color: tSecondaryColor, fontSize: isTab(context) ? 7.sp : 10.sp, fontWeight: FontWeight.w400),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    //   ],
                                                                    // ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 70,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              15),
                                                                      child:
                                                                          ArgonButton(
                                                                        highlightElevation:
                                                                            0,
                                                                        height: isTab(context)
                                                                            ? 70
                                                                            : 40,
                                                                        width:
                                                                            90.w,
                                                                        color:
                                                                            tPrimaryColor,
                                                                        borderRadius:
                                                                            15,
                                                                        child:
                                                                            Text(
                                                                          'Deposit ${"" + Secondarycurrency + "${widget.amount}"}',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                tSecondaryColor,
                                                                            fontSize:
                                                                                13.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                        loader:
                                                                            Container(
                                                                          // height: 40,
                                                                          // width: double.infinity,
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 0),
                                                                          child:
                                                                              Lottie.asset(
                                                                            Loading.LOADING,
                                                                            // width: 50.w,
                                                                          ),
                                                                        ),
                                                                        onTap: isLoading
                                                                            ? null
                                                                            : (startLoading, stopLoading, btnState) async {
                                                                                // WidgetsBinding
                                                                                //     .instance!
                                                                                //     .addPostFrameCallback((_) async {
                                                                                setState(() {
                                                                                  isLoading = true;
                                                                                });
                                                                                // });
                                                                                print(isLoading.toString() + '  isLoading');
                                                                                //startLoading();
                                                                                loader(true);
                                                                                // if (isPasscodeExist) {
                                                                                //   Twl.navigateTo(
                                                                                //       context,
                                                                                //       EnterYourPasscode(
                                                                                //         type: GoldType().Sell,
                                                                                //         amount: widget.amount,
                                                                                //         bankId: bankList['id'],
                                                                                //       ));
                                                                                // } else {
                                                                                var sellRes = await OrderAPI().sellGold(context, bankList['id'].toString());
                                                                                print(sellRes);
                                                                                if (sellRes != null && sellRes['status'] == 'OK') {
                                                                                  stopLoading();
                                                                                  loader(false);
                                                                                  // WidgetsBinding
                                                                                  //     .instance!
                                                                                  //     .addPostFrameCallback((_) async {
                                                                                  setState(() {
                                                                                    isLoading = false;
                                                                                  });
                                                                                  // });
                                                                                  Twl.navigateTo(context, SalesConfirmSucessful());
                                                                                } else {
                                                                                  // WidgetsBinding
                                                                                  //     .instance!
                                                                                  //     .addPostFrameCallback((_) async {
                                                                                  setState(() {
                                                                                    isLoading = false;
                                                                                  });
                                                                                  // });
                                                                                  loader(false);
                                                                                  stopLoading();
                                                                                  // Twl.createAlert(context, 'error', sellRes['error']);
                                                                                }
                                                                                // }
                                                                                print('isloading ' + isLoading.toString());
                                                                                loader(false);
                                                                                stopLoading();
                                                                              },
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              if (loadingPaymentStatus)
                                                Center(
                                                  child: Container(
                                                    color:
                                                        tBlack.withOpacity(0.3),
                                                    // padding:
                                                    //     EdgeInsets.only(top: 100),
                                                    height: 100.h,
                                                    width: 100.w,
                                                    alignment: Alignment.center,
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: tPrimaryColor,
                                                    ),
                                                  ),
                                                )
                                            ],
                                          );
                                        })

                                        //  bankdepositAlert(
                                        //     context, bankList, widget.amount),
                                        );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  // child: Row(
                                  //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   // crossAxisAlignment: CrossAxisAlignment.center,
                                  //   children: [
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        Images.BANKICON,
                                        scale: 3.5,
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Bank Deposit",
                                              style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: isTab(context)
                                                      ? 8.sp
                                                      : 11.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 0.5.h,
                                            ),
                                            Text(
                                              bankList['bank_name'],
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: isTab(context)
                                                      ? 7.sp
                                                      : 10.sp,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "Sort Code: ${bankList['short_code']}",
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: isTab(context)
                                                      ? 7.sp
                                                      : 10.sp,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              "Account Number: ${bankList['account_number']}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: tSecondaryColor,
                                                  fontSize: isTab(context)
                                                      ? 7.sp
                                                      : 10.sp,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Image.asset(
                                          Images.NEXTICON,
                                          scale: 4,
                                        ),
                                      )
                                      //   ],
                                      // ),
                                      // Padding(
                                      //   padding: EdgeInsets.only(right: 10),
                                      //   child: Image.asset(
                                      //     Images.NEXTICON,
                                      //     scale: 4,
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onTap: () {
                          Twl.navigateTo(context, ProfileBankDetails());
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    Images.ADDBANKICON,
                                    scale: 3.5,
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    "Connect a Bank\nAccount",
                                    style: TextStyle(
                                        color: tSecondaryColor,
                                        fontSize: isTab(context) ? 8.sp : 11.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  Images.NEXTICON,
                                  scale: 4,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (loadingPaymentStatus)
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
              ),
            )
        ],
      ),
    );
  }

  bankdepositAlert(BuildContext context, details, amount) {
    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        children: [
          AlertDialog(
            backgroundColor: tTextformfieldColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: tTextformfieldColor,
                    child: Container(
                        color: tTextformfieldColor,
                        height: 260,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                // child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // children: [
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Images.BANKICON,
                                      scale: 3.5,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Bank Deposit",
                                          style: TextStyle(
                                              color: tSecondaryColor,
                                              fontSize:
                                                  isTab(context) ? 8.sp : 11.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 0.5.h,
                                        ),
                                        Text(
                                          details['bank_name'],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: tSecondaryColor,
                                              fontSize:
                                                  isTab(context) ? 7.sp : 10.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "Sort Code: ${details['short_code']}",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: tSecondaryColor,
                                              fontSize:
                                                  isTab(context) ? 7.sp : 10.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Container(
                                          width: 48.w,
                                          child: Text(
                                            "Account Number:  ${details['account_number']}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: tSecondaryColor,
                                                fontSize: isTab(context)
                                                    ? 7.sp
                                                    : 10.sp,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                //   ],
                                // ),
                              ),
                              SizedBox(
                                height: 90,
                              ),
                              Center(
                                child: Container(
                                  width: double.infinity,
                                  child: ArgonButton(
                                    highlightElevation: 0,
                                    height: isTab(context) ? 70 : 40,
                                    width: 90.w,
                                    color: tPrimaryColor,
                                    borderRadius: 15,
                                    child: Text(
                                      'Deposit ${"" + Secondarycurrency + "${amount}"}',
                                      style: TextStyle(
                                        color: tSecondaryColor,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    loader: Container(
                                        // height: 40,
                                        // width: double.infinity,
                                        // padding: EdgeInsets.symmetric(horizontal: 0),
                                        // child: Lottie.asset(
                                        //   loading.LOADING,
                                        //   // width: 50.w,
                                        // ),
                                        ),
                                    onTap: (startLoading, stopLoading,
                                        btnState) async {
                                      FocusScope.of(context).unfocus();
                                      loader(true);
                                      //startLoading();
                                      var sellRes = await OrderAPI().sellGold(
                                          context, details['id'].toString());
                                      print(sellRes);
                                      if (sellRes != null &&
                                          sellRes['status'] == 'OK') {
                                        loader(false);
                                        stopLoading();
                                        Twl.navigateTo(
                                            context, BottomNavigation());
                                      } else {
                                        loader(false);
                                        stopLoading();
                                        // Twl.createAlert(
                                        //     context, 'error', sellRes['error']);
                                      }
                                      // loader(false);
                                      stopLoading();
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              )
            ],
          ),
          if (loadingPaymentStatus)
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
              ),
            )
        ],
      );
    });
  }
}
