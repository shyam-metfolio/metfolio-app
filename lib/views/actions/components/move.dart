import 'package:base_project_flutter/api_services/orderApi.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalAmount.dart';
import 'package:base_project_flutter/views/successfullPage/movedsucessfull.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:base_project_flutter/provider/actionProvider.dart';
import 'package:provider/provider.dart';
import '../../../api_services/userApi.dart';
import '../../../constants/constants.dart';
import '../../../constants/imageConstant.dart';
import '../../../globalFuctions/globalFunctions.dart';
import '../../../globalWidgets/button.dart';
import '../../../provider/actionProvider.dart';
import '../../../responsive.dart';
import '../../homePage/components/dashBoardPage.dart';
import '../../keypad/keypad.dart';
import '../../veriffPage/veriffPage.dart';

class MoveAction extends StatefulWidget {
  const MoveAction({Key? key}) : super(key: key);

  @override
  State<MoveAction> createState() => _MoveActionState();
}

class _MoveActionState extends State<MoveAction> {
  @override
  void initState() {
    super.initState();
    ActionProvider _data = Provider.of<ActionProvider>(context, listen: false);
    setState(() {
      if (_data.navGoldType == '2') {
        currentGoldType = 2;
        moveGoldType = 1;
      } else {
        currentGoldType = 1;
        moveGoldType = 2;
      }
    });
    getMyGoal();
    checkGold();
    // checkGold(physicalGold.toString());
    e();
  }

  e() async {
    await FirebaseAnalytics.instance.logEvent(
      name: "move_page",
      parameters: {
        "button_clicked": true,
      },
    );

    Segment.track(
      eventName: 'move_page',
      properties: {"clicked": true},
    );

    mixpanel.track('move_page', properties: {
      "button_clicked": true,
    });
  }

  var totalGold;
  // checkGold(String goldType) async {
  //   var res = await UserAPI().checkAvaliableGold(context, goldType);
  //   print(res);
  //   if (res != null && res['status'] == "OK") {
  //     setState(() {
  //       totalGold = res['details']['availableGold'];
  //     });
  //   } else {}
  // }

  TextEditingController pinController1 = TextEditingController();
  String? selectedValue;
  // String? currentGoldType = '1';
  // String? moveGoldType = '2';
  var currentGoldType = 1;
  var moveGoldType = 2;
  List<DropdownMenuItem<String>> months = [
    DropdownMenuItem(child: Text("Physical Gold Account"), value: "1"),
    DropdownMenuItem(child: Text("My Goal Account"), value: "2"),
  ];
  List<DropdownMenuItem<String>> golds = [
    DropdownMenuItem(child: Text("Physical Gold"), value: "1"),
    DropdownMenuItem(child: Text("My Goal"), value: "2"),
  ];
  TextEditingController _qtyController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  var withDrawMoveGold = '0';
  var myGoalDetails;
  var goalTotalValue;
  var avalibleGoalGold;
  var avaliblephyscialGold;
  var verifStatus;
  getMyGoal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var status = await checkVeriffStatus(context);
    // setState(() {
    //   verifStatus = status;
    //   print(verifStatus.runtimeType);
    // });
    var res = await UserAPI().getMyGoals(context);

    if (res != null && res['status'] == 'OK') {
      setState(() {
        sharedPreferences.setString("goalName", res['details']['name_of_goal']);
        myGoalDetails = res;
        avalibleGoalGold = res['details']['availableGoldByGoal'];
      });
    } else {
      setState(() {
        myGoalDetails = res;
      });
    }
  }

  checkGold() async {
    var phygoldres = await UserAPI().checkAvaliableGold(context, '1');
    if (phygoldres != null && phygoldres['status'] == "OK") {
      setState(() {
        avaliblephyscialGold = double.parse(
            phygoldres['details']['availableGold'].toStringAsFixed(3));
      });
    } else {}
    var goalGoldres = await UserAPI().checkAvaliableGold(context, '2');
    if (goalGoldres != null && goalGoldres['status'] == "OK") {
      setState(() {
        avalibleGoalGold = double.parse(
            goalGoldres['details']['availableGold'].toStringAsFixed(3));
      });
    } else {}
  }

  bool loadingPaymentStatus = false;
  loader(value) {
    setState(() {
      loadingPaymentStatus = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  if (myGoalDetails != null)
                    if (myGoalDetails['status'] == 'NOK')
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Move gold between accounts and goals",
                            style: TextStyle(
                                fontSize: isTab(context) ? 13.sp : 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Signika',
                                color: tBlue),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: tContainerColor,
                                borderRadius: BorderRadius.circular(12)),
                            padding: EdgeInsets.fromLTRB(30, 15, 15, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Hit those Goals!",
                                  style: TextStyle(
                                      fontSize: isTab(context) ? 13.sp : 14.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Signika',
                                      color: tBlue),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // customAlert(
                                    //     context,
                                    //     'Continue creating your Goal?',
                                    //     "Yes",
                                    //     'Do it later', (startLoading,
                                    //         stopLoading, btnState) async {
                                    // Twl.navigateTo(context, NameYourGoal());
                                    // if (verifStatus) {
                                    Twl.navigateTo(context, GoalAmount());
                                    // } else {
                                    //   Twl.navigateTo(context, VeriffiPage());
                                    // }
                                    // });
                                  },
                                  child: Center(
                                    child: Container(
                                      // width: 200,
                                      width: 50.w,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: tPrimaryColor),
                                      child: Center(
                                        child: Text(
                                          'Start a goal!',
                                          style: TextStyle(
                                            color: tSecondaryColor,
                                            // fontFamily: 'Signika',
                                            fontSize: 13.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Image.asset(
                                  Images.NEWGOAL,
                                  scale: 2.5,
                                ),
                              ],
                            ),
                          ),
                          if (myGoalDetails['status'] == 'NOK')
                            SizedBox(
                              height: 20,
                            ),
                        ],
                      ),
                  if (myGoalDetails != null)
                    if (myGoalDetails['status'] == 'OK')
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 4.h,
                            ),
                            Text("Move gold between accounts and goals",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontFamily: "Signika",
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        isTab(context) ? 12.5.sp : 15.5.sp)),
                            // SizedBox(
                            //   height: 3.h,
                            // ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                // color: tContainerColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              child: Column(
                                children: [
                                  Text(
                                    'Available to move - ${((currentGoldType == 1 ? avaliblephyscialGold : avalibleGoalGold) ?? 0).toStringAsFixed(3)}g',
                                    style: TextStyle(
                                        color: tTextSecondary,
                                        fontSize: isTab(context) ? 7.sp : 10.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    withDrawMoveGold + 'g',
                                    style: TextStyle(
                                        color: tTextSecondary,
                                        fontSize: isTab(context) ? 7.sp : 18.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: tContainerColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 12),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          currentGoldType == 1
                                              ? Images.GOLD
                                              : Images.MUGOALGOLD,
                                          scale: 4.9,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'From',
                                                style: TextStyle(
                                                    color: tTextSecondary,
                                                    fontSize: isTab(context)
                                                        ? 7.sp
                                                        : 9.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                currentGoldType == 1
                                                    ? 'Physical Gold '
                                                    : myGoalDetails['details']
                                                        ['name_of_goal'],
                                                style: TextStyle(
                                                    color: tTextSecondary,
                                                    fontSize: isTab(context)
                                                        ? 7.sp
                                                        : 11.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Spacer(),
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (currentGoldType == 1 &&
                                                    moveGoldType == 2) {
                                                  currentGoldType = 2;
                                                  moveGoldType = 1;
                                                } else {
                                                  currentGoldType = 1;
                                                  moveGoldType = 2;
                                                }
                                                withDrawMoveGold = '0';
                                                _qtyController.clear();
                                              });

                                              print('currentGoldType' +
                                                  currentGoldType.toString());
                                              print('moveGoldType' +
                                                  moveGoldType.toString());
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: tlightGrayblue,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 5),
                                              child: Image.asset(
                                                Images.EXCHANGEMOVE,
                                                // scale: ,
                                                height: 3.h,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Spacer(),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'To',
                                                style: TextStyle(
                                                    color: tTextSecondary,
                                                    fontSize: isTab(context)
                                                        ? 7.sp
                                                        : 9.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                moveGoldType == 1
                                                    ? 'Physical Gold '
                                                    : myGoalDetails['details']
                                                        ['name_of_goal'],
                                                style: TextStyle(
                                                    color: tTextSecondary,
                                                    fontSize: isTab(context)
                                                        ? 7.sp
                                                        : 11.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Image.asset(
                                          moveGoldType == 1
                                              ? Images.GOLD
                                              : Images.MUGOALGOLD,
                                          scale: 5.2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  KeyPad(
                                    decimalvalue: true,
                                    pinController: _qtyController,
                                    isPinLogin: false,
                                    max: 1000,
                                    min: (currentGoldType == 1
                                        ? avaliblephyscialGold
                                        : avalibleGoalGold),
                                    onChange: (String pin) {
                                      setState(() {
                                        _qtyController..text = pin;
                                      });
                                      if (pin != '') {
                                        if (((currentGoldType == 1
                                                    ? avaliblephyscialGold
                                                    : avalibleGoalGold) >=
                                                double.parse(pin)) &&
                                            1000 >= double.parse(pin)) {
                                          // print('${_qtyController.text}');
                                          setState(() {
                                            withDrawMoveGold = pin;
                                            print(withDrawMoveGold);
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          withDrawMoveGold = '';
                                          print(withDrawMoveGold);
                                        });
                                      }
                                    },
                                    onSubmit: (String pin) {
                                      if (pin.length != 4) {
                                        // (pin.length == 0)
                                        //     ? showInSnackBar('Please Enter Pin')
                                        //     : showInSnackBar('Wrong Pin');
                                        return;
                                      } else {
                                        pinController1.text = pin;

                                        print('Pin is ${pinController1.text}');
                                      }
                                    },
                                  ),
                                  // Container(
                                  //   height: 25,
                                  //   decoration: BoxDecoration(
                                  //       color: tPrimaryTextformfield,
                                  //       borderRadius: BorderRadius.circular(5)),
                                  //   child: DropdownButtonFormField(
                                  //       icon: Padding(
                                  //         padding: EdgeInsets.only(right: 30),
                                  //         child: Image.asset(
                                  //           Images.EXPANDMORE,
                                  //           scale: 4,
                                  //         ),
                                  //       ),
                                  //       focusColor: tWhite,
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.w700,
                                  //         color: tSecondaryColor,
                                  //         fontSize: isTab(context) ? 7.sp : 10.sp,
                                  //       ),
                                  //       decoration: InputDecoration(
                                  //           hintText: "Physical Gold Account",
                                  //           hintStyle: TextStyle(
                                  //             fontWeight: FontWeight.w700,
                                  //             color: tSecondaryColor,
                                  //             fontFamily: 'Barlow',
                                  //             fontSize: isTab(context) ? 7.sp : 10.sp,
                                  //           ),
                                  //           // enabledBorder: OutlineInputBorder(
                                  //           //     borderSide:
                                  //           //         BorderSide(color: tPrimaryColor, width: 1.5),
                                  //           //     borderRadius: BorderRadius.circular(10)),
                                  //           // border: OutlineInputBorder(
                                  //           //   borderRadius: BorderRadius.all(
                                  //           //     Radius.circular(10.0),
                                  //           //   ),
                                  //           // ),
                                  //           contentPadding:
                                  //               EdgeInsets.fromLTRB(40, -22, 10, 0),
                                  //           border: InputBorder.none),
                                  //       value: selectedValue,
                                  //       items: months,
                                  //       onChanged: (String? newvalue) {
                                  //         setState(() {
                                  //           // currentGoldType = newvalue!;
                                  //           // checkGold(newvalue);
                                  //           print('CurrentGoldType' +
                                  //               ' ' +
                                  //               currentGoldType.toString());
                                  //         });
                                  //       }),
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // Container(
                                  //   height: 40,
                                  //   child: TextFormField(
                                  //       textAlign: TextAlign.center,
                                  //       //_phoneNumberController,
                                  //       controller: _qtyController,
                                  //       keyboardType: TextInputType.phone,
                                  //       validator: (value) {
                                  //         if (value!.isEmpty) {
                                  //           Twl.createAlert(
                                  //               context, 'error', "Enter gold quantity");
                                  //         } else if (totalGold == 0) {
                                  //           Twl.createAlert(context, 'error',
                                  //               "you don't sufficent have gold to move");
                                  //         } else if (totalGold < double.parse(value)) {
                                  //           Twl.createAlert(context, 'error',
                                  //               "you don't sufficent have gold to move");
                                  //         }
                                  //       },
                                  //       onChanged: (value) {
                                  //         if (value.isEmpty) {
                                  //           Twl.createAlert(
                                  //               context, 'error', "Enter gold quantity");
                                  //         } else if (totalGold == 0) {
                                  //           Twl.createAlert(context, 'error',
                                  //               "you don't sufficent have gold to move");
                                  //         } else if (totalGold < double.parse(value)) {
                                  //           Twl.createAlert(context, 'error',
                                  //               "you don't sufficent have gold to move");
                                  //         }
                                  //       },
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.w700,
                                  //           color: tSecondaryColor,
                                  //           fontSize: isTab(context) ? 9.sp : 12.sp),
                                  //       decoration: InputDecoration(
                                  //         // prefix: Text('+91 ',style: TextStyle(color: tBlack),),
                                  //         hintText: 'g',

                                  //         hintStyle: TextStyle(
                                  //             fontWeight: FontWeight.w700,
                                  //             color: tSecondaryColor.withOpacity(0.3),
                                  //             fontSize: isTab(context) ? 9.sp : 12.sp),
                                  //         // hintText: 'Enter Your Mobile Number',
                                  //         fillColor: tPrimaryTextformfield,
                                  //         contentPadding: EdgeInsets.symmetric(
                                  //             horizontal: 10, vertical: 2),
                                  //         filled: true,
                                  //         border: OutlineInputBorder(
                                  //           borderRadius: BorderRadius.circular(15),
                                  //           borderSide: BorderSide(
                                  //             width: 0,
                                  //             style: BorderStyle.none,
                                  //           ),
                                  //         ),
                                  //       )),
                                  // ),
                                  // // Container(
                                  // //   width: double.infinity,
                                  // //   decoration: BoxDecoration(
                                  // //       color: tPrimaryTextformfield,
                                  // //       borderRadius: BorderRadius.circular(12)),
                                  // //   padding: EdgeInsets.symmetric(vertical: 5),
                                  // //   child: Container(
                                  // //     child: Center(
                                  // //       child: Text(
                                  // //         "2.8g",
                                  // //         style: TextStyle(
                                  // //           fontFamily: "Signika",
                                  // //           fontWeight: FontWeight.w400,
                                  // //           color: tSecondaryColor,
                                  // //           fontSize: isTab(context) ? 13.sp : 16.sp,
                                  // //         ),
                                  // //       ),
                                  // //     ),
                                  // //   ),
                                  // // ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // Image.asset(
                                  //   Images.EXPANDEDMORE,
                                  //   scale: 4,
                                  // ),
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  // Container(
                                  //   height: 40,
                                  //   decoration: BoxDecoration(
                                  //       color: tPrimaryTextformfield,
                                  //       borderRadius: BorderRadius.circular(12)),
                                  //   child: DropdownButtonFormField(
                                  //       icon: Padding(
                                  //         padding: EdgeInsets.only(right: 30),
                                  //         child: Image.asset(
                                  //           Images.EXPANDMORE,
                                  //           scale: 3.5,
                                  //         ),
                                  //       ),
                                  //       focusColor: tWhite,
                                  //       style: TextStyle(
                                  //         fontWeight: FontWeight.w700,
                                  //         color: tSecondaryColor,
                                  //         fontSize: isTab(context) ? 9.sp : 12.sp,
                                  //       ),
                                  //       decoration: InputDecoration(
                                  //           hintText: "My Gold",
                                  //           hintStyle: TextStyle(
                                  //             fontWeight: FontWeight.w700,
                                  //             color: tSecondaryColor,
                                  //             fontFamily: 'Barlow',
                                  //             fontSize: isTab(context) ? 9.sp : 12.sp,
                                  //           ),
                                  //           // enabledBorder: OutlineInputBorder(
                                  //           //     borderSide:
                                  //           //         BorderSide(color: tPrimaryColor, width: 1.5),
                                  //           //     borderRadius: BorderRadius.circular(10)),
                                  //           // border: OutlineInputBorder(
                                  //           //   borderRadius: BorderRadius.all(
                                  //           //     Radius.circular(10.0),
                                  //           //   ),
                                  //           // ),
                                  //           contentPadding:
                                  //               EdgeInsets.fromLTRB(40, 5, 10, 10),
                                  //           border: InputBorder.none),
                                  //       value: selectedValue,
                                  //       items: golds,
                                  //       onChanged: (String? newvalue) {
                                  //         setState(() {
                                  //           // moveGoldType = newvalue!;
                                  //           print('moveGoldType' +
                                  //               ' ' +
                                  //               moveGoldType.toString());
                                  //         });
                                  //       }),
                                  // ),
                                  // SizedBox(
                                  //   height: 3.h,
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Align(
                                alignment: Alignment.center,
                                child: Button(
                                    borderSide: BorderSide(
                                      color: tPrimaryColor,
                                    ),
                                    color: tPrimaryColor,
                                    textcolor: tWhite,
                                    bottonText: 'Confirm Move',
                                    onTap: (startLoading, stopLoading,
                                        btnState) async {
                                      print(totalGold);
                                      print(withDrawMoveGold);
                                      // print(
                                      //     totalGold >= double.parse(withDrawMoveGold));
                                      // if (verifStatus) {
                                      if ((currentGoldType == 1
                                                  ? avaliblephyscialGold
                                                  : avalibleGoalGold) !=
                                              0 &&
                                          (withDrawMoveGold != 0 ||
                                              withDrawMoveGold != '0') &&
                                          (currentGoldType == 1
                                                  ? avaliblephyscialGold
                                                  : avalibleGoalGold) >=
                                              double.parse(withDrawMoveGold)) {
                                        if (currentGoldType != moveGoldType) {
                                          loader(true);
                                          var qty = _qtyController.text;
                                          var res = await OrderAPI().moveGold(
                                              context,
                                              currentGoldType.toString(),
                                              moveGoldType.toString(),
                                              withDrawMoveGold.toString());
                                          print(res);
                                          if (res != null &&
                                              res['status'] == 'OK') {
                                            loader(false);
                                            Twl.navigateTo(
                                                context, MovedSucessful());
                                          } else {
                                            loader(false);
                                            // Twl.createAlert(
                                            //     context, 'error', res['error']);
                                          }
                                          // Twl.navigateTo(context, MovedSucessful());
                                        } else {
                                          loader(false);
                                          // Twl.createAlert(context, 'error',
                                          //     'you can not move gold to same account');
                                        }
                                      } else if (withDrawMoveGold == 0 ||
                                          withDrawMoveGold == '0' ||
                                          withDrawMoveGold == null) {
                                        loader(false);
                                        // Twl.createAlert(
                                        //     context, 'error', "Enter gold quantity");
                                      } else if (totalGold == 0) {
                                        // Twl.createAlert(context, 'error',
                                        //     "you don't sufficent have gold to move");
                                      } else if (totalGold <
                                          double.parse(withDrawMoveGold)) {
                                        // Twl.createAlert(context, 'error',
                                        //     "you don't sufficent have gold to move");
                                      }
                                      // } else {
                                      //   Twl.navigateTo(context, VeriffiPage());
                                      // }
                                      // else {
                                      //   stopLoading();
                                      //   Twl.createAlert(context, 'error',
                                      //       'you can not move gold to same account');
                                      // }
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ),
          if (loadingPaymentStatus)
            Center(
              child: Container(
                color: tBlack.withOpacity(0.3),
                // padding:
                //     EdgeInsets.only(top: 100),
                height: 100.h,
                width: 100.w,
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  color: tPrimaryColor,
                ),
              ),
            )
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   elevation: 0,
      //   onPressed: () {
      //     Twl.navigateTo(context, MovedSucessful());
      //   },
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //   label: Container(
      //     // height: 10.h,
      //     width: 40.w,
      //     child: Center(
      //       child: Text(
      //         'Confirm Move',
      //         style: TextStyle(
      //             color: tSecondaryColor,
      //             fontWeight: FontWeight.w300,
      //             fontSize: 15),
      //       ),
      //     ),
      //   ),
      //   backgroundColor: tPrimaryColor,
      // ),
    );
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
