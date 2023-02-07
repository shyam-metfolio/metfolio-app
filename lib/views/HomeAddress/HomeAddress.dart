// ignore_for_file: unused_field

import 'dart:async';

import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/HomeAddress/manualAddress.dart';
import 'package:base_project_flutter/views/listAddress/listAddress.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';

import '../bottomNavigation.dart/bottomNavigation.dart';
import '../selectandupdatedocPage/selectandUpdate.dart';

class HomeAddress extends StatefulWidget {
  const HomeAddress(
      {Key? key,
      // this.firstName,
      // this.dob,
      // this.lastName,
      // this.email,
      required this.isLoginFlow,
      this.firstName,
      this.goldtype,
      this.qty})
      : super(key: key);
  final firstName;
  final goldtype;
  // final lastName;
  final qty;
  final bool isLoginFlow;

  @override
  State<HomeAddress> createState() => _HomeAddressState();
}

class _HomeAddressState extends State<HomeAddress> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();

  String _platformVersion = 'Unknown';
  String _sessionResult = 'Not started';
  String _sessionError = 'None';
  late TextEditingController _sessionURLController;
  late TextEditingController _localeController;
  bool _isBrandingOn = true;
  bool _useCustomIntro = true;

  @override
  void initState() {
    super.initState();
    _sessionURLController = TextEditingController();
    _localeController = TextEditingController();
    initPlatformState();
    setState(() {
      _sessionURLController
        ..text =
            "https://alchemy.veriff.com/v/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uX2lkIjoiNzE3ODMyMDQtNTA3NS00YzQ2LWJmOWItYzVjMDY1NjBiZTIzIiwiaWF0IjoxNjU5NTk2NjQ1fQ.m9QX4mkCYeAmmgZlamvpnJ_lMGT3Fem7U5oakwvxIws";
    });
  }

  @override
  void dispose() {
    _sessionURLController.dispose();
    _localeController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Veriff().platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Configuration setupConfiguration(url) {
    Configuration config = Configuration(url);
    config.useCustomIntroScreen = true;
    AssetImage logo = AssetImage('assets/icons/Splash1.png');
    if (_isBrandingOn) {
      Branding branding = Branding(
        themeColor: "#E5B02C",
        backgroundColor: "#ffffff",
        statusBarColor: "#ffffff",
        primaryTextColor: "#E5B02C",
        secondaryTextColor: "#1E365B",
        primaryButtonBackgroundColor: "#1E365B",
        buttonCornerRadius: 20,
        // logo: logo,
        androidNotificationIcon: "ic_notification",
      );
      config.branding = branding;
    }
    if (_localeController.text.length != 0) {
      config.languageLocale = _localeController.text;
    }
    if (_useCustomIntro) {
      config.useCustomIntroScreen = _useCustomIntro;
      print('Custom intro set to: $_useCustomIntro');
    }
    return config;
  }

  x() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // SharedPreferences sharedPreferences =
      //     await SharedPreferences.getInstance();
      // setState(() {
      //   sharedPreferences.setString(
      //       'firstName', widget.firstName);
      //   sharedPreferences.setString(
      //       'lastName', widget.lastName);
      //   sharedPreferences.setString(
      //       'email', widget.email);
      //   sharedPreferences.setString('dob', widget.dob);
      // });

      loader(true);
      var pincode;
      var address;
      setState(() {
        pincode = _postCodeController.text;
        address = _addressController.text;
      });
      print(pincode);
      print(address);
      Twl.navigateTo(
          context,
          ListAddress(
            postalcode: pincode,
            goldtype: widget.goldtype,
            // final lastName;
            qty: widget.qty,
            isLoginFlow: widget.isLoginFlow,
          ));
      // var signUpRes = await UserAPI().updateProfile(
      //     context,
      //     widget.firstName,
      //     widget.lastName,
      //     widget.email,
      //     widget.dob,
      //     pincode,
      //     address);
      // print(signUpRes);

      // if (signUpRes['status'] == 'OK' &&
      //     signUpRes != null) {
      //   var number;
      loader(false);
      //   setState(() {
      //     number = signUpRes['details']['contact_no']
      //         .toString();
      //   });
      //   print('verffi api>>>>>>>>>>>>');
      //   var veriffiRes = await UserAPI().veriff(context,
      //       widget.firstName, widget.lastName, number);
      //   if (veriffiRes['status'] == 'OK' &&
      //       veriffiRes != null) {
      //     var url;
      //     setState(() {
      //       url = veriffiRes['details']['url'];
      //     });
      //     print(url);
      //     var res = await _startVeriffFlow(context, url);
      //     print(res);
      //     // if(res == st){

      //     // }
      //   } else {
      //     stopLoading();
      //     Twl.createAlert(
      //         context, 'error', veriffiRes['error']);
      //   }
      // } else {
      //   stopLoading();
      //   Twl.createAlert(
      //       context, 'error', signUpRes['error']);
      // }

      // Twl.navigateTo(context, SelectAndUpdate());
    }

    // if (_formKey.currentState!.validate()) {
    //   Twl.navigateTo(context, OtpPage());

    // var res =await  UserAPI.sendOtp(context,_userNameController.text);
    // if (res != null && res['status'] == 'OK'){ Twl.navigateTo(context, OtpPage());}
  }

  // Future<void>
  _startVeriffFlow(context, url, sessionId) async {
    if (_sessionURLController.text == null) {
      print("You must enter a session URL!");
      return;
    }
    Veriff veriff = Veriff();
    Configuration config = setupConfiguration(url);

    try {
      Result result = await veriff.start(config);
      print("================= Result from Veriff SDK ================\n");
      setState(() {
        _sessionResult = result.status.toString();
        _sessionError = result.error.toString();
      });
      var resVerffiCallback = await UserAPI()
          .veriffCallBack(context, result.status.toString(), sessionId);
      print('resVerffiCallback');
      print(resVerffiCallback);
      switch (result.status) {
        case Status.done:
          print("Session is completed.");
          if (resVerffiCallback != null &&
              resVerffiCallback['status'] == 'OK' &&
              (resVerffiCallback['veriff_status'] == true ||
                  resVerffiCallback['veriff_status'] == 'true')) {
            return Twl.navigateTo(context, BottomNavigation());
          } else {
            // return Twl.createAlert(
            //     context, "error", resVerffiCallback['error']);
          }
          break;
        case Status.canceled:
          print("Session is canceled by the user.");
          // return Twl.createAlert(
          //     context, 'error', 'Session is canceled by the user.');
          break;
        case Status.error:
          switch (result.error) {
            case Error.cameraUnavailable:
              print("User did not give permission for the camera");
              // return Twl.createAlert(context, 'error',
              //     'User did not give permission for the camera.');
              break;
            case Error.microphoneUnavailable:
              print("User did not give permission for the microphone.");
              break;
            case Error.networkError:
              print("Network error occurred.");
              // return Twl.createAlert(
              //     context, 'error', 'Network error occurred.');
              break;
            case Error.sessionError:
              print("A local error happened before submitting the session.");
              // return Twl.createAlert(context, 'error',
              //     'A local error happened before submitting the session.');
              break;
            case Error.deprecatedSDKVersion:
              print(
                  "Version of Veriff SDK used in plugin has been deprecated. Please update to the latest version.");
              // return Twl.createAlert(context, 'error',
              //     'Version of Veriff SDK used in plugin has been deprecated. Please update to the latest version.');
              break;
            case Error.unknown:
              print("Uknown error occurred.");
              // return Twl.createAlert(
              //     context, 'error', 'Uknown error occurred.');
              break;
            case Error.nfcError:
              print("Error with NFC");
              // return Twl.createAlert(context, 'error', 'Error with NFC');
              break;
            case Error.setupError:
              print("Error with setup");
              // return Twl.createAlert(context, 'error', 'Error with setup');
              break;
            case Error.none:
              print("No error.");
              // return Twl.createAlert(context, 'error', 'No error.');
              break;
            default:
              break;
          }
          break;
        default:
          break;
      }
      print("==========================================================\n");
      return result.status;
    } on PlatformException {
      //log this
    }
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  bool loadingPaymentStatus = false;
  loader(value) {
    setState(() {
      loadingPaymentStatus = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.willpopAlert(context);
      },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: tWhite,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: tWhite,
                leading: GestureDetector(
                  onTap: () {
                    if (widget.isLoginFlow) {
                      Twl.willpopAlert(context);
                    } else {
                      Twl.navigateBack(context);
                    }
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
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Postcode",
                                  style: TextStyle(
                                      color: tPrimaryColor,
                                      fontSize: isTab(context) ? 18.sp : 21.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Signika'),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Please enter your postcode',
                                  style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 9.sp : 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  'Post Code*',
                                  style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: isTab(context) ? 9.sp : 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Padding(
                                  padding: EdgeInsets.only(right: 15.w),
                                  child: TwlNormalTextField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    controller: _postCodeController,
                                    validator: postCodeValidator,
                                    // textInputType: TextInputType.number,
                                    // inputForamtters: [
                                    //   LengthLimitingTextInputFormatter(6)
                                    // ],
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                // Text(
                                //   'Address line 1*',
                                //   style: TextStyle(
                                //     color: tSecondaryColor,
                                //     fontSize: isTab(context) ? 9.sp : 12.sp,
                                //     fontWeight: FontWeight.w400,
                                //   ),
                                // ),
                                // SizedBox(height: 1.h),
                                // Padding(
                                //   padding: EdgeInsets.only(right: 15.w),
                                //   child: TwlNormalTextField(
                                //     controller: _addressController,
                                //     validator: adressValidator,
                                //     textInputType: TextInputType.streetAddress,
                                //   ),
                                // ),
                                // SizedBox(height: 10),
                                // GestureDetector(
                                //   onTap: () {
                                //     Twl.navigateTo(
                                //         context,
                                //         ManualAddress(
                                //          dob: widget.dob,
                                //          firstName: widget.firstName,
                                //          email: widget.email,
                                //          lastName: widget.email,
                                //         ));
                                //   },
                                //   child: Text(
                                //     'Or enter address manually',
                                //     style: TextStyle(
                                //       color: tSecondaryColor,
                                //       fontSize: isTab(context) ? 9.sp : 12.sp,
                                //       fontWeight: FontWeight.w400,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Container(
                            height: 40,
                            width: 230,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: tPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                ),
                                child: Text('Continue',
                                    style: TextStyle(
                                      color: tBlue,
                                    )),
                                onPressed: x
                                // stopLoading();
                                // }
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                      ],
                    ),
                  ),
                ),
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
    );
  }

  String? postCodeValidator(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
      // return "PostCode can't be empty";
    }
    return null;
  }

  String? adressValidator(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
      // return "Address can't be empty";
    }
    return null;
  }
}
