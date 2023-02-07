import 'dart:async';

import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

import '../../api_services/addressApi.dart';
import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../extra.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../HomeAddress/manualAddress.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../loginPassCodePages/createYourPasscode.dart';
import '../veriffPage/veriffPage.dart';

class ConfirmAddress extends StatefulWidget {
  ConfirmAddress(
      {Key? key,
      this.address,
      this.postalCode,
      required this.isLoginFlow,
      this.goldtype,
      this.qty})
      : super(key: key);
  final address;
  final postalCode;
  final bool isLoginFlow;
  final goldtype;
  final qty;
  @override
  State<ConfirmAddress> createState() => _SearchAddressState();
}

class _SearchAddressState extends State<ConfirmAddress> {
  @override
  void initState() {
    initPlatformState();
    // TODO: implement initState
    super.initState();
  }

  x() async {
    // if (_formKey.currentState!.validate()) {
    // //startLoading();
    startLoader(true);
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
    var address1;
    var address2;
    var postalCode;
    var city;
    var country;
    setState(() {
      address1 = widget.address['line_1'];
      city = widget.address['town_or_city'];
      postalCode = widget.postalCode['postcode'];
      country = widget.address['county'];
    });
    var lat = widget.postalCode['latitude'];
    var lng = widget.postalCode['longitude'];
    var addressRes = await UserAPI().addAddress(context, address1, '',
        postalCode, city, lat.toString(), lng.toString(), country);
    print('addressRes>>>>');
    print(addressRes);
    if (addressRes != null && addressRes['status'] == 'OK') {
      var number;

      setState(() {
        number = sharedPreferences.getString("userName");
        // signUpRes['details']['contact_no']
        //     .toString();
      });
      if (widget.isLoginFlow == true) {
        /*  //  print('verffi api>>>>>>>>>>>>');
        var veriffiRes =
            await UserAPI().veriff(context, firstName, lastName, number);
        print(veriffiRes);
        if (veriffiRes['status'] == 'OK' && veriffiRes != null) {
          var url;
          setState(() {
            url = veriffiRes['details']['url'];
          });
          print(url);
          var res =
              await _startVeriffFlow(context, url, veriffiRes['details']['id']);
          print(res);
          // if(res == st){

          // }
        } else {
          startLoader(false);

          // Twl.createAlert(
          //     context, 'error', veriffiRes['error']);
        }*/

        Twl.navigateTo(context, Extra());
      } else {
        startLoader(false);

        // Twl.navigateTo(context, BottomNavigation());
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
    // }
    // Twl.navigateTo(context, ManualAddress(address:widget.address,postalCode:widget.postalCode));
  }

  String _platformVersion = 'Unknown';
  String _sessionResult = 'Not started';
  String _sessionError = 'None';
  late TextEditingController _sessionURLController;
  late TextEditingController _localeController;
  bool _isBrandingOn = true;
  bool _useCustomIntro = true;
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
    // if (_localeController.text.length != 0) {
    //   config.languageLocale = _localeController.text;
    // }
    if (_useCustomIntro) {
      config.useCustomIntroScreen = _useCustomIntro;
      print('Custom intro set to: $_useCustomIntro');
    }
    return config;
  }

  checkVeriffStatus(status, url, sessionId) {
    print(status);
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
    // if (_sessionURLController.text == null) {
    //  return;
    // } print("You must enter a session URL!");

    Veriff veriff = Veriff();
    Configuration config = setupConfiguration(url);

    try {
      Result result = await veriff.start(config);

      print("================= Result from Veriff SDK ================\n");
      print(result.error);
      print(result.status);
      print(result);
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
            body: WillPopScope(
              onWillPop: () {
                return Twl.navigateBack(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 0, bottom: 10),
                child: Column(
                  children: [
                    Text(
                      "Confirm your address",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: tPrimaryColor,
                          fontSize: isTab(context) ? 18.sp : 21.sp,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Signika'),
                    ),
                    SizedBox(height: 2.h),
                    GestureDetector(
                      child: Text(
                        'Please confirm that you live at the address written below',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.address['line_1'],
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.address['town_or_city'],
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.address['county'],
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          widget.postalCode['postcode'],
                          style: TextStyle(
                            color: tSecondaryColor,
                            fontSize: isTab(context) ? 9.sp : 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   widget.address['line_1'] +
                    //       '\n' +
                    //       widget.address['town_or_city'] +
                    //       '\n' +
                    //       widget.address['county'] +
                    //       '\n' +
                    //       widget.postalCode['postcode'],
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     color: tSecondaryColor,
                    //     fontSize: isTab(context) ? 9.sp : 14.sp,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Twl.navigateTo(
                            context,
                            ManualAddress(
                              address: widget.address,
                              postalCode: widget.postalCode,
                              isLoginFlow: widget.isLoginFlow,
                              // dob: widget.dob,
                              // firstName: widget.firstName,
                              // email: widget.email,
                              // lastName: widget.email,
                            ));
                      },
                      child: Text(
                        'Edit Address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tSecondaryColor,
                          fontSize: isTab(context) ? 9.sp : 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                            onPressed: x),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            )),
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

class VeriffStatusCheck extends StatefulWidget {
  const VeriffStatusCheck({Key? key, this.sessionId, this.status})
      : super(key: key);
  final sessionId;
  final status;
  @override
  State<VeriffStatusCheck> createState() => _VeriffStatusCheckState();
}

class _VeriffStatusCheckState extends State<VeriffStatusCheck> {
  bool loading = false;

  startLoader(value) {
    setState(() {
      loading = value;
    });
  }

  Timer? timer;
  @override
  void initState() {
    check();
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => check());
    // TODO: implement initState
    super.initState();
  }

  check() async {
    var resVerffiCallback = await UserAPI()
        .veriffCallBack(context, widget.status, widget.sessionId);
    print('resVerffiCallback');
    print(resVerffiCallback);

    if (resVerffiCallback != null &&
        resVerffiCallback['status'] == 'OK' &&
        (resVerffiCallback['veriff_status'] == true ||
            resVerffiCallback['veriff_status'] == 'true')) {
      // if (resVerffiCallback['details']['status'] == 'approved') {
      startLoader(false);
      // checkVeriffStatus(widget.status, null, null);
      timer?.cancel();
      Twl.navigateTo(
          context,
          CreateYourPassCode(
            loginFlow: true,
          ));
      // } else {
      startLoader(false);
      // }
    } else {
      checkVeriffStatus(resVerffiCallback['error'], null, null);
      print(resVerffiCallback['error']);
      startLoader(false);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Twl.willpopAlert(context);
      },
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: tWhite,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: tWhite,
                automaticallyImplyLeading: false,
                // leading: GestureDetector(
                //   // change the back button shadow
                //   onTap: () {
                //     // Twl.navigateBack(context);
                //   },
                //   child: Padding(
                //     padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                //     child: Container(
                //       decoration: BoxDecoration(
                //           color: tWhite,
                //           borderRadius: BorderRadius.circular(10)),
                //       child: Image.asset(
                //         Images.NAVBACK,
                //         scale: 4,
                //       ),
                //     ),
                //   ),
                // ),
              ),
              body: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer(),
                    Container(
                      width: 80.w,
                      child: Text(
                        'Please wait while we verify your identity',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: tPrimaryColor,
                          fontSize: isTab(context) ? 9.sp : 20.sp,
                          // isTab(context) ? 9.sp : 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: 50.w,
                        decoration: BoxDecoration(
                            color: tTextformfieldColor,
                            borderRadius: BorderRadius.circular(200)),
                        child: Lottie.asset(Loading.PROCESSING)),
                    Spacer(),
                    // Center(
                    //   child: SizedBox(
                    //     width: 60.w,
                    //     child: Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 20),
                    //       child: Align(
                    //         alignment: Alignment.center,
                    //         child: Button(
                    //             borderSide: BorderSide.none,
                    //             color: tPrimaryColor,
                    //             textcolor: tWhite,
                    //             bottonText: 'check',
                    //             onTap:
                    //                 (startLoading, stopLoading, btnState) async {
                    //               startLoader(true);

                    //             }),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Spacer(),
                  ],
                ),
              )),
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
      ),
    );
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

      default:
    }
  }
}
