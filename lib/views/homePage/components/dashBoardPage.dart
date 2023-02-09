import 'dart:async';

import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';

import 'package:base_project_flutter/views/nameyourgoal/nameyourgoal.dart';

import 'package:base_project_flutter/views/sorryscreen/sorryscreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../../../api_services/userApi.dart';
import '../../../provider/actionProvider.dart';
import '../../../responsive.dart';
import '../../components/goldcontainer.dart';
import '../../components/menuContainerWidget.dart';
import '../../nameyourgoal/GoalAmount.dart';
import '../../veriffPage/veriffPage.dart';

// ignore: must_be_immutable
class DashBoardPage extends StatefulWidget {
  final Function navigate;
  Function? innerNavvigate;

  DashBoardPage({required this.navigate, this.innerNavvigate});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  void initState() {
    getGoldPrice();
    getMyGoal();
    ActionProvider _data = Provider.of<ActionProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _data.phyGoldAction(1);
      _data.goalGoldAction(1);
    });

    // TODO: implement initState
    super.initState();
  }

  var myGoalDetails;
  var goalTotalValue;
  var avalibleGoalGold;
  getMyGoal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = await UserAPI().getMyGoals(context);
    if (mounted) {
      setState(() {
        myGoalDetails = res;
        // print("name_of_goal");
        // print(myGoalDetails['details']['name_of_goal']);
      });
    }
    if (res != null && res['status'] == 'OK') {
      setState(() {
        sharedPreferences.setString("goalName", res['details']['name_of_goal']);
        // myGoalDetails = res;
        avalibleGoalGold = res['details']['availableGoldByGoal'];
      });
    }
  }

  var res;
  var priceDetails;
  var phyGoldValue = 0.0;
  var totalGold = '0';
  var verifStatus;
  getGoldPrice() async {
    // var status = await checkVeriffStatus(context);
    // setState(() {
    //   verifStatus = status;
    //   print(verifStatus.runtimeType);
    // });
    // SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    // var authCode = sharedPrefs.getString('authCode');
    // var checkApi = await UserAPI().checkApi(authCode);
    // print(checkApi);
    // if (checkApi != null && checkApi['status'] == 'OK') {
    //   verifStatus = checkApi['detail']['veriff_status'];
    //   print(verifStatus.runtimeType);
    // } else {
    //   Twl.createAlert(context, 'error', checkApi['error']);
    // }

    res = await UserAPI().getGoldPrice(context);
    print('getGoldPrice>>>>>>>>>>>>>');
    print(res);
    if (mounted) {
      setState(() {
        priceDetails = res['details'];
        if (avalibleGoalGold != null) {
          goalTotalValue = avalibleGoalGold * (priceDetails['price_gram_24k']);
          print('goalTotalValue');
          print(goalTotalValue);
        }
      });
    }
    checkGold();
    // }

    print('getGoldPrice');
    print(res);
  }

  checkGold() async {
    var res =
        await UserAPI().checkAvaliableGold(context, physicalGold.toString());
    if (res != null && res['status'] == "OK") {
      if (mounted) {
        setState(() {
          totalGold = res['details']['availableGold'].toStringAsFixed(3);
          if (totalGold != null) {
            phyGoldValue = double.parse(totalGold.toString()) *
                (priceDetails['price_gram_24k']);
          }
        });
      }
    } else {}
    print('totalGold>>>>>>>>>>>>>');
    // print(totalGold);
    print(phyGoldValue);
    print(double.parse(totalGold.toString()));
  }

  var phyGoldType = 1;

  var selectedIndex = 0;
  var btnColor = tTextformfieldColor;
  var selectedvalue;

  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(context);
    return myGoalDetails == null
        ? Center(
            child: Container(
              width: 10.w,
              height: 10.w,
              child: CircularProgressIndicator(
                color: tPrimaryColor,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
                    color: tPrimaryColor,
                    child: Row(
                      children: [
                        ArgonButton(
                          highlightElevation: 0,
                          elevation: 0,
                          width: 30.w,
                          height: isTab(context) ? 200 : 140,
                          borderRadius: 15,
                          color: tContainerColor,
                          child: Goldcontainer(
                            // selectedvalue == 1 ? btnColor : tContainerColor,
                            goldGrams: _data.phyGoldDispalyType == 1
                                ? '${totalGold}g'
                                : (Secondarycurrency +
                                    phyGoldValue.toStringAsFixed(2)),
                            // goldGrams: '£5,300.72',
                            imagess: Images.GOLD,
                            title: "Physical Gold",
                            ontap: () async {
                              goldDisplaySheet(context, _data, phyGoldValue,
                                  totalGold, Images.GOLD, 1);

                              Segment.track(
                                eventName: 'physical_gold_button',
                                properties: {"tapped": true},
                              );

                              mixpanel.track(
                                'physical_gold_button',
                                properties: {"tapped": true},
                              );

                              await FirebaseAnalytics.instance.logEvent(
                                name: "physical_gold_button",
                                parameters: {"tapped": true},
                              );
                            },
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
                          onTap: (tartLoading, stopLoading, btnState) {
                            Twl.navigateTo(
                              context,
                              BottomNavigation(
                                tabIndexId: 0,
                                actionIndex: 0,
                                homeindex: 1,
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        // if (myGoalDetails != null)
                        if (myGoalDetails['status'] == 'NOK')
                          ArgonButton(
                            elevation: 0,
                            highlightElevation: 0,
                            height: isTab(context) ? 200 : 140,
                            width: 30.w,
                            borderRadius: 10,
                            color: tContainerColor,
                            child: Container(
                              width: 40.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // height: 5.h,
                                    // height: 38,
                                    child: Image.asset(
                                      Images.MUGOALGOLD,
                                      height: 35,
                                      // scale: 3,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 28,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        // color: tContainerColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    // padding: EdgeInsets.fromLTRB(30, 15, 15, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Start a Goal!",
                                            style: TextStyle(
                                                color: tBlue,
                                                fontFamily: 'Barlow',
                                                fontSize:
                                                    isTab(context) ? 11.sp : 19,
                                                fontWeight: FontWeight.w700)
                                            // style: TextStyle(
                                            //     fontSize:
                                            //         isTab(context) ? 13.sp : 19,
                                            //     fontWeight: FontWeight.w500,
                                            //     fontFamily: 'Barlow',
                                            //     color: tBlue),
                                            ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // if (verifStatus) {
                                            Twl.navigateTo(
                                                context, GoalAmount());
                                            // } else {
                                            //   Twl.navigateTo(
                                            //       context, VeriffiPage());
                                            // }
                                            // Twl.navigateTo(context, NameYourGoal());

                                            Segment.track(
                                              eventName: 'start_a_goal_button',
                                              properties: {"tapped": true},
                                            );

                                            mixpanel.track(
                                              'start_a_goal_button',
                                              properties: {"tapped": true},
                                            );

                                            await FirebaseAnalytics.instance
                                                .logEvent(
                                              name: "start_a_goal_button",
                                              parameters: {"tapped": true},
                                            );
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              // width: 26.w,
                                              // height: 22,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: tTextformfieldColor),
                                              child: Image.asset(
                                                Images.RIGHTARROW,
                                                scale: 7,
                                              )
                                              // Center(
                                              //   child: Text(
                                              //     'Start Now!',
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //       color: tSecondaryColor,
                                              //       // fontFamily: 'Signika',
                                              //       fontSize: 10.sp,
                                              //     ),
                                              //   ),
                                              // ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                            onTap: (tartLoading, stopLoading, btnState) {
                              Twl.navigateTo(context, GoalAmount());
                            },
                          ),
                        // if (myGoalDetails != null)
                        if (myGoalDetails['status'] == 'OK')
                          ArgonButton(
                            highlightElevation: 0,
                            elevation: 0,
                            height: isTab(context) ? 200 : 140,
                            width: 30.w,
                            borderRadius: 10,
                            color: tContainerColor,
                            child: Container(
                              width: 30.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 13),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Image.asset(
                                      'images/arc.png',
                                      width: 40,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 28,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _data.goalDispalyType == 1
                                            ? avalibleGoalGold
                                                    .toStringAsFixed(3) +
                                                'g'
                                            : '£${(goalTotalValue ?? 0).toStringAsFixed(2)}',
                                        style: TextStyle(
                                            color: tBlue,
                                            fontFamily: 'Barlow',
                                            fontSize:
                                                isTab(context) ? 13.sp : 24,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          goldDisplaySheet(
                                            context,
                                            _data,
                                            goalTotalValue,
                                            avalibleGoalGold ?? 0,
                                            Images.GOLD,
                                            2,
                                          );
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: tSecondaryColor)),
                                          child: Image.asset(
                                            'images/down.png',
                                            height: 8,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    myGoalDetails['name_of_goal'] == ''
                                        ? "My Goal"
                                        : myGoalDetails['details']
                                            ['name_of_goal'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: tBlue,
                                        fontFamily: 'Barlow',
                                        fontSize: isTab(context) ? 11.sp : 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
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
                            onTap: (tartLoading, stopLoading, btnState) {
                              Twl.navigateTo(
                                context,
                                BottomNavigation(
                                  tabIndexId: 0,
                                  actionIndex: 0,
                                  homeindex: 2,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  Container(
                    height: 3.h,
                    margin: EdgeInsets.all(0),
                    color: tPrimaryColor,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Text(
                      "Quick access",
                      style: TextStyle(
                          fontSize: isTab(context) ? 18.sp : 21.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Signika',
                          color: tSecondaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MenuContainerWidget(
                        tittle: "Buy Gold",
                        image: Images.QUICKGOLD,
                        onTap: (tartLoading, stopLoading, btnState) async {
                          await _data.changeActionIndex(0);
                          Twl.navigateTo(
                              context,
                              BottomNavigation(
                                tabIndexId: 1,
                                actionIndex: 0,
                              ));
                          _data.navGoldTypeaction('1');

                          Segment.track(
                            eventName: 'buy_gold_button',
                            properties: {"tapped": true},
                          );

                          await FirebaseAnalytics.instance.logEvent(
                            name: "buy_gold_button",
                            parameters: {"tapped": true},
                          );

                          mixpanel.track(
                            'buy_gold_button',
                            properties: {"tapped": true},
                          );
                        },
                      ),
                      MenuContainerWidget(
                        tittle: "Sell Gold",
                        image: Images.SELLGOLD,
                        onTap: (tartLoading, stopLoading, btnState) async {
                          await _data.changeActionIndex(1);
                          Twl.navigateTo(context,
                              BottomNavigation(tabIndexId: 1, actionIndex: 0));

                          Segment.track(
                            eventName: 'sell_gold_button',
                            properties: {"tapped": true},
                          );

                          await FirebaseAnalytics.instance.logEvent(
                            name: "sell_gold_button",
                            parameters: {"tapped": true},
                          );

                          mixpanel.track(
                            "sell_gold_button",
                            properties: {"tapped": true},
                          );
                        },
                      ),
                      MenuContainerWidget(
                        tittle: "Move",
                        image: Images.MOVE,
                        onTap: (tartLoading, stopLoading, btnState) async {
                          // await _data.changeActionIndex(2);
                          // print('_data.initialIndex');
                          // print(initialIndex);
                          // if (verifStatus) {
                          Twl.navigateTo(context,
                              BottomNavigation(tabIndexId: 1, actionIndex: 2));
                          _data.navGoldTypeaction('1');
                          // } else {
                          //   Twl.navigateTo(context, VeriffiPage());
                          // }
                          // widget.navigate(1);

                          Segment.track(
                            eventName: 'move_button',
                            properties: {"tapped": true},
                          );

                          await FirebaseAnalytics.instance.logEvent(
                            name: "move_button",
                            parameters: {"tapped": true},
                          );

                          mixpanel.track(
                            "move_button",
                            properties: {"tapped": true},
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MenuContainerWidget(
                        tittle: "Delivery",
                        image: Images.DELIVERY,
                        onTap: (tartLoading, stopLoading, btnState) async {
                          // if (verifStatus) {
                          await _data.changeActionIndex(3);
                          Twl.navigateTo(context,
                              BottomNavigation(tabIndexId: 1, actionIndex: 3));
                          // } else {
                          //   Twl.navigateTo(context, VeriffiPage());
                          // }
                          // widget.navigate(1);
                          // Twl.navigateTo(context, DeliveryForm());

                          Segment.track(
                            eventName: 'delivery_button',
                            properties: {"tapped": true},
                          );

                          await FirebaseAnalytics.instance.logEvent(
                            name: "delivery_button",
                            parameters: {"tapped": true},
                          );

                          mixpanel.track(
                            "delivery_button",
                            properties: {"tapped": true},
                          );
                        },
                      ),
                      MenuContainerWidget(
                        tittle: "Help",
                        image: Images.HELPHOME,
                        onTap: (tartLoading, stopLoading, btnState) async {
                          print("asdcsa");
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          var userId = sharedPreferences.getString('userId');
                          var userName = sharedPreferences.getString(
                                'firstName',
                              )! +
                              ' ' +
                              sharedPreferences.getString(
                                'lastName',
                              )!;
                          var phoneNumber =
                              sharedPreferences.getString('username');
                          var email = sharedPreferences.getString('email');
                          // print(userName);
                          print(phoneNumber);
                          print(email);
                          await Intercom.instance
                              .loginIdentifiedUser(userId: userId);
                          await Intercom.instance.updateUser(
                              name: userName, phone: phoneNumber, email: email);
                          await Intercom.instance.displayMessenger();
                          // Twl.navigateTo(context, Sorry());

                          Segment.track(
                            eventName: 'help_button',
                            properties: {"tapped": true},
                          );

                          await FirebaseAnalytics.instance.logEvent(
                            name: "help_button",
                            parameters: {"tapped": true},
                          );

                          mixpanel.track(
                            "help_button",
                            properties: {"tapped": true},
                          );
                        },
                      ),
                      MenuContainerWidget(
                        tittle: "New Goal",
                        image: Images.NEWGOAL,
                        onTap: (tartLoading, stopLoading, btnState) async {
                          // if (verifStatus) {
                          if (myGoalDetails['status'] == 'NOK') {
                            Twl.navigateTo(context, GoalAmount());
                          } else if (myGoalDetails['status'] == 'OK') {
                            Twl.navigateTo(context, Sorry());
                          }
                          // } else {
                          //   Twl.navigateTo(context, VeriffiPage());
                          // }

                          Segment.track(
                            eventName: 'new_goal_button',
                            properties: {"tapped": true},
                          );

                          await FirebaseAnalytics.instance.logEvent(
                            name: "new_goal_button",
                            parameters: {"tapped": true},
                          );

                          mixpanel.track(
                            "new_goal_button",
                            properties: {"tapped": true},
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

goldDisplaySheet(context, _data, amount, gram, image, type) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      topRight: Radius.circular(10),
    )),
    context: context,
    builder: (ctx) {
      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 10,
                    width: 30.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tPrimaryColor3,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (type == 1) {
                      _data.phyGoldAction(2);
                    } else {
                      _data.goalGoldAction(2);
                    }

                    // setState(() {
                    //   phyGoldType = 2;
                    // });
                    // print('phyGoldType' +
                    //     phyGoldType.toString());
                    Twl.navigateBack(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tTextformfieldColor,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Image.asset(
                            Images.SELLGOLD,
                            scale: 4.5,
                            // height: 20,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'View in GBP',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Barlow',
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),
                        Spacer(),
                        Text(
                          Secondarycurrency + (amount ?? 0).toStringAsFixed(2),
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (type == 1) {
                      _data.phyGoldAction(1);
                    } else {
                      _data.goalGoldAction(1);
                    }

                    Twl.navigateBack(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tTextformfieldColor,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          image,
                          height: 20,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'View in Grams',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Barlow',
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${double.parse(gram.toString()).toStringAsFixed(3)}g',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: isTab(context) ? 10.sp : 12.sp,
                            color: tSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        );
      });
    },
  );
}

// checkVeriffStatus(context) async {
//   SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
//   var authCode = sharedPrefs.getString('authCode');
//   var checkApi = await UserAPI().checkApi(authCode);
//   print(checkApi);
//   if (checkApi != null && checkApi['status'] == 'OK') {
//     return checkApi['detail']['veriff_status'];
//   } else {
//     // return Twl.createAlert(context, 'error', checkApi['error']);
//   }
// }
