import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/provider/actionProvider.dart';
import 'package:base_project_flutter/views/actions/components/buyAction.dart';
import 'package:base_project_flutter/views/actions/components/deliveryFromBottomSheet.dart';
import 'package:base_project_flutter/views/actions/components/sellAction.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalWidgets/button.dart';
import '../../../responsive.dart';
import '../../paymentdetails/paymentdetails.dart';

class BuyAndSell extends StatefulWidget {
  const BuyAndSell({
    this.loader,
  });
  final loader;
  @override
  State<BuyAndSell> createState() => _BuyAndSellState();
}

class _BuyAndSellState extends State<BuyAndSell> {
  void initState() {
    super.initState();

    e();
  }

  e() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "buy_and_sell_page",
      parameters: {
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'buy_and_sell_page',
      properties: {"clicked": true},
    );

    mixpanel.track('buy_and_sell_page', properties: {
      "button_clicked": true,
    });
  }

  @override
  void didChangeDependencies() {
    if (physicalGold.toString() == goldType) {
      checkGold(physicalGold.toString());
    } else {}

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  var totalGold = 0.0;
  checkGold(String goldType) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    ActionProvider _data = Provider.of<ActionProvider>(context, listen: false);
    setState(() {
      initialIndexTab = _data.initialIndex;
    });
    var res = await UserAPI().checkAvaliableGold(context, goldType);
    if (res != null && res['status'] == "OK") {
      setState(() {
        totalGold = double.parse(res['details']['availableGold'].toString());
      });
    } else {}
    setState(() {
      print('_data.navGoldType>>>>>>>>>>');
      print(_data.navGoldType);

      goldType = _data.navGoldType.toString();
      deliverFromValue = (goldType == '1')
          ? 'Physical Gold Account'
          : sharedPreferences.getString('goalName').toString();
    });
    print('goldType>>>>>>>>>>' + goldType.toString());
  }

  String? selectedValue;
  String? goldType = '1';
  List<DropdownMenuItem<String>> months = [
    DropdownMenuItem(
        child: Text("Physical Gold Account"), value: physicalGold.toString()),
    DropdownMenuItem(child: Text("My Goal Account"), value: myGoal.toString()),
  ];
  String deliverFromValue = 'Physical Gold Account';
  selectDeliverFrom(String value, double goldqty, String goldTypes) {
    print(value);
    print(goldqty);
    setState(() {
      deliverFromValue = value;
      totalGold = goldqty;
      goldType = goldTypes;
      print(goldType);
    });
    // checkGold(goldType);
  }

  var initialIndexTab;
  @override
  Widget build(BuildContext context) {
    ActionProvider _data = Provider.of<ActionProvider>(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    'Performing action for:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: tTextSecondary,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      diplayBottomSheet();

                      await FirebaseAnalytics.instance.logEvent(
                        name: "perform_action_for",
                        parameters: {
                          "button_clicked": true,
                        },
                      );

                      Segment.track(
                        eventName: 'perform_action_for',
                        properties: {"clicked": true},
                      );

                      mixpanel.track('perform_action_for', properties: {
                        "button_clicked": true,
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: tTextformfieldColor,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            deliverFromValue,
                            style: TextStyle(
                              fontSize: isTab(context) ? 10.sp : 12.sp,
                              fontWeight: FontWeight.bold,
                              color: tSecondaryColor,
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            Images.EXPANDEDMORE,
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 40,
                  //   decoration: BoxDecoration(
                  //       color: tPrimaryTextformfield,
                  //       borderRadius: BorderRadius.circular(15)),
                  //   child: DropdownButtonFormField(
                  //       icon: Padding(
                  //         padding: EdgeInsets.only(right: 50),
                  //         child: Image.asset(
                  //           Images.EXPANDMORE,
                  //           scale: 3.5,
                  //         ),
                  //       ),
                  //       focusColor: tWhite,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w700,
                  //         color: tSecondaryColor,
                  //         fontSize: isTab(context) ? 9.sp : 12.sp,
                  //       ),
                  //       decoration: InputDecoration(
                  //           hintText: "Physical Gold Account",
                  //           hintStyle: TextStyle(
                  //             fontWeight: FontWeight.w700,
                  //             color: tSecondaryColor,
                  //             fontFamily: 'Barlow',
                  //             fontSize: isTab(context) ? 9.sp : 13.sp,
                  //           ),
                  //           contentPadding: EdgeInsets.fromLTRB(40, 0, 10, 7),
                  //           border: InputBorder.none),
                  //       value: selectedValue,
                  //       items: months,
                  //       onChanged: (String? newvalue) {
                  //         setState(() {
                  //           goldType = newvalue!;
                  //           checkGold(newvalue);
                  //           print('goldType' + goldType.toString());
                  //         });
                  //       }),
                  // ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: tContainerColor,
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                    child: DefaultTabController(
                      length: 2,
                      initialIndex: _data.initialIndex,
                      child: Container(
                        height: isTab(context) ? 800 : 450,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: Container(
                                height: isTab(context) ? 50 : 30,
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    color: tIndicatorColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: TabBar(
                                    indicatorPadding: EdgeInsets.zero,
                                    labelPadding: EdgeInsets.only(top: 3),
                                    labelStyle: TextStyle(
                                        // fontFamily: "Barlow",
                                        fontSize: isTab(context) ? 9.sp : 12.sp,
                                        fontWeight: FontWeight.w400),
                                    padding: EdgeInsets.zero,
                                    indicator: BoxDecoration(
                                        color: tPrimaryColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    labelColor: tSecondaryColor,
                                    unselectedLabelColor: tSecondaryColor,
                                    unselectedLabelStyle: TextStyle(
                                        // fontFamily: "Barlow",
                                        fontSize: isTab(context) ? 9.sp : 12.sp,
                                        fontWeight: FontWeight.w400),
                                    tabs: const [
                                      Tab(
                                        text: 'Buy',
                                      ),
                                      Tab(
                                        text: 'Sell',
                                      ),
                                    ],
                                    onTap: (int) {
                                      FocusScope.of(context).unfocus();
                                      // print(int);
                                      // WidgetsBinding.instance!
                                      //     .addPostFrameCallback((_) async {
                                      //   await diplayBottomSheet();
                                      // });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      BuyActionPage(
                                        goldType: goldType,
                                        loader: widget.loader,
                                      ),
                                      SellActionPage(
                                        goldType: goldType,
                                        totalGold: totalGold,
                                        loader: widget.loader,
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 0.5.h,
                  // ),
                  // Text(
                  //   "The prices above refresh every 60 seconds to reflect the live gold price.",
                  //   style: TextStyle(
                  //       color: tSecondaryColor,
                  //       fontSize: isTab(context) ? 5.sp : 8.sp,
                  //       fontWeight: FontWeight.w300),
                  // ),
                  // SizedBox(
                  //   height: 3.h,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 17.w),
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: Button(
                  //         borderSide: BorderSide.none,
                  //         color: tPrimaryColor,
                  //         textcolor: tWhite,
                  //         bottonText: 'Confirm',
                  //         onTap: (startLoading, stopLoading, btnState) async {
                  //           Twl.navigateTo(context, PaymentDetails());
                  //           // if (_formKey.currentState!.validate()) {
                  //           //   Twl.navigateTo(
                  //           //       context, PurchesedConfirmSucessful());
                  //           // }
                  //           // //startLoading();
                  //         }
                  //         // stopLoading();
                  //         // }
                  //         ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  diplayBottomSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      context: context,
      builder: (ctx) {
        return DeliveryFromBottomSheet(
          selected: deliverFromValue,
          type: true,
          title: 'Performing action for:',
          selectDelivery: selectDeliverFrom,
        );
      },
    );
  }
}
