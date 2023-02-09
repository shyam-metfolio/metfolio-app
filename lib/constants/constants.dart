import 'package:flutter/material.dart';

const tDefaultPadding = 20.0;
const tredColor = Color(0xffFA0808);
const tPrimaryColor = Color(0XFFE5B02C);
const tPrimaryColor2 = Color(0XFFE5E5E5);
const tPrimaryColor3 = Color(0xFfF9DDA5);
const grayColor = Color(0xff57B0BA);
const tgreenColor = Color(0xff44EF1C);
const tSecondaryColor = Color(0XFF1E365B);
const tlightBlue = Color(0xff2AB2BC);
const tgrayColor2 = Color(0xff707070);
const twhiteColor2 = Color(0xffE8ECF4);
// const tSecondCardBackground = Color(0xFFF3F4F6);
const tWhite = Color(0XFFffffff);
const tGray = Color(0XFF757575);
const tSecondaryGary = Color(0XFFE5E5E5);
const tBackground = Color(0XFFF5F5F5);
const tBlack = Color(0XFF000000);
const tYellow = Color(0XFFF57C00);
const tDivider = Color(0XFFE1E1E1);
const tTextformfieldSecondary = Color(0XFF6881A5);
const tlightGray = Color(0XFFC4C4C4);
const tIndicatorColor = Color(0XFFF9DDA5);
const tContainerColor = Color(0XFFF3F4F6);
const tBlue = Color(0XFF3D5579);
const tText = Color(0xFF707070);
const tTextformfieldColor = Color(0xFFE7ECF5);
const tTextSecondary = Color(0xFF1E365B);
const tPrimaryTextformfield = Color(0xFFE7ECF5);
const tlightGrayblue = Color(0XFFE7ECF5);
const tlightColor = Color(0XFFF1F2F4);
const tEditColor = Color(0XFFDDB24A);
const tTabColor = Color(0XFF6881A5);
const tBoxShadow = BoxShadow(
  color: Color(0x28000000),
  blurRadius: 4,
  offset: Offset(0, 2),
);
const mapKey = 'AIzaSyA2ejzT7rnz6u9rlyvaEt1fT46539yDjNA';
const currencySymbol = '₹ ';
const Secondarycurrency = '£';
const currency = 'GBP';

const Buy = 1;
const Sell = 2;
const Move = 2;

const physicalGold = 1;
const myGoal = 2;

class GoldType {
  int Buy = 1;
  int Sell = 2;
  int Deliver = 5;
  int EditGoal = 6;
  int EndGoal = 7;
}

int daysInMonth(DateTime date) {
  var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
  var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
      firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}

var addressKey = '5VvhGDeezkCpMvD7QKbdMg36096';

var stripeScritKey =
    'sk_test_51LjgVyCWDgwcpbq2s5O0tHdZucayEwP3CWqkGZOUR2JhNjE1NH55MUK6JpOOds2nWqAHxYFGVkYzQ5Thw6ZtNW2900sEaX6CZ8';

// delete string constant

var hardDelete = 'hard';
var softDelete = 'soft';
var instaGramUrl = 'https://www.instagram.com/metfolioapp/';
var termsAndConditonsUrl =
    'https://www.metfolio.com/legal/terms-and-conditions';
var privacyUrl = 'https://www.metfolio.com/legal/privacy-policy';
var tikTokUrl = 'https://www.tiktok.com/@metfolio?lang=en';
var facebookUrl = 'https://www.facebook.com/profile.php?id=100082838512895';
var appStoreUrl = 'https://apps.apple.com/in/app/metfolio/id6443775527';
var playStoreUrl =
    'https://play.google.com/store/apps/details?id=com.metfolio.app';
