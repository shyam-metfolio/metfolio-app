import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/models/myOrders.dart' as myOrdersModel;
import 'package:base_project_flutter/provider/actionProvider.dart';
import 'package:base_project_flutter/views/editmaingoal/editmaingoal.dart';
import 'package:base_project_flutter/views/homePage/components/dashBoardPage.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalAmount.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_segment/flutter_segment.dart';
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
        print("avalibleGoalGold>>>>>>>>>>>>>>>");
        print(avalibleGoalGold);
        print(avalibleGoalGold.runtimeType);
      });
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
    res = await UserAPI().getGoldPrice(context);
    if (avalibleGoalGold != null) {
      setState(() {
        priceDetails = res['details'];
        goalTotalValue = avalibleGoalGold * (priceDetails['price_gram_24k']);
        print("goalTotalValue>>>>>>>>>>>>>>");
        print(goalTotalValue);
      });
    }
    print('getGoldPrice');
    print(res);
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

  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(context);
    return (myGoalDetails == null)
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
                                        _data.navGoldTypeaction('2');
                                        Twl.navigateTo(
                                            context,
                                            BottomNavigation(
                                                tabIndexId: 1, actionIndex: 2));
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
