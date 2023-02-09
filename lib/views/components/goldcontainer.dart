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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
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
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  goldGrams ?? "",
                  style: TextStyle(
                    color: tBlue,
                    fontFamily: 'Barlow',
                    fontSize: isTab(context) ? 13.sp : 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                InkWell(
                  onTap: ontap,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: tSecondaryColor)),
                    child: Image.asset(
                      'images/down.png',
                      height: 8,
                    ),
                  ),
                )
              ],
            ),
          ),
          Text(
            title ?? "",
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
    );
  }
}
