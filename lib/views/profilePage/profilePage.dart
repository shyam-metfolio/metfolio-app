import 'dart:async';

import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/profilePage/profileTab.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import 'settingsTab.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
 var btnColor = tIndicatorColor;
  var selectedvalue;
class _ProfilePageState extends State<ProfilePage> {
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTabController(
                length: 2,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 3.h),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: tPrimaryTextformfield,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Container(
                          height: 40,
                          child: TabBar(
                            labelStyle: TextStyle(
                                fontSize: isTab(context) ? 9.sp : 12.sp,
                                fontWeight: FontWeight.w400),
                            unselectedLabelStyle: TextStyle(
                                fontSize: isTab(context) ? 9.sp : 12.sp,
                                fontWeight: FontWeight.w400),
                            labelPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            unselectedLabelColor: tSecondaryColor,
                            labelColor: tWhite,
                            indicator: BoxDecoration(
                              color: tTabColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            tabs: [
                              Tab(
                                child: Text("Profile"),
                              ),
                              Tab(
                                child: Text("Settings"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 72.h,
                      child: TabBarView(
                        children: [
                          ProfileTab(),
                          SettingsTab(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
















































// import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
// import 'package:base_project_flutter/globalWidgets/button.dart';
// import 'package:base_project_flutter/globalWidgets/customTextFiled.dart';
// import 'package:base_project_flutter/responsive.dart';
// import 'package:base_project_flutter/views/HomeAddress/HomeAddress.dart';
// import 'package:sizer/sizer.dart';
// import '../../constants/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// // import '../Frame7/Frame7.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   bool _isLoading = true;
//   void displayDialog(context, title, text) => showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(title),
//           content: Text(text),
//           actions: [
//             new FlatButton(
//               child: new Text("Continue"),
//               onPressed: () {
//                 // Twl.navigateTo(context, Frame7());
//               },
//             ),
//           ],
//         ),
//       );
//   String? email = ' ';
//   String? username = '  ';
//   String? lastName = '  ';
//   String? fullName = '  ';
//   String? profileImage = '  ';
//   String? firstName = '  ';

//   late String authCode;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   void validateAndSave() {
//     final FormState? form = _formKey.currentState;
//     if (form!.validate()) {
//       print('Form is valid');
//     } else {
//       print('Form is invalid');
//     }
//   }

//   final TextEditingController _emailIdController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();

//   final TextEditingController _firstNameController = TextEditingController();

//   final TextEditingController _lastNameController = TextEditingController();
//   void initState() {
//     super.initState();
//   }

//   void dispose() {
//     // Clean up the controller when the widget is disposed.

//     _emailIdController.dispose();
//     _phoneController.dispose();

//     _firstNameController.dispose();

//     _lastNameController.dispose();

//     super.dispose();
//   }

//   bool kycLoading = true;

//   String? validateEmail(String? value) {
//     String pattern =
//         r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//         r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
//         r"{0,253}[a-zA-Z0-9])?)*$";
//     RegExp regex = new RegExp(pattern);
//     if (!regex.hasMatch(value!))
//       return 'Enter a valid email address';
//     else
//       return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: tWhite,
//           centerTitle: true,
//           elevation: 0,
//           // title: Text("Profile"),
//           // actions: [
//           //   Padding(
//           //       padding: EdgeInsets.all(15),
//           //       child: Image.asset("assets/icons/appbar_notification.png"))
//           // ],
//           leading: IconButton(
//               onPressed: () {
//                 Twl.navigateBack(context);
//               },
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.orange,
//               )),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30,vertical:60),
//           child: Column(
//             children: [
//               Center(
//                 child: Card(
                  
//                     elevation: 1,
//                     color:tlightGrayblue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Container(
//                       height: 300,
//                       width: double.infinity,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 10),
//                         child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Column(children: [
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 Text(
//                                   "You must have an account to use this feature", style: TextStyle(
//                                                   color: tBlack,
//                                                   fontSize: 14.sp),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ]),
//                               Column(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {},
//                                     child: Container(
//                                       width: 150,
//                                       height: 40,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         color: tPrimaryColor,
//                                       ),
//                                       child: Center(
//                                           child: Text('Login',
//                                               style: TextStyle(
//                                                   color: tBlack,
//                                                   fontSize: 13.sp))),
//                                     ),
//                                   ),SizedBox(height:10),
//                                   GestureDetector(
//                                     onTap: () {
//                                       Twl.navigateTo(context, HomeAddress());
//                                     },
//                                     child: Container(
//                                       width: 150,
//                                       height: 40,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           color: tPrimaryColor),
//                                       child: Center(
//                                           child: Text('Sign Up',
//                                               style: TextStyle(
//                                                   color: tBlack,
//                                                   fontSize: 13.sp))),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ]),
//                       ),
//                     )),
//               ),
//             ],
//           ),
//         ));
//   }
// }
