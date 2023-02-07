import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/constants/imageConstant.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectAndUpdate extends StatefulWidget {
  const SelectAndUpdate({Key? key}) : super(key: key);

  @override
  State<SelectAndUpdate> createState() => _SelectAndUpdateState();
}

class _SelectAndUpdateState extends State<SelectAndUpdate> {
  int val = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: tWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tWhite,
        leading: GestureDetector(
          onTap: () {
            Twl.navigateBack(context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Image.asset(
              Images.NAVBACK,
              scale: 4,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Select and upload a \n document",
                  style: TextStyle(
                      color: tPrimaryColor,
                      fontSize: isTab(context) ? 18.sp : 21.sp,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 26,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Please select and upload one official\ndocument to confirm you reside in the\nUnited Kingdom and verify who you are.\nData is processed securely",
                    style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 11.sp : 14.sp,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 49,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      val = 0;
                      print(val);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: tTextformfieldColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: ListTile(
                          leading: Transform.scale(
                            scale: 1.5,
                            child: Radio(
                              value: 0,
                              groupValue: val,
                              onChanged: (value) {
                                setState(() {
                                  val = 0;
                                });
                              },
                              activeColor: Color(0xFF243558),
                            ),
                          ),
                          title: Text(
                            "Passport",
                            style: TextStyle(
                                color: Color(0xff1E365B),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      val = 1;
                      print(val);
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                          color: tTextformfieldColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: ListTile(
                          leading: Transform.scale(
                            scale: 1.5,
                            child: Radio(
                              value: 1,
                              groupValue: val,
                              onChanged: (value) {
                                setState(() {
                                  val = 1;
                                });
                              },
                              activeColor: Color(0xFF243558),
                            ),
                          ),
                          title: Text(
                            "Drivers Licence",
                            style: TextStyle(
                                color: Color(0xff1E365B),
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 40),
                        primary: tPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      // Twl.navigateTo(context, val==0? Pasport() : License(),
                      // );
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: tBlue),
                    )),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
