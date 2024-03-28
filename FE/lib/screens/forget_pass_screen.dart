// ignore_for_file: override_on_non_overriding_member, library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/screens/otp_verify_screen.dart';
import 'package:wordwizzard/services/auth.dart';
import 'package:wordwizzard/utils/verify.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  _ForgetPassScreenState createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';

  void handlePress() async {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      final resData = await handleForgetPass(_email);
      if (resData["code"] == 0) {
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => OtpVerifyScreen(
                email: _email,
                userId: resData["userId"],
                action: "forget_pass"),
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
    }
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
        title: Text(getTranslated(context, "forgot_pass")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                child:
                    SvgPicture.asset('assets/images/forget_pass/forget_pass.svg'),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      InputDecoration(labelText: getTranslated(context, "email")),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return getTranslated(context, "empty_email_err_mess");
                    } else if (!isEmailValid(val)) {
                      return getTranslated(context, "invalid_email_err_mess");
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) {
                    _email = val!;
                  },
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: handlePress,
                    child: Text(getTranslated(context, 'send'), style: const TextStyle(color: Colors.white),)),
              )  
            ],
          ),
        ),
      ),
    );
  }
}
