// ignore_for_file: unused_field

import 'dart:async';

import 'package:base_project_flutter/globalWidgets/twlTextField.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/veriffPage/veriffPage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../extra.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';

import '../bottomNavigation.dart/bottomNavigation.dart';
import '../listAddress/confirmAddress.dart';
import '../loginPassCodePages/createYourPasscode.dart';
import '../selectandupdatedocPage/selectandUpdate.dart';

class ManualAddress extends StatefulWidget {
  const ManualAddress(
      {Key? key, this.address, this.postalCode, required this.isLoginFlow})
      : super(key: key);
  // final firstName;
  // final dob;this.firstName, this.dob, this.lastName, this.email,
  // final lastName;
  // final email;
  final address;
  final postalCode;
  final bool isLoginFlow;

  @override
  State<ManualAddress> createState() => _ManualAddressState();
}

class _ManualAddressState extends State<ManualAddress> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
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

    getAddressDetails();
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

  getAddressDetails() {
    if (widget.address != null) {
      setState(() {
        print("addressss");
        _addressController..text = widget.address['line_1'];
        _cityController..text = widget.address['town_or_city'];
        _postCodeController..text = widget.postalCode['postcode'];
      });
    }
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

  checkVeriffStatus(status, url, sessionId) {
    switch (status) {
      case 'approved':
        return Twl.navigateTo(
            context,
            CreateYourPassCode(
              loginFlow: true,
            ));
      case 'resubmission_requested':
        return Twl.navigateTo(
            context,
            VeriffiPage(
              sessionUrl: null,
              sessionId: null,
            ));
      // break;
      case 'declined':
        return Twl.navigateTo(
            context,
            VeriffiPage(
              sessionUrl: null,
              sessionId: null,
            ));
      // break;
      case 'expired':
        return Twl.navigateTo(
            context,
            VeriffiPage(
              sessionUrl: null,
              sessionId: null,
            ));
      // break;
      case 'abandoned':
        return Twl.navigateTo(
            context,
            VeriffiPage(
              sessionUrl: null,
              sessionId: null,
            ));
      // break;
      case 'process':
        return Twl.navigateTo(
            context,
            VeriffStatusCheck(
              sessionId: sessionId,
              status: status,
            ));
      default:
    }
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
      startLoader(false);
      switch (result.status) {
        case Status.done:
          print("Session is completed.");
          if (resVerffiCallback != null &&
              resVerffiCallback['status'] == 'OK' &&
              (resVerffiCallback['veriff_status'] == true ||
                  resVerffiCallback['veriff_status'] == 'true')) {
            // checkVeriffStatus(
            //     resVerffiCallback['details']['status'], url, sessionId);
            return Twl.navigateTo(
                context,
                CreateYourPassCode(
                  loginFlow: true,
                ));
            // return Twl.navigateTo(context, BottomNavigation());
          } else {
            checkVeriffStatus(resVerffiCallback['error'], url, sessionId);
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

  bool loading = false;

  startLoader(value) {
    setState(() {
      loading = value;
    });
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;

  x() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      startLoader(true);
      //startLoading();
      // var pincode;
      // var address;
      // setState(() {
      //   pincode = _postCodeController.text;
      //   address = _addressController.text;
      // });
      // print(pincode);
      // print(address);
      var firstName;
      var lastName;
      var emailId;
      var dob;
      print(firstName);
      print(lastName);
      print(emailId);
      print(dob);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      setState(() {
        firstName = sharedPreferences.getString('firstName');
        lastName = sharedPreferences.getString('lastName');
        emailId = sharedPreferences.getString('email');
        dob = sharedPreferences.getString('dob');
      });
      print(firstName);
      print(lastName);
      print(emailId);
      print(dob);
      // var signUpRes = await UserAPI().updateProfile(
      //   context,
      //   firstName,
      //   lastName,
      //   emailId,
      //   dob,
      //   // pincode,
      //   // address
      // );
      // print(signUpRes);

      // if (signUpRes['status'] == 'OK' &&
      //     signUpRes != null) {
      var address1 = _addressController.text;
      var address2 = _address2Controller.text;
      var postalCode = _postCodeController.text;
      var city = _cityController.text;
      var lat;
      // = widget.postalCode['latitude'];
      var lng;
      // = widget.postalCode['longitude'];

      setState(() {
        if (widget.postalCode != null) {
          lat = widget.postalCode['latitude'];
          lng = widget.postalCode['longitude'];
        } else {
          lat = 0;
          lng = 0;
        }
      });
      var addressRes = await UserAPI().addAddress(
          context,
          address1,
          '',
          // address2,
          postalCode,
          city,
          lat.toString(),
          lng.toString(),
          '');

      if (addressRes != null && addressRes['status'] == 'OK') {
        var number;

        setState(() {
          number = sharedPreferences.getString("userName");
          // signUpRes['details']['contact_no']
          //     .toString();
        });
        if (widget.isLoginFlow == true) {
          /* print('verffi api>>>>>>>>>>>>');
          var veriffiRes =
              await UserAPI().veriff(context, firstName, lastName, number);
          if (veriffiRes['status'] == 'OK' && veriffiRes != null) {
            var url;
            setState(() {
              url = veriffiRes['details']['url'];
            });
            print(url);
            var res = await _startVeriffFlow(
                context, url, veriffiRes['details']['id']);
            print(res);
            // if(res == st){

            // }
          } else {
            startLoader(false);

            // Twl.createAlert(context, 'error',
            //     veriffiRes['error']);
          }*/
          Twl.navigateTo(context, Extra());
        } else {
          startLoader(false);
          Twl.navigateTo(context, BottomNavigation());

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          Segment.identify(traits: {
            'email': sharedPreferences.getString('email'),
            'streetAddress': _addressController.text,
            'city': _cityController.text,
            'postalCode': _postCodeController.text,
          });

          await FirebaseAnalytics.instance.logEvent(
            name: "address_signup",
            parameters: {
              'streetAddress': _addressController.text,
              'city': _cityController.text,
              'postalCode': _postCodeController.text,
              "button_clicked": true,
            },
          );
        }
      } else {
        startLoader(false);

        // Twl.createAlert(
        //     context, 'error', addressRes['error']);
      }
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
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
                                "Home Address",
                                style: TextStyle(
                                    color: tPrimaryColor,
                                    fontSize: isTab(context) ? 18.sp : 21.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Signika'),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'We require your home address to open your account',
                                style: TextStyle(
                                  color: tSecondaryColor,
                                  fontSize: isTab(context) ? 9.sp : 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Address line 1*',
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
                                  controller: _addressController,
                                  // validator: adressValidator,
                                  textInputType: TextInputType.streetAddress,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Address line 2',
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
                                  controller: _address2Controller,
                                  // validator: adressValidator,
                                  textInputType: TextInputType.streetAddress,
                                ),
                              ),
                              SizedBox(height: 2.h),
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
                                  controller: _postCodeController,
                                  validator: postCodeValidator,
                                  // textInputType: TextInputType.number,
                                  inputForamtters: [
                                    // LengthLimitingTextInputFormatter(6)
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'City',
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
                                  controller: _cityController,
                                  validator: cityValidator,
                                  textInputType: TextInputType.streetAddress,
                                ),
                              ),
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

  String? cityValidator(String? value) {
    if (value!.isEmpty || value == '') {
      return "";
      // return "City can't be empty";
    }
    return null;
  }
}
