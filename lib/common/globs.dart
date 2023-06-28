
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Globs {
    static const appName = "Food Delivery";

    static void showHUD({String status = "loading ....."}) async {
      await Future.delayed(const Duration(milliseconds: 1));
      EasyLoading.show(status: status);
    }

    static void hideHUD()  {
    EasyLoading.dismiss();
  }
}

class SVKey {
  static const mainUrl = "http://localhost:3001";
  static const baseUrl = '$mainUrl/api/';
  static const nodeUrl = mainUrl;

  static const svLogin = '${baseUrl}login';
  static const svSignUp = '${baseUrl}sign_up';
  static const svForgotPasswordRequest = '${baseUrl}forgot_password_request';
  static const svForgotPasswordVerify = '${baseUrl}forgot_password_verify';
  static const svForgotPasswordSetNew = '${baseUrl}forgot_password_set_new';
}

class KKey {
  static const payload = "payload";
  static const status = "status";
  static const message = "message";
}

class MSG {
  static const enterEmail = "Please enter valid email address.";
  static const enterPassword = "Please enter password minimum 6 characters at least.";
  static const success = "success";
  static const fail = "fail";
}