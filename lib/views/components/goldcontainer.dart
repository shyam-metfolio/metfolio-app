import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../responsive.dart';

class Goldcontainer extends StatelessWidget {
  const Goldcontainer({
    Key? key,
    this.title,
    this.goldGrams,
    this.imagess,
    this.scale,
    this.ontap,
  }) : super(key: key);

  final title;
  final goldGrams;
  final imagess;
  final scale;
  final ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 28,
            child: Image.asset(
              imagess,
              height: 29,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            height: 28,
          ),
          Text(
            title ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: tBlue,
                fontFamily: 'Barlow',
                fontSize: isTab(context) ? 11.sp : 19,
                fontWeight: FontWeight.w700),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  goldGrams ?? "",
                  style: TextStyle(
                    color: tBlue,
                    fontFamily: 'Barlow',
                    fontSize: isTab(context) ? 13.sp : 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                // IconButton(
                //   iconSize: ,
                //   onPressed: ontap,
                //   icon: Icon(
                //     Icons.keyboard_arrow_down,
                //     color: tPrimaryColor,
                //   ),
                // ),
                InkWell(
                  onTap: ontap,
                  child: Container(
                    padding: EdgeInsets.only(top: 6, left: 10
                        //, right: 10, bottom: 6,
                        // bottom: 8,
                        ),
                    child: Image.asset(
                      Images.EXPANDMORE,
                      // height: 20,
                      scale: 3.8,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
