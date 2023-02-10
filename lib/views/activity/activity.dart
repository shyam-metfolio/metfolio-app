import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/models/myOrders.dart' as myOrdersModel;
import 'package:base_project_flutter/views/veriffPage/veriffPage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart' as dt;
import 'package:flutter_segment/flutter_segment.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../api_services/userApi.dart';
import '../../constants/constants.dart';

import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../models/myOrders.dart';
import '../../provider/actionProvider.dart';
import '../../responsive.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../components/BuyContainerWidget.dart';
import '../components/accountValueContainer.dart';
import '../components/menuContainerWidget.dart';
import '../homePage/components/dashBoardPage.dart';
import '../successfullPage/PurchesedConfirmSucessfull.dart';
import '../successfullPage/SaleIsConfirmSucessfull.dart';
import '../successfullPage/movedsucessfull.dart';
import 'package:date_utils/date_utils.dart' as utls;

var verifStatus;

class Activity extends StatefulWidget {
  const Activity({Key? key, this.headHide}) : super(key: key);
  final headHide;
  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  Future<myOrdersModel.MyOrderDetialsModel>? MyOrderDetials;
  void initState() {
    setState(() {
      MyOrderDetials =
          UserAPI().getMyOrders(context, '0', widget.headHide ? '1' : '');
    });
    checkGold();

    super.initState();
  }

  var res;
  var priceDetails;
  var totalGoldPrice;
  getGoldPrice() async {
    if (mounted) {
      res = await UserAPI().getGoldPrice(context);
      if (totalGold != 0) {
        if (mounted) {
          setState(() {
            priceDetails = res['details'];
            totalGoldPrice = totalGold * (priceDetails['price_gram_24k']);
          });
        }
      }
    }

    print('getGoldPrice');
    print(res);
  }

  var totalGold = 0.0;
  String flitervalue = '';
  checkGold() async {
    // var status = await checkVeriffStatus(context);
    // setState(() {
    //   verifStatus = status;
    //   print(verifStatus.runtimeType);
    // });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.remove('startDate');
    // sharedPreferences.remove('endDate');

    Segment.track(
      eventName: 'accounts_screen',
      properties: {
        "userName": sharedPreferences.getString('userName'),
        "email": sharedPreferences.getString('email'),
        "clicked": true
      },
    );

    await FirebaseAnalytics.instance.logEvent(
      name: "accounts_screen",
      parameters: {
        "userName": sharedPreferences.getString('userName'),
        "email": sharedPreferences.getString('email'),
        "clicked": true
      },
    );

    mixpanel.track(
      'accounts_screen',
      properties: {
        "userName": sharedPreferences.getString('userName'),
        "email": sharedPreferences.getString('email'),
        "clicked": true
      },
    );

    setState(() {
      if (sharedPreferences.getString('filteredValue') != null) {
        flitervalue = sharedPreferences.getString('filteredValue').toString();
      } else {
        var now = new DateTime.now();
        final DateFormat filteredValueformatter = DateFormat('MMMM yyyy');
        flitervalue =
            filteredValueformatter.format(DateTime.parse(now.toString()));
      }
    });

    var res =
        await UserAPI().checkAvaliableGold(context, physicalGold.toString());
    if (res != null && res['status'] == "OK") {
      if (mounted) {
        setState(() {
          totalGold = double.parse(res['details']['availableGold'].toString());
        });
      }
    } else {}
    getGoldPrice();
  }

  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(context);
    return Scaffold(
      backgroundColor: tWhite,
      appBar: widget.headHide
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: tWhite,
            ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: widget.headHide == true ? 0 : 20),
        child: FutureBuilder<MyOrderDetialsModel>(
            future: MyOrderDetials,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("ERROR" + snapshot.error.toString());
                // return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    child: CircularProgressIndicator(
                      color: tPrimaryColor,
                    ),
                  ),
                );

                // return Center(
                //   child: Container(
                //     width: 40.w,
                //     child: Lottie.asset(
                //       loading.LOADING,
                //       // width: 50.w,
                //     ),
                //   ),
                // );
              }
              if (snapshot.hasData) {
                return ActivityPagination(
                  details: snapshot.data,
                  headHide: widget.headHide,
                  totalGold: totalGold,
                  priceDetails: totalGoldPrice,
                  flitervalue: flitervalue,
                );
              } else {
                return SingleChildScrollView(
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.headHide == true)
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      // if (priceDetails != null)
                                      AccountvalueContainer(
                                          goal: false,
                                          physcialGold: true,
                                          tittle: "Physical Gold",
                                          subtittle:
                                              "${totalGold.toStringAsFixed(3)} g",
                                          value: "Total - " +
                                              ((_data.phyGoldDispalyType == 1)
                                                  ? "${totalGold.toStringAsFixed(3)} g"
                                                  : Secondarycurrency +
                                                      (totalGoldPrice ?? 0)
                                                          .toStringAsFixed(2)),
                                          onTap: () async {
                                            goldDisplaySheet(
                                                context,
                                                _data,
                                                totalGoldPrice,
                                                totalGold,
                                                Images.GOLD,
                                                1);

                                            Segment.track(
                                              eventName:
                                                  'change_physical_gold_unit',
                                              properties: {"tapped": true},
                                            );

                                            await FirebaseAnalytics.instance
                                                .logEvent(
                                              name: "change_physical_gold_unit",
                                              parameters: {"tapped": true},
                                            );

                                            mixpanel.track(
                                              "change_physical_gold_unit",
                                              properties: {"tapped": true},
                                            );
                                          }
                                          //  (startLoading, stopLoading,
                                          //     btnState) {
                                          //   // if (verifStatus) {
                                          //   goldDisplaySheet(
                                          //       context,
                                          //       _data,
                                          //       totalGoldPrice,
                                          //       totalGold,
                                          //       Images.GOLD,
                                          //       1);
                                          //   // } else {
                                          //   //   Twl.navigateTo(
                                          //   //       context, VeriffiPage());
                                          //   // }
                                          // },
                                          ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          "Quick access",
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     _data.navGoldTypeaction('1');

                                            //     // if (verifStatus) {
                                            //     Twl.navigateTo(
                                            //       context,
                                            //       BottomNavigation(
                                            //         tabIndexId: 1,
                                            //         actionIndex: 0,
                                            //       ),
                                            //     );
                                            //     // } else {
                                            //     //   Twl.navigateTo(
                                            //     //       context, VeriffiPage());
                                            //     // }
                                            //     // Twl.navigateTo(context,
                                            //     //     PurchesedConfirmSucessful());
                                            //   },
                                            //   child:
                                            MenuContainerWidget(
                                              tittle: "Buy & Sell",
                                              image: Images.QUICKGOLD,
                                              onTap: (startLoading, stopLoading,
                                                  btnState) async {
                                                _data.changeActionIndex(0);
                                                _data.navGoldTypeaction('1');
                                                print("sdcsdcsdcs");
                                                // if (verifStatus) {
                                                Twl.navigateTo(
                                                    context,
                                                    BottomNavigation(
                                                        tabIndexId: 1,
                                                        actionIndex: 0));
                                                // } else {
                                                //   Twl.navigateTo(context, VeriffiPage());
                                                // }
                                                // Twl.navigateTo(
                                                //     context, PurchesedConfirmSucessful());

                                                Segment.track(
                                                  eventName:
                                                      'buy_and_sell_gold_button',
                                                  properties: {"tapped": true},
                                                );

                                                await FirebaseAnalytics.instance
                                                    .logEvent(
                                                  name:
                                                      "buy_and_sell_gold_button",
                                                  parameters: {"tapped": true},
                                                );

                                                mixpanel.track(
                                                  "buy_and_sell_gold_button",
                                                  properties: {"tapped": true},
                                                );
                                              },
                                            ),
                                            // ),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     // if (verifStatus) {
                                            //     Twl.navigateTo(
                                            //         context,
                                            //         BottomNavigation(
                                            //             tabIndexId: 1,
                                            //             actionIndex: 3));
                                            //     // } else {
                                            //     //   Twl.navigateTo(
                                            //     //       context, VeriffiPage());
                                            //     // }
                                            //   },
                                            //   child:
                                            MenuContainerWidget(
                                              tittle: "Delivery",
                                              image: Images.DELIVERY,
                                              onTap: (startLoading, stopLoading,
                                                  btnState) async {
                                                Twl.navigateTo(
                                                    context,
                                                    BottomNavigation(
                                                        tabIndexId: 1,
                                                        actionIndex: 3));
                                                // if (verifStatus) {
                                                // Twl.navigateTo(
                                                //     context, SalesConfirmSucessful());
                                                // } else {
                                                //   Twl.navigateTo(context, VeriffiPage());
                                                // }

                                                Segment.track(
                                                  eventName: 'delivery_button',
                                                  properties: {"tapped": true},
                                                );

                                                await FirebaseAnalytics.instance
                                                    .logEvent(
                                                  name: "delivery_button",
                                                  parameters: {"tapped": true},
                                                );

                                                mixpanel.track(
                                                  "delivery_button",
                                                  properties: {"tapped": true},
                                                );
                                              },
                                            ),
                                            // ),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     // if (verifStatus) {
                                            //     Twl.navigateTo(
                                            //         context,
                                            //         BottomNavigation(
                                            //             tabIndexId: 1,
                                            //             actionIndex: 2));
                                            //     // } else {
                                            //     //   Twl.navigateTo(
                                            //     //       context, VeriffiPage());
                                            //     // }
                                            //     // Twl.navigateTo(
                                            //     //     context, MovedSucessful());
                                            //   },
                                            //   child:
                                            MenuContainerWidget(
                                              tittle: "Move",
                                              image: Images.MOVE,
                                              onTap: (startLoading, stopLoading,
                                                  btnState) async {
                                                // if (verifStatus) {
                                                Twl.navigateTo(
                                                    context,
                                                    BottomNavigation(
                                                        tabIndexId: 1,
                                                        actionIndex: 2));
                                                // } else {
                                                //   Twl.navigateTo(context, VeriffiPage());
                                                // }
                                                // Twl.navigateTo(context, MovedSucessful());

                                                Segment.track(
                                                  eventName: 'move_button',
                                                  properties: {"tapped": true},
                                                );

                                                await FirebaseAnalytics.instance
                                                    .logEvent(
                                                  name: "move_button",
                                                  parameters: {"tapped": true},
                                                );

                                                mixpanel.track(
                                                  "move_button",
                                                  properties: {"tapped": true},
                                                );
                                              },
                                            ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25),
                                        child: Text(
                                          "Activity",
                                          style: TextStyle(
                                              fontSize: isTab(context)
                                                  ? 13.sp
                                                  : 16.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Signika',
                                              color: tSecondaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          if (widget.headHide == false ||
                              widget.headHide == null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Activity",
                                  style: TextStyle(
                                      fontFamily: 'Signika',
                                      fontSize: isTab(context) ? 18.sp : 21.sp,
                                      fontWeight: FontWeight.w500,
                                      color: tPrimaryColor),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      flitervalue,
                                      style: TextStyle(
                                          fontFamily: 'Signika',
                                          color: tSecondaryColor,
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () async {
                                        var datePicked = await dt.DatePicker
                                            .showSimpleDatePicker(
                                          context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2015),
                                          lastDate: DateTime(2060),
                                          dateFormat: "MMMM-yyyy",
                                          // locale: DateTimePickerLocale.en_us,
                                          looping: true,
                                        );
                                        print(datePicked);
                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();

                                        sharedPreferences
                                            .remove('filteredValue');
                                        final DateFormat
                                            filteredValueformatter =
                                            DateFormat('MMMM yyyy');
                                        var filtervalue = filteredValueformatter
                                            .format(DateTime.parse(
                                                datePicked.toString()));
                                        print('filtervalue>>>>>>>>>>>>>');
                                        print(filtervalue);
                                        sharedPreferences.setString(
                                            'filteredValue', filtervalue);

                                        // ignore: unused_local_variable
                                        var now = new DateTime.now();
                                        var formatter = new DateFormat(
                                            'yyyy-MM-dd 00:00:00');
                                        var endformatter = new DateFormat(
                                            'yyyy-MM-dd 23:59:59');
                                        print(utls.DateUtils.firstDayOfMonth(
                                            datePicked!));
                                        print(utls.DateUtils.lastDayOfMonth(
                                            datePicked));
                                        String startDate = formatter.format(
                                            utls.DateUtils.firstDayOfMonth(
                                                datePicked));

                                        String endDate = endformatter.format(
                                            utls.DateUtils.lastDayOfMonth(
                                                datePicked));
                                        print('dates');
                                        print(startDate);
                                        print(endDate);

                                        setState(() {
                                          sharedPreferences.remove('startDate');
                                          sharedPreferences.remove('endDate');
                                          sharedPreferences
                                              .remove('customFilter');
                                          sharedPreferences.setString(
                                              'startDate', startDate);
                                          sharedPreferences.setString(
                                              'endDate', endDate);
                                          print(sharedPreferences
                                              .getString('startDate'));
                                          print(sharedPreferences
                                              .getString('endDate'));
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              BottomNavigation(
                                                                  tabIndexId:
                                                                      2)),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        });
                                      },
                                      child: Text(
                                        "Filter",
                                        style: TextStyle(
                                            fontFamily: 'Signika',
                                            color: tSecondaryColor,
                                            fontSize:
                                                isTab(context) ? 9.sp : 12.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                              ],
                            ),
                          Text('Your transactions will appear here.'),
                        ],
                      )),
                );
              }
            }),
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
    this.flitervalue,
  }) : super(key: key);
  final details;
  final headHide;
  final totalGold;
  final priceDetails;
  final flitervalue;

  @override
  State<ActivityPagination> createState() => _ActivityPaginationState();
}

class _ActivityPaginationState extends State<ActivityPagination> {
  // late Future<myOrdersModel.MyOrderDetialsModel> MyOrderDetials;
  ScrollController scrollController = new ScrollController();
  late final List<myOrdersModel.Detail> myOrderDetails;
  late double scrollPosition;
  int page = 0;
  _scrollListener() async {
    if (scrollController.position.maxScrollExtent > scrollController.offset &&
        scrollController.position.maxScrollExtent - scrollController.offset <=
            55) {
      print('End Scroll');
      page = (page + 1);
      await UserAPI()
          .getMyOrders(context, page.toString(), widget.headHide ? '1' : '')
          .then((val) {
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
    print('myOrderDetails>>>>>>>>>>>>>');
    print(myOrderDetails);
    // CheckGold();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(context);
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        if (widget.headHide == true)
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  // padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      // if (widget.priceDetails != null)
                      AccountvalueContainer(
                          goal: false,
                          physcialGold: true,
                          tittle: "Physical Gold",
                          subtittle: "${widget.totalGold.toStringAsFixed(3)} g",
                          value: "Total - " +
                              ((_data.phyGoldDispalyType == 1)
                                  ? "${widget.totalGold.toStringAsFixed(3)} g"
                                  : Secondarycurrency +
                                      (widget.priceDetails ?? 0)
                                          .toStringAsFixed(2)),
                          onTap: () {
                            goldDisplaySheet(
                                context,
                                _data,
                                widget.priceDetails,
                                widget.totalGold,
                                Images.GOLD,
                                1);
                          }
                          // (startLoading, stopLoading, btnState) {
                          //   // if (verifStatus) {
                          //   goldDisplaySheet(context, _data, widget.priceDetails,
                          //       widget.totalGold, Images.GOLD, 1);
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MenuContainerWidget(
                              tittle: "Buy & Sell",
                              image: Images.QUICKGOLD,
                              onTap: (startLoading, stopLoading, btnState) {
                                _data.changeActionIndex(0);
                                _data.navGoldTypeaction('1');
                                print("sdcsdcsdcs");
                                // if (verifStatus) {
                                Twl.navigateTo(
                                    context,
                                    BottomNavigation(
                                        tabIndexId: 1, actionIndex: 0));
                                // } else {
                                //   Twl.navigateTo(context, VeriffiPage());
                                // }
                                // Twl.navigateTo(
                                //     context, PurchesedConfirmSucessful());
                              },
                            ),
                            MenuContainerWidget(
                              tittle: "Delivery",
                              image: Images.DELIVERY,
                              onTap: (startLoading, stopLoading, btnState) {
                                Twl.navigateTo(
                                    context,
                                    BottomNavigation(
                                        tabIndexId: 1, actionIndex: 3));
                                // if (verifStatus) {
                                // Twl.navigateTo(
                                //     context, SalesConfirmSucessful());
                                // } else {
                                //   Twl.navigateTo(context, VeriffiPage());
                                // }
                              },
                            ),
                            MenuContainerWidget(
                              tittle: "Move",
                              image: Images.MOVE,
                              onTap: (startLoading, stopLoading, btnState) {
                                // if (verifStatus) {
                                Twl.navigateTo(
                                    context,
                                    BottomNavigation(
                                        tabIndexId: 1, actionIndex: 2));
                                // } else {
                                //   Twl.navigateTo(context, VeriffiPage());
                                // }
                                // Twl.navigateTo(context, MovedSucessful());
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
                      SizedBox(
                        height: 3.h,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        if (widget.headHide == false || widget.headHide == null)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Activity",
                  style: TextStyle(
                      fontFamily: 'Signika',
                      fontSize: isTab(context) ? 18.sp : 21.sp,
                      fontWeight: FontWeight.w500,
                      color: tPrimaryColor),
                ),
                SizedBox(
                  height: 3.h,
                ),
                Row(
                  children: [
                    Text(
                      widget.flitervalue,
                      style: TextStyle(
                          fontFamily: 'Signika',
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        var datePicked =
                            await dt.DatePicker.showSimpleDatePicker(
                          context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2060),
                          dateFormat: "MMMM-yyyy",
                          // locale: DateTimePickerLocale.en_us,
                          looping: true,
                        );
                        print(datePicked);
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();

                        sharedPreferences.remove('filteredValue');
                        final DateFormat filteredValueformatter =
                            DateFormat('MMMM yyyy');
                        var filtervalue = filteredValueformatter
                            .format(DateTime.parse(datePicked.toString()));
                        sharedPreferences.setString(
                            'filteredValue', filtervalue);

                        // ignore: unused_local_variable
                        var now = new DateTime.now();
                        var formatter = new DateFormat('yyyy-MM-dd 00:00:00');
                        var endformatter =
                            new DateFormat('yyyy-MM-dd 23:59:59');
                        print(utls.DateUtils.firstDayOfMonth(datePicked!));
                        print(utls.DateUtils.lastDayOfMonth(datePicked));
                        String startDate = formatter
                            .format(utls.DateUtils.firstDayOfMonth(datePicked));

                        String endDate = endformatter
                            .format(utls.DateUtils.lastDayOfMonth(datePicked));
                        print('dates');
                        print(startDate);
                        print(endDate);

                        setState(() {
                          sharedPreferences.remove('startDate');
                          sharedPreferences.remove('endDate');
                          sharedPreferences.remove('customFilter');
                          sharedPreferences.setString('startDate', startDate);
                          sharedPreferences.setString('endDate', endDate);
                          print(sharedPreferences.getString('startDate'));
                          print(sharedPreferences.getString('endDate'));
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavigation(tabIndexId: 2)),
                              (Route<dynamic> route) => false);
                        });
                        // showModalBottomSheet(
                        //     context: context,
                        //     builder: (context) {
                        //       return Column(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [

                        //           Expanded(
                        //             child: Container(
                        //               padding: const EdgeInsets.symmetric(
                        //                   horizontal: 25),
                        //               child: DatePickerWidget(
                        //                 looping:
                        //                     false, // default is not looping
                        //                 firstDate: DateTime(2015),
                        //                 // DateTime.now(), //DateTime(1960),
                        //                 //  lastDate: DateTime(2002, 1, 1),
                        //                 //              initialDate: DateTime.now(),// DateTime(1994),
                        //                 dateFormat:
                        //                     // "MM-dd(E)",
                        //                     "MMMM/yyyy",
                        //                 onConfirm: (DateTime newDate, _) {},
                        //                 //     locale: DatePicker.localeFromString('he'),
                        //                 onChange: (DateTime newDate, _) async {
                        //                   print(utls.DateUtils.firstDayOfMonth(
                        //                       newDate));
                        //                   print(utls.DateUtils.lastDayOfMonth(
                        //                       newDate));

                        //                   //  SharedPreferences
                        //                   //         sharedPreferences =
                        //                   //         await SharedPreferences
                        //                   //             .getInstance();
                        //                   //     sharedPreferences
                        //                   //         .remove('filteredValue');
                        //                   //     sharedPreferences.setString(
                        //                   //         'filteredValue', 'Today');
                        //                   //     var now = new DateTime.now();
                        //                   //     var formatter = new DateFormat(
                        //                   //         'yyyy-MM-dd 00:00:00');
                        //                   //     String endDate = formatter
                        //                   //         .format(DateTime.now()
                        //                   //             .add(Duration(
                        //                   //                 days: 1)));
                        //                   //     String startDate =
                        //                   //         formatter.format(now);
                        //                   //     print('dates');
                        //                   //     print(startDate);
                        //                   //     print(endDate);
                        //                   //     sharedPreferences
                        //                   //         .remove('customFilter');
                        //                   //     sharedPreferences.setString(
                        //                   //         'startDate', startDate);
                        //                   //     sharedPreferences.setString(
                        //                   //         'endDate', endDate);
                        //                   //     setState(() {
                        //                   //       Navigator.of(context)
                        //                   //           .pushAndRemoveUntil(
                        //                   //               MaterialPageRoute(
                        //                   //                   builder: (context) =>
                        //                   //                       BottomNavigation(
                        //                   //                           tabIndexId:
                        //                   //                               2)),
                        //                   //               (Route<dynamic>
                        //                   //                       route) =>
                        //                   //                   false);
                        //                   //     });
                        //                 },
                        //                 pickerTheme: DateTimePickerTheme(
                        //                   backgroundColor: Colors.transparent,
                        //                   itemTextStyle: TextStyle(
                        //                       color: Colors.black,
                        //                       fontSize: 19),
                        //                   dividerColor: tText,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //           // Expanded(
                        //           //   child: CupertinoDatePicker(
                        //           //     mode: CupertinoDatePickerMode.dateAndTime,
                        //           //     dateOrder: DatePickerDateOrder.dmy,
                        //           //     initialDateTime: DateTime.now(),
                        //           //     onDateTimeChanged: (DateTime dateTime) {
                        //           //       // tbd
                        //           //     },
                        //           //   ),
                        //           // ),
                        //           // ElevatedButton(
                        //           //     onPressed: () {}, child: Text("save"))
                        //         ],
                        //       );
                        //     });

                        // showBarModalBottomSheet(
                        //     context: context,
                        //     backgroundColor: Colors.transparent,
                        //     builder: (context) => StatefulBuilder(
                        //           builder: (BuildContext context,
                        //               StateSetter setState) {
                        //             return Container(
                        //               height:
                        //                   MediaQuery.of(context).size.height /
                        //                       1.5,
                        //               child: Padding(
                        //                 padding: EdgeInsets.only(
                        //                     left: 20, right: 20, top: 20),
                        //                 child: Column(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.start,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     SizedBox(
                        //                       height: 10,
                        //                     ),
                        //                     Center(
                        //                       child: Container(
                        //                         height: 3,
                        //                         width: 70,
                        //                         color: tBlack,
                        //                       ),
                        //                     ),
                        //                     SizedBox(
                        //                       height: 40,
                        //                     ),
                        //                     Row(
                        //                       children: [
                        //                         Text("Select Duration",
                        //                             style: TextStyle(
                        //                                 fontSize: isTab(context)
                        //                                     ? 13.sp
                        //                                     : 16.sp,
                        //                                 fontWeight:
                        //                                     FontWeight.w700)),
                        //                       ],
                        //                     ),
                        //                     SizedBox(
                        //                       width: 20,
                        //                     ),
                        //                     ListTile(
                        //                         title: Text(
                        //                           'Today',
                        //                           style: TextStyle(
                        //                               color: tSecondaryColor,
                        //                               fontWeight:
                        //                                   FontWeight.w700,
                        //                               fontSize: isTab(context)
                        //                                   ? 13.sp
                        //                                   : 16.sp),
                        //                         ),
                        //                         onTap: () async {
                        //                           SharedPreferences
                        //                               sharedPreferences =
                        //                               await SharedPreferences
                        //                                   .getInstance();
                        //                           sharedPreferences
                        //                               .remove('filteredValue');
                        //                           sharedPreferences.setString(
                        //                               'filteredValue', 'Today');
                        //                           var now = new DateTime.now();
                        //                           var formatter = new DateFormat(
                        //                               'yyyy-MM-dd 00:00:00');
                        //                           String endDate = formatter
                        //                               .format(DateTime.now()
                        //                                   .add(Duration(
                        //                                       days: 1)));
                        //                           String startDate =
                        //                               formatter.format(now);
                        //                           print('dates');
                        //                           print(startDate);
                        //                           print(endDate);
                        //                           sharedPreferences
                        //                               .remove('customFilter');
                        //                           sharedPreferences.setString(
                        //                               'startDate', startDate);
                        //                           sharedPreferences.setString(
                        //                               'endDate', endDate);
                        //                           setState(() {
                        //                             Navigator.of(context)
                        //                                 .pushAndRemoveUntil(
                        //                                     MaterialPageRoute(
                        //                                         builder: (context) =>
                        //                                             BottomNavigation(
                        //                                                 tabIndexId:
                        //                                                     2)),
                        //                                     (Route<dynamic>
                        //                                             route) =>
                        //                                         false);
                        //                           });
                        //                         }),
                        //                     ListTile(
                        //                         title: Text(
                        //                           'Yesterday',
                        //                           style: TextStyle(
                        //                               color: tSecondaryColor,
                        //                               fontWeight:
                        //                                   FontWeight.w700,
                        //                               fontSize: isTab(context)
                        //                                   ? 13.sp
                        //                                   : 16.sp),
                        //                         ),
                        //                         onTap: () async {
                        //                           SharedPreferences
                        //                               sharedPreferences =
                        //                               await SharedPreferences
                        //                                   .getInstance();

                        //                           sharedPreferences
                        //                               .remove('filteredValue');
                        //                           sharedPreferences.setString(
                        //                               'filteredValue',
                        //                               'Yesterday');

                        //                           var now = new DateTime.now();
                        //                           var formatter = new DateFormat(
                        //                               'yyyy-MM-dd 00:00:00');
                        //                           String endDate =
                        //                               formatter.format(now);

                        //                           String startDate = formatter
                        //                               .format(DateTime.now()
                        //                                   .subtract(Duration(
                        //                                       days: 1)));
                        //                           print('dates');
                        //                           print(startDate);
                        //                           print(endDate);
                        //                           sharedPreferences
                        //                               .remove('customFilter');
                        //                           sharedPreferences.setString(
                        //                               'startDate', startDate);
                        //                           sharedPreferences.setString(
                        //                               'endDate', endDate);
                        //                           setState(() {
                        //                             Navigator.of(context)
                        //                                 .pushAndRemoveUntil(
                        //                                     MaterialPageRoute(
                        //                                         builder: (context) =>
                        //                                             BottomNavigation(
                        //                                                 tabIndexId:
                        //                                                     2)),
                        //                                     (Route<dynamic>
                        //                                             route) =>
                        //                                         false);
                        //                           });
                        //                         }),
                        //                     ListTile(
                        //                         title: Text(
                        //                           'Last 7 Days',
                        //                           style: TextStyle(
                        //                               color: tSecondaryColor,
                        //                               fontWeight:
                        //                                   FontWeight.w700,
                        //                               fontSize: isTab(context)
                        //                                   ? 13.sp
                        //                                   : 16.sp),
                        //                         ),
                        //                         onTap: () async {
                        //                           SharedPreferences
                        //                               sharedPreferences =
                        //                               await SharedPreferences
                        //                                   .getInstance();

                        //                           sharedPreferences
                        //                               .remove('filteredValue');
                        //                           sharedPreferences.setString(
                        //                               'filteredValue',
                        //                               'Last 7 Days');

                        //                           // ignore: unused_local_variable
                        //                           var now = new DateTime.now();
                        //                           var formatter = new DateFormat(
                        //                               'yyyy-MM-dd 00:00:00');
                        //                           String endDate = formatter
                        //                               .format(DateTime.now()
                        //                                   .add(Duration(
                        //                                       days: 1)));

                        //                           String startDate = formatter
                        //                               .format(DateTime.now()
                        //                                   .subtract(Duration(
                        //                                       days: 7)));
                        //                           print('dates');
                        //                           print(startDate);
                        //                           print(endDate);
                        //                           sharedPreferences
                        //                               .remove('customFilter');
                        //                           sharedPreferences.setString(
                        //                               'startDate', startDate);
                        //                           sharedPreferences.setString(
                        //                               'endDate', endDate);
                        //                           setState(() {
                        //                             Navigator.of(context)
                        //                                 .pushAndRemoveUntil(
                        //                                     MaterialPageRoute(
                        //                                         builder: (context) =>
                        //                                             BottomNavigation(
                        //                                                 tabIndexId:
                        //                                                     2)),
                        //                                     (Route<dynamic>
                        //                                             route) =>
                        //                                         false);
                        //                           });
                        //                         }),
                        //                     ListTile(
                        //                         title: Text(
                        //                           'Last 30 days',
                        //                           style: TextStyle(
                        //                               color: tSecondaryColor,
                        //                               fontWeight:
                        //                                   FontWeight.w700,
                        //                               fontSize: isTab(context)
                        //                                   ? 13.sp
                        //                                   : 16.sp),
                        //                         ),
                        //                         onTap: () async {
                        //                           SharedPreferences
                        //                               sharedPreferences =
                        //                               await SharedPreferences
                        //                                   .getInstance();

                        //                           sharedPreferences
                        //                               .remove('filteredValue');
                        //                           sharedPreferences.setString(
                        //                               'filteredValue',
                        //                               'Last 30 days');

                        //                           // ignore: unused_local_variable
                        //                           var now = new DateTime.now();
                        //                           var formatter = new DateFormat(
                        //                               'yyyy-MM-dd 00:00:00');
                        //                           String endDate = formatter
                        //                               .format(DateTime.now()
                        //                                   .add(Duration(
                        //                                       days: 1)));

                        //                           String startDate = formatter
                        //                               .format(DateTime.now()
                        //                                   .subtract(Duration(
                        //                                       days: 30)));
                        //                           print('dates');
                        //                           print(startDate);
                        //                           print(endDate);
                        //                           sharedPreferences
                        //                               .remove('customFilter');
                        //                           sharedPreferences.setString(
                        //                               'startDate', startDate);
                        //                           sharedPreferences.setString(
                        //                               'endDate', endDate);
                        //                           setState(() {
                        //                             Navigator.of(context)
                        //                                 .pushAndRemoveUntil(
                        //                                     MaterialPageRoute(
                        //                                         builder: (context) =>
                        //                                             BottomNavigation(
                        //                                                 tabIndexId:
                        //                                                     2)),
                        //                                     (Route<dynamic>
                        //                                             route) =>
                        //                                         false);
                        //                           });
                        //                         }),
                        //                     ListTile(
                        //                         title: Text(
                        //                           'Last 3 Months',
                        //                           style: TextStyle(
                        //                               color: tSecondaryColor,
                        //                               fontWeight:
                        //                                   FontWeight.w700,
                        //                               fontSize: 16.sp),
                        //                         ),
                        //                         onTap: () async {
                        //                           SharedPreferences
                        //                               sharedPreferences =
                        //                               await SharedPreferences
                        //                                   .getInstance();

                        //                           sharedPreferences
                        //                               .remove('filteredValue');
                        //                           sharedPreferences.setString(
                        //                               'filteredValue',
                        //                               'Last 3 months');

                        //                           // ignore: unused_local_variable
                        //                           var now = new DateTime.now();
                        //                           var formatter = new DateFormat(
                        //                               'yyyy-MM-dd 00:00:00');
                        //                           String endDate = formatter
                        //                               .format(DateTime.now()
                        //                                   .add(Duration(
                        //                                       days: 1)));

                        //                           String startDate = formatter
                        //                               .format(DateTime.now()
                        //                                   .subtract(Duration(
                        //                                       days: 90)));
                        //                           print('dates');
                        //                           print(startDate);
                        //                           print(endDate);
                        //                           sharedPreferences
                        //                               .remove('customFilter');
                        //                           sharedPreferences.setString(
                        //                               'startDate', startDate);
                        //                           sharedPreferences.setString(
                        //                               'endDate', endDate);
                        //                           setState(() {
                        //                             Navigator.of(context)
                        //                                 .pushAndRemoveUntil(
                        //                                     MaterialPageRoute(
                        //                                         builder: (context) =>
                        //                                             BottomNavigation(
                        //                                                 tabIndexId:
                        //                                                     2)),
                        //                                     (Route<dynamic>
                        //                                             route) =>
                        //                                         false);
                        //                           });
                        //                         }),
                        //                     SizedBox(
                        //                       height: 15,
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //         ));
                      },
                      child: Row(
                        children: [
                          Text(
                            "Filter by month",
                            style: TextStyle(
                                fontFamily: 'Signika',
                                color: tSecondaryColor,
                                fontSize: isTab(context) ? 9.sp : 12.sp,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            Images.EXPANDMORE,
                            scale: 3.8,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            // itemCount: myOrderDetails.length,
            // controller: scrollController,
            // itemBuilder: (context, index) {
            var details = myOrderDetails[index];
            return Column(
              children: [
                (details.typeId != 3)
                    ? Column(
                        children: [
                          BuyContainerWidget(
                            tittle: getTypeOfActivity(details.typeId),
                            // == Buy
                            //  ? "Buy" :details.typeId == Move? 'Move': "Sell",
                            date: Twl.dateFormate(details.createdOn),
                            goldgrams:
                                "${(double.parse(details.quantity.replaceAll('g', '') == '' ? '0' : details.quantity.replaceAll('g', ''))).toStringAsFixed(3)} Grams",

                            cost: (details.typeId == 1 || details.typeId == 2)
                                ? "£${details.totalWTax != null ? (details.totalWTax).toStringAsFixed(2) : ''}"
                                : null,
                            des: (details.typeId == 3 || details.typeId == 4)
                                ? (details.moveDesc ?? '')
                                : '',
                            // : getDeliveryStatus(details.deliveryStatus ?? '1'),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      )
                    : Container(),
              ],
            );
          },
          childCount: widget.headHide
              ? (myOrderDetails.length < 4 ? myOrderDetails.length : 4)
              : myOrderDetails.length,
        )),
      ],
    );
  }
}

getTypeOfActivity(typeId) {
  switch (typeId) {
    case 1:
      return 'Buy';
      break;
    case 2:
      return 'Sell';
      break;
    case 3:
      return 'Move';
      break;
    case 4:
      return 'Move';
      break;
    case 5:
      return 'Delivery';
      break;
    default:
      return '';
  }
}

getDeliveryStatus(status) {
  switch (status) {
    case 2:
      return 'Processing';
      break;
    case 3:
      return 'Completed';
      break;
    default:
      return 'Pending';
  }
}
