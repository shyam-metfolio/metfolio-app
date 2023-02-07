import 'dart:async';

import 'package:base_project_flutter/constants/constants.dart';
import 'package:base_project_flutter/main.dart';
import 'package:base_project_flutter/responsive.dart';
import 'package:base_project_flutter/views/frame/frame.dart';
import 'package:base_project_flutter/views/loginPassCodePages/mobileNumber.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
//
import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:sizer/sizer.dart';

import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';

import '../demoHome/demoHome.dart';
import '../logiPage/loginPage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;

  List<String> images = [
    "https://images.wallpapersden.com/image/download/purple-sunrise-4k-vaporwave_bGplZmiUmZqaraWkpJRmbmdlrWZlbWU.jpg",
    "https://wallpaperaccess.com/full/2637581.jpg",
    "https://uhdwallpapers.org/uploads/converted/20/01/14/the-mandalorian-5k-1920x1080_477555-mm-90.jpg",
    "https://wallpaperaccess.com/full/2637581.jpg",
  ];

  List<Container> car = [];
  int activePage = 0;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    car = [
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(100),
            ),
            color: bgcolor1(),
          ),
          child: Column(children: [
            Container(height: 35),
            Image.asset('images/C1.png', height: 158, width: 191),
            Container(height: 40),
            Text("Convenient",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "SignikaS",
                    color: _getColorFromHex("#1E365B"))),
            Container(height: 15),
            Image.asset('images/T11.png', height: 63, width: 277),
          ])),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: bgcolor1(),
          ),
          child: Column(children: [
            Container(height: 35),
            Image.asset('images/C2.png', height: 158, width: 191),
            Container(height: 40),
            Text("Simple",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "SignikaS",
                    color: _getColorFromHex("#1E365B"))),
            Container(height: 15),
            Image.asset('images/T21.png', height: 43, width: 255),
          ])),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: bgcolor1(),
          ),
          child: Column(children: [
            Container(height: 35),
            Image.asset('images/C3.png', height: 158, width: 191),
            Container(height: 40),
            Text("Get Started",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "SignikaS",
                    color: _getColorFromHex("#1E365B"))),
            Container(height: 15),
            Image.asset('images/T31.png', height: 43, width: 269),
          ])),
      Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: const Radius.circular(100),
            ),
            color: bgcolor1(),
          ),
          child: Column(children: [
            Container(height: 35),
            Image.asset('images/C4.png', height: 158, width: 191),
            Container(height: 40),
            Text("Bank Grade Security",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: "SignikaS",
                    color: _getColorFromHex("#1E365B"))),
            Container(height: 15),
            Image.asset('images/T41.png', height: 43, width: 266),
          ])),
    ];

    _pageController = PageController(viewportFraction: 1, initialPage: 0);
    ch();
  }

  ch() async {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (activePage < 3) {
        activePage++;
      } else {
        activePage = 0;
      }

      _pageController.animateToPage(
        activePage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  notif(x) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Image.asset('images/logo.png', height: 25),
            content: Text("Buttons have been disabled!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Poppins-Regular",
                    color: _getColorFromHex("#1E365B"))),
          );
        });
  }

  bgcolor() {
    return _getColorFromHex("#FFFFFF");
  }

  bgcolor1() {
    return _getColorFromHex("#F9DDA5");
  }

  url() {
    return "images/des2.png";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Twl.willpopAlert(context);
        },
        child: Scaffold(
            backgroundColor: bgcolor(),
            body: Center(
              child: Column(
                children: <Widget>[
                  Container(color: _getColorFromHex("#F9DDA5"), height: 70),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: _getColorFromHex("#F9DDA5"),
                      child: Image.asset('images/logo.png',
                          height: 26, width: 171)),
                  Container(color: _getColorFromHex("#F9DDA5"), height: 40),
                  /*     ClipPath(
                  clipper: ShapeClipper(),
                  child:*/
                  Container(
                    height: 360,
                    child: PageView.builder(
                        itemCount: car.length,
                        pageSnapping: true,
                        controller: _pageController,
                        onPageChanged: (page) {
                          setState(() {
                            activePage = page;
                          });
                        },
                        itemBuilder: (context, pagePosition) {
                          bool active = pagePosition == activePage;
                          return slider(car, pagePosition, active, context);
                        }),
                  ),
                  //   ),
                  Container(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicators(car.length, activePage)),
                  Container(height: 50),

                  Column(children: [
                    Container(
                        height: 40,
                        width: 230,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: _getColorFromHex("#E5B02C"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              Twl.navigateTo(context, LoginMobileNumber());

                              await analytics.logEvent(
                                name: "signup_button_clicked",
                                parameters: {
                                  "button_clicked": true,
                                },
                              );

                              Segment.track(
                                eventName: 'Signup_Button',
                                properties: {"clicked": true},
                              );

                              mixpanel
                                  .track('signup_button_clicked', properties: {
                                "button_clicked": true,
                              });

                              await logEvent(
                                  "signup_button_clicked", {"clicked": true});
                            },
                            child: Text("Sign up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)))),
                    Container(height: 10),
                    Container(
                        height: 40,
                        width: 230,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: _getColorFromHex("#E5B02C"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              Twl.navigateTo(context, LoginMobileNumber1());

                              await analytics.logEvent(
                                name: "login_button_clicked",
                                parameters: {
                                  "button_clicked": true,
                                },
                              );

                              Segment.track(
                                eventName: 'Login_Button',
                                properties: {"clicked": true},
                              );

                              mixpanel
                                  .track('login_button_clicked', properties: {
                                "button_clicked": true,
                              });

                              await logEvent(
                                  "login_button_clicked", {"clicked": true});
                            },
                            child: Text("Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24))))
                  ]),
                ],
              ),
            )));
  }
}

_getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }
}

AnimatedContainer slider(images, pagePosition, active, context) {
  double margin = active ? 10 : 20;

  return AnimatedContainer(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOutCubic,
    child: images[pagePosition],
  );
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index
              ? _getColorFromHex("#E5B02C")
              : _getColorFromHex("#F9DDA5"),
          shape: BoxShape.circle),
    );
  });
}

class ShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0.0, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - 100, 0.0)
      ..close();
  }

  @override
  bool shouldReclip(ShapeClipper oldClipper) => false;
}
