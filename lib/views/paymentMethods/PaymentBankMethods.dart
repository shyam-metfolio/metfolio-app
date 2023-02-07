import 'dart:async';

import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/views/paymentMethods/depositBankList.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../responsive.dart';
import '../profilePage/profileBankDetails.dart';

class PaymentBankMethods extends StatefulWidget {
  const PaymentBankMethods({Key? key, this.amount}) : super(key: key);
  final amount;
  @override
  State<PaymentBankMethods> createState() => _PaymentBankListsState();
}

class _PaymentBankListsState extends State<PaymentBankMethods> {
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please select your deposit method',
                style: TextStyle(
                    fontFamily: "Signika",
                    color: tPrimaryColor,
                    fontSize: isTab(context) ? 18.sp : 21.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                'When selling gold on Metfolio, we will deposit your funds using the following options',
                style: TextStyle(
                    color: tSecondaryColor,
                    fontSize: isTab(context) ? 8.sp : 11.sp,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 3.h,
              ),
              // if (bankDetails != null)
              //   ListView.builder(
              //       shrinkWrap: true,
              //       itemCount: bankDetails.length,
              //       itemBuilder: (BuildContext context, int index) {
              //         return
              GestureDetector(
                onTap: () {
                  Twl.navigateTo(
                      context, DePositBankList(amount: widget.amount));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              Images.BANKICON,
                              scale: 4,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bank Deposit",
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 8.sp : 11.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 0.5.h,
                                ),
                                Text(
                                  "Sell your gold and have your funds\ndeposited into your bank account\nwithin 3 business days",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 7.sp : 10.sp,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10, bottom: 9),
                          child: Image.asset(
                            Images.NEXTICON,
                            scale: 4,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
              //   );
              // }),
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: 20),
              //   child: GestureDetector(
              //     onTap: () {
              //       Twl.navigateTo(context, ProfileBankDetails());
              //     },
              //     child: Container(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Row(
              //             children: [
              //               Image.asset(
              //                 Images.ADDBANKICON,
              //                 scale: 3.5,
              //               ),
              //               SizedBox(
              //                 width: 4.w,
              //               ),
              //               Text(
              //                 "Connect another Bank\nAccount",
              //                 style: TextStyle(
              //                     color: tSecondaryColor,
              //                     fontSize: isTab(context) ? 8.sp : 11.sp,
              //                     fontWeight: FontWeight.w600),
              //               ),
              //             ],
              //           ),
              //           Padding(
              //             padding: EdgeInsets.only(right: 10),
              //             child: Image.asset(
              //               Images.NEXTICON,
              //               scale: 4,
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
