import 'package:base_project_flutter/views/nameyourgoal/nameyourgoal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';


class ChooseYourFrequency extends StatefulWidget {
  const ChooseYourFrequency({Key? key}) : super(key: key);

  @override
  State<ChooseYourFrequency> createState() => _ChooseYourFrequencyState();
}

class _ChooseYourFrequencyState extends State<ChooseYourFrequency> {
  String? selectedValue;
  List<String> items = [
    '7th of every month',
    '6th of every month',
    '5th of every month',
    '4th of every month',
    '3th of every month',
    '2th of every month',
    '1th of every month'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: tWhite,
      //   leading: GestureDetector(
      //     onTap: () {
      //       Twl.navigateBack(context);
      //     },
      //     child: Image.asset(
      //       Images.NAVBACK,
      //       scale: 3.5,
      //     ),
      //   ),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: GestureDetector(
              onTap: () {
                Twl.navigateBack(context);
              },
              child: Image.asset(
                Images.NAVBACK,
                scale: 4,
              ),
            ),
          ),
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
                        'Choose your frequency',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Signika",
                            color: tPrimaryColor,
                            fontSize: isTab(context) ? 18.sp : 21.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 4.9.h,
                    ),
                    Center(
                      child: Container(
                        width: 80.w,
                        height: 4.5.h,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            focusColor: tTextformfieldColor,

                            autofocus: true,

                            isExpanded: true,
                            hint: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '7th of every month',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: isTab(context) ? 10.sp : 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: tSecondaryColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Center(
                                        child: Text(
                                          item,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                isTab(context) ? 10.sp : 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: tSecondaryColor,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value as String;
                              });
                            },
                            icon: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 17),
                                decoration: BoxDecoration(
                                    color: tSecondaryColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(11),
                                        bottomRight: Radius.circular(11))),
                                child: Image.asset(
                                  Images.DOWNARROW,
                                  height: 12,
                                )),
                            iconSize: 14,
                            alignment: Alignment.center,
                            iconEnabledColor: tBlack,
                            iconDisabledColor: tGray,
                            buttonHeight: 50,
                            buttonWidth: 200,
                            buttonPadding: EdgeInsets.only(left: 5, right: 0),
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: tTextformfieldColor,
                            ),
                            buttonElevation: 1,
                            itemHeight: 40,
                            itemPadding: EdgeInsets.only(left: 15, right: 15),
                            dropdownMaxHeight: 200,
                            dropdownPadding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 10),
                            dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: tWhite),
                            dropdownElevation: 1,
                            // scrollbarRadius: Radius.circular(40),
                            // scrollbarThickness: 6,
                            // scrollbarAlwaysShow: true,
                            offset: Offset(-20, 0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Your decided amount will be converted into gold and added to yuor account on this day of every month',
                        style: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Button(
                borderSide: BorderSide(
                  color: tPrimaryColor,
                ),
                color: tPrimaryColor,
                textcolor: tWhite,
                bottonText: 'Continue',
                onTap: (startLoading, stopLoading, btnState) async {
                  // Twl.navigateTo(context, NameYourGoal());
                }),
          ),
          SizedBox(
            height: 3.h,
          )
        ],
      ),
    );
  }
}
