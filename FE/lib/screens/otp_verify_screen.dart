// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/screens/change_pass_screen.dart';
import 'package:wordwizzard/screens/home_screen.dart';
import 'package:wordwizzard/services/auth.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen(
      {Key? key,
      required this.email,
      required this.userId,
      required this.action})
      : super(key: key);

  final String email;
  final String userId;
  final String action;

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool isErrorBorder = false;
  int countdown = 60;

  @override
  void initState() {
    super.initState();
    handleShowResend();
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void handleOnChange(String val, int index) async {
    if (val.isNotEmpty && index < 5) {
      FocusScope.of(context).nextFocus();
    } else if (val.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    } else if (index == 5) {
      String otp = '';
      for (var element in _controllers) {
        otp += element.text;
      }
      debugPrint(widget.action);
      if (widget.action == 'forget_pass') {
        handleResetPassOTP(otp, widget.userId).then((val) => handleResResult(val["code"], 'forget_pass'));
      } else if (widget.action == 'sign_up') {
        handleRegisterOTP(otp, widget.userId).then((val) => handleResResult(val, 'sign_up'));
      }
    }
  }

  void handleResResult(int resCode, String action) {
    debugPrint(resCode.toString());
    if (resCode == 0) {
      if(action == 'sign_up') {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
      }else if(action == 'forget_pass'){
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => ChangePassScreen(userId: widget.userId),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            }));
      }
    } else if (resCode == 3) {
      setState(() {
        isErrorBorder = true;
      });
      for (var element in _controllers) {
        element.text = '';
      }
      _focusNodes[0].requestFocus();
      Fluttertoast.showToast(msg: getTranslated(context, 'wrong_otp'));
    }
  }

  void handleResend() {
    handleResendOTP(widget.email).then((val) {
      if (val == 0) {
        handleShowResend();
      }
    });
  }

  void handleShowResend() {
    setState(() {
      countdown = 60;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(getTranslated(context, 'verify_email')),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                child: SvgPicture.asset(
                    'assets/images/otp_verify/otp_verify_img.svg'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  getTranslated(context, 'otp_verify'),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        getTranslated(context, 'otp_send_to'),
                      ),
                      Text(
                        widget.email,
                        style: const TextStyle(color: Colors.deepOrangeAccent),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                    (index) => Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: const Color(0xffdcedc8),
                          border: Border.all(
                              width: 2,
                              color:
                                  isErrorBorder ? Colors.red : Colors.green)),
                      width: 54.0,
                      child: TextFormField(
                        style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        autofocus: index == 0 ? true : false,
                        focusNode: _focusNodes[index],
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          counterText: '',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent,),
                        )),
                        onChanged: (value) {
                          handleOnChange(value, index);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      getTranslated(
                          context,
                          countdown == 0
                              ? 'not_receive_otp'
                              : 'can_resent_after'),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    countdown == 0
                        ? GestureDetector(
                            onTap: handleResend,
                            child: Text(
                              getTranslated(context, 'resent'),
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 16),
                            ),
                          )
                        : Text(
                            '$countdown',
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16),
                          )
                  ])),
            ],
          ),
        ),
      ),
    );
  }
}
