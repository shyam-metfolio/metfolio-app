import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';

class Frame extends StatefulWidget {
  const Frame({Key? key}) : super(key: key);

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
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
            child: Image.asset(
              Images.NAVBACK,
              scale: 4,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Card(
                          elevation: 0,
                          color: tlightGrayblue,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "You must have an account to use this feature",
                                        style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize:
                                                isTab(context) ? 13.sp : 16.sp,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 150,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: tPrimaryColor,
                                            ),
                                            child: Center(
                                                child: Text('Login',
                                                    style: TextStyle(
                                                        color: tSecondaryColor,
                                                        fontSize: isTab(context)
                                                            ? 9.sp
                                                            : 12.sp,
                                                        fontWeight:
                                                            FontWeight.w400))),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 150,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: tPrimaryColor),
                                            child: Center(
                                                child: Text('Sign Up',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: tSecondaryColor,
                                                      fontSize: isTab(context)
                                                          ? 9.sp
                                                          : 12.sp,
                                                    ))),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
