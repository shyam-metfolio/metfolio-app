import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../responsive.dart';

class NoActiveGoalsContainer extends StatelessWidget {
  const NoActiveGoalsContainer({Key? key, this.buttontext}) : super(key: key);
  final buttontext;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: tContainerColor, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "You have no active goals",
            style: TextStyle(
                color: tBlue,
                fontSize: isTab(context) ? 11.sp : 16.sp,
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            decoration: BoxDecoration(
                color: tPrimaryColor, borderRadius: BorderRadius.circular(11)),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 6),
            child: Text(
              buttontext ?? "",
              style: TextStyle(
                  color: tSecondaryColor,
                  fontSize: isTab(context) ? 8.sp : 11.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Image.asset(
            Images.TARGET,
            scale: 3.5,
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}
