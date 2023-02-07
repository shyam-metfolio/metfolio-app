import 'package:base_project_flutter/Constants/apiConstants.dart';
import 'package:base_project_flutter/globalFuctions/globalFunctions.dart';
import 'package:base_project_flutter/responsive.dart';

import 'package:base_project_flutter/views/homePage/components/goals.dart';
import 'package:base_project_flutter/views/homePage/components/account.dart';
import 'package:base_project_flutter/views/profilePage/profilePage.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';

import '../../api_services/userApi.dart';
import '../../constants/constants.dart';
import 'components/dashBoardPage.dart';

class HomePage extends StatefulWidget {
  final Function naviagte;
  final homeindex;

  const HomePage({required this.naviagte, required this.homeindex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;

  _onTabTapped(int index) {
    setState(() {
      tabIndex = index;
    });
    controller.animateTo(
      index,
      duration: Duration(milliseconds: 10),
      curve: Curves.easeIn,
    );
  }

  late TabController controller;

  @override
  void initState() {
    super.initState();
    // checkLoginStatus();
    controller =
        TabController(length: 3, vsync: this, initialIndex: widget.homeindex);
  }

// late SharedPreferences sharedPreferences;
//   var mobileNo;
//   var email;
//   var firstname;
//   var check;
//   var profileImage;
//   var authCode;
//   var details;
//   var lastName;

//   checkLoginStatus() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     authCode = sharedPreferences.getString('authCode');
//     check = await UserAPI().checkApi(sharedPreferences.getString('authCode')!);
//     print(check);
//     if (check != null && check['status'] == 'OK') {
//       setState(() {
//         details = check['detail'];
//       });
//       sharedPreferences.setString(
//           'contactnumber', check['detail']['contact_no'].toString());
//       sharedPreferences.setString('email', check['detail']['email'].toString());

//       sharedPreferences.setString(
//           'username', check['detail']['first_name'].toString());
//       sharedPreferences.setString('lastName', check['detail']['last_name']);
//       if (check['detail']['profile_image'] != null) {
//         sharedPreferences.setString(
//             "profile_image", check['detail']['profile_image']);
//       }
//     }

//     setState(() {
//       mobileNo = sharedPreferences.getString("contactnumber") != null
//           ? sharedPreferences.getString("contactnumber")
//           : ' ';
//       print(mobileNo);
//       email = sharedPreferences.getString('email') != null
//           ? sharedPreferences.getString('email')
//           : ' ';
//       firstname = sharedPreferences.getString('username') != null
//           ? sharedPreferences.getString('username')
//           : ' ';
//       lastName = sharedPreferences.getString('lastName') != null
//           ? sharedPreferences.getString('lastName')
//           : '';
//       profileImage = sharedPreferences.getString('profile_image') != null
//           ? sharedPreferences.getString('profile_image')
//           : 'https://img.icons8.com/bubbles/50/000000/user.png';
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tWhite,
      body: DefaultTabController(
        initialIndex: tabIndex,
        length: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (testEnvironment) Spacer(),
                  if (testEnvironment) Text("Test environment"),
                  if (testEnvironment) Spacer(),
                  NameClip(),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Theme(
                data: ThemeData(
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  backgroundColor: Colors.white,
                ),
                child: Container(
                  color: Colors.transparent,
                  child: TabBar(
                    overlayColor: MaterialStateProperty.all<Color>(tBackground),
                    controller: controller,
                    indicator: BoxDecoration(
                      color: tIndicatorColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    indicatorPadding: EdgeInsets.only(top: 36, bottom: 9),
                    isScrollable: true,
                    labelColor: tSecondaryColor,
                    labelStyle: TextStyle(
                        fontFamily: "Barlow",
                        color: tWhite,
                        fontSize: isTab(context) ? 11.sp : 14.sp,
                        fontWeight: FontWeight.bold),
                    unselectedLabelColor: tSecondaryColor,
                    unselectedLabelStyle: TextStyle(
                        color: tWhite,
                        fontFamily: "Barlow",
                        fontSize: isTab(context) ? 11.sp : 14.sp,
                        fontWeight: FontWeight.bold),
                    indicatorWeight: 8,
                    onTap: (index) {
                      _onTabTapped(index);
                    },
                    tabs: [
                      Tab(
                        text: "Dashboard",
                      ),
                      Tab(
                        text: "Accounts",
                      ),
                      Tab(
                        text: "Goals",
                      )
                    ],
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: controller,
                    children: [
                      DashBoardPage(
                        navigate: widget.naviagte,
                        innerNavvigate: _onTabTapped,
                      ),
                      AccountPage(),
                      GoalsPage(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NameClip extends StatefulWidget {
  const NameClip({
    Key? key,
  }) : super(key: key);

  @override
  State<NameClip> createState() => _NameClipState();
}

class _NameClipState extends State<NameClip> {
  @override
  void initState() {
    checkLoginStatus();
    // TODO: implement initState
    super.initState();
  }

  late SharedPreferences sharedPreferences;
  var mobileNo;
  var email;
  var firstname;
  var check;
  var profileImage;
  var authCode;
  var details;
  var lastName;

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    authCode = sharedPreferences.getString('authCode');
    check = await UserAPI().checkApi(sharedPreferences.getString('authCode')!);
    print(check);
    if (check != null && check['status'] == 'OK') {
      setState(() {
        details = check['detail'];
      });
      sharedPreferences.setString(
          'contactnumber', check['detail']['contact_no'].toString());
      sharedPreferences.setString('email', check['detail']['email'].toString());

      sharedPreferences.setString(
          'username', check['detail']['username'].toString());
      sharedPreferences.setString(
          'firstName', check['detail']['first_name'].toString());
      sharedPreferences.setString('lastName', check['detail']['last_name']);
      if (check['detail']['profile_image'] != null) {
        sharedPreferences.setString(
            "profile_image", check['detail']['profile_image']);
      }
    }

    setState(() {
      mobileNo = sharedPreferences.getString("contactnumber") != null
          ? sharedPreferences.getString("contactnumber")
          : ' ';
      print(mobileNo);
      email = sharedPreferences.getString('email') != null
          ? sharedPreferences.getString('email')
          : ' ';
      firstname = sharedPreferences.getString('firstName') != null
          ? sharedPreferences.getString('firstName')
          : ' ';
      lastName = sharedPreferences.getString('lastName') != null
          ? sharedPreferences.getString('lastName')
          : '';
      profileImage = sharedPreferences.getString('profile_image') != null
          ? sharedPreferences.getString('profile_image')
          : 'https://img.icons8.com/bubbles/50/000000/user.png';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Twl.navigateTo(context, ProfilePage());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(color: tPrimaryColor, shape: BoxShape.circle),
        child: Text(
            (firstname != null && lastName != null)
                ? (firstname[0].toUpperCase() ?? '') +
                    (lastName[0].toUpperCase() ?? '')
                : '',
            style: TextStyle(
                color: tSecondaryColor,
                fontSize: isTab(context) ? 10.sp : 13.sp,
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}
