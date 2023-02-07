import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/provider/actionProvider.dart';
import 'package:base_project_flutter/views/actions/components/buyAndSell.dart';
import 'package:base_project_flutter/views/actions/components/deliver.dart';
import 'package:base_project_flutter/views/actions/components/move.dart';
import 'package:base_project_flutter/views/actions/components/prices.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';
import '../homePage/homePage.dart';
import '../profilePage/profilePage.dart';

class ActionsPage extends StatefulWidget {
  const ActionsPage({
    Key? key,
    this.actionIndex,
    this.laoder,
  }) : super(key: key);
  final actionIndex;
  final laoder;
  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  // = new TabController(vsync: this, initialIndex: 0, length:4);

  e() async {
    Segment.track(
      eventName: 'actions_page',
      properties: {"tapped": true},
    );

    await FirebaseAnalytics.instance.logEvent(
      name: "actions_page",
      parameters: {"tapped": true},
    );

    mixpanel.track(
      "actions_page",
      properties: {"tapped": true},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    // _tabController = new TabController(vsync: this, initialIndex: 2, length: 4);
    super.initState();
    e();
  }

  bool loadingPaymentStatus = false;
  // loader(value) {
  //   setState(() {
  //     loadingPaymentStatus = value;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // ActionProvider _data = Provider.of<ActionProvider>(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: tWhite,
        body:
            // Consumer<ActionProvider>(
            //   builder: (context, auth, _) =>
            DefaultTabController(
          length: 4,
          initialIndex: widget.actionIndex ?? 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 3.h,
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       NameClip(),
                //       // GestureDetector(
                //       //   onTap: () {
                //       //     Twl.navigateTo(context, ProfilePage());
                //       //   },
                //       //   child: Container(
                //       //     padding:
                //       //         EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                //       //     decoration: BoxDecoration(
                //       //         color: tPrimaryColor, shape: BoxShape.circle),
                //       //     child: Text("AB",
                //       //         style: TextStyle(
                //       //             color: tSecondaryColor,
                //       //             fontSize: isTab(context) ? 10.sp : 13.sp,
                //       //             fontWeight: FontWeight.w400)),
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 1.h,
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Theme(
                    data: ThemeData(
                      highlightColor: Colors.white,
                      splashColor: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                    child: Container(
                      color: Colors.transparent,
                      child: TabBar(
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
                            color: tWhite,
                            fontFamily: "Barlow",
                            fontSize: isTab(context) ? 10.sp : 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelColor: tSecondaryColor,
                          unselectedLabelStyle: TextStyle(
                            color: tWhite,
                            fontFamily: "Barlow",
                            fontSize: isTab(context) ? 10.sp : 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          indicatorWeight: 7,
                          tabs: [
                            Tab(
                              text: "Buy and Sell",
                            ),
                            Tab(
                              text: "Prices",
                            ),
                            Tab(
                              text: "Move",
                            ),
                            Tab(
                              text: "Deliver",
                            ),
                          ],
                          onTap: (init) {
                            FocusScope.of(context).unfocus();
                            // FocusManager.instance.primaryFocus?.unfocus();
                            // FocusScope.of(context).requestFocus(FocusNode());
                            // _data.changeActionIndex(init);
                            // print(_data.initialIndex);
                          },
                          indicatorSize: TabBarIndicatorSize.label),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(physics: NeverScrollableScrollPhysics(),
                        // controller: _tabController,
                        children: [
                          BuyAndSell(
                            loader: widget.laoder,
                          ),
                          Prices(),
                          MoveAction(),
                          DeliverPage(),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
