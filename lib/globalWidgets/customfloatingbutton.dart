import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants/constants.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({Key? key, this.onPressed, this.text})
      : super(key: key);
  final onPressed;
  final text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: onPressed ?? "",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Container(
          // height: 10.h,
          width: 40.w,
          child: Center(
            child: Text(
              text ?? "",
              style: TextStyle(
                  color: tSecondaryColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            ),
          ),
        ),
        backgroundColor: tPrimaryColor,
      ),
    );
  }
}
