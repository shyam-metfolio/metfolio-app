// ignore_for_file: must_be_immutable

import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../constants/imageConstant.dart';

class KeyPad extends StatelessWidget {
  double buttonSize = 6.0;
  final TextEditingController pinController;
  final Function onChange;
  final Function onSubmit;
  final bool isPinLogin;
  final decimalvalue;
  final max;
  final min;
  String decimal = "." + "\n";

  KeyPad(
      {required this.onChange,
      required this.onSubmit,
      required this.pinController,
      required this.isPinLogin,
      this.decimalvalue,
      this.max,
      this.min});

  @override
  Widget build(BuildContext context) {
    return Container(
      //  margin: EdgeInsets.only(left: 30, right: 30),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 33,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget('1'),
                buttonWidget('2'),
                buttonWidget('3'),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget('4'),
                buttonWidget('5'),
                buttonWidget('6'),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonWidget('7'),
                buttonWidget('8'),
                buttonWidget('9'),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                (decimalvalue == true)
                    ? buttonWidget(decimal)
                    : Container(
                        height: buttonSize.h,
                        width: buttonSize.h,
                      ),
                buttonWidget('0'),
                iconButtonWidget(Icons.backspace, () {
                  if (pinController.text.length > 0) {
                    pinController.text = pinController.text
                        .substring(0, pinController.text.length - 1);
                  }
                  if (pinController.text.length > 5) {
                    pinController.text = pinController.text.substring(0, 3);
                  }
                  onChange(pinController.text);
                }),
                // Container(
                //   width: buttonSize,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buttonWidget(String buttonText) {
    return ArgonButton(
      highlightElevation: 0,
      elevation: 0,
      height: buttonSize.h,
      width: buttonSize.h,
      borderRadius: 15,
      color: tlightGrayblue,
      child: Container(
        height: buttonSize.h,
        width: buttonSize.h,
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: tPrimaryColor,
                fontSize: 20.sp),
          ),
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
      onTap: (pinController.text.contains('.') && buttonText == '.\n')
          ? null
          : (startLoading, stopLoading, btnState) {
              if (max != null && min != null && pinController.text != '') {
                // if ((double.parse(pinController.text) == 0 &&
                //     buttonText == '0')) {
                // } else {
                if ((min >= double.parse(pinController.text)) &&
                    max >= double.parse(pinController.text)) {
                  print(pinController.text.contains('.'));
                  // if (pinController.text.length <= 4) {
                  if (pinController.text.contains('.')) {
                    print(pinController.text.split('.'));
                    var list = pinController.text.split('.');
                    if (list[1].length < 3) {
                      pinController.text = pinController.text +
                          buttonText.replaceAll(decimal, ".");
                      onChange(pinController.text);
                    }
                  } else {
                    if (isPinLogin == true) {
                      if (pinController.text.length <= 3) {
                        pinController.text = pinController.text +
                            buttonText.replaceAll(decimal, ".");
                        onChange(pinController.text);
                        print(pinController.text);
                      }
                    } else {
                      // print(buttonText == '.\n');
                      if (buttonText == '.\n' || buttonText == '.') {
                        print("state1");
                        pinController.text = pinController.text +
                            buttonText.replaceAll(decimal, ".");
                        onChange(pinController.text);
                      } else if (int.parse(buttonText) > 0) {
                        pinController.text = pinController.text +
                            buttonText.replaceAll(decimal, ".");
                        onChange(
                            num.parse(pinController.text).toInt().toString());
                      } else if (int.parse(buttonText) == 0) {
                        print("state2");
                        onChange(
                            num.parse(pinController.text).toInt().toString());
                      } else {
                        print("state3");
                        print("state1");
                        pinController.text = pinController.text +
                            buttonText.replaceAll(decimal, ".");
                        onChange(pinController.text);
                        print(pinController.text);
                      }
                    }
                  }
                  if ((min >= double.parse(pinController.text)) &&
                      max >= double.parse(pinController.text)) {
                  } else {
                    pinController.text = pinController.text
                        .substring(0, pinController.text.length - 1);
                  }
                }
                // }
              } else {
                print(pinController.text.contains('.'));
                // if (pinController.text.length <= 4) {
                if (pinController.text.contains('.')) {
                  print(pinController.text.split('.'));
                  var list = pinController.text.split('.');
                  if (list[1].length < 3) {
                    pinController.text = pinController.text +
                        buttonText.replaceAll(decimal, ".");
                    onChange(pinController.text);
                  }
                } else {
                  if (isPinLogin == true) {
                    if (pinController.text.length <= 3) {
                      pinController.text = pinController.text +
                          buttonText.replaceAll(decimal, ".");
                      onChange(pinController.text);
                      print(pinController.text);
                    }
                  } else {
                    pinController.text = pinController.text +
                        buttonText.replaceAll(decimal, ".");
                    onChange(pinController.text);
                    print(pinController.text);
                  }
                  if (pinController.text[0] == '0') {
                    pinController.text.replaceFirst('0', '');
                  }
                }
                print("asdasdas" + pinController.text);
              }
            },
    );
  }

  iconButtonWidget(IconData icon, function) {
    return ArgonButton(
      height: buttonSize.h,
      width: buttonSize.h,
      highlightElevation: 0,
      elevation: 0,
      borderRadius: 10,
      color: tlightGrayblue,
      child: InkWell(
        onTap: function,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Image.asset(
              Images.PINICONBACK,
              scale: 3.9,
            ),
          ),
        ),
      ),
    );
  }
}
