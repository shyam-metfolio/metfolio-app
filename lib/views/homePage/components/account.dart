import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/views/activity/activity.dart';
import 'package:base_project_flutter/views/components/BuyContainerWidget.dart';

import 'package:base_project_flutter/views/successfullPage/PurchesedConfirmSucessfull.dart';
import 'package:base_project_flutter/views/successfullPage/SaleIsConfirmSucessfull.dart';
import 'package:base_project_flutter/views/successfullPage/movedsucessfull.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../responsive.dart';
import '../../components/accountValueContainer.dart';
import '../../components/menuContainerWidget.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Activity(
      headHide: true,
    );
    // SingleChildScrollView(
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 5),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(
    //           height: 4.h,
    //         ),
    //         AccountvalueContainer(
    //           tittle: "Physical Gold",
    //           subtittle: "100g",
    //           value: "Value - £5,300.74",
    //         ),
    //         SizedBox(
    //           height: 2.h,
    //         ),
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 15),
    //           child: Text(
    //             "Quick access",
    //             style: TextStyle(
    //                 fontSize: isTab(context) ? 13.sp : 16.sp,
    //                 fontWeight: FontWeight.w500,
    //                 fontFamily: 'Signika',
    //                 color: tSecondaryColor),
    //           ),
    //         ),
    //         SizedBox(
    //           height: 3.h,
    //         ),
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 25),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               GestureDetector(
    //                 onTap: () {
    //                   Twl.navigateTo(context, PurchesedConfirmSucessful());
    //                 },
    //                 child: MenuContainerWidget(
    //                   tittle: "Buy & Sell",
    //                   image: Images.GOLD,
    //                 ),
    //               ),
    //               GestureDetector(
    //                 onTap: () {
    //                   Twl.navigateTo(context, SalesConfirmSucessful());
    //                 },
    //                 child: MenuContainerWidget(
    //                   tittle: "Delivery",
    //                   image: Images.DELIVERY,
    //                 ),
    //               ),
    //               GestureDetector(
    //                 onTap: () {
    //                   Twl.navigateTo(context, MovedSucessful());
    //                 },
    //                 child: MenuContainerWidget(
    //                   tittle: "Move",
    //                   image: Images.MOVE,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(
    //           height: 3.h,
    //         ),
    //         Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 15),
    //           child: Text(
    //             "Activity",
    //             style: TextStyle(
    //                 fontSize: isTab(context) ? 13.sp : 16.sp,
    //                 fontWeight: FontWeight.w500,
    //                 fontFamily: 'Signika',
    //                 color: tSecondaryColor),
    //           ),
    //         ),
    //         SizedBox(
    //           height: 3.h,
    //         ),
    //         BuyContainerWidget(
    //           tittle: "Buy",
    //           date: "16th February",
    //           goldgrams: "36.9 Grams",
    //           cost: "£1335",
    //         ),
    //         SizedBox(
    //           height: 2.h,
    //         ),
    //         BuyContainerWidget(
    //           tittle: "Buy",
    //           date: "14th February",
    //           goldgrams: "36.9 Grams",
    //           cost: "£1335",
    //         ),

    //         // GestureDetector(
    //         //   onTap: () {
    //         //     Twl.navigateTo(context, PhysicalGold());
    //         //   },
    //         //   child: PortfolioContainerWidget(
    //         //     tittle: "Physical Gold",
    //         //     goldgrams: "100g",
    //         //   ),
    //         // ),
    //         // SizedBox(
    //         //   height: 2.h,
    //         // ),
    //         // GestureDetector(
    //         //     onTap: () {
    //         //       Twl.navigateTo(context, DecideYourPayment());
    //         //     },
    //         //     child: NoActiveGoalsContainer(
    //         //       buttontext: 'Start a Goal!',
    //         //     )),
    //       ],
    //     ),
    //   ),
    // );
  }
}
