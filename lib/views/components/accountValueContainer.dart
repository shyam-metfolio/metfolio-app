import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/views/editmaingoal/editmaingoal.dart';
import 'package:base_project_flutter/views/paymentMethods/paymentMethod.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';

class AccountvalueContainer extends StatelessWidget {
  const AccountvalueContainer({
    Key? key,
    this.tittle,
    this.subtittle,
    this.value,
    this.physcialGold,
    this.onTap,
    this.goal,
  }) : super(key: key);
  final tittle;
  final subtittle;
  final value;
  final physcialGold;
  final onTap;
  final goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ArgonButton(
        highlightElevation: 0,
        height: isTab(context) ? 200 : 123,
        width: 94.w,
        elevation: 0,
        borderRadius: 12,
        color: tContainerColor,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.fromLTRB(30, 15, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tittle,
                    // ((goal) ? tittle['details']['name_of_goal'] : tittle) ?? "",
                    style: TextStyle(
                        color: tBlue,
                        fontFamily: 'Barlow',
                        fontSize: isTab(context) ? 13.sp : 16.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  Image.asset(
                    (physcialGold == false) ? Images.MUGOALGOLD : Images.GOLD,
                    scale: 4,
                  )
                ],
              ),
              // Text(
              //   subtittle ?? "",
              //   style: TextStyle(
              //       color: tBlue,
              //       fontFamily: 'Barlow',
              //       fontSize: isTab(context) ? 13.sp : 16.sp,
              //       fontWeight: FontWeight.w700),
              // ),
              SizedBox(
                height: goal ? 30 : 35,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value ?? "",
                    style: TextStyle(
                        color: tBlue,
                        fontFamily: 'Barlow',
                        fontSize: isTab(context) ? 13.sp : 16.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                      // width: 1.w,
                      ),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.9.w,
                          vertical: 8,
                        ),
                        child: Image.asset(
                          Images.EXPANDMORE,
                          scale: 3.8,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  if (goal)
                    // if (tittle['details']['subscription_status'] != '1' &&
                    //     tittle['details']['subscription_status'] != 1)
                    GestureDetector(
                      onTap: () {
                        Twl.navigateTo(
                          context,
                          PaymentMethodPage(
                            type: GoldType().EditGoal,
                            payment: "",
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Edit Billing',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: tBlue,
                              // fontFamily: 'Barlow',
                              fontSize: isTab(context) ? 13.sp : 10.sp,
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        loader: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Lottie.asset(
              Loading.LOADING,
              // width: 50.w,
            )
            // SpinKitRotatingCircle(
            //   color: Colors.white,
            //   // size: loaderWidth ,
            // ),
            ),
        onTap: (startLoading, stopLoading, btnState) {},
      ),
    );
  }
}
