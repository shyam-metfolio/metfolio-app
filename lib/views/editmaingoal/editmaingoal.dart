import 'dart:async';

import 'package:loading_icon_button/loading_icon_button.dart';
import 'package:base_project_flutter/api_services/orderApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
import 'package:base_project_flutter/views/nameyourgoal/GoalAmount.dart';

import 'package:base_project_flutter/views/successfullPage/changesSavesSucessfull.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/stripeApi.dart';
import '../../api_services/userApi.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../PersonalDetails/PersonalDetails.dart';
import '../components/alertPage.dart';
import '../loginPassCodePages/enterYourPasscode.dart';
import '../sorryscreen/areYouSureScreen.dart';

class EditMainGoal extends StatefulWidget {
  const EditMainGoal({Key? key}) : super(key: key);

  @override
  State<EditMainGoal> createState() => _EditMainGoalState();
}

const double width = 400.0;
const double height = 45.0;
const double loginAlign = -1;
const double signInAlign = 1;
const Color selectedColor = tWhite;
const Color normalColor = tSecondaryColor;

class _EditMainGoalState extends State<EditMainGoal> {
  var xAlign;
  var loginColor;
  var signInColor;

  String? selectedValue;
  var paymentDate = [
    '1st of every month',
    "7th of every month",
    "14th  of every month",
    "28th of every month"
  ];
  String selectedDate = '1st of every month';
  bool isExpanded = false;
  String? monthsSelectedValue = "1st of every month";
  List<DropdownMenuItem<String>> months = [
    // DropdownMenuItem(
    //     child: Text("7th of every month"), value: "7th of every month"),
    // DropdownMenuItem(
    //     child: Text("6th of every month"), value: "6th of every month"),
    // DropdownMenuItem(
    //     child: Text("5th of every month"), value: "5th of every month"),

    DropdownMenuItem(
        child: Text("1st of every month"), value: "1st of every month"),
    DropdownMenuItem(
        child: Text("7th of every month"), value: "7th of every month"),
    DropdownMenuItem(
        child: Text("14th  of every month"), value: "14th of every month"),
    DropdownMenuItem(
        child: Text("28th of every month"), value: "28th of every month"),
  ];
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _nameGoalController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    getMyGoal();
    super.initState();
    checkPassodeStatus();
    xAlign = signInAlign;
    loginColor = normalColor;
    signInColor = selectedColor;
  }

  bool isPasscodeExist = false;
  checkPassodeStatus() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var userId = sharedPrefs.getString('userId');
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId.toString())
        .snapshots()
        .listen((userData) {
      setState(() {
        if (userData.data()?['userId'] != null) {
          isPasscodeExist = true;
        }
      });
    });
  }

  var myGoalDetails;
  var goalId;
  var defPaymentDeatils;
  getMyGoal() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    loader(true);
    var res = await UserAPI().getMyGoals(context);
    print(res);
    if (res != null && res['status'] == 'OK') {
      setState(() {
        sharedPreferences.setString("goalName", res['details']['name_of_goal']);
        myGoalDetails = res;
        goalId = res['details']['id'].toString();
        _amountController..text = res['details']['goal_amount'].toString();
        _nameGoalController..text = res['details']['name_of_goal'];
        currentStatus = res['details']['current_status'];
        if (res['details']['current_status'] == 1) {
          xAlign = loginAlign;
          loginColor = selectedColor;
          signInColor = normalColor;
        } else {
          xAlign = signInAlign;
          signInColor = selectedColor;
          loginColor = normalColor;
        }

        if (paymentDate.contains(res['details']['payment_date'])) {
          monthsSelectedValue = res['details']['payment_date'];
        }
      });
    } else {
      loader(false);
    }
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var cusId = sharedPrefs.getString('cusId');
    print('cusId>>>>>>>>>>>>' + cusId.toString());
    var defPmId;
    var cusDetails = await StripePaymentApi()
        .getCustomerPaymentDetails(context, cusId.toString());
    print("cusDetails" + cusDetails.toString());
    if (cusDetails != null) {
      setState(() {
        defPmId = cusDetails['invoice_settings']['default_payment_method'];
      });
      print(defPmId);
      var res =
          await StripePaymentApi().getCustomerCards(context, cusId.toString());
      print("cardlist>>>>>>>>");
      print(res);
      if (res != null) {
        for (var i = 0; i <= res['data'].length - 1; i++) {
          if (res['data'][i]['id'] == defPmId) {
            setState(() {
              defPaymentDeatils = res['data'][i];
            });
            break;
          }
        }
        print(defPaymentDeatils);
        // print("defPaymentDeatils>>>>>>" +
        //     defPaymentDeatils['card']['wallet']['type']);
        loader(false);
      } else {
        loader(false);
      }
    } else {
      // print(defPaymentDeatils);
      loader(false);
    }
  }

  editGoalAction() {
    return customAlert(
        context,
        'Would you like to save your changes?',
        "Confirm",
        'Discard',
        null, (startLoading, stopLoading, btnState) async {
      if (_formKey.currentState!.validate() && monthsSelectedValue != null) {
        //startLoading();
        var goalName;
        var amount;
        var date;
        print(amount);
        setState(() {
          goalName = _nameGoalController.text;
          amount = (_amountController.text);
          date = monthsSelectedValue;
        });
        var res = await OrderAPI().editGoal(
            context,
            goalId,
            goalName,
            amount.replaceAll(RegExp(Secondarycurrency), ''),
            date,
            '1',
            currentStatus.toString());
        if (res != null && res['status'] == 'OK') {
          stopLoading();
          Twl.navigateTo(context, ChangesSavedSucessful());
        } else {
          stopLoading();
          // Twl.createAlert(context, 'error', res['error']);
        }
        stopLoading();
      } else {
        if (monthsSelectedValue == null) {
          // Twl.createAlert(context, 'warning', 'select your day');
        }
      }
    });
  }

  bool loading = false;
  loader(value) {
    setState(() {
      loading = value;
    });
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  var currentStatus = 2;
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () {
            return editGoalAction();
          },
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: tWhite,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: tWhite,
                leading: GestureDetector(
                  onTap: () {
                    // Twl.navigateBack(context);
                    editGoalAction();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: selectedvalue == 1 ? btnColor : tWhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset(
                        Images.NAVBACK,
                        scale: 4,
                      ),
                    ),
                  ),
                ),
              ),
              body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Edit Goal ',
                                style: TextStyle(
                                    color: tPrimaryColor,
                                    fontFamily: "Signika",
                                    fontSize: isTab(context) ? 18.sp : 21.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'Goal Name',
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 9.sp : 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(height: 15),
                              Container(
                                height: 42,
                                child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                      // UpperCaseTextFormatter(),
                                    ],
                                    textAlign: TextAlign.center,
                                    controller: _nameGoalController,
                                    validator: (value) {
                                      // if (value!.length >= 10) {
                                      //   return "";
                                      // } else {
                                      //   return null;
                                      // }
                                    },
                                    //_phoneNumberController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: tSecondaryColor,
                                        fontSize:
                                            isTab(context) ? 9.sp : 12.sp),
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(height: 0),
                                      // prefix: Text('+91 ',style: TextStyle(color: tBlack),),
                                      // hintText: 'Down payment for house',
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              tSecondaryColor.withOpacity(0.3),
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp),
                                      // hintText: 'Enter Your Mobile Number',
                                      fillColor: tPrimaryTextformfield,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                    )),
                              ),
                              if (myGoalDetails != null)
                                if (myGoalDetails['details']
                                            ['subscription_status'] !=
                                        '1' &&
                                    myGoalDetails['details']
                                            ['subscription_status'] !=
                                        1)
                                  SizedBox(
                                    height: 30,
                                  ),
                              if (myGoalDetails != null)
                                if (myGoalDetails['details']
                                            ['subscription_status'] !=
                                        '1' &&
                                    myGoalDetails['details']
                                            ['subscription_status'] !=
                                        1)
                                  Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Goal Status',
                                      style: TextStyle(
                                          color: tSecondaryColor,
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                              if (myGoalDetails != null)
                                if (myGoalDetails['details']
                                            ['subscription_status'] !=
                                        '1' &&
                                    myGoalDetails['details']
                                            ['subscription_status'] !=
                                        1)
                                  SizedBox(
                                    height: 15,
                                  ),
                              if (myGoalDetails != null)
                                if (myGoalDetails['details']
                                            ['subscription_status'] !=
                                        '1' &&
                                    myGoalDetails['details']
                                            ['subscription_status'] !=
                                        1)
                                  Center(
                                    child: Container(
                                      width: 90.w,
                                      // height: height,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: tTextformfieldColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(11.0),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          AnimatedAlign(
                                            alignment: Alignment(xAlign, 0),
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: Container(
                                              width: 43.w,
                                              height: height,
                                              decoration: BoxDecoration(
                                                color: tTextformfieldSecondary,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(11.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                xAlign = loginAlign;
                                                loginColor = selectedColor;
                                                currentStatus = 1;
                                                signInColor = normalColor;
                                              });
                                            },
                                            child: Align(
                                              alignment: Alignment(-1, 0),
                                              child: Container(
                                                width: 45.w,
                                                color: Colors.transparent,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Paused',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: loginColor,
                                                    fontSize: isTab(context)
                                                        ? 9.sp
                                                        : 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                xAlign = signInAlign;
                                                signInColor = selectedColor;
                                                currentStatus = 2;
                                                loginColor = normalColor;
                                              });
                                            },
                                            child: Align(
                                              alignment: Alignment(1, 0),
                                              child: Container(
                                                width: 45.w,
                                                color: Colors.transparent,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Active',
                                                  style: TextStyle(
                                                    color: signInColor,
                                                    fontSize: isTab(context)
                                                        ? 9.sp
                                                        : 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'Monthly amount',
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 9.sp : 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 42,
                                child: TextFormField(
                                    textAlign: TextAlign.center,
                                    //_phoneNumberController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]+[.]{0,1}[0-9]*')),
                                      DecimalTextInputFormatter(decimalRange: 2)
                                    ],
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true),
                                    controller: _amountController,
                                    // keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Twl.createAlert(context, 'error',
                                            "Enter montly amount");
                                      } else if (double.parse(value.replaceAll(
                                                  RegExp(Secondarycurrency),
                                                  '')) >=
                                              1 &&
                                          double.parse(value.replaceAll(
                                                  RegExp(Secondarycurrency),
                                                  '')) >=
                                              5000) {
                                        // return Twl.createAlert(context, 'error',
                                        //     "Entering amount and set limit min 1 and max 5000");
                                      }
                                    },
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        // Twl.createAlert(
                                        //     context, 'error', "Enter montly amount");
                                      } else if (int.parse(value.replaceAll(
                                                  RegExp(Secondarycurrency),
                                                  '')) >=
                                              1 &&
                                          int.parse(value.replaceAll(
                                                  RegExp(Secondarycurrency),
                                                  '')) >=
                                              5000) {
                                        // Twl.createAlert(context, 'error',
                                        //     "Entering amount and set limit min 1 and max 5000");
                                      }
                                    },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: tSecondaryColor,
                                        fontSize:
                                            isTab(context) ? 9.sp : 12.sp),
                                    decoration: InputDecoration(
                                      // prefix: Text('+91 ',style: TextStyle(color: tBlack),),
                                      hintText: '£',
                                      prefixText: 'GBP ($Secondarycurrency):',
                                      counterText: "",

                                      prefixStyle: TextStyle(
                                        fontFamily: 'Signika',
                                        fontWeight: FontWeight.w700,
                                        color: tTextSecondary,
                                        fontSize: isTab(context) ? 9.sp : 12.sp,
                                      ),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color:
                                              tSecondaryColor.withOpacity(0.3),
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp),
                                      // hintText: 'Enter Your Mobile Number',
                                      fillColor: tPrimaryTextformfield,
                                      contentPadding: EdgeInsets.only(
                                        left: 10,
                                        top: 2,
                                        bottom: 2,
                                        right: 21.w,
                                      ),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'Payment Date',
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 9.sp : 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (!isExpanded) {
                                      isExpanded = true;
                                    } else {
                                      isExpanded = false;
                                    }
                                  });
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: tPrimaryTextformfield,
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        monthsSelectedValue != ''
                                            ? monthsSelectedValue.toString()
                                            : 'Select your date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: monthsSelectedValue == ''
                                              ? tSecondaryColor.withOpacity(0.3)
                                              : tSecondaryColor,
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Image.asset(
                                          Images.EXPANDMORE,
                                          scale: 3.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              if (isExpanded)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: tPrimaryTextformfield,
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: EdgeInsets.only(bottom: 25),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...List.generate(
                                        paymentDate.length,
                                        (index) => Container(
                                          height: 30,
                                          child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                monthsSelectedValue =
                                                    paymentDate[index];
                                                isExpanded = false;
                                              });
                                            },
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                            title: Text(
                                              paymentDate[index],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: tSecondaryColor,
                                                fontSize: isTab(context)
                                                    ? 9.sp
                                                    : 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              // Container(
                              //   height: 42,
                              //   decoration: BoxDecoration(
                              //       color: tPrimaryTextformfield,
                              //       borderRadius: BorderRadius.circular(15)),
                              //   child: DropdownButtonFormField(
                              //       icon: Padding(
                              //         padding: EdgeInsets.only(right: 50),
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
                              //           focusColor: tPrimaryTextformfield,
                              //           hintText: "7th of every month",
                              //           hintStyle: TextStyle(
                              //             fontWeight: FontWeight.w700,
                              //             color: tSecondaryColor.withOpacity(0.3),
                              //             fontSize: isTab(context) ? 9.sp : 12.sp,
                              //           ),
                              //           contentPadding:
                              //               EdgeInsets.fromLTRB(40, 0, 10, 3),
                              //           border: InputBorder.none),
                              //       value: monthsSelectedValue,
                              //       items: months,
                              //       onChanged: (String? newvalue) {
                              //         setState(() {
                              //           monthsSelectedValue = newvalue!;
                              //         });
                              //       }),
                              // ),
                              SizedBox(
                                height: 25,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  'Payment Method',
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: isTab(context) ? 9.sp : 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              if (defPaymentDeatils != null)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: tPrimaryTextformfield,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 10.w,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          getcardType(defPaymentDeatils['card']
                                                      ['wallet'] !=
                                                  null
                                              ? defPaymentDeatils['card']
                                                  ['wallet']['type']
                                              : ''),
                                          height: 28),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (defPaymentDeatils[
                                                            'billing_details']
                                                        ['name'] !=
                                                    null &&
                                                defPaymentDeatils[
                                                            'billing_details']
                                                        ['name'] !=
                                                    '')
                                              Text(
                                                defPaymentDeatils[
                                                            'billing_details']
                                                        ['name'] ??
                                                    "",
                                                // 'Meeren J. Raniga',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: tSecondaryColor,
                                                  fontSize: isTab(context)
                                                      ? 9.sp
                                                      : 12,
                                                ),
                                              ),
                                            Text(
                                              'Card ending ${defPaymentDeatils['card']['last4']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: tSecondaryColor,
                                                fontSize:
                                                    isTab(context) ? 9.sp : 15,
                                                // fontFamily: 'Barlow-Bold',
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              SizedBox(
                                height: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40.w,
                                      child: Button(
                                          borderSide: BorderSide(
                                            color: tPrimaryColor,
                                          ),
                                          color: tPrimaryColor,
                                          textcolor: tWhite,
                                          bottonText: 'Confirm changes',
                                          onTap: (startLoading, stopLoading,
                                              btnState) async {
                                            if (_formKey.currentState!
                                                    .validate() &&
                                                monthsSelectedValue != null) {
                                              var goalName;
                                              var amount;
                                              var date;
                                              print(amount);
                                              setState(() {
                                                goalName =
                                                    _nameGoalController.text;
                                                amount =
                                                    (_amountController.text);
                                                date = monthsSelectedValue;
                                              });
                                              // if (isPasscodeExist) {
                                              //   Twl.navigateTo(
                                              //       context,
                                              //       EnterYourPasscode(
                                              //         type: GoldType().EditGoal,
                                              //         goalId: goalId,
                                              //         amount: amount,
                                              //         currentStatus: currentStatus,
                                              //         goalName: goalName,
                                              //         date: date,
                                              //       ));
                                              // } else {

                                              showDialog(
                                                context: context,
                                                barrierDismissible:
                                                    true, // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Stack(
                                                      children: [
                                                        AlertDialog(
                                                          backgroundColor:
                                                              tTextformfieldColor,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15.0))),
                                                          // title: const Text('Are you sure you want to exit?'),
                                                          // content: SingleChildScrollView(
                                                          //   child: ListBody(
                                                          //     children: const <Widget>[
                                                          //       Text('This is a demo alert dialog.'),
                                                          //       Text('Would you like to approve of this message?'),
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                          actions: <Widget>[
                                                            Column(
                                                              children: [
                                                                Center(
                                                                  child: Card(
                                                                      elevation:
                                                                          0,
                                                                      color:
                                                                          tTextformfieldColor,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            350,
                                                                        width: double
                                                                            .infinity,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 30,
                                                                              vertical: 10),
                                                                          child: Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                Column(children: [
                                                                                  SizedBox(
                                                                                    height: 20,
                                                                                  ),
                                                                                  Text(
                                                                                    'Would you like to save your changes?',
                                                                                    style: TextStyle(color: tSecondaryColor, fontSize: isTab(context) ? 13.sp : 16.sp, fontWeight: FontWeight.w400),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ]),
                                                                                Column(
                                                                                  children: [
                                                                                    Center(
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        child: ArgonButton(
                                                                                          highlightElevation: 0,
                                                                                          height: isTab(context) ? 70 : 40,
                                                                                          width: 90.w,
                                                                                          color: tPrimaryColor,
                                                                                          borderRadius: 15,
                                                                                          child: Text(
                                                                                            'Confirm',
                                                                                            style: TextStyle(
                                                                                              color: tSecondaryColor,
                                                                                              fontSize: 13.sp,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                          ),
                                                                                          // loader: Container(
                                                                                          //   // height: 40,
                                                                                          //   // width: double.infinity,
                                                                                          //   padding: EdgeInsets.symmetric(horizontal: 0),
                                                                                          //   child: Lottie.asset(
                                                                                          //     loading.LOADING,
                                                                                          //     // width: 50.w,
                                                                                          //   ),
                                                                                          // ),
                                                                                          onTap: (startLoading, stopLoading, btnState) async {
                                                                                            loader(true);
                                                                                            //startLoading();
                                                                                            var goalName;
                                                                                            var amount;
                                                                                            var date;
                                                                                            print(amount);
                                                                                            setState(() {
                                                                                              goalName = _nameGoalController.text;
                                                                                              amount = (_amountController.text);
                                                                                              date = monthsSelectedValue;
                                                                                            });
                                                                                            print("this is new date" + date);
                                                                                            print(date);
                                                                                            var res = await OrderAPI().editGoal(context, goalId, goalName, amount.replaceAll(RegExp(Secondarycurrency), ''), date, '1', currentStatus.toString());
                                                                                            print(res);
                                                                                            if (res != null && res['status'] == 'OK') {
                                                                                              loader(false);
                                                                                              stopLoading();
                                                                                              // WidgetsBinding.instance!
                                                                                              //     .addPostFrameCallback(
                                                                                              //         (_) async {
                                                                                              Twl.navigateTo(context, ChangesSavedSucessful());
                                                                                              // });
                                                                                            } else {
                                                                                              loader(false);
                                                                                              stopLoading();
                                                                                              // Twl.createAlert(context, 'error',
                                                                                              //     res['error']);
                                                                                            }
                                                                                            stopLoading();
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(height: 10),
                                                                                    Center(
                                                                                      child: Container(
                                                                                        width: double.infinity,
                                                                                        child: ArgonButton(
                                                                                          highlightElevation: 0,
                                                                                          height: isTab(context) ? 70 : 40,
                                                                                          width: 90.w,
                                                                                          color: tPrimaryColor,
                                                                                          borderRadius: 15,
                                                                                          child: Text(
                                                                                            'Discard',
                                                                                            style: TextStyle(
                                                                                              color: tSecondaryColor,
                                                                                              fontSize: 13.sp,
                                                                                              fontWeight: FontWeight.w600,
                                                                                            ),
                                                                                          ),
                                                                                          // loader: Container(
                                                                                          //   // height: 40,
                                                                                          //   // width: double.infinity,
                                                                                          //   padding: EdgeInsets.symmetric(horizontal: 0),
                                                                                          //   child: Lottie.asset(
                                                                                          //     loading.LOADING,
                                                                                          //     // width: 50.w,
                                                                                          //   ),
                                                                                          // ),
                                                                                          onTap: (startLoading, stopLoading, btnState) async {
                                                                                            Twl.navigateBack(context);
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ]),
                                                                        ),
                                                                      )),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        if (loading)
                                                          Center(
                                                              child: Container(
                                                            color: tBlack
                                                                .withOpacity(
                                                                    0.3),
                                                            // padding:
                                                            //     EdgeInsets.only(top: 100),
                                                            height: 100.h,
                                                            width: 100.w,
                                                            alignment: Alignment
                                                                .center,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color:
                                                                  tPrimaryColor,
                                                            ),
                                                          ))
                                                      ],
                                                    );
                                                  });
                                                },
                                              );
                                              // customAlert(
                                              //     context,
                                              //     'Would you like to save your changes?',
                                              //     "Confirm",
                                              //     'Discard',
                                              //     null, (startLoading,
                                              //         stopLoading,
                                              //         btnState) async {
                                              //   loader(true);
                                              //   //startLoading();
                                              //   var goalName;
                                              //   var amount;
                                              //   var date;
                                              //   print(amount);
                                              //   setState(() {
                                              //     goalName =
                                              //         _nameGoalController.text;
                                              //     amount =
                                              //         (_amountController.text);
                                              //     date = monthsSelectedValue;
                                              //   });
                                              //   var res = await OrderAPI()
                                              //       .editGoal(
                                              //           context,
                                              //           goalId,
                                              //           goalName,
                                              //           amount.replaceAll(
                                              //               RegExp(
                                              //                   Secondarycurrency),
                                              //               ''),
                                              //           date,
                                              //           '1',
                                              //           currentStatus.toString());
                                              //   print(res);
                                              //   if (res != null &&
                                              //       res['status'] == 'OK') {
                                              //     loader(false);
                                              //     stopLoading();
                                              //     // WidgetsBinding.instance!
                                              //     //     .addPostFrameCallback(
                                              //     //         (_) async {
                                              //     Twl.navigateTo(context,
                                              //         ChangesSavedSucessful());
                                              //     // });
                                              //   } else {
                                              //     loader(false);
                                              //     stopLoading();
                                              //     // Twl.createAlert(context, 'error',
                                              //     //     res['error']);
                                              //   }
                                              //   stopLoading();
                                              // });
                                            }
                                            // } else {
                                            //   if (monthsSelectedValue == null) {
                                            //     // Twl.createAlert(context, 'warning',
                                            //     //     'select your day');
                                            //   }
                                            // }
                                            // Twl.navigateTo(context, ChangesSavedSucessful());
                                          }),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 40.w,
                                      child: Button(
                                          borderSide: BorderSide(
                                            color: tPrimaryColor,
                                          ),
                                          color: tPrimaryColor,
                                          textcolor: tWhite,
                                          bottonText: 'Discard changes',
                                          onTap: (startLoading, stopLoading,
                                              btnState) async {
                                            Twl.navigateBack(context);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    var goalName;
                                    var amount;
                                    var date;
                                    setState(() {
                                      goalName = _nameGoalController.text;
                                      amount = _amountController.text;
                                      date = monthsSelectedValue;
                                    });
                                    Twl.navigateTo(
                                        context,
                                        AreYouSureScreen(
                                          goalName: goalName,
                                          amount: amount.replaceAll('£', ''),
                                          date: date,
                                          goalId: goalId,
                                        ));
                                    // var res = await OrderAPI().editGoal(
                                    //     context,
                                    //     goalId,
                                    //     goalName,
                                    //     amount,
                                    //     date,
                                    //     '2',
                                    //     currentStatus.toString());
                                    // if (res != null && res['status'] == 'OK') {
                                    //   Twl.navigateTo(context, BottomNavigation());
                                    // } else {
                                    //   Twl.createAlert(context, 'error', res['error']);
                                    // }
                                  },
                                  child: Text(
                                    'End Goal ',
                                    style: TextStyle(
                                        color: tSecondaryColor,
                                        fontSize: isTab(context) ? 9.sp : 12.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (loading)
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
          ))
      ],
    );
  }
}

getcardType(type) {
  switch (type) {
    case 'apple_pay':
      return Images.APPLEMARK;
      break;
    case 'google_pay':
      return Images.GPAYMARK;
      break;
    default:
      return Images.PAYMENTCARDICON;
  }
}
