import 'package:base_project_flutter/api_services/orderApi.dart';
import 'package:base_project_flutter/api_services/stripeApi.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/globalWidgets/customTextFiled.dart';
import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/models/myOrders.dart' as myOrdersModel;
import 'package:base_project_flutter/provider/actionProvider.dart';
import 'package:base_project_flutter/views/editmaingoal/editmaingoal.dart';
import 'package:base_project_flutter/views/homePage/components/dashBoardPage.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalAmount.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:base_project_flutter/views/successfullPage/deliverySucessfull.dart';
import 'package:base_project_flutter/views/successfullPage/thanksForStaetingGoalSucessfull.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../globalWidgets/button.dart';
import '../../../models/myOrders.dart';
import '../../../responsive.dart';
import '../../activity/activity.dart';
import '../../bottomNavigation.dart/bottomNavigation.dart';
import '../../components/BuyContainerWidget.dart';
import '../../components/accountValueContainer.dart';
import '../../components/alertPage.dart';
import '../../components/menuContainerWidget.dart';
import '../../nameyourgoal/nameyourgoal.dart';
import '../../veriffPage/veriffPage.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  late Future<myOrdersModel.MyOrderDetialsModel> MyOrderDetials;
  final goalNameController = TextEditingController();
  final goalAmountController = TextEditingController();
  int repeatType = 0;
  bool goalIsActive = false;
  bool editGoalName = false;
  bool editGoalAmount = false;
  String goalName = "";
  String goalAmount = "";
  bool invalidEntryName = false;
  bool invalidEntryAmount = false;
  @override
  void initState() {
    getMyGoal();

    MyOrderDetials = UserAPI().getMyOrders(context, '0', '2');
    super.initState();
  }

  var myGoalDetails;
  var goalTotalValue;
  var avalibleGoalGold;
  var verifStatus;
  var defPaymentDeatils;
  var goalId;
  getMyGoal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var status = await checkVeriffStatus(context);
    // setState(() {
    //   verifStatus = status;
    //   print(verifStatus.runtimeType);
    // });

    Segment.track(
      eventName: 'goals_screen',
      properties: {"clicked": true},
    );

    await FirebaseAnalytics.instance.logEvent(
      name: "goals_screen",
      parameters: {"clicked": true},
    );

    var res = await UserAPI().getMyGoals(context);

    if (res != null && res['status'] == 'OK') {
      setState(() {
        sharedPreferences.setString("goalName", res['details']['name_of_goal']);
        myGoalDetails = res;
        avalibleGoalGold = res['details']['availableGoldByGoal'];
        goalId = res['details']['id'].toString();

        print("avalibleGoalGold>>>>>>>>>>>>>>>");
        print(avalibleGoalGold);
        print(avalibleGoalGold.runtimeType);
      });
      var cusId = sharedPreferences.getString('cusId');
      print('cusId>>>>>>>>>>>>' + cusId.toString());
      var defPmId;
      var cusDetails = await StripePaymentApi()
          .getCustomerPaymentDetails(context, cusId.toString());
      print("cusDetails" + cusDetails.toString());
      if (cusDetails != null) {
        defPmId = cusDetails['invoice_settings']['default_payment_method'];

        print(defPmId);
        var result = await StripePaymentApi()
            .getCustomerCards(context, cusId.toString());
        print("cardlist>>>>>>>>");
        print(result);
        if (result != null) {
          for (var i = 0; i <= result['data']!.length - 1; i++) {
            if (result['data'][i]['id'] == defPmId) {
              if (mounted) {
                setState(() {
                  defPaymentDeatils = result['data'][i];
                });
              }
              break;
            }
          }
          print(defPaymentDeatils);
          // print("defPaymentDeatils>>>>>>" +
          //     defPaymentDeatils['card']['wallet']['type']);
        }
      }
    } else {
      setState(() {
        myGoalDetails = res;
      });
    }
    getGoldPrice();
  }

  var res;
  var priceDetails;
  getGoldPrice() async {
    if (mounted) {
      res = await UserAPI().getGoldPrice(context);
      if (avalibleGoalGold != null) {
        if (mounted) {
          setState(() {
            priceDetails = res['details'];
            goalTotalValue =
                avalibleGoalGold * (priceDetails['price_gram_24k']);
            print("goalTotalValue>>>>>>>>>>>>>>");
            print(goalTotalValue);
          });
        }
      }
      print('getGoldPrice');
      print(res);
    }
  }

  x() async {
    Twl.navigateTo(context, GoalAmount());
    Segment.track(
      eventName: 'start_goal_button',
      properties: {"clicked": true},
    );

    await FirebaseAnalytics.instance.logEvent(
      name: "start_goal_button",
      parameters: {"clicked": true},
    );

    mixpanel.track(
      'start_goal_button',
      properties: {"clicked": true},
    );
  }

  bool loading = false;

  void repeatgoal() {
    showMaterialModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setStates2) {
        return Container(
          height: 90.h,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      child: Container(
                        height: 4,
                        width: 20.w,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: tPrimaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Repeats on",
                            style: TextStyle(
                              fontFamily: 'Barlow',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Done",
                            style: TextStyle(
                                fontFamily: 'Barlow',
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: tlightBlue),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Divider(
                      height: 4,
                      color: tgrayColor2,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Start Date",
                            style: TextStyle(
                                fontFamily: 'Barlow',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Your first transaction will occur on this date",
                            style: TextStyle(
                                fontFamily: 'Barlow',
                                fontSize: 10,
                                color: grayColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Today - 23/02/2023",
                                style: TextStyle(
                                    fontFamily: 'Barlow',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: tgreenColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: tSecondaryColor)),
                                child: Center(
                                  child: Image.asset(
                                    "images/tick.png",
                                    width: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider(
                            height: 4,
                            color: tGray,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Text(
                            "Repeats",
                            style: TextStyle(
                                fontFamily: 'Barlow',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Your subsequent transactions will occur on this schedule",
                            style: TextStyle(
                                fontFamily: 'Barlow',
                                fontSize: 10,
                                color: grayColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Daily",
                                style: TextStyle(
                                    fontFamily: 'Barlow',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  setStates2(() {
                                    repeatType = 0;
                                  });
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      color: repeatType == 0
                                          ? tgreenColor
                                          : twhiteColor2,
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: tSecondaryColor)),
                                  child: Center(
                                    child: repeatType != 0
                                        ? null
                                        : Image.asset(
                                            "images/tick.png",
                                            width: 14,
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider(
                            height: 4,
                            color: tlightGray,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Weekly",
                                style: TextStyle(
                                    fontFamily: 'Barlow',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  setStates2(() {
                                    repeatType = 1;
                                  });
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      color: repeatType == 1
                                          ? tgreenColor
                                          : twhiteColor2,
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: tSecondaryColor)),
                                  child: Center(
                                    child: repeatType != 1
                                        ? null
                                        : Image.asset(
                                            "images/tick.png",
                                            width: 14,
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Divider(
                            height: 4,
                            color: tlightGray,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Monthly",
                                style: TextStyle(
                                    fontFamily: 'Barlow',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () {
                                  setStates2(() {
                                    repeatType = 2;
                                  });
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      color: repeatType == 2
                                          ? tgreenColor
                                          : twhiteColor2,
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: tSecondaryColor)),
                                  child: Center(
                                    child: repeatType != 2
                                        ? null
                                        : Image.asset(
                                            "images/tick.png",
                                            width: 14,
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void editgoal() {
    // getGoalData();
    print("myGoalDetails--->" + myGoalDetails.toString());
    goalNameController.text = myGoalDetails['details']['name_of_goal'];
    goalAmountController.text =
        myGoalDetails['details']['goal_amount'].toString();
    goalIsActive =
        myGoalDetails['details']['current_status'] == 2 ? true : false;
    print("defPaymentDeatils");
    print(defPaymentDeatils);
    setState(() {
      editGoalName = false;
      editGoalAmount = false;
      invalidEntryName = false;
      invalidEntryAmount = false;
    });
    showMaterialModalBottomSheet(
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (contexts, setStates) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setStates(() {
                editGoalName = false;
                editGoalAmount = false;
              });
            },
            child: Container(
              height: 75.h,
              padding: MediaQuery.of(context).viewInsets,
              child: CustomScrollView(
                // padding: EdgeInsets.all(0),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        Align(
                          child: Container(
                            height: 4,
                            width: 20.w,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: tPrimaryColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Edit Goal",
                                    style: TextStyle(
                                      fontFamily: 'Barlow',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                          backgroundColor: tredColor,
                                          radius: 12,
                                          child: Image.asset(
                                            "images/bin.png",
                                            width: 15,
                                          )),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        "End Goal",
                                        style: TextStyle(
                                          fontFamily: 'Barlow',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: tYellow,
                                        size: 16,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Click off the popup to discard\nchanges.",
                                style: TextStyle(
                                    fontFamily: 'Barlow',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: grayColor),
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Text(
                                "Goal Name",
                                style: TextStyle(
                                  fontFamily: 'Barlow',
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: invalidEntryName
                                            ? tredColor
                                            : tSecondaryColor)),
                                child: editGoalName
                                    ? TextFormField(
                                        autofocus: true,
                                        textAlign: TextAlign.center,
                                        controller: goalNameController,
                                        style: TextStyle(
                                            fontFamily: 'Barlow',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setStates(() {
                                            if (!editGoalName)
                                              editGoalName = true;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                goalNameController.text,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'Barlow',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.edit,
                                              size: 14,
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Goal Status",
                                style: TextStyle(
                                  fontFamily: 'Barlow',
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                    border: Border.all(color: tSecondaryColor),
                                    borderRadius: BorderRadius.circular(24)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setStates(() {
                                            if (!goalIsActive)
                                              goalIsActive = true;
                                          });
                                        },
                                        child: Container(
                                          height: 22,
                                          decoration: BoxDecoration(
                                              color: goalIsActive
                                                  ? tPrimaryColor
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          child: Center(
                                            child: Text(
                                              "Active",
                                              style: TextStyle(
                                                  fontFamily: 'Barlow',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: tSecondaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setStates(() {
                                            if (goalIsActive)
                                              goalIsActive = false;
                                          });
                                        },
                                        child: Container(
                                          height: 22,
                                          decoration: BoxDecoration(
                                              color: !goalIsActive
                                                  ? tPrimaryColor
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                          child: Center(
                                            child: Text(
                                              "Inactive",
                                              style: TextStyle(
                                                  fontFamily: 'Barlow',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: tSecondaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Recurring Order of:",
                                style: TextStyle(
                                  fontFamily: 'Barlow',
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: invalidEntryAmount
                                            ? tredColor
                                            : tSecondaryColor)),
                                child: editGoalAmount
                                    ? TextFormField(
                                        autofocus: true,
                                        textAlign: TextAlign.center,
                                        controller: goalAmountController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        style: TextStyle(
                                            fontFamily: 'Barlow',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setStates(() {
                                            if (!editGoalAmount)
                                              editGoalAmount = true;
                                            print(editGoalAmount);
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                "£${getAmount(goalAmountController.text)} worth of Gold",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'Barlow',
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.edit,
                                              size: 14,
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Paying with",
                                        style: TextStyle(
                                          fontFamily: 'Barlow',
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      if (defPaymentDeatils != null)
                                        Row(
                                          children: [
                                            Image.asset(
                                              getcardType(defPaymentDeatils[
                                                          'card']['wallet'] !=
                                                      null
                                                  ? defPaymentDeatils['card']
                                                      ['wallet']['type']
                                                  : ''),
                                              width: 30,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              getcardTypeName(defPaymentDeatils[
                                                          'card']['wallet'] !=
                                                      null
                                                  ? defPaymentDeatils['card']
                                                      ['wallet']['type']
                                                  : ''),
                                              style: TextStyle(
                                                  fontFamily: 'Barlow',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            InkWell(
                                              child: Image.asset(
                                                "images/down.png",
                                                width: 12,
                                              ),
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Repeat",
                                        style: TextStyle(
                                          fontFamily: 'Barlow',
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      InkWell(
                                        onTap: repeatgoal,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "images/calender.png",
                                              width: 24,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "Monthly on 23rd",
                                              style: TextStyle(
                                                  fontFamily: 'Barlow',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            InkWell(
                                              child: Image.asset(
                                                "images/down.png",
                                                width: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: loading
                                          ? null
                                          : () async {
                                              if (goalNameController
                                                      .text.isEmpty ||
                                                  goalNameController.text ==
                                                      "" ||
                                                  goalAmountController
                                                      .text.isEmpty ||
                                                  getAmount(goalAmountController
                                                          .text) ==
                                                      "") {
                                                if ((goalNameController
                                                            .text.isEmpty ||
                                                        goalNameController
                                                                .text ==
                                                            "") &&
                                                    (goalAmountController
                                                            .text.isEmpty ||
                                                        getAmount(
                                                                goalAmountController
                                                                    .text) ==
                                                            "")) {
                                                  print("bothfalse");
                                                  setStates(() {
                                                    invalidEntryName = true;
                                                    invalidEntryAmount = true;
                                                  });
                                                }

                                                if (goalNameController
                                                        .text.isEmpty ||
                                                    goalNameController.text ==
                                                        "")
                                                  setStates(() {
                                                    invalidEntryName = true;
                                                    invalidEntryAmount = false;
                                                  });
                                                if (goalAmountController
                                                        .text.isEmpty ||
                                                    getAmount(
                                                            goalAmountController
                                                                .text) ==
                                                        "")
                                                  setStates(() {
                                                    invalidEntryAmount = true;
                                                    invalidEntryName = false;
                                                  });
                                                return;
                                              }
                                              setStates(() {
                                                loading = true;
                                                invalidEntryAmount = false;
                                                invalidEntryName = false;
                                              });
                                              var goalName;
                                              var amount;
                                              var date;
                                              var currentStatus =
                                                  goalIsActive ? 2 : 1;
                                              goalName =
                                                  goalNameController.text;
                                              amount =
                                                  goalAmountController.text;
                                              date = "1st of every month";
                                              print("currentstatus" +
                                                  currentStatus.toString());
                                              var response = await OrderAPI()
                                                  .editGoal(
                                                      context,
                                                      goalId,
                                                      goalName,
                                                      amount.replaceAll(
                                                          RegExp(
                                                              Secondarycurrency),
                                                          ''),
                                                      date,
                                                      '1',
                                                      currentStatus.toString());
                                              print(response);
                                              setStates(() {
                                                loading = false;
                                              });
                                              Navigator.pop(context);
                                              Twl.navigateTo(
                                                  context,
                                                  BottomNavigation(
                                                    actionIndex: 0,
                                                    tabIndexId: 0,
                                                  ));
                                            },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: tPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: loading
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                "Confirm Changes",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'Barlow',
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(context);
    return (myGoalDetails == null && defPaymentDeatils == null)
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
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (myGoalDetails != null)
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        if (myGoalDetails['status'] == 'NOK')
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: tContainerColor,
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Hit those Goals!",
                                  style: TextStyle(
                                      fontSize: isTab(context) ? 13.sp : 14.sp,
                                      fontWeight: FontWeight.bold,
                                      // fontFamily: 'Signika',
                                      color: tSecondaryColor),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 21.w),
                                  child: Container(
                                    height: 40,
                                    width: 230,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        primary: tPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                      child: Text('Start a goal!',
                                          style: TextStyle(
                                            color: tBlue,
                                          )),
                                      onPressed: x,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Image.asset(
                                  Images.NEWGOAL,
                                  scale: 1.7,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        if (myGoalDetails['status'] == 'NOK')
                          SizedBox(
                            height: 30,
                          ),
                        if (myGoalDetails['status'] == 'NOK')
                          Center(
                            child: Container(
                              width: 100.w,
                              child: Text(
                                "Metfolio Goals! Set up a fully personalised\ngoal and start buying physical gold\nautomatically every single month.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: isTab(context) ? 8.sp : 11.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Signika',
                                    color: tSecondaryColor),
                              ),
                            ),
                          ),
                      ],
                    ),
                  if (myGoalDetails != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (myGoalDetails['status'] == 'OK')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // SizedBox(
                              //   height: 4.h,
                              // ),
                              AccountvalueContainer(
                                  goal: true,
                                  physcialGold: false,
                                  tittle: myGoalDetails['details']
                                      ['name_of_goal'],
                                  subtittle:
                                      "${avalibleGoalGold.toStringAsFixed(3)} g",
                                  value: "Total - " +
                                      (_data.goalDispalyType == 1
                                          ? "${avalibleGoalGold.toStringAsFixed(3)} g"
                                          : "${Secondarycurrency + (goalTotalValue ?? 0).toStringAsFixed(2)}"),
                                  onTap: (myGoalDetails['details']
                                                  ['subscription_status'] !=
                                              '1' &&
                                          myGoalDetails['details']
                                                  ['subscription_status'] !=
                                              1)
                                      ? () {
                                          goldDisplaySheet(
                                              context,
                                              _data,
                                              goalTotalValue,
                                              avalibleGoalGold,
                                              Images.GOLD,
                                              2);
                                        }
                                      : null
                                  // (startLoading, stopLoading, btnState) {
                                  //   // if (verifStatus) {
                                  //   goldDisplaySheet(
                                  //       context,
                                  //       _data,
                                  //       goalTotalValue,
                                  //       avalibleGoalGold,
                                  //       Images.GOLD,
                                  //       2);
                                  //   // } else {
                                  //   //   Twl.navigateTo(context, VeriffiPage());
                                  //   // }
                                  // },
                                  ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Quick access",
                                  style: TextStyle(
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Signika',
                                      color: tSecondaryColor),
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MenuContainerWidget(
                                      tittle: "Buy & Sell",
                                      image: Images.QUICKGOLD,
                                      onTap:
                                          (tartLoading, stopLoading, btnState) {
                                        // if (verifStatus) {
                                        _data.changeActionIndex(0);
                                        _data.navGoldTypeaction('2');
                                        Twl.navigateTo(
                                            context,
                                            BottomNavigation(
                                                tabIndexId: 1, actionIndex: 0));
                                        // } else {
                                        //   Twl.navigateTo(
                                        //       context, VeriffiPage());
                                        // }
                                        // Twl.navigateTo(context,
                                        //     ThanksForStartingGoalSucessful());
                                      },
                                    ),
                                    MenuContainerWidget(
                                      tittle: "Edit Goal",
                                      image: Images.EDITGOAL,
                                      onTap:
                                          (tartLoading, stopLoading, btnState) {
                                        // if (verifStatus) {
                                        Twl.navigateTo(context, EditMainGoal());

                                        // } else {
                                        //   Twl.navigateTo(
                                        //       context, VeriffiPage());
                                        // }
                                        // Twl.navigateTo(
                                        //     context, EditGoalAmount());
                                      },
                                    ),
                                    MenuContainerWidget(
                                      tittle: "Move",
                                      image: Images.MOVE,
                                      onTap:
                                          (tartLoading, stopLoading, btnState) {
                                        // if (verifStatus) {
                                        // _data.navGoldTypeaction('2');
                                        // Twl.navigateTo(
                                        //     context,
                                        //     BottomNavigation(
                                        //         tabIndexId: 1, actionIndex: 2));
                                        editgoal();
                                        // } else {
                                        //   Twl.navigateTo(
                                        //       context, VeriffiPage());
                                        // }
                                        // Twl.navigateTo(
                                        //     context, DeliverySucessful());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Activity",
                                  style: TextStyle(
                                      fontSize: isTab(context) ? 13.sp : 16.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Signika',
                                      color: tSecondaryColor),
                                ),
                              ),

                              // BuyContainerWidget(
                              //   tittle: "Buy",
                              //   date: "16th February",
                              //   goldgrams: "36.9 Grams",
                              //   cost: "£1335",
                              // ),
                              // SizedBox(
                              //   height: 2.h,
                              // ),
                              // GestureDetector(
                              //   onTap: () {
                              //     Twl.navigateTo(context, EditMainGoal());
                              //   },
                              //   child: BuyContainerWidget(
                              //     tittle: "Buy",
                              //     date: "14th February",
                              //     goldgrams: "36.9 Grams",
                              //     cost: "£1335",
                              //   ),
                              // ),
                              SizedBox(
                                height: 3.h,
                              ),
                              // StartGoal()
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: FutureBuilder<MyOrderDetialsModel>(
                                    future: MyOrderDetials,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        // return Text(snapshot.error.toString());
                                        print("ERROR" +
                                            snapshot.error.toString());
                                      }
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return Center(
                                            child: Container(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(
                                            color: tPrimaryColor,
                                          ),
                                        ));
                                        ;
                                      }
                                      if (snapshot.hasData) {
                                        return ActivityPagination(
                                          details: snapshot.data,
                                        );
                                      } else {
                                        return Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 3.h,
                                                ),
                                                Text(
                                                    'Your transactions will appear here.'),
                                              ],
                                            ));
                                      }
                                    }),
                              )
                            ],
                          ),
                      ],
                    ),
                ],
              ),
            ),
          );
  }
}

class ActivityPagination extends StatefulWidget {
  const ActivityPagination({
    Key? key,
    this.details,
    this.headHide,
    this.totalGold,
    this.priceDetails,
  }) : super(key: key);
  final details;
  final headHide;
  final totalGold;
  final priceDetails;

  @override
  State<ActivityPagination> createState() => _ActivityPaginationState();
}

class _ActivityPaginationState extends State<ActivityPagination> {
  // late Future<myOrdersModel.MyOrderDetialsModel> MyOrderDetials;
  ScrollController scrollController = new ScrollController();
  late final List<myOrdersModel.Detail> myOrderDetails;
  late double scrollPosition;
  int page = 0;
  _scrollListener() {
    if (scrollController.position.maxScrollExtent > scrollController.offset &&
        scrollController.position.maxScrollExtent - scrollController.offset <=
            55) {
      print('End Scroll');
      page = (page + 1);
      UserAPI().getMyOrders(context, page.toString(), '2').then((val) {
        // currentPage = currentPage++;
        if (val.details != null) {
          setState(() {
            // currentPage = currentPage + 1;
            myOrderDetails.addAll(val.details);
          });
        } else {
          return Center(
            child: Text('End of data'),
          );
        }
      });
    }
  }

  void initState() {
    scrollController = ScrollController();
    myOrderDetails = widget.details.details;
    scrollController.addListener(_scrollListener);
    // CheckGold();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: myOrderDetails.length >= 4 ? 4 : myOrderDetails.length,
        controller: scrollController,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          var details = myOrderDetails[index];
          return Column(
            children: [
              if (details.typeId != 3)
                BuyContainerWidget(
                  tittle: getTypeOfActivity(details.typeId),
                  // ?details.typeId == Buy ? "Buy": details.typeId == Move? 'Move': "Sell",
                  date: Twl.dateFormate(details.createdOn),
                  goldgrams:
                      "${(double.parse(details.quantity.replaceAll('g', ''))).toStringAsFixed(3)} Grams",
                  cost: (details.typeId == 1 || details.typeId == 2)
                      ? "£${details.totalWTax != null ? (details.totalWTax).toStringAsFixed(2) : ''}"
                      : null,
                  des: (details.typeId == 3 || details.typeId == 4)
                      ? (details.moveDesc ?? '')
                      : '',
                ),
              if (details.typeId != 3)
                SizedBox(
                  height: 2.h,
                ),
            ],
          );
        },
      ),
    );
  }
}

getcardType(type) {
  switch (type) {
    case 'apple_pay':
      return Images.APPLEMARK;
      break;
    case 'google_pay':
      return Images.GPAYMARK;
      break;
    default:
      return Images.PAYMENTCARDICON;
  }
}

getcardTypeName(type) {
  switch (type) {
    case 'apple_pay':
      return "Apple Pay";
      break;
    case 'google_pay':
      return "Google Pay";
      break;
    default:
      return "Card";
  }
}

getAmount(amt) {
  var ans = "";
  for (int i = 0; i < amt.length; i++) {
    if (amt[i] == '0')
      continue;
    else {
      ans = amt.substring(i);
      break;
    }
  }
  return ans;
}
