// import 'package:base_project_flutter/api_services/orderApi.dart';
// import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
// import 'package:base_project_flutter/responsive.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../constants/imageConstant.dart';
// import '../../globalFuctions/globalFunctions.dart';
// import '../../globalWidgets/button.dart';
// import '../paymentdetails/paymentdetails.dart';
// import '../successfullPage/PurchesedConfirmSucessfull.dart';

// class NameYourGoal extends StatefulWidget {
//   const NameYourGoal({Key? key}) : super(key: key);

//   @override
//   State<NameYourGoal> createState() => _NameYourGoalState();
// }

// class _NameYourGoalState extends State<NameYourGoal> {
//   TextEditingController _nameGoalController = TextEditingController();
//   double _currentSliderValue = 20;
//   String? selectedValue;

//   String? monthsSelectedValue;
//   List<DropdownMenuItem<String>> months = [
//     // DropdownMenuItem(
//     //     child: Text("7th of every month"), value: "7th of every month"),
//     // DropdownMenuItem(
//     //     child: Text("6th of every month"), value: "6th of every month"),
//     // DropdownMenuItem(
//     //     child: Text("5th of every month"), value: "5th of every month"),
//     DropdownMenuItem(
//         child: Text("28th of every month"), value: "28th of every month"),
//     DropdownMenuItem(
//         child: Text("14th  of every month"), value: "14th of every month"),
//     DropdownMenuItem(
//         child: Text("7th of every month"), value: "7th of every month"),
//     DropdownMenuItem(
//         child: Text("1st of every month"), value: "1st of every month"),
//   ];
//   final _formKey = new GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: tWhite,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: tWhite,
//         leading: GestureDetector(
//           onTap: () {
//             Twl.navigateBack(context);
//           },
//           child: Padding(
//             padding: EdgeInsets.only(left: 20),
//             child: Image.asset(
//               Images.NAVBACK,
//               scale: 4,
//             ),
//           ),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 1.2.h,
//                         ),
//                         Center(
//                           child: Text(
//                             'Name your goal',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 fontFamily: "signika",
//                                 color: tPrimaryColor,
//                                 fontSize: isTab(context) ? 13.sp : 16.sp,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 2.h,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: TwlNormalTextField(
//                             controller: _nameGoalController,
//                             validator: (v) {
//                               if (v!.isEmpty) {
//                                 return "Enter your goal name";
//                               } else {
//                                 return null;
//                               }
//                             },
//                           ),
//                         ),
//                         SizedBox(
//                           height: 6.h,
//                         ),
//                         Text(
//                           'Decide your amount',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontFamily: "signika",
//                               color: tPrimaryColor,
//                               fontSize: isTab(context) ? 13.sp : 16.sp,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(
//                           height: 1.5.h,
//                         ),
//                         Text(
//                           'Type or use the slider',
//                           style: TextStyle(
//                               color: tSecondaryColor,
//                               fontSize: isTab(context) ? 9.sp : 12.sp,
//                               fontWeight: FontWeight.w400),
//                         ),
//                         SizedBox(
//                           height: 1.5.h,
//                         ),
//                         // Text(
//                         //   'Quantity',
//                         //   style: TextStyle(
//                         //       fontFamily: "Signika",
//                         //       color: tTextSecondary,
//                         //       fontSize: isTab(context) ? 15.sp : 16.sp,
//                         //       fontWeight: FontWeight.w400),
//                         // ),
//                         // SizedBox(
//                         //   height: 3.7.h,
//                         // ),
//                         Container(
//                           width: double.infinity,
//                           margin: EdgeInsets.symmetric(horizontal: 20),
//                           padding: EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                               color: tTextformfieldColor,
//                               borderRadius: BorderRadius.circular(12)),
//                           child: Center(
//                             child: Text(
//                               Secondarycurrency +
//                                   _currentSliderValue.toString(),
//                               style: TextStyle(
//                                   color: tTextSecondary,
//                                   fontFamily: "Signika",
//                                   fontSize: isTab(context) ? 15.sp : 16.sp,
//                                   fontWeight: FontWeight.w400),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 3.9.h,
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(horizontal: 20),
//                           width: double.infinity,
//                           child: CupertinoSlider(
//                               thumbColor: tTextSecondary,
//                               activeColor: tTextSecondary,
//                               divisions: 5,
//                               max: 100.0,
//                               value: _currentSliderValue,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _currentSliderValue = value;
//                                 });
//                               }),
//                         ),
//                         SizedBox(
//                           height: 2.h,
//                         ),
//                         Text(
//                           'Choose any amount over £50 to be\nconverted into gold every month',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               color: tSecondaryColor,
//                               fontSize: isTab(context) ? 10.sp : 12.sp),
//                         ),
//                         SizedBox(
//                           height: 6.h,
//                         ),
//                         Text(
//                           'Choose your payment date',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontFamily: "signika",
//                               color: tPrimaryColor,
//                               fontSize: isTab(context) ? 13.sp : 16.sp,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(
//                           height: 1.5.h,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20),
//                           child: Container(
//                             // height: 5.5.h,
//                             decoration: BoxDecoration(
//                                 color: tPrimaryTextformfield,
//                                 borderRadius: BorderRadius.circular(15)),
//                             child: DropdownButtonFormField(
//                                 icon: Padding(
//                                   padding: EdgeInsets.only(right: 50),
//                                   child: Image.asset(
//                                     Images.EXPANDMORE,
//                                     scale: 3.5,
//                                   ),
//                                 ),
//                                 focusColor: tWhite,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w700,
//                                   color: tSecondaryColor,
//                                   fontSize: isTab(context) ? 9.sp : 12.sp,
//                                 ),
//                                 decoration: InputDecoration(
//                                     hintText: "7th of every month",
//                                     hintStyle: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       color: tSecondaryColor,
//                                       fontSize: isTab(context) ? 9.sp : 12.sp,
//                                     ),
//                                     contentPadding:
//                                         EdgeInsets.fromLTRB(40, 5, 10, 7),
//                                     border: InputBorder.none),
//                                 value: selectedValue,
//                                 items: months,
//                                 onChanged: (String? newvalue) {
//                                   setState(() {
//                                     monthsSelectedValue = newvalue!;
//                                   });
//                                 }),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 40,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20.w),
//                           child: Button(
//                               borderSide: BorderSide(
//                                 color: tPrimaryColor,
//                               ),
//                               color: tPrimaryColor,
//                               textcolor: tWhite,
//                               bottonText: 'Continue',
//                               onTap:
//                                   (startLoading, stopLoading, btnState) async {
//                                 if (_formKey.currentState!.validate() &&
//                                     monthsSelectedValue != null) {
//                                   //startLoading();
//                                   var goalName;
//                                   var amount;
//                                   var date;
//                                   setState(() {
//                                     goalName = _nameGoalController.text;
//                                     amount = _currentSliderValue.toString();
//                                     date = monthsSelectedValue;
//                                   });
//                                   var res = await OrderAPI().addGoal(
//                                       context, goalName, amount, date, '');
//                                   if (res != null && res['status'] == 'OK') {
//                                     stopLoading();
//                                     Twl.navigateTo(
//                                         context, PurchesedConfirmSucessful());
//                                     // Twl.navigateTo(context, PaymentDetails());
//                                   } else {
//                                     stopLoading();
//                                     Twl.createAlert(
//                                         context, 'error', res['error']);
//                                   }
//                                   stopLoading();
//                                 } else {
//                                   if (monthsSelectedValue == null) {
//                                     Twl.createAlert(
//                                         context, 'warning', 'select your day');
//                                   }
//                                 }
//                               }),
//                         ),
//                         SizedBox(
//                           height: 3.h,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
