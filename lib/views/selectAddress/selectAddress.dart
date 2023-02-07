import 'dart:async';

import 'package:base_project_flutter/models/myAddressesModel.dart'
    as myAddresses;
import 'package:base_project_flutter/views/conformdelivarydetails/conformdeliverydetails.dart';
import 'package:base_project_flutter/views/deliveryForm/deliveryHomeAddress.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';
import '../HomeAddress/HomeAddress.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({Key? key, this.goldType, required this.qty})
      : super(key: key);
  final goldType;
  final qty;
  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  late Future<myAddresses.MyAddressesModel> MyOrderDetials;
  void initState() {
    super.initState();
    MyOrderDetials = UserAPI().getMyAddress(context, '0');
  }
var btnColor = tIndicatorColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                borderRadius: BorderRadius.circular(10)
              ),
              child: Image.asset(
                Images.NAVBACK,
                scale: 4,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: FutureBuilder<myAddresses.MyAddressesModel>(
            future: MyOrderDetials,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // return Text(snapshot.error.toString());
                print("ERROR" + snapshot.error.toString());
              }
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                    child: Container(
                  // padding:
                  //     EdgeInsets.only(top: 100),
                  // height: 100.h,
                  // width: 100.w,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: tPrimaryColor,
                  ),
                ));
              }
              if (snapshot.hasData) {
                return MyAddressPagination(
                  addressDetails: snapshot.data,
                  goldType: widget.goldType,
                  qty: widget.qty,
                );
              } else {
                return Column(
                  children: [
                    Text("Your Addresses appear here."),
                    Column(
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            Twl.navigateTo(
                                context,
                                HomeAddress(
                                  isLoginFlow: false,
                                ));
                            // Twl.navigateTo(context, DeliveryHomeAddress());
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                color: tContainerColor,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                "Deliver to a different address",
                                style: TextStyle(
                                    fontSize: isTab(context) ? 9.sp : 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: tSecondaryColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}

class MyAddressPagination extends StatefulWidget {
  const MyAddressPagination({
    Key? key,
    this.addressDetails,
    this.goldType,
    required this.qty,
  }) : super(key: key);
  final addressDetails;
  final goldType;
  final qty;
  @override
  State<MyAddressPagination> createState() => _MyAddressPaginationState();
}

class _MyAddressPaginationState extends State<MyAddressPagination> {
  ScrollController scrollController = new ScrollController();
  late final List<myAddresses.Detail> myAddreses;
  late double scrollPosition;
  int page = 0;
  _scrollListener() {
    if (scrollController.position.maxScrollExtent > scrollController.offset &&
        scrollController.position.maxScrollExtent - scrollController.offset <=
            55) {
      print('End Scroll');
      page = (page + 1);
      UserAPI().getMyAddress(context, page.toString()).then((val) {
        // currentPage = currentPage++;
        if (val.details != null) {
          setState(() {
            // currentPage = currentPage + 1;
            myAddreses.addAll(val.details);
          });
        } else {
          return Center(
            child: Text('End of data'),
          );
        }
      });
    }
  }

  void initState() {
    scrollController = ScrollController();
    myAddreses = widget.addressDetails.details;
    scrollController.addListener(_scrollListener);
    // CheckGold();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      // crossAxisAlignment: CrossAx
      // isAlignment.start,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Select Address",
                style: TextStyle(
                    fontFamily: 'Signika',
                    fontSize: isTab(context) ? 18.sp : 21.sp,
                    fontWeight: FontWeight.w500,
                    color: tPrimaryColor),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            var address = myAddreses[index];
            return Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 20,
              ),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: tlightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home Address",
                          style: TextStyle(
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w400,
                              color: tSecondaryColor),
                        ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Text(
                          address.addressLineOne,
                          style: TextStyle(
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w400,
                              color: tSecondaryColor),
                        ),
                        // SizedBox(
                        //   height: 1.h / 2,
                        // ),
                        Text(
                          address.city,
                          style: TextStyle(
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w400,
                              color: tSecondaryColor),
                        ),
                        // SizedBox(
                        //   height: 1.h / 2,
                        // ),
                        Text(
                          address.postCode,
                          style: TextStyle(
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w400,
                              color: tSecondaryColor),
                        ),
                        // SizedBox(
                        //   height: 1.h / 2,
                        // ),
                        Text(
                          address.country,
                          style: TextStyle(
                              fontSize: isTab(context) ? 9.sp : 12.sp,
                              fontWeight: FontWeight.w400,
                              color: tSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Twl.navigateTo(
                          context,
                          ConfirmDeliveryDetails(
                            goldType: widget.goldType,
                            addDetails: address,                          
                            qty: widget.qty,
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: tPrimaryColor,
                          borderRadius: BorderRadius.circular(13)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 8),
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Text(
                        "Select",
                        style: TextStyle(
                            fontFamily: 'Signika',
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }, childCount: myAddreses.length),
        ),

        SliverToBoxAdapter(
          child: Column(
            children: [
              // SizedBox(
              //   height: 2.h,
              // ),
              GestureDetector(
                onTap: () {
                  Twl.navigateTo(
                      context,
                      HomeAddress(
                        isLoginFlow: false,
                        qty: widget.qty,
                        goldtype: widget.goldType,
                      ));
                  // Twl.navigateTo(context, DeliveryHomeAddress());
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: tContainerColor,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "Deliver to a different address",
                      style: TextStyle(
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                          color: tSecondaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 43.h,
        // ),
        // GestureDetector(
        //   onTap: () {
        //     Twl.navigateTo(context, BankDetails());
        //   },
        //   child: Center(
        //     child: Container(
        //       decoration: BoxDecoration(
        //           color: tPrimaryColor,
        //           borderRadius: BorderRadius.circular(10)),
        //       padding:
        //           EdgeInsets.symmetric(horizontal: 20.w, vertical: 15),
        //       child: Text(
        //         "Continue",
        //         style: TextStyle(
        //             color: tSecondaryColor,
        //             fontSize: isTab(context) ? 9.sp : 12.sp,
        //             fontWeight: FontWeight.w400),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
