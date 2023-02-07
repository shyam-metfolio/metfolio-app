import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../responsive.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    this.color,
    this.bottonText,
    this.onTap,
    this.borderSide,
    this.textcolor,
  }) : super(key: key);
  final color;
  final String? bottonText;
  final onTap;
  final borderSide;
  final textcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ArgonButton(
        highlightElevation: 0,
        elevation: 0,
        height: isTab(context) ? 70 : 45,
        width: 82.w,
        color: color,
        borderRadius: 11,
        borderSide: borderSide,
        child: Text(
          bottonText!,
          style: TextStyle(
              color: tSecondaryColor,
              fontWeight: FontWeight.w400,
              fontSize: isTab(context) ? 9.sp : 15),
        ),
        loader: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:
                // Container(),
                Lottie.asset(
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
    );
  }
}
