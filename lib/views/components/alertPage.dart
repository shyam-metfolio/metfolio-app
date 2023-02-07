import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';

customAlert(BuildContext context, title, okText, cancelText, image, okTap) {
  showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: tTextformfieldColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                      height: 350,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  title,
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                              if (image != null)
                                Image.asset(
                                  image!,
                                  scale: 1.3,
                                ),
                              Column(
                                children: [
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
                                          okText,
                                          style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        loader: Container(
                                          // height: 40,
                                          // width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Lottie.asset(
                                            Loading.LOADING,
                                            // width: 50.w,
                                          ),
                                        ),
                                        onTap: okTap,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
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
                                          cancelText,
                                          style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        loader: Container(
                                          // height: 40,
                                          // width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Lottie.asset(
                                            Loading.LOADING,
                                            // width: 50.w,
                                          ),
                                        ),
                                        onTap: (startLoading, stopLoading,
                                            btnState) async {
                                          if (cancelText == 'Discard') {
                                            Twl.navigateBack(context);
                                          } else {
                                            Twl.navigateTo(
                                              context,
                                              BottomNavigation(),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
}

declinedAlert(
  BuildContext context,
  title,
  okText,
) {
  showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: tTextformfieldColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                      height: 250,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  title,
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                              Column(
                                children: [
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
                                          okText,
                                          style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        loader: Container(
                                          // height: 40,
                                          // width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Lottie.asset(
                                            Loading.LOADING,
                                            // width: 50.w,
                                          ),
                                        ),
                                        onTap: (startLoading, stopLoading,
                                            btnState) async {
                                          //startLoading();
                                          Twl.navigateBack(context);
                                          stopLoading();
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
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
}

TimeOutPayment(BuildContext context, ontap) {
  showDialog(
    context: context, barrierLabel: '',
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: tTextformfieldColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                      height: 250,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Your session has expired, please process  your transaction within 5 minutes.',
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                              Column(
                                children: [
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
                                          'OK',
                                          style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        loader: Container(
                                          // height: 40,
                                          // width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Lottie.asset(
                                            Loading.LOADING,
                                            // width: 50.w,
                                          ),
                                        ),
                                        onTap: ontap,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
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
}
