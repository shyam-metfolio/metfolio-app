import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/views/actions/components/deliveryFromBottomSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../responsive.dart';
import '../../homePage/components/dashBoardPage.dart';
import '../../loginPassCodePages/enterYourPasscode.dart';
import '../../selectAddress/selectAddress.dart';
import '../../veriffPage/veriffPage.dart';

class DeliverPage extends StatefulWidget {
  const DeliverPage({Key? key}) : super(key: key);

  @override
  State<DeliverPage> createState() => _DeliverPageState();
}

class _DeliverPageState extends State<DeliverPage> {
  String? selectedValue;
  String? monthsSelectedValue;
  List<DropdownMenuItem<String>> months = [
    DropdownMenuItem(
        child: Text("Physical Gold Account"), value: "Physical Gold Account"),
    DropdownMenuItem(child: Text("My Goal Account"), value: "My Goal Account"),
  ];

  @override
  void initState() {
    // WidgetsBinding.instance!.addPostFrameCallback((_) async {
    //   await diplayBottomSheet();
    // });
    checkGold();

    super.initState();
    e();
  }

  e() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "deliver_page",
      parameters: {
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'deliver_page',
      properties: {"clicked": true},
    );

    mixpanel.track('deliver_page', properties: {
      "button_clicked": true,
    });
  }

  bool isPasscodeExist = false;
  // checkPassodeStatus() async {
  //   SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  //   var userId = sharedPrefs.getString('userId');

  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .where('userId', isEqualTo: userId.toString())
  //       .get()
  //       .then((QuerySnapshot snapshot) async {
  //     print("isPasscodeExist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  //     print(userId);
  //     // print(userData.data()?['userId']);
  //     if (snapshot.docs.length > 0) {
  //       if (snapshot.docs[0].data() != null) {
  //         WidgetsBinding.instance!.addPostFrameCallback((_) async {
  //           setState(() {
  //             isPasscodeExist = true;
  //           });
  //           print("passcode exit");
  //           print(isPasscodeExist);
  //         });
  //       }

  //       // print(snapshot.docs[0].data());
  //     } else {
  //       WidgetsBinding.instance!.addPostFrameCallback((_) async {
  //         setState(() {
  //           isPasscodeExist = false;
  //         });
  //       });
  //       print("passcode NOT exit");
  //       print(isPasscodeExist);
  //     }
  //   });
  // }

  @override
  void didChangeDependencies() {
    // checkPassodeStatus();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  var totalGold = 0.0;
  String deliverFromValue = 'Physical Gold Account';
  String goldType = '1';
  selectDeliverFrom(String value, double goldQty, goldtype) {
    setState(() {
      deliverFromValue = value;
      goldType = goldtype;
      print(goldType);
      totalGold = goldQty;
    });
  }

  var verifStatus = false;
  checkGold() async {
    // var status = await checkVeriffStatus(context);
    // setState(() {
    //   verifStatus = status;
    //   print(verifStatus.runtimeType);
    // });
    var phygoldres = await UserAPI().checkAvaliableGold(context, '1');
    if (phygoldres != null && phygoldres['status'] == "OK") {
      setState(() {
        totalGold =
            double.parse(phygoldres['details']['availableGold'].toString());
      });
    } else {
      // Twl.createAlert(context, 'error', phygoldres['error']);
    }
  }

  @override
  Widget build(BuildContext context) {
    // diplayBottomSheet();
    return Scaffold(
      backgroundColor: tWhite,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 4.h,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Performing action for:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: tTextSecondary,
                      fontSize: isTab(context) ? 9.sp : 12.sp,
                      fontWeight: FontWeight.w300),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  // if (verifStatus) {
                  diplayBottomSheet();
                  // } else {
                  //   Twl.navigateTo(context, VeriffiPage());
                  // }
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: tTextformfieldColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        deliverFromValue,
                        style: TextStyle(
                          fontSize: isTab(context) ? 10.sp : 12.sp,
                          fontWeight: FontWeight.bold,
                          color: tSecondaryColor,
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        Images.EXPANDEDMORE,
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                'Available to deliver - ${totalGold.toStringAsFixed(3)}g',
                style: TextStyle(
                    color: tTextSecondary,
                    fontSize: isTab(context) ? 7.sp : 10.sp,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 3.h,
              ),
              Text(
                "Metfolio 50 Gram 24K LBMA Approved Gold Bar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: tSecondaryColor,
                  // fontFamily: "Signika",
                  fontWeight: FontWeight.w700,
                  fontSize: isTab(context) ? 9.sp : 12.sp,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Image.asset(
                Images.GOLDBAR,
                scale: 3.5,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 74.w,
                child: Text(
                  "Consolidate your physical gold holdings on Metfolio by taking delivery of a 50 gram gold bar at no extra cost! If your gold is in different accounts, move it to one account and take delivery from there.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: tSecondaryColor,
                    // fontFamily: "Signika",
                    fontWeight: FontWeight.w500,
                    fontSize: isTab(context) ? 6.sp : 9.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: FloatingActionButton.extended(
                        elevation: 0,
                        onPressed: () {
                          // if (verifStatus) {
                          if (totalGold != 0 && totalGold != '0') {
                            if (totalGold >= 50) {
                              // if (isPasscodeExist == false) {
                              //   print("asdcsdc");
                              print(isPasscodeExist);
                              Twl.navigateTo(
                                  context,
                                  SelectAddress(
                                    goldType: goldType,
                                    qty: 50,
                                  ));
                              // } else {
                              //   print("aacascssdcsdc");
                              //   print(isPasscodeExist);
                              //   Twl.navigateTo(
                              //       context,
                              //       EnterYourPasscode(
                              //           type: GoldType().Deliver,
                              //           currentStatus: goldType,
                              //           amount: 50));
                              // }
                            } else {
                              // Twl.createAlert(context, 'error',
                              //     'you dont have sufficient');
                            }
                          } else {
                            // Twl.createAlert(context, 'error',
                            //     "you don't have gold to delivery or switch your account");
                          }
                          // } else {
                          //   Twl.navigateTo(context, VeriffiPage());
                          // }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        label: Container(
                          // height: 10.h,
                          width: 40.w,
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                  color: tSecondaryColor,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        backgroundColor: verifStatus
                            ? (totalGold >= 50
                                ? tPrimaryColor
                                : tPrimaryColor.withOpacity(0.5))
                            : tPrimaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    // Center(
                    //   child: Text(
                    //     "We are working on giving more delivery options in the future!",
                    //     style: TextStyle(
                    //         color: tSecondaryColor,
                    //         fontSize: isTab(context) ? 6.sp : 9.sp,
                    //         fontWeight: FontWeight.w300),
                    //   ),
                    // ),
                  ],
                ),
              )
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 17.w),
              //   child: Button(
              //       borderSide: BorderSide(
              //         color: tPrimaryColor,
              //       ),
              //       color: tPrimaryColor,
              //       textcolor: tWhite,
              //       bottonText: 'Continue',
              //       onTap: (startLoading, stopLoading, btnState) async {
              //         Twl.navigateTo(context, SelectAddress());
              //       }),
              // ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Container(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       Center(
      //         child: FloatingActionButton.extended(
      //           elevation: 0,
      //           onPressed: () {},
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10)),
      //           label: Container(
      //             // height: 10.h,
      //             width: 40.w,
      //             child: Center(
      //               child: Text(
      //                 'Continue',
      //                 style: TextStyle(
      //                     color: tSecondaryColor,
      //                     fontWeight: FontWeight.w300,
      //                     fontSize: 15),
      //               ),
      //             ),
      //           ),
      //           backgroundColor: tPrimaryColor,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 1.h,
      //       ),
      //       Center(
      //         child: Text(
      //           "We are working on giving more delivery options in the future!",
      //           style: TextStyle(
      //               color: tSecondaryColor,
      //               fontSize: isTab(context) ? 6.sp : 9.sp,
      //               fontWeight: FontWeight.w300),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  diplayBottomSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      )),
      context: context,
      builder: (ctx) {
        return DeliveryFromBottomSheet(
          selectDelivery: selectDeliverFrom,
          title: 'Deliver from:',
        );
      },
    );
  }
}
