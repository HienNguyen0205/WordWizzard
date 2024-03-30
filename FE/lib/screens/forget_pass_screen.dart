import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/auth.dart';
import 'package:wordwizzard/utils/verify.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({super.key});

  @override
  ForgetPassScreenState createState() => ForgetPassScreenState();
}

class ForgetPassScreenState extends State<ForgetPassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';

  void handlePress() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      handleForgetPass(_email).then((value) {
        if (value["code"] == 0) {
          Navigator.of(context).pushNamed(otpVerifyRoute, arguments: {
            "email": _email,
            "userId": value["userId"],
            "action": "forget_pass"
          });
        }
      });
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
        centerTitle: true,
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
                child: SvgPicture.asset(
                    'assets/images/forget_pass/forget_pass.svg'),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: getTranslated(context, "email")),
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: handlePress,
                    child: Text(
                      getTranslated(context, 'send'),
                      style: const TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
