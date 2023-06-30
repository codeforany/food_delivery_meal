import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';
import 'package:food_delivery/common/extension.dart';
import 'package:food_delivery/common_widget/round_button.dart';
import 'package:food_delivery/view/login/new_password_view.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import '../../common/globs.dart';
import '../../common/service_call.dart';

class OTPView extends StatefulWidget {
  final String email;
  const OTPView({super.key, required this.email});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 64,
              ),
              Text(
                "We have sent an OTP to your email",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Please check your email ${widget.email}\ncontinue to reset your password",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 60,
              ),

              SizedBox(height: 60, child: OtpPinField(
                    key: _otpPinFieldController,
                    autoFillEnable: true,

                    ///for Ios it is not needed as the SMS autofill is provided by default, but not for Android, that's where this key is useful.
                    textInputAction: TextInputAction.done,

                    ///in case you want to change the action of keyboard
                    /// to clear the Otp pin Controller
                    onSubmit: (newCode) {
                      code = newCode;
                      btnSubmit();
                      /// return the entered pin
                    },
                    onChange: (newCode) {
                      code = newCode;

                      /// return the entered pin
                    },
                    onCodeChanged: (newCode) {
                      code = newCode;
                    },

                    fieldWidth: 40,

                    /// to decorate your Otp_Pin_Field
                    otpPinFieldStyle: OtpPinFieldStyle(

                        /// border color for inactive/unfocused Otp_Pin_Field
                        defaultFieldBorderColor: Colors.transparent,

                        /// border color for active/focused Otp_Pin_Field
                        activeFieldBorderColor: Colors.transparent,

                        /// Background Color for inactive/unfocused Otp_Pin_Field
                        defaultFieldBackgroundColor: TColor.textfield,
                        activeFieldBackgroundColor: TColor.textfield

                        /// Background Color for active/focused Otp_Pin_Field
                        ),
                    maxLength: 6,

                    /// no of pin field
                    showCursor: true,

                    /// bool to show cursor in pin field or not
                    cursorColor: TColor.placeholder,

                    /// to choose cursor color
                    upperChild: const Column(
                      children: [
                        SizedBox(height: 30),
                        Icon(Icons.flutter_dash_outlined, size: 150),
                        SizedBox(height: 20),
                      ],
                    ),
                    showCustomKeyboard: false,

                    ///bool which manage to show custom keyboard
                    // customKeyboard: Container(),  /// Widget which help you to show your own custom keyboard in place if default custom keyboard
                    // showDefaultKeyboard: true,  ///bool which manage to show default OS keyboard
                    cursorWidth: 3,

                    /// to select cursor width
                    mainAxisAlignment: MainAxisAlignment.center,

                    /// place otp pin field according to yourselft

                    /// predefine decorate of pinField use  OtpPinFieldDecoration.defaultPinBoxDecoration||OtpPinFieldDecoration.underlinedPinBoxDecoration||OtpPinFieldDecoration.roundedPinBoxDecoration
                    ///use OtpPinFieldDecoration.custom  (by using this you can make Otp_Pin_Field according to yourself like you can give fieldBorderRadius,fieldBorderWidth and etc things)
                    otpPinFieldDecoration:
                        OtpPinFieldDecoration.defaultPinBoxDecoration),),

              
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: "Next",
                  onPressed: () {
                    btnSubmit();
                  }),
                TextButton(
                onPressed: () {
                   serviceCallForgotRequest({"email": widget.email});
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Didn't Received? ",
                      style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Click Here",
                      style: TextStyle(
                          color: TColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   //TODO: Action
  void btnSubmit() {
    if (code.length != 6) {
      mdShowAlert(Globs.appName, MSG.enterCode, () {});
      return;
    }

    endEditing();

    serviceCallForgotVerify({"email": widget.email, "reset_code": code});
  }

  //TODO: ServiceCall

  void serviceCallForgotVerify(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svForgotPasswordVerify,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        var payloadObj = responseObj[KKey.payload] as Map? ?? {};
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewPasswordView(nObj: payloadObj,)));
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, err.toString(), () {});
    });
  }

  void serviceCallForgotRequest(Map<String, dynamic> parameter) {
    Globs.showHUD();

    ServiceCall.post(parameter, SVKey.svForgotPasswordRequest,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
         mdShowAlert(Globs.appName,
            "reset code successfully", () {});
       
      } else {
        mdShowAlert(Globs.appName,
            responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      mdShowAlert(Globs.appName, err.toString(), () {});
    });
  }
}
