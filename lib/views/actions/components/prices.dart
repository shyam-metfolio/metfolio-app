import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/main.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../responsive.dart';

class Prices extends StatefulWidget {
  const Prices({Key? key}) : super(key: key);

  @override
  State<Prices> createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  @override
  void initState() {
    getGoldPrice();
    // TODO: implement initState
    super.initState();
    e();
  }

  e() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "prices_page",
      parameters: {
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'prices_page',
      properties: {"clicked": true},
    );

    mixpanel.track('prices_page', properties: {
      "button_clicked": true,
    });
  }

  var res;
  var priceDetails;
  getGoldPrice() async {
    res = await UserAPI().getGoldPrice(context);
    setState(() {
      priceDetails = res['details'];
    });
    print('getGoldPrice');
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(children: [
        SizedBox(
          height: 4.h,
        ),
        Image.asset(
          Images.GOLD,
          scale: 5,
        ),
        SizedBox(
          height: 0.5.h,
        ),
        Text(
          "Physical Gold",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: tSecondaryColor,
            fontFamily: "Signika",
            fontSize: isTab(context) ? 13.sp : 16.sp,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: tContainerColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 50),
            child: priceDetails == null
                ? Center(
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      child: CircularProgressIndicator(
                        color: tPrimaryColor,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Text(
                        "1 gram -  ${Secondarycurrency + ' ' + priceDetails['price_gram_24k'].toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 13.sp : 16.sp,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "10 grams -  ${Secondarycurrency + ' ' + (priceDetails['price_gram_24k'] * 10).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 13.sp : 16.sp,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "1 troy ounce -  ${Secondarycurrency + ' ' + (priceDetails['price_gram_24k'] * 31.1).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 13.sp : 16.sp,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "50 grams -  ${Secondarycurrency + ' ' + (priceDetails['price_gram_24k'] * 50).toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 13.sp : 16.sp,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(
          height: 3.h,
        ),
        Center(
          child: Container(
            width: 70.w,
            child: Text(
              "Disclaimer: The prices distributed above are the spot gold price, the buying prices differ.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: tSecondaryColor,
                fontSize: isTab(context) ? 4.5.sp : 7.5.sp,
              ),
            ),
          ),
        ),
      ]),
    ));
  }
}
