import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalAmount.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../api_services/userApi.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../provider/actionProvider.dart';

class DeliveryFromBottomSheet extends StatefulWidget {
  DeliveryFromBottomSheet({
    required this.selectDelivery,
    Key? key,
    this.title,
    this.selected,
    this.type,
  }) : super(key: key);

  Function selectDelivery;
  final title;
  final type;
  final selected;

  @override
  State<DeliveryFromBottomSheet> createState() =>
      _DeliveryFromBottomSheetState();
}

class _DeliveryFromBottomSheetState extends State<DeliveryFromBottomSheet> {
  @override
  void initState() {
    checkGold();
    getMyGoal();
    super.initState();
  }

  var myGoalDetails;
  var goalTotalValue;
  var avalibleGoalGold;
  var myGoalName;
  getMyGoal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = await UserAPI().getMyGoals(context);
    setState(() {
      myGoalDetails = res;
    });
    if (res != null && res['status'] == 'OK') {
      setState(() {
        // myGoalDetails = res;
        print("name_of_goal");
        sharedPreferences.setString(
            "goalName", myGoalDetails['details']['name_of_goal']);
        print(myGoalDetails['details']['name_of_goal']);
        myGoalName = (myGoalDetails['details']['name_of_goal']);
        avalibleGoalGold = res['details']['availableGoldByGoal'];
      });
    }
  }

  var physcialGold = 0.0;
  var goalGold = 0.0;
  checkGold() async {
    var phygoldres = await UserAPI().checkAvaliableGold(context, '1');
    if (phygoldres != null && phygoldres['status'] == "OK") {
      setState(() {
        physcialGold =
            double.parse(phygoldres['details']['availableGold'].toString());
      });
    } else {}
    var goalGoldres = await UserAPI().checkAvaliableGold(context, '2');
    if (goalGoldres != null && goalGoldres['status'] == "OK") {
      setState(() {
        goalGold =
            double.parse(goalGoldres['details']['availableGold'].toString());
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(context);
    return Container(
      height: 1000,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(top: 24, left: 8, right: 16),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.type == true ? 'Buy for' : 'Sell from'}",
                          style: TextStyle(
                              fontFamily: "Barlow",
                              fontWeight: FontWeight.bold,
                              color: tTextSecondary,
                              fontSize: 26)),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Done",
                              style: TextStyle(
                                  fontFamily: "SignikaB",
                                  fontWeight: FontWeight.bold,
                                  color: _getColorFromHex("#2AB2BC"),
                                  fontSize: 20)))
                    ])),
            Divider(color: _getColorFromHex("#707070")),
            Padding(
                padding: EdgeInsets.only(top: 12, left: 12),
                child: Text("My accounts",
                    style: TextStyle(
                        fontFamily: "Barlow",
                        fontWeight: FontWeight.w700,
                        color: tTextSecondary,
                        fontSize: 15))),
            Container(
              height: 30,
            ),

            GestureDetector(
              onTap: () async {
                _data.navGoldTypeaction('1');
                Twl.navigateBack(context);

                widget.selectDelivery(
                    'Physical Gold Account', physcialGold, '1');

                await FirebaseAnalytics.instance.logEvent(
                  name: "physical_gold_account",
                  parameters: {
                    "button_clicked": true,
                  },
                );

                Segment.track(
                  eventName: 'physical_gold_account',
                  properties: {"clicked": true},
                );

                mixpanel.track('physical_gold_account', properties: {
                  "button_clicked": true,
                });
              },
              child: Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Image.asset(
                        Images.GOLD,
                        height: 20,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Physical Gold Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Barlow',
                          fontSize: isTab(context) ? 10.sp : 12.sp,
                          color: tSecondaryColor,
                        ),
                      ),
                      Spacer(),

                      /*  Text(
                          '${physcialGold.toStringAsFixed(3)}g',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),*/
                      (widget.selected == 'Physical Gold Account')
                          ? Image.asset(
                              'images/yes.png',
                              height: 20,
                            )
                          : Image.asset(
                              'images/no.png',
                              height: 20,
                            ),
                    ],
                  )),
            ),
            Padding(
                padding: EdgeInsets.only(
                  left: 12,
                  top: 12,
                  bottom: 10,
                ),
                child:
                    Container(height: 0.6, color: _getColorFromHex("#707070"))),

            if (myGoalDetails != null)
              if (myGoalDetails['status'] == 'OK')
                Column(children: [
                  GestureDetector(
                    onTap: () {
                      _data.navGoldTypeaction('2');
                      Twl.navigateBack(context);

                      widget.selectDelivery(
                          myGoalDetails['details']['name_of_goal'],
                          goalGold,
                          '2');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        children: [
                          Image.asset(
                            Images.MUGOALGOLD,
                            scale: 4.5,
                            // height: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            myGoalName ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Barlow',
                              fontSize: isTab(context) ? 10.sp : 12.sp,
                              color: tSecondaryColor,
                            ),
                          ),
                          Spacer(),
                          /*Text(
                            '${goalGold.toStringAsFixed(3)}g',
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: isTab(context) ? 10.sp : 12.sp,
                              color: tSecondaryColor,
                            ),
                          ),*/
                          (widget.selected == (myGoalName ?? ""))
                              ? Image.asset(
                                  'images/yes.png',
                                  height: 20,
                                )
                              : Image.asset(
                                  'images/no.png',
                                  height: 20,
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        top: 12,
                        bottom: 10,
                      ),
                      child: Container(
                          height: 0.6, color: _getColorFromHex("#707070"))),
                ]),
            // if (myGoalDetails['status'] == 'NOK' && type == 2)
            if (myGoalDetails != null)
              if (myGoalDetails['status'] == 'NOK')
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Twl.navigateBack(context);
                        Twl.navigateTo(context, GoalAmount());

                        await FirebaseAnalytics.instance.logEvent(
                          name: "start_goal_button",
                          parameters: {
                            "button_clicked": true,
                          },
                        );

                        Segment.track(
                          eventName: 'start_goal_button',
                          properties: {"clicked": true},
                        );

                        mixpanel.track('start_goal_button', properties: {
                          "button_clicked": true,
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              Images.NEWGOAL,
                              height: 30,
                            ),
                            SizedBox(width: 15),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              child: Text(
                                'Start a Goal!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Barlow',
                                  fontSize: isTab(context) ? 10.sp : 12.sp,
                                  color: tSecondaryColor,
                                ),
                              ),
                            ),
                            Spacer(),
                            Image.asset(
                              Images.RIGHTARROW,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 12,
                          bottom: 10,
                        ),
                        child: Container(
                            height: 0.6, color: _getColorFromHex("#707070"))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Metfolio Goals! Set up a fully personalised goal and start buying physical gold automatically every single month.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTab(context) ? 10.sp : 12.sp,
                          color: tSecondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}

_getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
}
