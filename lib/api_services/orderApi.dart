import 'package:base_project_flutter/api_services/ApiHelper.dart';
import 'package:base_project_flutter/api_services/userApi.dart';
import 'package:base_project_flutter/constants/constants.dart';
import 'package:flutter/material.dart';

import '../constants/apiConstants.dart';

class OrderAPI {
  // add to cart
  addToCart(BuildContext context, String type, String qty, String amount,
      String goldType) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = ADDTOCART + headers['auth_code'];
    Map<String, String> params = {
      'type_id': type,
      'qty': qty,
      'amount': amount,
      'gold_type': goldType
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  // delete to cart
  deleteCart(
    BuildContext context,
  ) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = DELETECART + headers['auth_code'];
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    // var response = jsonMap;

    return jsonMap;
  }

  

  // add  goal

  addGoal(BuildContext context, String name, String amount, String date,
      String pmId, currency) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = ADDOREDITGOAL + headers['auth_code'];
    Map<String, String> params = {
      'name_of_goal': name,
      'goal_amount': amount,
      'payment_date': date,
      'goal_type': '1',
      'status': '1',
      'current_status': '2',
      'pm_id': pmId,
      'currency': currency
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  //  edit goal
  editGoal(BuildContext context, String goalId, String name, String amount,
      String date, String status, String currentstatus) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = ADDOREDITGOAL + headers['auth_code'] + '&goalId=${goalId}';
    Map<String, String> params = {
      'name_of_goal': name,
      'goal_amount': amount,
      'payment_date': date,
      'goal_type': '1',
      'status': status,
      'currency':currency,
      'current_status': currentstatus
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;
    print(jsonMap);
    return jsonMap;
  }

  //  move gold
  moveGold(BuildContext context, String currentGoldType, String moveGoldType,
      String quantity) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = MOVEGOLD + headers['auth_code'];
    Map<String, String> params = {
      'current_gold_type': currentGoldType,
      'move_gold_type': moveGoldType,
      'quantity': quantity
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  // buy gold
  buyGold(BuildContext context, String paymentIntentID) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri =
        BUYGOLD + headers['auth_code'] + '&payment_intent=' + paymentIntentID;
    jsonMap = await ApiHelper().getTypeGet(context, uri);
    // var response = jsonMap;

    return jsonMap;
  }

  //  createGoalPayment
  createGoalPayment(BuildContext context, String cardNumber, String expMonth,
      String expYear, String cvc, String cardName) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = CREATEGOALPAYMENT + headers['auth_code'];
    Map<String, String> params = {
      'type': 'card',
      'card[number]': cardNumber,
      'card[exp_month]': expMonth,
      'card[exp_year]': expYear,
      'card[cvc]': cvc,
      'metadata[auto_update_default_payment]': 'true',
      'billing_details[name]': cardName
      // 'billing_details[address][city]': 'hydetabad',
      // 'billing_details[address][country]': 'In',
      // 'billing_details[address][line1]': 'test line one',
      // 'billing_details[address][line2]': 'test line Two',
      // 'billing_details[address][postal_code]': '500072',
      // 'billing_details[address][state]': 'Telangana',
      // 'billing_details[email]': 'spvn81@gmail.com',
      // 'billing_details[name]': 'sai pavan',
      // 'billing_details[phone]': '6300565084'
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  //  confirmGoalPayment
  confirmGoalPayment(
    BuildContext context,
    String id,
  ) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = COMFIRMGOALPAYMENT + headers['auth_code'];
    Map<String, String> params = {
      'latest_invoice': id,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }

  //  sellGold
  sellGold(
    BuildContext context,
    String bankId,
  ) async {
    var jsonMap;
    var headers = await UserAPI().getHeader(context);
    var uri = SELLGOLD + headers['auth_code'];
    Map<String, String> params = {
      'customer_bank_id': bankId,
    };
    jsonMap = await ApiHelper().getTypePost(context, uri, params);
    // var response = jsonMap;

    return jsonMap;
  }
}
