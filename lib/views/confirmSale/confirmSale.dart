import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/views/profilePage/bankDetailsPage.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';

class ConfirmSale extends StatefulWidget {
  const ConfirmSale({Key? key}) : super(key: key);

  @override
  State<ConfirmSale> createState() => _ConfirmSaleState();
}

class _ConfirmSaleState extends State<ConfirmSale> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 6.h,
              ),
              GestureDetector(
                onTap: () {
                  Twl.navigateBack(context);
                },
                child: Image.asset(
                  Images.NAVIGATEBACK,
                  scale: 4,
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Text(
                "Confirm Sale",
                style: TextStyle(
                    fontFamily: 'Signika',
                    fontSize: isTab(context) ? 18.sp : 21.sp,
                    fontWeight: FontWeight.w500,
                    color: tPrimaryColor),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                "Selling Quantity",
                style: TextStyle(
                    fontFamily: 'Signika',
                    fontSize: isTab(context) ? 13.sp : 16.sp,
                    fontWeight: FontWeight.w400,
                    color: tSecondaryColor),
              ),
              SizedBox(
                height: 3.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: tlightGrayblue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "2.8g",
                    style: TextStyle(
                        fontFamily: 'Signika',
                        fontSize: isTab(context) ? 13.sp : 16.sp,
                        fontWeight: FontWeight.w400,
                        color: tSecondaryColor),
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                "Deposit Details",
                style: TextStyle(
                    fontSize: isTab(context) ? 13.sp : 16.sp,
                    fontWeight: FontWeight.w400,
                    color: tSecondaryColor),
              ),
              SizedBox(
                height: 3.h,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: tlightGrayblue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "£250 to be deposited",
                      style: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                          color: tSecondaryColor),
                    ),
                    Text(
                      "John Smith",
                      style: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                          color: tSecondaryColor),
                    ),
                    Text(
                      "Barclays Bank",
                      style: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                          color: tSecondaryColor),
                    ),
                    Text(
                      "Sort Code: 00-05-09",
                      style: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                          color: tSecondaryColor),
                    ),
                    Text(
                      "Account Number: 5737583",
                      style: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                          color: tSecondaryColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 39.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Align(
                  alignment: Alignment.center,
                  child: Button(
                      borderSide: BorderSide(
                        color: tPrimaryColor,
                      ),
                      color: tPrimaryColor,
                      textcolor: tWhite,
                      bottonText: 'Continue',
                      onTap: (startLoading, stopLoading, btnState) async {
                        Twl.navigateTo(context, BankDetails());
                      }),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Twl.navigateTo(context, BankDetails());
              //   },
              //   child: Center(
              //     child: Container(
              //       decoration: BoxDecoration(
              //           color: tPrimaryColor,
              //           borderRadius: BorderRadius.circular(10)),
              //       padding:
              //           EdgeInsets.symmetric(horizontal: 20.w, vertical: 15),
              //       child: Text(
              //         "Continue",
              //         style: TextStyle(
              //             color: tSecondaryColor,
              //             fontSize: isTab(context) ? 10.sp : 13.sp,
              //             fontWeight: FontWeight.w400),
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
