import 'dart:async';

import 'package:flutter/material.dart';

import '../../constants/imageConstant.dart';
import '../../globalFuctions/globalFunctions.dart';
import '../Splash2/Splash2.dart';

class Splash1 extends StatefulWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      //     backgroundColor: tWhite,
      //     centerTitle: true,
      //     elevation: 0,
      //     // title: Text("Profile"),
      //     // actions: [
      //     //   Padding(
      //     //       padding: EdgeInsets.all(15),
      //     //       child: Image.asset("assets/icons/appbar_notification.png"))
      //     // ],
      //     leading: IconButton(
      //         onPressed: () {
      //           Twl.navigateBack(context);
      //         },
      //         icon: Icon(Icons.arrow_back_ios, color: tPrimaryColor)),
      //   ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Twl.navigateTo(context, MyHomePage());
            },
            child: Image.asset(Images.SPLASH1),
          ),
        ),
      ),
    );
  }
}
