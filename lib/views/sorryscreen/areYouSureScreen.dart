import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/sorryscreen/goalEnded.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/orderApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../loginPassCodePages/enterYourPasscode.dart';

class AreYouSureScreen extends StatefulWidget {
  const AreYouSureScreen(
      {Key? key, this.goalName, this.amount, this.date, this.goalId})
      : super(key: key);
  final goalName;
  final amount;
  final date;
  final goalId;
  @override
  State<AreYouSureScreen> createState() => _AreYouSureScreenState();
}

class _AreYouSureScreenState extends State<AreYouSureScreen> {
  @override
  void initState() {
    super.initState();
    checkPassodeStatus();
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

  @override
  var currentStatus = 2;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tWhite,
        // leading: GestureDetector(
        //   onTap: () {
        //     Twl.navigateBack(context);
        //   },
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 20),
        //     child: Image.asset(
        //       Images.NAVBACK,
        //       scale: 4,
        //     ),
        //   ),
        // ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.2.h,
                    ),
                    Center(
                      child: Text(
                        'Are you sure you want to\nend your goal?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tPrimaryColor,
                          fontSize: isTab(context) ? 18.sp : 21.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Signika',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Center(
                      child: Text(
                        'If you end your goal, the balance will be added to\nyour physical gold account ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Image.asset(
                      Images.GOLDS,
                      scale: 4,
                    )
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var goalName;
                var amount;
                var date;
                var goalId;
                setState(() {
                  goalName = widget.goalName;
                  amount = widget.amount;
                  date = widget.date;
                  goalId = widget.goalId;
                });
                // if (isPasscodeExist) {
                //   Twl.navigateTo(
                //       context,
                //       EnterYourPasscode(
                //         type: GoldType().EndGoal,
                //         goalId: goalId,
                //         amount: amount,
                //         currentStatus: currentStatus,
                //         goalName: goalName,
                //         date: date,
                //       ));
                // } else {
                var res = await OrderAPI().editGoal(context, goalId, goalName,
                    amount, date, '2', currentStatus.toString());
                print(res);
                if (res != null && res['status'] == 'OK') {
                  // Twl.navigateTo(
                  //     context,
                  //     BottomNavigation(
                  //       actionIndex: 0,
                  //       tabIndexId: 0,
                  //     ));
                  Twl.navigateTo(context, GoalEndedScreen());
                } else {
                  // Twl.createAlert(context, 'error', res['error']);
                }

                // }
              },
              child: Text(
                'End Goal ',
                style: TextStyle(
                    color: tSecondaryColor,
                    fontSize: isTab(context) ? 9.sp : 12.sp,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Button(
                borderSide: BorderSide(
                  color: tPrimaryColor,
                ),
                color: tPrimaryColor,
                textcolor: tWhite,
                bottonText: 'Continue My Goal',
                onTap: (startLoading, stopLoading, btnState) async {
                  Twl.navigateTo(
                      context,
                      BottomNavigation(
                        actionIndex: 0,
                        tabIndexId: 0,
                      ));
                }),
          ),
          SizedBox(
            height: 1.h,
          )
        ],
      ),
    );
  }
}
