import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';

import '../../globalWidgets/button.dart';



class ThanksForStartingGoal extends StatefulWidget {
  const ThanksForStartingGoal({ Key? key }) : super(key: key);

  @override
  State<ThanksForStartingGoal> createState() => _ThanksForStartingGoalState();
}

class _ThanksForStartingGoalState extends State<ThanksForStartingGoal> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
        elevation: 0,
        backgroundColor: tWhite,
        leading: Container()
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                      SizedBox(
                                height: 1.2.h,
                              ),
                              Center(
                                child: Text(
                                  'Successful ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: tPrimaryColor,
                                      fontSize: isTab(context) ? 15.sp : 18.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                             
                              SizedBox(
                                height: 12.h,
                              ),
                              Image.asset(Images.GOLD,scale: 3,)
                              
            
                  ],
                ),
              ),
            ),
          ),
              Button(
                    borderSide: BorderSide(
                      color: tPrimaryColor,
                    ),
                    color: tPrimaryColor,
                    textcolor: tWhite,
                    bottonText: 'Back to portfolio',
                    onTap: (startLoading, stopLoading, btnState) async {
                    
                    }),
                    SizedBox(
                      height: 3.h,
                    )

        ],
      ),
      
    );
  }
}