import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:base_project_flutter/constants/apiConstants.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/extra.dart';
import 'package:base_project_flutter/provider/actionProvider.dart';
import 'package:base_project_flutter/views/HomeAddress/HomeAddress.dart';
import 'package:base_project_flutter/views/PersonalDetails/PersonalDetails.dart';
import 'package:base_project_flutter/views/Splash2/Splash2.dart';
import 'package:base_project_flutter/views/emailVerification/emailVerifiaction.dart';
import 'package:base_project_flutter/views/loginPassCodePages/createYourPasscode.dart';
import 'package:base_project_flutter/views/passCodePage/lockScreen.dart';
import 'package:base_project_flutter/views/veriffPage/veriffPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';
import 'api_services/userApi.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'globalFuctions/globalFunctions.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

var checkAuth = '1';
var bloodGroup;
var verffiStatus;
var isEmailVerified;
var userId;
var verificationStatus;
var stripePublicKey = '';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  // await FirebaseAuth.instance.signInAnonymously();
  // var user = FirebaseAuth.instance.currentUser;
  print('Handling a background message ${message.notification}');
}

AndroidNotificationChannel? channel;
late Mixpanel mixpanel;

late AppsFlyerOptions appsFlyerOptions;
late AppsflyerSdk appsflyerSdk;
FirebaseAnalytics analytics = FirebaseAnalytics.instance;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
// List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  await Firebase.initializeApp();
  await Intercom.instance.initialize(
    'f7jdkh2r',
    androidApiKey: 'android_sdk-fe2b2eec4d8270e6113c662843759863087b6e8d',
    iosApiKey: 'ios_sdk-602b58fdb1b614b0865b17558405fb5727c93ebf',
  );
  Stripe.merchantIdentifier = 'merchant.com.metfolio';
  // Stripe.stripeAccountId = '';
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // getLocation();

  await analytics.logEvent(
    name: "app_opened",
    parameters: {
      "opened": true,
    },
  );

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  // checkLoginStatus() async {
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  var authCode = sharedPrefs.getString('authCode');

  if (authCode != null) {
    var check = await UserAPI().checkApi(sharedPrefs.getString('authCode'));
    print("authCode>>>>> " + authCode);
    print(check);
    print("CheckAuthcode");
    if (check != null && check['status'] == 'OK') {
      // if (check['detail']['veriff_status'] == false) {
      // var res = await UserAPI().deleteUser(hardDelete);
      // print(res);
      // if (res != null && res['status'] == 'OK') {
      //   sharedPrefs.remove('authCode');
      //   checkAuth = '';
      // } else {
      //   // print("deleteUser>>>>>" + res['error']);
      // }
      // } else {
      checkAuth = '1';
      // setState(() {
      if (check['detail']['userId'] != null) {
        sharedPrefs.setString('userId', check['detail']['userId'].toString());
      }
      //    if(check['detail']['userId'] != null){
      // sharedPrefs.setString('userId', check['detail']['userId'].toString());
      //    }
      if (check['detail']['email'] != null) {
        sharedPrefs.setString('email', check['detail']['email']);
      }
      if (check['detail']['username'] != null) {
        sharedPrefs.setString(
            'username', check['detail']['username'].toString());
      }
      if (check['detail']['first_name'] != null) {
        sharedPrefs.setString('firstName', check['detail']['first_name']);
      }
      if (check['detail']['last_name'] != null) {
        sharedPrefs.setString('lastName', check['detail']['last_name']);
      }
      // bloodGroup = check['detail']['blood_group'];
      verffiStatus = check['detail']['veriff_status'];
      isEmailVerified = check['detail']['is_email_verified'];
      userId = check['detail']['userId'];
      verificationStatus = check['detail']['verification_status'];
      stripePublicKey = check['detail']['stripe_publishable_key'];
      print("stripePublicKey>>>>>>>>>>");
      print(stripePublicKey);

      if (check['detail']['stripe_cus_id'] != null) {
        sharedPrefs.setString('cusId', check['detail']['stripe_cus_id']);
      }

      sharedPrefs.setString(
          'stripePublicKey', check['detail']['stripe_publishable_key']);
      sharedPrefs.setString(
          'stripesecretKey', check['detail']['stripe_secret_Key']);
      // print(isEmailVerified);
      // print(isEmailVerified.runtimeType);
      // print(stripePublicKey);
      Stripe.publishableKey = stripePublicKey;

      // Stripe.urlScheme = 'flutterstripe';
      await Stripe.instance.applySettings();
      await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId.toString())
          .get()
          .then((QuerySnapshot snapshot) async {
        print("isPasscodeExist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        // print(userData.data()?['userId']);
        if (snapshot.docs.length > 0) {
          if (snapshot.docs[0].data() != null) {
            // setState(() {
            isPasscodeExist = true;
            // });
          }
          print("passcode exit");
          print(isPasscodeExist);
          // print(snapshot.docs[0].data());
        } else {
          print("passcode NOT exit");
          // setState(() {
          isPasscodeExist = false;
          // });
        }
      });
      // }
    } else {
      // setState(() {
      checkAuth = '';
      // });
    }
  } else {
    // setState(() {
    checkAuth = '';
    // });
    // }
    print("checkAuth>>>>> " + checkAuth);
  }

  // await Firebase.initializeApp();
  // try {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   cameras = await availableCameras();
  // } on CameraException catch (e) {
  //   print('Error in fetching the cameras: $e');
  // }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());

//   OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

//   OneSignal.shared.setAppId("d7903f03-f26a-4d31-969f-20397f880a93");

// // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
//   OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
//     print("Accepted permission: $accepted");
//   });

  String writeKey;
  if (Platform.isAndroid) {
    writeKey = "1LJ8yWpoiXsN1XRdp9bYoLxk1nKJ7E94";
  } else {
    //iOS
    writeKey = "j6CGQteegeVu6lFTP7RSoD7kXd3bkITj";
  }

  await Segment.config(
    options: SegmentConfig(
      writeKey: writeKey,
      trackApplicationLifecycleEvents: false,
    ),
  );

  Segment.setContext({
    'device': {
      'token': 'testing',
    }
  });
}

bool isPasscodeExist = false;

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    this.checkAuth,
  }) : super(key: key);
  final checkAuth;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Smartlook smartlook = Smartlook.instance;

  @override
  void initState() {
    // checkLoginStatus();

    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userId.toString())
    //     .snapshots()
    //     .listen((userData) async {
    //   print("isPasscodeExist>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    //   print(userData.data()?['userId']);
    //   if (await userData.data()?['userId'] != null) {
    //     setState(() {
    //       isPasscodeExist = true;
    //     });
    //     print(isPasscodeExist);
    //   }
    // });
    super.initState();
    smartlook.start();
    smartlook.preferences
        .setProjectKey('94e524ea30ee65ec3db6cac4ab10450c04510754');

    final Properties properties = Properties();
    properties.putString('opened', value: 'true');

    smartlook.trackEvent('App_Opened', properties: properties);

    Segment.track(
      eventName: 'App_Opened',
      properties: {"opened": true},
    );

    initMixpanel();

    appsflyerSdkSetUp();
  }

  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init("709e6e13dfe0b1c5d22fc51032bbf937",
        trackAutomaticEvents: true);

    // Track with event-name
    mixpanel.track('App Opened');
// Track with event-name and property
    mixpanel.track('App Opened', properties: {'Hello': 'Users'});
  }

  appsflyerSdkSetUp() async {
    appsFlyerOptions = AppsFlyerOptions(
        afDevKey: "YZZvqQyQHyaKqKXeCKFD9T",
        appId: "id6443775527",
        showDebug: true,
        timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
        appInviteOneLink: "", // Optional field
        disableAdvertisingIdentifier: false, // Optional field
        disableCollectASA: false); // Optional field

    appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

    await logEvent("App Opened", {"clicked": true});
  }

  // var checkAuth = '1';
  // var bloodGroup;
  // var verffiStatus;
  // var isEmailVerified;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Segment.screen(
      screenName: 'Metfolio Home Screen',
    );

    // If you want to flush the data now
    Segment.flush();

    return BackGestureWidthTheme(
        backGestureWidth: BackGestureWidth.fraction(1 / 2),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ActionProvider>(
                create: (context) => ActionProvider()),
          ],
          child: Sizer(builder: (context, orientation, screenType) {
            return MaterialApp(
                builder: (context, child) {
                  return MediaQuery(
                    child: child!,
                    data:
                        MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
                  );
                },
                color: tPrimaryColor,
                title: 'MetFolio',
                debugShowCheckedModeBanner: testEnvironment,
                //suseInheritedMediaQuery: true,
                theme: ThemeData(
                  // splashColor: Colors.transparent,
                  // highlightColor: Colors.transparent,
                  // textTheme: GoogleFonts.barlowTextTheme(
                  //   Theme.of(context).textTheme,
                  // ),
                  // primaryTextTheme: GoogleFonts.barlowTextTheme(
                  //   Theme.of(context).textTheme,
                  // ),
                  // primarySwatch: Colors.blue,
                  pageTransitionsTheme: PageTransitionsTheme(
                    builders: {
                      // for Android - default page transition
                      // TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),

                      // for iOS - one which considers ancestor BackGestureWidthTheme
                      TargetPlatform.iOS:
                          CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
                    },
                  ),
                ),
                home:
                    // Builder(
                    //     builder: (context) => MediaQuery(
                    //         data: MediaQuery.of(context)
                    //             .copyWith(textScaleFactor: 1.0),
                    //         child:
                    (checkAuth == null || checkAuth == '')
                        ? MyHomePage() //Splash2()
                        : (verificationStatus == 0 ||
                                verificationStatus == null)
                            ? PersonalDetails(
                                isLoadingFlow: true,
                              )
                            : verificationStatus == 1
                                ? EmailNotVerified()
                                : verificationStatus == 2
                                    ? HomeAddress(isLoginFlow: true)
                                    : /*verificationStatus == 3
                                        ? //VeriffiPage()
                                        Extra()
                                        :*/
                                    isPasscodeExist
                                        // ? VeriffStatusCheck()
                                        ? LockScreen(navigate: false)
                                        : CreateYourPassCode(
                                            loginFlow: true,
                                          ),
                navigatorObservers: [
                  SegmentObserver(),
                ]
                // BottomNavigation(),
                // BottomNavigation(),
                // splashTransition: SplashTransition.scaleTransition,
                // backgroundColor: Colors.white),
                );
          }),
        ));
  }
}

checkverification(context, status) {
  switch (status) {
    case 0:
      Twl.navigateTo(
          context,
          PersonalDetails(
            isLoadingFlow: true,
          ));
      break;
    case 1:
      Twl.navigateTo(context, EmailNotVerified());
      break;
    case 2:
      Twl.navigateTo(context, HomeAddress(isLoginFlow: true));
      break;
    case 3:
      Twl.navigateTo(context, VeriffiPage());
      break;
    case 5:
      Twl.navigateTo(
          context,
          CreateYourPassCode(
            loginFlow: true,
          ));
      // Twl.navigateTo(context, BottomNavigation());
      break;
    default:
  }
}
// class LocalAuthApi {
//   static final _auth = LocalAuthentication();

//   static Future<bool> hasBiometrics() async {
//     try {
//       return await _auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       return false;
//     }
//   }

//   static Future<List<BiometricType>> getBiometrics() async {
//     try {
//       return await _auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       return <BiometricType>[];
//     }
//   }

//   static Future<bool> authenticate() async {
//     final isAvailable = await hasBiometrics();
//     if (!isAvailable) return false;

//     try {
//       return await _auth.authenticate(
//         localizedReason: 'Scan Fingerprint to Authenticate',
//          options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//     } on PlatformException catch (e) {
//       return false;
//     }
//   }
// }

// class FingerprintPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: Text('MyApp.title'),
//           centerTitle: true,
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(32),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 buildAvailability(context),
//                 SizedBox(height: 24),
//                 buildAuthenticate(context),
//               ],
//             ),
//           ),
//         ),
//       );

//   Widget buildAvailability(BuildContext context) => buildButton(
//         text: 'Check Availability',
//         icon: Icons.event_available,
//         onClicked: () async {
//           final isAvailable = await LocalAuthApi.hasBiometrics();
//           final biometrics = await LocalAuthApi.getBiometrics();

//           final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Availability'),
//               content: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   buildText('Biometrics', isAvailable),
//                   buildText('Fingerprint', hasFingerprint),
//                 ],
//               ),
//             ),
//           );
//         },
//       );

//   Widget buildText(String text, bool checked) => Container(
//         margin: EdgeInsets.symmetric(vertical: 8),
//         child: Row(
//           children: [
//             checked
//                 ? Icon(Icons.check, color: Colors.green, size: 24)
//                 : Icon(Icons.close, color: Colors.red, size: 24),
//             const SizedBox(width: 12),
//             Text(text, style: TextStyle(fontSize: 24)),
//           ],
//         ),
//       );

//   Widget buildAuthenticate(BuildContext context) => buildButton(
//         text: 'Authenticate',
//         icon: Icons.lock_open,
//         onClicked: () async {
//           final isAuthenticated = await LocalAuthApi.authenticate();

//           // if (isAuthenticated) {
//           //   Navigator.of(context).pushReplacement(
//           //     MaterialPageRoute(builder: (context) => HomePage()),
//           //   );
//           // }
//         },
//       );

//   Widget buildButton({
//      String ?text,
//      IconData? icon,
//      VoidCallback? onClicked,
//   }) =>
//       ElevatedButton.icon(
//         style: ElevatedButton.styleFrom(
//           minimumSize: Size.fromHeight(50),
//         ),
//         icon: Icon(icon, size: 26),
//         label: Text(
//           text!,
//           style: TextStyle(fontSize: 20),
//         ),
//         onPressed: onClicked,
//       );
// }

// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:base_project_flutter/constants/constants.dart';
// import 'package:base_project_flutter/provider/actionProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// import 'constants/imageConstant.dart';

// void main() => runApp(App());

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // wrap widgets tree with [BackGestureWidthTheme]
//     // to apply it to all descendants
//     return BackGestureWidthTheme(
//       backGestureWidth: BackGestureWidth.fraction(1 / 2),
//       child: MultiProvider(
//         providers: [
//           ChangeNotifierProvider<ActionProvider>(
//               create: (context) => ActionProvider()),
//         ],
//         child: Sizer(builder: (context, orientation, screenType) {
//           return MaterialApp(
//               color: tPrimaryColor,
//               title: 'MetFolio',
//               debugShowCheckedModeBanner: false,
//               //suseInheritedMediaQuery: true,
//               theme: ThemeData(
//                 // splashColor: Colors.transparent,
//                 // highlightColor: Colors.transparent,
//                 textTheme: GoogleFonts.barlowTextTheme(
//                   Theme.of(context).textTheme,
//                 ),
//                 primaryTextTheme: GoogleFonts.barlowTextTheme(
//                   Theme.of(context).textTheme,
//                 ),
//                 primarySwatch: Colors.blue,
//                 pageTransitionsTheme: PageTransitionsTheme(
//                   builders: {
//                     // for Android - default page transition
//                     TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),

//                     // for iOS - one which considers ancestor BackGestureWidthTheme
//                     TargetPlatform.iOS:
//                         CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
//                   },
//                 ),
//               ),
//               home: MainPage());
//         }),
//       ),
//     );
//   }
// }

// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cupertino back gesture'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Push other page'),
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) {
//                   return OtherPage();
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other page'),
      ),
      body: Center(
        child: Text('Try to swipe back'),
      ),
    );
  }
}

logEvent(String eventName, Map? eventValues) async {
  bool? result;
  try {
    result = await appsflyerSdk.logEvent(eventName, eventValues);
  } on Exception catch (e) {
    print("Result Error: $e");
  }
  print("Result logEvent: $result");
}
