import 'dart:io';
import 'dart:math';

import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/extra2.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/views/actions/actions.dart';
import 'package:base_project_flutter/views/activity/activity.dart';
import 'package:encrypt/encrypt.dart' as ency;
import 'package:base_project_flutter/views/homePage/homePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import '../../constants/constants.dart';
import '../../constants/imageConstant.dart';
import '../../extra.dart';
import '../../extra3.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../../globalWidgets/button.dart';
import '../../responsive.dart';
import '../keypad/keypad.dart';
import '../otpPage/otpPage.dart';
import '../passCodePage/lockScreen.dart';

class BottomNavigation extends StatefulWidget {
  BottomNavigation(
      {Key? key, this.tabIndexId, this.actionIndex, this.homeindex})
      : super(key: key);
  final actionIndex;
  final tabIndexId;
  final homeindex;
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with WidgetsBindingObserver {
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   checkPasscode();
  //   print('state = $state');
  //   if (state == AppLifecycleState.resumed) {
  //     if (isPasscodeExist) {
  //       Twl.navigateTo(context, LockScreen(navigate: false));
  //     }
  //   }
  // }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void checkBottomIndex() {
    setState(() {
      tabIndexs = widget.tabIndexId != null ? widget.tabIndexId : 0;
    });
  }

  var tabIndexs = 0;
  void _onItemTapped(int index) {
    setState(() {
      tabIndexs = index;
      print(index);
    });
  }

  bool isPasscodeExist = false;

  event() async {
    await FirebaseAnalytics.instance.logBeginCheckout(
        value: 10.0,
        currency: 'USD',
        items: [
          AnalyticsEventItem(
              itemName: 'Socks', itemId: 'xjw73ndnw', price: 10.0),
        ],
        coupon: '10PERCENTOFF');

    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    print("hi: ${sharedPrefs.getString('userName')}");
    print("hi: ${sharedPrefs.getString('email')}");

    Segment.track(
      eventName: 'dashboard_screen',
      properties: {
        "userName": sharedPrefs.getString('userName'),
        "first_name": sharedPrefs.getString('firstName'),
        "email": sharedPrefs.getString('email'),
        "clicked": true
      },
    );

    await FirebaseAnalytics.instance.logEvent(
      name: "user_logged_in",
      parameters: {
        "userName": sharedPrefs.getString('userName'),
        "first_name": sharedPrefs.getString('firstName'),
        "email": sharedPrefs.getString('email'),
      },
    );

    mixpanel.track('dashboard_screen', properties: {
      "userName": sharedPrefs.getString('userName'),
      "first_name": sharedPrefs.getString('firstName'),
      "email": sharedPrefs.getString('email'),
      "clicked": true
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkBottomIndex();
    goldSetting();
    super.initState();
    notificationPermission();
    final facebookAppEvents = FacebookAppEvents();
    facebookAppEvents.setAdvertiserTracking(enabled: true);
    facebookAppEvents.setAutoLogAppEventsEnabled(true);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        if (message.data['type'] == 'news') {
          print('onMessageOpenedApp --1');

          // setState(() {
          //   Twl.navigateTo(context,
          //       OrderTrackingScreen(myOrderId: message.data['order_id']));
          // });
          // showBarModalBottomSheet(
          //     expand: true,
          //     context: context,
          //     backgroundColor: Colors.transparent,
          //     builder: (context) => Container(
          //             // height: MediaQuery.of(context).size.height * 0.90,
          //             child: NotificationNewsDetails(
          //           authCode: authCode,
          //           newsId: message.data['newsId'].toString(),
          //         ))
          //     //NewsDetails(news: widget.news, authCode: widget.authCode)),
          //     );
        } else {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => MyNavigationBar()));
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        // addNotification(message.notification.title, message.notification.body,
        //     message.notification.android.imageUrl);
        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                // channel!.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));

        print('Message data: ${message.data}');
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
          print('onMessageOpenedApp --2');

          // setState(() {
          //   Twl.navigateTo(context,
          //       OrderTrackingScreen(myOrderId: message.data['order_id']));
          // });
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

      print(message.data['type'].toString());
      print(message.data);
      print(message.data['type'].toString() == "1");
      if (message.data['type'].toString() == "1") {
        print('onMessageOpenedApp --3');
        // setState(() {
        //   Twl.navigateTo(context,
        //       OrderTrackingScreen(myOrderId: message.data['order_id']));
        // });
      } else {
        // Get.to(StoreviewPage(storeId: message.data['store_id']));

        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => NotificationPage()));
      }
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => NotificationPage()));
    });

    event();
  }

  // @override
  // void didChangeDependencies() {
  //   advancedStatusCheck();
  //   super.didChangeDependencies();
  // }

  notificationPermission() async {
    // ignore: unused_local_variable
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  // advancedStatusCheck() async {
  //   print("status.localVersion>?>????????????????????????");
  //   final newVersion = NewVersion(
  //     iOSId: 'com.metfolio.app',
  //     androidId: 'com.metfolio.app',
  //   );
  //   try {
  //     final status = await newVersion.getVersionStatus();

  //     print('status.localVersion' + status!.releaseNotes.toString());
  //     print('status.localVersion' + status.appStoreLink);
  //     print('status.localVersion' + status.localVersion);
  //     print('status.localVersion' + status.storeVersion);
  //     print('status.localVersion' + status.canUpdate.toString());
  //     // print(double.parse(status.localVersion).toDouble() <
  //     //     double.parse(status.storeVersion).toDouble());
  //     print('statusdmcvkdmcd');
  //     if (status != null &&
  //         (double.parse(status.localVersion).toDouble() <
  //             double.parse(status.storeVersion).toDouble())) {
  //       print(status.releaseNotes);
  //       print(status.appStoreLink);
  //       print(status.localVersion);
  //       print(status.storeVersion);
  //       print(status.canUpdate.toString());
  //       print('statusdmcvkdmcd');
  //       newVersion.showUpdateDialog(
  //         context: context,
  //         versionStatus: status,
  //         dialogTitle: 'Update!!',
  //         dialogText: 'Please Update the app from' +
  //             status.localVersion +
  //             ' to ' +
  //             status.storeVersion,
  //         dismissButtonText: 'skip',
  //         dismissAction: () {
  //           SystemNavigator.pop();
  //         },
  //         updateButtonText: 'Update',
  //       );
  //     }
  //   } catch (e) {
  //     Twl.createAlert(context, "error", e.toString());
  //   }
  // }

  onNavigate(int index) {}
  goldSetting() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var res = await UserAPI().goldSetting(context);
    if (res != null && res['status'] == 'OK') {
      setState(() {
        sharedPreferences.setString(
            'minting', res['details']['WebSetting'][0]['value']);
        sharedPreferences.setString(
            'volatility', res['details']['WebSetting'][1]['value']);
        print("minting" +
            ' ' +
            sharedPreferences.getString('minting').toString());
        print("volatility" +
            ' ' +
            sharedPreferences.getString('volatility').toString());
      });
    }
  }

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
      child: Scaffold(
        body: UpgradeAlert(
          upgrader: Upgrader(
              dialogStyle: Platform.isIOS
                  ? UpgradeDialogStyle.cupertino
                  : UpgradeDialogStyle.material),
          child: Stack(
            children: [
              // DrawerList(),
              IndexedStack(
                index: tabIndexs,
                children: [
                  HomePage(
                    naviagte: _onItemTapped,
                    homeindex: widget.homeindex ?? 0,
                  ),
                  /*    ActionsPage(
                    actionIndex: widget.actionIndex,
                    laoder: loader,
                  ),*/
                  Extra2(),
                  // ApplePayScreen(),
                  // GooglePayScreen(),
                  // CustomCardPaymentScreen(),
                  // StripePayment(),
                  // ExistingCardsPage(),
                  // PaymentMethodPage(),
                  // LockScreen(),
                  // ConfirmYourPassCode(),
                  // PaymentListCards(),
                  // PaymentBankLists(),
                  // PaymentCardDetails(),
                  // DePositBankList(),
                  // AccountExists(),
                  // ChangedPasscode(),
                  // NotificationPage(),

                  Activity(headHide: false),
                  //Extra2()
                ],
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: tSecondaryColor,
          selectedItemColor: tSecondaryColor,
          onTap: _onItemTapped,
          currentIndex: tabIndexs,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          // iconSize: isTab(context) ? 40 : 30,
          type: BottomNavigationBarType.fixed,
          backgroundColor: tContainerColor,
          elevation: 0,
          items: [
            _bottomNavigationBarItem(
              icon: Image.asset(
                BottomNavigationImages.HOME,
                height: 3.5.h,
              ),
              label: 'Home',
            ),
            _bottomNavigationBarItem(
              icon: Image.asset(
                BottomNavigationImages.ACTIONS,
                height: 4.h,
              ),
              label: 'Invest',
            ),
            _bottomNavigationBarItem(
              icon: Image.asset(
                BottomNavigationImages.ACTIVITY,
                height: 3.5.h,
              ),
              label: 'Activity',
            ),
            /*  _bottomNavigationBarItem(
              icon: Image.asset(
                BottomNavigationImages.HOME,
                height: 3.5.h,
              ),
              label: 'Extra',
            ),*/
          ],
        ),
      ),
    );
  }

  _bottomNavigationBarItem({required icon, required String label}) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({
    Key? key,
    this.child,
  });
  final child;

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  bool isPasscodeExist = false;
  checkPasscode() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var userId = sharedPrefs.getString('userId');
    await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId.toString())
        .get()
        .then((QuerySnapshot snapshot) async {
      print("isPasscodeExist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      // print(userData.data()?['userId']);
      if (snapshot.docs.length > 0) {
        if (snapshot.docs[0].data() != null) {
          setState(() {
            isPasscodeExist = true;
          });
        }
        print("passcode exit");
        print(isPasscodeExist);
        // print(snapshot.docs[0].data());
      } else {
        print("passcode NOT exit");
        setState(() {
          isPasscodeExist = false;
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    checkPasscode();
  }

  bool isLoading = false;
  loader(value) {
    setState(() {
      isLoading = value;
    });
  }

  var btnColor = tIndicatorColor;
  var selectedvalue;
  var passcodeError = '';
  String currentText = "";

  late String displayCode;
  TextEditingController pinController1 = TextEditingController();
  void showInSnackBar(String value) {
    print('error' + value);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(new SnackBar(content: new Text(value)));
  }

  getNextCode() {
    pinController1.text = '';
    var rng = new Random();
    var code = (rng.nextInt(9000) + 1000).toString();
    print('Random No is : $code');
    return code;
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getPasscode(enteredPasscode) async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    var authCode = sharedPrefs.getString('authCode');
    var userId = sharedPrefs.getString('userId');
    print('check passcode');
    var collectionReference = _firestore.collection('users');
    await FirebaseFirestore.instance
        .collection('users')
        .where('userId', isEqualTo: userId.toString())
        .get()
        .then((QuerySnapshot snapshot) async {
      print("isPasscodeExist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      // print(userData.data()?['userId']);
      if (snapshot.docs.length > 0) {
        if (snapshot.docs[0].data() != null) {
          var details = snapshot.docs[0].data();
          print(snapshot.docs[0].data());
          print(snapshot.docs[0]['userId']);
          print(snapshot.docs[0]['passcode']);
          print("passcode>>>2");
          print(snapshot.docs[0]['passcode']);
          final iv = ency.IV.fromLength(16);
          final key = ency.Key.fromUtf8('my 32 length key................');
          final encrypter = ency.Encrypter(ency.AES(key));

          // final decrypted = encrypter.decrypt(userData.data()!['passcode'], iv: iv);
          final decrypted = encrypter.decrypt(
              ency.Encrypted.from64(snapshot.docs[0]['passcode']),
              iv: iv);
          print(decrypted);
          var attempts = sharedPrefs.getInt("passcodeAttempts");
          print(attempts);
          if ((attempts ?? 0) <= 3) {
            if (enteredPasscode == decrypted) {
              setState(() {
                passcodeError = '';
              });
              loader(false);
              setState(() {
                isPasscodeExist = false;
              });
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text('your passcode verified'),
              // ));
            } else {
              loader(false);

              setState(() {
                passcodeError = 'Incorrect passcode';

                if (sharedPrefs.getInt("passcodeAttempts") != null) {
                  sharedPrefs.setInt("passcodeAttempts", ((attempts ?? 0) + 1));
                } else {
                  sharedPrefs.setInt("passcodeAttempts", 1);
                }
                print(sharedPrefs.getInt("passcodeAttempts"));
                // sharedPrefs.setInt("passcodeAttempts", 1);
              });

              // WidgetsBinding.instance!.addPostFrameCallback((_) async {
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text('Enter a valid passcode'),
              //   ));
              // });
            }
          } else {
            loader(false);
            Twl.navigateTo(
                context,
                PassCodeOtp(
                  isDisableBack: true,
                ));
          }
        }
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isPasscodeExist == true) {
      return WillPopScope(
        onWillPop: () {
          return Twl.willpopAlert(context);
        },
        child: Stack(
          children: [
            SafeArea(
              child: Scaffold(
                  backgroundColor: tWhite,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: tWhite,
                    leading: GestureDetector(
                      // change the back button shadow
                      onTap: () {
                        Twl.willpopAlert(context);
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
                  body: SingleChildScrollView(
                    child: Builder(
                      builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "Passcode lock",
                                style: TextStyle(
                                    fontFamily: 'signika',
                                    color: tPrimaryColor,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500
                                    // fontFamily: AppTextStyle.robotoBold
                                    ),
                              ),
                            ),
                            SizedBox(height: 60),
                            Center(
                              child: Text(
                                "Enter your passcode",
                                style: TextStyle(
                                    color: tSecondaryColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600
                                    // fontFamily: AppTextStyle.robotoBold
                                    ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 70,
                              ),
                              child: PinCodeTextField(
                                textInputAction: TextInputAction.previous,
                                //backgroundColor: Colors.white,
                                appContext: context,

                                pastedTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 4,
                                obscureText: true,
                                // obscuringCharacter: '*',

                                // blinkWhenObscuring: true,
                                animationType: AnimationType.fade,
                                // validator: (v) {
                                //   if (v!.length < 4 || v.length == 0) {
                                //     return "passcode length did not match";
                                //   } else {
                                //     return null;
                                //   }
                                // },
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  activeColor: tlightGrayblue,
                                  selectedColor: tlightGrayblue,
                                  selectedFillColor: tlightGrayblue,
                                  inactiveFillColor: tlightGrayblue,
                                  inactiveColor: tlightGrayblue,
                                  borderRadius: BorderRadius.circular(12),
                                  borderWidth: 1,
                                  fieldHeight: isTab(context) ? 10.w : 13.w,
                                  fieldWidth: isTab(context) ? 10.w : 12.w,
                                  activeFillColor: tlightGrayblue,
                                ),
                                cursorColor: Colors.black,
                                animationDuration: Duration(milliseconds: 300),
                                enableActiveFill: true,
                                //errorAnimationController: errorController,
                                controller: pinController1,
                                keyboardType: TextInputType.none,
                                // boxShadows: [tBoxShadow],
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                onTap: () {
                                  print("Pressed");
                                },
                                onChanged: (value) {
                                  print(value);
                                  setState(() {
                                    currentText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");

                                  return true;
                                },
                              ),
                            ),
                            // Center(
                            //     child: Text(
                            //   passcodeError,
                            //   style: TextStyle(color: Colors.red),
                            // )),
                            KeyPad(
                              pinController: pinController1,
                              isPinLogin: true,
                              onChange: (String pin) {
                                pinController1.text = pin;
                                print('${pinController1.text}');
                                setState(() {});
                              },
                              onSubmit: (String pin) {
                                if (pin.length != 4) {
                                  (pin.length == 0)
                                      ? showInSnackBar('Please Enter Pin')
                                      : showInSnackBar('Wrong Pin');
                                  return;
                                } else {
                                  pinController1.text = pin;

                                  if (pinController1.text == displayCode) {
                                    showInSnackBar('Pin Match');
                                    setState(() {
                                      displayCode = getNextCode();
                                    });
                                  } else {
                                    showInSnackBar('Wrong pin');
                                  }
                                  print('Pin is ${pinController1.text}');
                                }
                              },
                            ),
                            // Passcode(
                            //   pinController: pinController1,
                            //   isPinLogin: false,
                            //   onChange: (String pin) {
                            //     pinController1.text = pin;
                            //     print('${pinController1.text}');
                            //     setState(() {});
                            //   },
                            //   onSubmit: (String pin) {
                            //     if (pin.length != 4) {
                            //       (pin.length == 0)
                            //           ? showInSnackBar('Please Enter Pin')
                            //           : showInSnackBar('Wrong Pin');
                            //       return;
                            //     } else {
                            //       pinController1.text = pin;

                            //       if (pinController1.text == displayCode) {
                            //         showInSnackBar('Pin Match');
                            //         setState(() {
                            //           displayCode = getNextCode();
                            //         });
                            //       } else {
                            //         showInSnackBar('Wrong pin');
                            //       }
                            //       print('Pin is ${pinController1.text}');
                            //     }
                            //   },
                            // )s
                            SizedBox(height: 60),
                            GestureDetector(
                              onTap: () {
                                Twl.navigateTo(context, PassCodeOtp());
                              },
                              child: Center(
                                child: Text(
                                  "Forgot Passcode?",
                                  style: TextStyle(
                                      color: tSecondaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 2.h),
                              child: Align(
                                alignment: Alignment.center,
                                child: Button(
                                  borderSide: BorderSide.none,
                                  color: tPrimaryColor,
                                  textcolor: tWhite,
                                  bottonText: 'Continue',
                                  onTap: (startLoading, stopLoading,
                                      btnState) async {
                                    loader(true);
                                    getPasscode(pinController1.text);
                                    // if (_formKey.currentState!.validate()) {

                                    // }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            ),
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
    } else {
      return widget.child;
    }
  }
}
