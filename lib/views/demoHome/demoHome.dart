import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/responsive.dart';

import 'package:base_project_flutter/views/homePage/components/goals.dart';
import 'package:base_project_flutter/views/homePage/components/account.dart';
import 'package:base_project_flutter/views/logiPage/loginPage.dart';
import 'package:base_project_flutter/views/profilePage/profilePage.dart';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../components/goldcontainer.dart';
import '../components/menuContainerWidget.dart';
import '../homePage/components/dashBoardPage.dart';

class DemoHome extends StatefulWidget {
  final naviagte;

  const DemoHome({this.naviagte});

  @override
  State<DemoHome> createState() => _HomePageState();
}

class _HomePageState extends State<DemoHome>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;

  _onTabTapped(int index) {
    setState(() {
      tabIndex = index;
    });
    controller.animateTo(
      index,
      duration: Duration(milliseconds: 10),
      curve: Curves.easeIn,
    );
  }

  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      body: GestureDetector(
        onTap: () {
          Twl.navigateTo(context, LoginMobileNumber1());
        },
        child: DefaultTabController(
          // initialIndex: tabIndex,
          length: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Twl.navigateTo(context, LoginMobileNumber1());
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                            color: tPrimaryColor, shape: BoxShape.circle),
                        child: Text(
                          "AB",
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 10.sp : 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  color: Theme.of(context).canvasColor,
                  child: TabBar(
                    controller: controller,
                    indicator: BoxDecoration(
                      color: tIndicatorColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    indicatorPadding: EdgeInsets.only(top: 36, bottom: 9),
                    isScrollable: true,
                    labelColor: tSecondaryColor,
                    labelStyle: TextStyle(
                      fontFamily: "Barlow",
                      color: tWhite,
                      fontSize: isTab(context) ? 11.sp : 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelColor: tSecondaryColor,
                    unselectedLabelStyle: TextStyle(
                      color: tWhite,
                      fontFamily: "Barlow",
                      fontSize: isTab(context) ? 11.sp : 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    indicatorWeight: 8,
                    onTap: (index) {
                      Twl.navigateTo(context, LoginMobileNumber1());
                      // _onTabTapped(index);
                    },
                    tabs: [
                      Tab(
                        text: "Dashboard",
                      ),
                      Tab(
                        text: "Accounts",
                      ),
                      Tab(
                        text: "Goals",
                      )
                    ],
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      controller: controller,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Twl.navigateTo(context, LoginMobileNumber1());
                          },
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3.h,
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Twl.navigateTo(
                                              context, LoginMobileNumber1());
                                        },
                                        child: Goldcontainer(
                                          goldGrams: '£5,300.72',
                                          title: "Physical Gold",
                                          imagess: Images.GOLD,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Twl.navigateTo(
                                              context, LoginMobileNumber1());
                                        },
                                        child: Goldcontainer(
                                          goldGrams: '£5,300.72',
                                          title: "My Goal",
                                          imagess: Images.MUGOALGOLD,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 6.h,
                                  ),
                                  Text(
                                    "Quick access",
                                    style: TextStyle(
                                        fontSize:
                                            isTab(context) ? 18.sp : 21.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Signika',
                                        color: tSecondaryColor),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Twl.navigateTo(
                                              context, LoginMobileNumber1());
                                        },
                                        child: MenuContainerWidget(
                                          tittle: "Buy Gold",
                                          image: Images.GOLD,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Twl.navigateTo(
                                              context, LoginMobileNumber1());
                                        },
                                        child: MenuContainerWidget(
                                          tittle: "Sell Gold",
                                          image: Images.SELLGOLD,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Twl.navigateTo(
                                              context, LoginMobileNumber1());
                                        },
                                        child: MenuContainerWidget(
                                          tittle: "Move",
                                          image: Images.MOVE,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Twl.navigateTo(
                                              context, LoginMobileNumber1());
                                        },
                                        child: MenuContainerWidget(
                                          tittle: "Delivery",
                                          image: Images.DELIVERY,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Twl.navigateTo(
                                              context, LoginMobileNumber1());
                                        },
                                        child: MenuContainerWidget(
                                          tittle: "Help",
                                          image: Images.HELP,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Twl.navigateTo(
                                              context, LoginMobileNumber1());
                                        },
                                        child: MenuContainerWidget(
                                          tittle: "New Goal",
                                          image: Images.NEWGOAL,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AccountPage(),
                        GoalsPage(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
