// import 'dart:async';

// import 'package:base_project_flutter/api_services/stripeApi.dart';
// import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
// import 'package:base_project_flutter/views/bottomNavigation.dart/bottomNavigation.dart';
// import 'package:base_project_flutter/views/successfullPage/PurchesedConfirmSucessfull.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:sizer/sizer.dart';

// import '../../api_services/orderApi.dart';
// import '../../constants/constants.dart';
// import '../../constants/imageConstant.dart';
// import '../../globalFuctions/globalFunctions.dart';
// import '../../globalWidgets/button.dart';
// import '../../responsive.dart';
// import '../paymentMethods/paymentCardDetails.dart';

// class PaymentDetails extends StatefulWidget {
//   const PaymentDetails({Key? key, this.customerId}) : super(key: key);
//   // final pmId;
//   final customerId;
//   @override
//   State<PaymentDetails> createState() => _PaymentDetailsState();
// }

// class _PaymentDetailsState extends State<PaymentDetails> {
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _cardController = TextEditingController();

//   TextEditingController _expiryMonthController = TextEditingController();
//   TextEditingController _expiryYearController = TextEditingController();
//   TextEditingController _cvvController = TextEditingController();

//   final _formKey = new GlobalKey<FormState>();
//   var btnColor = tIndicatorColor;
//   var selectedvalue;
//   bool loadingPaymentStatus = false;
//   loader(value) {
//     setState(() {
//       loadingPaymentStatus = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         GestureDetector(
//           onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//           child: Scaffold(
//             backgroundColor: tWhite,
//             appBar: AppBar(
//               elevation: 0,
//               backgroundColor: tWhite,
//               leading: GestureDetector(
//                 // change the back button shadow
//                 onTap: () {
//                   Twl.navigateBack(context);
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: selectedvalue == 1 ? btnColor : tWhite,
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Image.asset(
//                       Images.NAVBACK,
//                       scale: 4,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             body: SafeArea(
//               child: Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Please enter your payment details",
//                                 style: TextStyle(
//                                   color: tPrimaryColor,
//                                   fontSize: isTab(context) ? 19.sp : 21.sp,
//                                   // fontWeight: FontWeight.w500,
//                                   fontFamily: 'Signika',
//                                 ),
//                               ),
//                               SizedBox(height: 2.h),
//                               Text(
//                                 "This card will be saved and can be\nused for future Metfolio purchases",
//                                 style: TextStyle(
//                                   color: tSecondaryColor,
//                                   fontSize: isTab(context) ? 9.sp : 12.sp,
//                                   // fontWeight: FontWeight.w500,
//                                   // fontFamily: 'Signika',
//                                 ),
//                               ),
//                               SizedBox(height: 2.h),
//                               titleWidget('Name (as shown on Card)'),
//                               SizedBox(height: 1.h),
//                               TwlNormalTextField(
//                                 controller: _nameController,
//                                 textInputType: TextInputType.name,
//                                 validator: validateName,
//                               ),
//                               SizedBox(height: 2.h),
//                               titleWidget('Card Number'),
//                               SizedBox(height: 1.h),
//                               TwlNormalTextField(
//                                 controller: _cardController,
//                                 textInputType: TextInputType.number,
//                                 validator: validateCard,
//                                 maxlength: 19,
//                                 inputForamtters: [
//                                   FilteringTextInputFormatter.digitsOnly,
//                                   CardNumberFormatter()
//                                 ],
//                               ),
//                               SizedBox(height: 2.h),
//                               titleWidget('Card expiry date'),
//                               SizedBox(height: 1.h),
//                               Padding(
//                                 padding: EdgeInsets.only(right: 40.w),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: TwlNormalTextField(
//                                         controller: _expiryMonthController,
//                                         textInputType: TextInputType.datetime,
//                                         validator: validateExpiryMonth,
//                                         inputForamtters: [
//                                           LengthLimitingTextInputFormatter(2)
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Expanded(
//                                       child: TwlNormalTextField(
//                                         controller: _expiryYearController,
//                                         textInputType: TextInputType.datetime,
//                                         validator: validateExpiryYear,
//                                         inputForamtters: [
//                                           LengthLimitingTextInputFormatter(4)
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 2.h),
//                               titleWidget('CVV'),
//                               SizedBox(height: 1.h),
//                               Padding(
//                                 padding: EdgeInsets.only(right: 50.w),
//                                 child: TwlNormalTextField(
//                                   controller: _cvvController,
//                                   textInputType: TextInputType.number,
//                                   validator: validateCvv,
//                                   inputForamtters: [
//                                     LengthLimitingTextInputFormatter(4)
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 17.w),
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Button(
//                               borderSide: BorderSide.none,
//                               color: tPrimaryColor,
//                               textcolor: tWhite,
//                               bottonText: 'Continue',
//                               onTap:
//                                   (startLoading, stopLoading, btnState) async {
//                                 if (_formKey.currentState!.validate()) {
//                                   loader(true);
//                                   //startLoading();
//                                   var cardnumber = _cardController.text;
//                                   var expMonth = _expiryMonthController.text;
//                                   var expYear = _expiryYearController.text;
//                                   var cvc = _cvvController.text;
//                                   var res = await OrderAPI().createGoalPayment(
//                                       context,
//                                       cardnumber,
//                                       expMonth,
//                                       expYear,
//                                       cvc,
//                                       _nameController.text);
//                                   print('createGoalPayment>>>>>>>>>>');
//                                   print(res);

//                                   if (res != null && res['status'] == 'OK') {
//                                     var pmId;
//                                     setState(() {
//                                       pmId = res['details']['id'];
//                                     });
//                                     print(pmId);
//                                     var cardres = await StripePaymentApi()
//                                         .addPaymentCardDetails(
//                                             context, pmId, widget.customerId);
//                                     print(cardres);
//                                     if (res != null && res['status'] == 'OK') {
//                                       loader(false);
//                                       // Twl.navigateBack(context);
//                                       Twl.navigateTo(
//                                           context, BottomNavigation());
//                                     } else {
//                                       loader(false);
//                                     }
//                                   }
//                                   loader(false);
//                                   // Twl.navigateTo(
//                                   //     context, PurchesedConfirmSucessful());
//                                 }
//                                 loader(false);
//                                 // //startLoading();
//                               }
//                               // stopLoading();
//                               // }
//                               ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (loadingPaymentStatus)
//           Center(
//               child: Container(
//             color: tBlack.withOpacity(0.3),
//             // padding:
//             //     EdgeInsets.only(top: 100),
//             height: 100.h,
//             width: 100.w,
//             alignment: Alignment.center,
//             child: CircularProgressIndicator(
//               color: tPrimaryColor,
//             ),
//           ))
//       ],
//     );
//   }

//   String? validateName(String? value) {
//     if (value!.isEmpty) {
//       return "";
//     }
//     return null;
//   }

//   String? validateCard(String? value) {
//     if (value!.isEmpty) {
//       return "";
//     }
//     return null;
//   }

//   String? validateExpiryMonth(String? value) {
//     if (value!.isEmpty || double.parse(value) > 12) {
//       return "";
//     }
//     return null;
//   }

//   String? validateExpiryYear(String? value) {
//     if (value!.isEmpty) {
//       return "";
//     }
//     return null;
//   }

//   String? validateCvv(String? value) {
//     if (value!.isEmpty) {
//       return "";
//     }
//     return null;
//   }

//   titleWidget(
//     String title,
//   ) {
//     return Text(
//       title,
//       style: TextStyle(
//         color: tSecondaryColor,
//         fontSize: isTab(context) ? 9.sp : 12.sp,
//         fontWeight: FontWeight.w500,
//       ),
//     );
//   }

//   Widget textFormField(TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.text,
//       style: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
//       decoration: InputDecoration(
//         // prefix: Text('+91 ',style: TextStyle(color: tBlack),),

//         hintStyle: TextStyle(fontSize: isTab(context) ? 10.sp : 14.sp),
//         // hintText: 'Enter Your Mobile Number',
//         fillColor: tPrimaryTextformfield,
//         contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
//         filled: true,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: BorderSide(
//             width: 0,
//             style: BorderStyle.none,
//           ),
//         ),
//       ),
//     );
//   }
// }
