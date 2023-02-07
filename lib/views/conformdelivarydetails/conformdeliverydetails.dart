import 'dart:async';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/successfullPage/deliverySucessfull.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../loginPassCodePages/enterYourPasscode.dart';

class ConfirmDeliveryDetails extends StatefulWidget {
  const ConfirmDeliveryDetails(
      {Key? key,
      this.goldType,
      this.addDetails,
      required this.qty,
      this.isLoginFlow,
      this.postalCode})
      : super(key: key);
  final goldType;
  final addDetails;
  final qty;
  final isLoginFlow;
  final postalCode;
  @override
  State<ConfirmDeliveryDetails> createState() => _ConfirmDeliveryDetailsState();
}

class _ConfirmDeliveryDetailsState extends State<ConfirmDeliveryDetails> {
  bool loading = false;
  loader(value) {
    setState(() {
      loading = value;
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

  var btnColor = tIndicatorColor;
  var selectedvalue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: tWhite,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: tWhite,
            leading: GestureDetector(
              onTap: () {
                Twl.navigateBack(context);
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
          body: WillPopScope(
            onWillPop: () {
              return Twl.navigateBack(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.2.h,
                          ),
                          Center(
                            child: Text(
                              'Confirm Delivery Details',
                              style: TextStyle(
                                  color: tPrimaryColor,
                                  fontFamily: "Signika",
                                  fontSize: isTab(context) ? 19.sp : 21.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Center(
                            child: Text(
                                "Metfolio 50 Gram 24K LBMA Approved Gold Bar",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    // fontFamily: "Signika",
                                    fontWeight: FontWeight.bold,
                                    fontSize: isTab(context) ? 9.sp : 12.sp)),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Center(
                            child: Image.asset(
                              Images.GOLDBAR,
                              scale: 3.5,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Delivery Address ',
                              style: TextStyle(
                                  color: tSecondaryColor,
                                  fontSize: isTab(context) ? 13.sp : 16.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 1.4.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 18),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: tlightColor,
                                    borderRadius: BorderRadius.circular(11)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Home Address',
                                      style: TextStyle(
                                          color: tSecondaryColor,
                                          fontSize:
                                              isTab(context) ? 9.sp : 12.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    SizedBox(height: 1.h),
                                    if (widget.isLoginFlow == null)
                                      Text(
                                        '${widget.addDetails.addressLineOne}\n${widget.addDetails.postCode}\n${widget.addDetails.city}\n${widget.addDetails.country}',
                                        style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize:
                                                isTab(context) ? 9.sp : 12.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    if (widget.isLoginFlow == false)
                                      Text(
                                        '${widget.addDetails['line_1']}\n${widget.postalCode['postcode']}\n${widget.addDetails['town_or_city']}\n${widget.addDetails['county']}',
                                        style: TextStyle(
                                            color: tSecondaryColor,
                                            fontSize:
                                                isTab(context) ? 9.sp : 12.sp,
                                            fontWeight: FontWeight.w400),
                                      )
                                  ],
                                )),
                          ),
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
                        loader(true);
                        // //startLoading();
                        if (widget.isLoginFlow == false) {
                          var address1;
                          var address2;
                          var postalCode;
                          var city;
                          var country;
                          setState(() {
                            address1 = widget.addDetails['line_1'];
                            city = widget.addDetails['town_or_city'];
                            postalCode = widget.postalCode['postcode'];
                            country = widget.addDetails['county'];
                          });
                          var lat = widget.postalCode['latitude'];
                          var lng = widget.postalCode['longitude'];
                          var addressRes = await UserAPI().addAddress(
                              context,
                              address1,
                              '',
                              postalCode,
                              city,
                              lat.toString(),
                              lng.toString(),
                              country);
                          print('addressRes>>>>');
                          print(addressRes);
                          if (addressRes != null &&
                              addressRes['status'] == 'OK') {
                            // if (isPasscodeExist) {
                            //   Twl.navigateTo(
                            //       context,
                            //       EnterYourPasscode(
                            //           type: GoldType().Deliver,
                            //           addDetailsId: addressRes['details']['id'],
                            //           currentStatus: widget.goldType,
                            //           amount: 50));
                            // } else {
                            var res = await UserAPI().goldDelivery(
                                context,
                                widget.qty.toString(),
                                widget.goldType,
                                addressRes['details']['id'].toString());
                            print(res);
                            if (res != null && res['status'] == 'OK') {
                              loader(false);
                              var delivryQty;
                              setState(() {
                                delivryQty = double.parse(
                                    res['details']['order']['quantity']);
                              });
                              print('delivryQty>>>>>>>>>>>');
                              print(delivryQty);
                              stopLoading();
                              Twl.navigateTo(context,
                                  DeliverySucessful(delivryQty: delivryQty));
                            } else {
                              loader(false);
                              stopLoading();
                              // Twl.createAlert(context, 'error', res['error']);
                            }
                            // }
                          } else {
                            loader(false);
                            // Twl.createAlert(
                            //     context, 'error', addressRes['error']);
                          }
                        } else {
                          // if (isPasscodeExist) {
                          //   Twl.navigateTo(
                          //       context,
                          //       EnterYourPasscode(
                          //           type: GoldType().Deliver,
                          //           addDetailsId: widget.addDetails.id,
                          //           currentStatus: widget.goldType,
                          //           amount: 50));
                          // } else {
                          var res = await UserAPI().goldDelivery(
                              context,
                              widget.qty.toString(),
                              widget.goldType,
                              widget.addDetails.id.toString());
                          print(res);
                          if (res != null && res['status'] == 'OK') {
                            loader(false);
                            var delivryQty;
                            setState(() {
                              delivryQty = double.parse(
                                  res['details']['order']['quantity']);
                            });
                            print('delivryQty>>>>>>>>>>>');
                            print(delivryQty);
                            stopLoading();
                            Twl.navigateTo(context,
                                DeliverySucessful(delivryQty: delivryQty));
                          } else {
                            loader(false);
                            stopLoading();
                            // Twl.createAlert(context, 'error', res['error']);
                          }
                          // }
                        }
                      }),
                ),
                SizedBox(
                  height: 3.h,
                )
              ],
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
