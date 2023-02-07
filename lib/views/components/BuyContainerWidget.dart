import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../responsive.dart';

class BuyContainerWidget extends StatelessWidget {
  const BuyContainerWidget({
    Key? key,
    this.tittle,
    this.goldgrams,
    this.date,
    this.cost,
    this.des,
  }) : super(key: key);
  final tittle;
  final goldgrams;
  final date;
  final cost;
  final des;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: tContainerColor, borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.only(left: 14, right: 10, top: 5, bottom: 5),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              tittle ?? "",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: tSecondaryColor,
                  fontSize: isTab(context) ? 9.sp : 12.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goldgrams ?? "",
                  style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 9.sp : 12.sp,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  date ?? "",
                  style: TextStyle(
                      color: tSecondaryColor,
                      fontSize: isTab(context) ? 5.sp : 8.sp,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child:
                // Text(
                //         cost ?? "",
                //         style: TextStyle(
                //             color: tSecondaryColor,
                //             fontSize: isTab(context) ? 9.sp : 12.sp,
                //             fontWeight: FontWeight.w700),
                //       ),
                Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cost != null
                    ? Text(
                        cost ?? "",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      )
                    : des != null
                        ? Text(
                            des ?? "",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: tSecondaryColor,
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        : Container(),
                // if (des != null)
                //   Text(
                //     des ?? "",
                //     style: TextStyle(
                //       color: tSecondaryColor,
                //       fontSize: isTab(context) ? 9.sp : 12.sp,
                //       fontWeight: FontWeight.w700,
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
