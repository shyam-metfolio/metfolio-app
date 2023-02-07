
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';

class YourDetails extends StatefulWidget {
  const YourDetails({Key? key, this.details}) : super(key: key);
  final details;

  @override
  State<YourDetails> createState() => _YourDetailsState();
}

class _YourDetailsState extends State<YourDetails> {
  @override
  void initState() {
    getNumber();
    super.initState();
  }

  var userNumber = '';
  getNumber() {
    if (widget.details != null) {
      var endLength = widget.details['username'].toString().length;
      print(widget.details['username'].toString().length);
      print(widget.details['username'].toString().substring(0, 3));
      print(widget.details['username'].toString().substring(3, endLength));
      setState(() {
        userNumber = widget.details['username'].toString().substring(0, 3) +
            ' ' +
            widget.details['username'].toString().substring(3, endLength);
      });
    }
  }

  var btnColor = tTextformfieldColor;
  var selectedvalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: tWhite,
        leading: GestureDetector(
          // change the back button shadow
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Details',
                      style: TextStyle(
                        color: tPrimaryColor,
                        fontSize: isTab(context) ? 18.sp : 21.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Signika',
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: tPrimaryColor,
                      radius: 40,
                      child: Center(
                        child: Text(
                          widget.details['first_name'][0].toUpperCase() +
                              widget.details['last_name'][0].toUpperCase(),
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 19.sp : 22.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  'Personal Details',
                  style: TextStyle(
                    color: tSecondaryColor,
                    fontSize: isTab(context) ? 13.sp : 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Signika',
                  ),
                ),
                SizedBox(height: 2.h),
                titleWidget('Name', context),
                SizedBox(height: 1.h),
                detailWidget(
                    widget.details['first_name'] +
                        ' ' +
                        widget.details['last_name'],
                    context,
                    1,
                    widget.details['country']),
                SizedBox(height: 2.h),
                titleWidget('Date of Birth', context),
                SizedBox(height: 1.h),
                detailWidget(
                    // Twl.dateFormate(
                    widget.details['date_of_birth']
                    // )
                    ,
                    context,
                    2,
                    widget.details['country']),
                SizedBox(height: 2.h),
                titleWidget('Home Address', context),
                SizedBox(height: 1.h),
                detailWidget(
                    widget.details['delivery_address'].isNotEmpty
                        ? (widget.details['delivery_address']
                                ['address_line_one'] +
                            '\n' +
                            widget.details['delivery_address']['post_code'] +
                            '\n' +
                            widget.details['delivery_address']['city'] +
                            '\n' +
                            widget.details['delivery_address']['country'])
                        : '',
                    context,
                    3,
                    widget.details['country']),
                SizedBox(height: 2.h),
                titleWidget('Phone Number', context),
                SizedBox(height: 1.h),
                detailWidget((userNumber).toString(), context, 4,
                    widget.details['country']),
                SizedBox(height: 2.h),
                titleWidget('Email', context),
                SizedBox(height: 1.h),
                detailWidget(widget.details['email'], context, 5,
                    widget.details['country']),
                SizedBox(height: 2.h),
                // titleWidget('Tax Residencies', context),
                // SizedBox(height: 1.h),
                // detailWidget(details['delivery_address']['country'] ??'', context, 6, details['country']),
                // SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  detailWidget(
    String title,
    BuildContext context,
    int index,
    country,
  ) {
    return GestureDetector(
      onTap: () {
        // if (index == 3) {
        //   Twl.navigateTo(context, ProfileHomeAddress());
        // } else if (index == 5) {
        //   Twl.navigateTo(
        //       context,
        //       PersonalDetails(
        //         isLoadingFlow: false,
        //       ));
        // }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: tTextformfieldColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Row(
          children: [
            // if (index == 4)
            //   Stack(
            //     children: [
            //       Container(
            //         // width: 50,
            //         // height: 20,
            //         padding: EdgeInsets.zero,
            //         child: CountryListPick(
            //           theme: CountryTheme(
            //             isShowFlag: true,
            //             isShowTitle: false,
            //             isShowCode: false,
            //             isDownIcon: false,
            //             showEnglishName: false,
            //           ),
            //           useUiOverlay: false,
            //           initialSelection: country,
            //         ),
            //       ),
            //     Container(
            //       color: Colors.transparent,
            //       // width: 40,
            //       // height: 20,
            //     ),
            //   ],
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              child: Text(
                title,
                style: TextStyle(
                  color: tSecondaryColor,
                  fontSize: isTab(context) ? 9.sp : 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  titleWidget(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: tSecondaryColor,
        fontSize: isTab(context) ? 9.sp : 12.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
