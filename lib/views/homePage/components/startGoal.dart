import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/components/noActiveGoalsContainer.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StartGoal extends StatefulWidget {
  const StartGoal({Key? key}) : super(key: key);

  @override
  State<StartGoal> createState() => _StartGoalState();
}

class _StartGoalState extends State<StartGoal> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      child: Column(
        children: [
          NoActiveGoalsContainer(
            buttontext: "Start a goal!",
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            "Metfolio Goals! Set up a fully personalised\ngoal and start buying physical gold\nautomatically every single month.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: isTab(context) ? 9.sp : 12.sp,
                fontWeight: FontWeight.w700,
                color: tSecondaryColor),
          )
        ],
      ),
    ));
  }
}
