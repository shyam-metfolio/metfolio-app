import 'dart:async';

import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/views/listAddress/confirmAddress.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/addressApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../HomeAddress/manualAddress.dart';
import '../conformdelivarydetails/conformdeliverydetails.dart';

class ListAddress extends StatefulWidget {
  ListAddress(
      {Key? key,
      this.postalcode,
      required this.isLoginFlow,
      this.goldtype,
      this.qty})
      : super(key: key);
  final postalcode;
  final bool isLoginFlow;
  final goldtype;
  final qty;
  @override
  State<ListAddress> createState() => _SearchAddressState();
}

class _SearchAddressState extends State<ListAddress> {
  @override
  void initState() {
    getListAddress();
    // TODO: implement initState
    super.initState();
  }

  var addressList;

  getListAddress() async {
    var res = await AddressApi()
        .searchAddressByPostalCode(context, widget.postalcode);
    print("res>>>>>>>");
    print(res);
    if (res != null) {
      setState(() {
        addressList = res;
      });
    }
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  var selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: tWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: tWhite,
          leading: GestureDetector(
            // change backbutton
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select your address",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: tPrimaryColor,
                        fontSize: isTab(context) ? 18.sp : 21.sp,
                        // fontWeight: FontWeight.w400,
                        fontFamily: 'Signika'),
                  ),
                  SizedBox(height: 2.h),
                  GestureDetector(
                    onTap: () {
                      Twl.navigateTo(
                          context,
                          ManualAddress(
                            isLoginFlow: widget.isLoginFlow,
                            // dob: widget.dob,
                            // firstName: widget.firstName,
                            // email: widget.email,
                            // lastName: widget.email,
                          ));
                    },
                    child: Text(
                      'Can’t find address?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontSize: isTab(context) ? 9.sp : 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if (addressList != null &&
                      addressList['addresses'].isNotEmpty)
                    Container(
                      height: 70.h,
                      child: ListView.builder(
                          itemCount: addressList['addresses'].length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                if (selectedIndex != null) {
                                  print(addressList[selectedIndex]);
                                  if (widget.isLoginFlow == true) {
                                    Twl.navigateTo(
                                        context,
                                        ConfirmAddress(
                                          address: addressList['addresses']
                                              [selectedIndex],
                                          postalCode: addressList,
                                          qty: widget.qty,
                                          goldtype: widget.goldtype,
                                          isLoginFlow: widget.isLoginFlow,
                                        ));
                                  } else {
                                    Twl.navigateTo(
                                        context,
                                        ConfirmDeliveryDetails(
                                          goldType: widget.goldtype,
                                          isLoginFlow: false,
                                          addDetails: addressList['addresses']
                                              [selectedIndex],
                                          postalCode: addressList,
                                          qty: widget.qty,
                                        ));
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  // horizontal: 20,
                                  vertical: 12,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(15),
                                //   color: selectedIndex == index
                                //       ? tPrimaryColor.withOpacity(0.2)
                                //       : tWhite,
                                //   // border: Border.all(
                                //   //   width: 2,
                                //   //   color:
                                //   //       selectedIndex == index ? tPrimaryColor : tWhite,
                                //   // ),
                                // ),
                                child: Text(
                                  "${addressList['addresses'][index]['line_1'] + ',' + " " + addressList['addresses'][index]['town_or_city'] + ',' + ' ' + addressList['addresses'][index]['county'] + ',' + " " + addressList['postcode']}",
                                  style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 9.sp : 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20),
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: Button(
                  //         borderSide: BorderSide.none,
                  //         color: tPrimaryColor,
                  //         textcolor: tWhite,
                  //         bottonText: 'Continue',
                  //         onTap: (startLoading, stopLoading, btnState) async {
                  //           if (selectedIndex != null) {
                  //             print(addressList[selectedIndex]);

                  //             Twl.navigateTo(
                  //                 context,
                  //                 ConfirmAddress(
                  //                   address: addressList['addresses']
                  //                       [selectedIndex],
                  //                   postalCode: addressList,
                  //                   isLoginFlow: widget.isLoginFlow,
                  //                 ));
                  //           }
                  //         }),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}
