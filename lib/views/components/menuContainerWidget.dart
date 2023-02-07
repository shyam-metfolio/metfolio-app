import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../responsive.dart';

class MenuContainerWidget extends StatelessWidget {
  const MenuContainerWidget({
    Key? key,
    this.image,
    this.tittle,
    this.onTap,
  }) : super(key: key);
  final image;
  final tittle;
  final onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ArgonButton(
            highlightElevation: 0,
            elevation: 0,
            height: 14.w,
            width: 14.w,
            borderRadius: 15,
            color: tContainerColor,
            child: Container(
              height: 14.w,
              width: 14.w,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              child: Image.asset(
                image ?? "",
                scale: 4,
              ),
            ),
            loader: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Lottie.asset(
                  Loading.LOADING,
                  // width: 50.w,
                )
                // SpinKitRotatingCircle(
                //   color: Colors.white,
                //   // size: loaderWidth ,
                // ),
                ),
            onTap: onTap,
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            tittle ?? "",
            style: TextStyle(
                color: tSecondaryColor,
                fontSize: isTab(context) ? 5.sp : 8.sp,
                fontFamily: 'Signika',
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
