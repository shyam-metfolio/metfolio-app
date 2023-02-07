import 'package:base_project_flutter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:veriff_flutter/veriff_flutter.dart';

import '../../api_services/userApi.dart';
import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../bottomNavigation.dart/bottomNavigation.dart';
import '../listAddress/confirmAddress.dart';
import '../loginPassCodePages/createYourPasscode.dart';

class VeriffiPage extends StatefulWidget {
  VeriffiPage({Key? key, this.sessionUrl, this.sessionId}) : super(key: key);
  final sessionUrl;
  final sessionId;

  @override
  State<VeriffiPage> createState() => _VeriffiPageState();
}

class _VeriffiPageState extends State<VeriffiPage> {
  @override
  void initState() {
    initPlatformState();
    // startVeriffVerifiaction();
    // TODO: implement initState
    super.initState();
  }

  bool isLoading = false;
  String _platformVersion = 'Unknown';
  String _sessionResult = 'Not started';
  String _sessionError = 'None';
  bool veriifStatusError = false;
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
    switch (status) {
      case 'approved':
        return Twl.navigateTo(
            context,
            CreateYourPassCode(
              loginFlow: true,
            ));
      case 'resubmission_requested':
        setState(() {
          veriifStatusError = true;
        });
        break;
      // break;
      case 'declined':
        setState(() {
          veriifStatusError = true;
        });
        break;

      case 'expired':
        setState(() {
          veriifStatusError = true;
        });
        break;

      case 'abandoned':
        setState(() {
          veriifStatusError = true;
        });
        break;
      case 'process':
        setState(() {
          veriifStatusError = true;
        });
        return Twl.navigateTo(
            context,
            VeriffStatusCheck(
              sessionId: sessionId,
              status: status,
            ));
        break;
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
      setState(() {
        _sessionResult = result.status.toString();
        _sessionError = result.error.toString();
      });
      var resVerffiCallback = await UserAPI()
          .veriffCallBack(context, result.status.toString(), sessionId);
      print('resVerffiCallback');
      print(resVerffiCallback);
      setState(() {
        isLoading = false;
      });
      switch (result.status) {
        case Status.done:
          print("Session is completed.");
          if (resVerffiCallback != null &&
              resVerffiCallback['status'] == 'OK' &&
              (resVerffiCallback['veriff_status'] == true ||
                  resVerffiCallback['veriff_status'] == 'true')) {
            Twl.navigateTo(
                context,
                CreateYourPassCode(
                  loginFlow: true,
                ));
            // checkVeriffStatus(
            //     resVerffiCallback['details']['status'], url, sessionId);
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

  startVeriffVerifiaction() async {
    setState(() {
      isLoading = true;
    });
    var firstName;
    var lastName;
    var emailId;
    var dob;
    var number;
    print(firstName);
    print(lastName);
    print(emailId);
    print(dob);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      number = sharedPreferences.getString("userName");
      firstName = sharedPreferences.getString('firstName');
      lastName = sharedPreferences.getString('lastName');
      emailId = sharedPreferences.getString('email');
      dob = sharedPreferences.getString('dob');
    });
    print(firstName);
    print(lastName);
    print(emailId);
    print(dob);
    print(widget.sessionUrl);
    // if (widget.sessionUrl == null && veriifStatusError == false) {
    var veriffiRes =
        await UserAPI().veriff(context, firstName, lastName, number);
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
      setState(() {
        isLoading = false;
      });
      // Twl.createAlert(context, 'error', veriffiRes['error']);
    }
    // } else {
    //   var res =
    //       await _startVeriffFlow(context, widget.sessionUrl, widget.sessionId);
    //   print(res);
    // }
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
                // leading: GestureDetector(
                //   onTap: () {
                //     // Twl.navigateTo(context, BottomNavigation());
                //   },
                //   child: Image.asset(
                //     Images.NAVBACK,
                //     scale: 4,
                //   ),
                // ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // if (isLoading)
                  //   Center(
                  //       child: CircularProgressIndicator(
                  //     color: tPrimaryColor,
                  //   )),
                  // if (isLoading == false)
                  Container(
                    width: 65.w,
                    child: Text(
                      'We were unable to process your ID. Please check that:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: tPrimaryColor,
                        fontSize: isTab(context) ? 18.sp : 21.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Signika',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      Images.VERIFFRESUBMIT,
                      fit: BoxFit.fill,
                      // scale: 0.5,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                    child: Align(
                      alignment: Alignment.center,
                      child: Button(
                        borderSide: BorderSide.none,
                        color: tPrimaryColor,
                        textcolor: tWhite,
                        bottonText: 'Retake Photo',
                        onTap: (startLoading, stopLoading, btnState) async {
                          //startLoading();
                          await startVeriffVerifiaction();
                          stopLoading();
                        },
                      ),
                    ),
                  ),
                  // Container(),
                ],
              )),
          if (isLoading)
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
}
