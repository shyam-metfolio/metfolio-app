import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../responsive.dart';
import '../Splash2/Splash2.dart';
// import '../DigitCode/DigitCode.dart';

class MobileNumber extends StatefulWidget {
  const MobileNumber({Key? key}) : super(key: key);

  @override
  State<MobileNumber> createState() => _MobileNumberState();
}

class _MobileNumberState extends State<MobileNumber> {
  String dropdownValue = '+44';
  // GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  // final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userLatNameController = TextEditingController();
  // final TextEditingController _userEmailController = TextEditingController();
  // final TextEditingController _userDateofBirthController =
  //     TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: tWhite,
        //   centerTitle: true,
        //   elevation: 0,
        //   // title: Text("Profile"),
        //   // actions: [
        //   //   Padding(
        //   //       padding: EdgeInsets.all(15),
        //   //       child: Image.asset("assets/icons/appbar_notification.png"))
        //   // ],
        //   leading: IconButton(
        //       onPressed: () {
        //         Twl.navigateBack(context);
        //       },
        //       icon: Icon(Icons.arrow_back_ios, color: tPrimaryColor)),
        // ),
        body: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 2, right: 20, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  Twl.navigateTo(context, MyHomePage());
                  // Twl.navigateBack(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: tPrimaryColor)),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mobile Number",
                          style: TextStyle(
                              color: tPrimaryColor,
                              fontFamily: 'Signika',
                              fontSize: isTab(context) ? 21.sp : 22.sp,
                              fontWeight: FontWeight.w700)),
                      SizedBox(height: 20),
                      Text(
                        "We may store and send a verification code to this number",
                        style: TextStyle(
                          fontFamily: 'Signika',
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 30),

                      // SizedBox(
                      //   height: tDefaultPadding * 2,
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: tlightGrayblue),
                            child: DropdownButton<String>(
                              value: dropdownValue,
                              items: <String>[
                                "+91",
                                "+44",
                                "+90",
                                "+21"
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 15
                                        // 16.sp
                                        ),
                                  ),
                                );
                              }).toList(),
                              underline: Container(color: tTextformfieldColor),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "number should be entered";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: _userLatNameController,
                                  //_phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(11)
                                  ],
                                  style: TextStyle(fontSize: 15),
                                  // isTab(context) ? 10.sp : 14.sp
                                  decoration: InputDecoration(
                                    // prefix: Text('+91 ',style: TextStyle(color: tBlack),),

                                    hintStyle: TextStyle(fontSize: 15
                                        // isTab(context) ? 10.sp : 14.sp
                                        ),
                                    // hintText: 'Enter Your Mobile Number',
                                    fillColor: tlightGrayblue,
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

                                    // border: OutlineInputBorder(

                                    //   borderRadius: BorderRadius.all(
                                    //     Radius.circular(10.0),
                                    //   ),
                                    // ),

                                    // enabledBorder: OutlineInputBorder(
                                    //     borderSide: BorderSide(color: tlightGray, width: 1.5),
                                    //     borderRadius: BorderRadius.circular(10)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Twl.navigateTo(
                  //   context,
                  //   DigitCode(),
                  // );
                }
              },
              child: Center(
                child: Container(
                  // width: 200,
                  width: 82.w,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: tPrimaryColor),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: tSecondaryColor,
                        fontFamily: 'Signika',
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
