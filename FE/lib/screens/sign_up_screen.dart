import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/auth.dart';
import 'package:wordwizzard/utils/verify.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passInputController = TextEditingController();
  String _userName = '';
  String _email = '';
  String _password = '';
  String emailErrMess = '';

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      handleRegister(_userName, _email, _password).then((value) {
        if (value['code'] == 0) {
          Navigator.of(context).pushNamed(otpVerifyRoute, arguments: {
            "email": _email,
            "userId": value['userId'],
            "action": "sign_up"
          });
        } else if (value['code'] == 2) {
          setState(() {
            emailErrMess = getTranslated(context, 'exist_email');
          });
        } else {
          debugPrint('signUp Error with code: $value');
        }
      });
    }
  }

  bool isCorrectConfirmPass(String confirmPass) {
    if (confirmPass == passInputController.text) {
      return true;
    }
    return false;
  }

  void handleSignInRoute() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 120,
                height: 200,
                child: Image.asset('assets/images/logo/logo-removebg.png'),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: getTranslated(context, "user_name"),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return getTranslated(
                                context, "require_input");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userName = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: getTranslated(context, "email"),
                          errorText: emailErrMess != '' ? emailErrMess : null,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            setState(() {
                              emailErrMess = getTranslated(
                                  context, "empty_email_err_mess");
                            });
                          } else if (!isEmailValid(val)) {
                            setState(() {
                              emailErrMess = getTranslated(
                                  context, "invalid_email_err_mess");
                            });
                          } else {
                            setState(() {
                              emailErrMess = '';
                            });
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passInputController,
                        decoration: InputDecoration(
                          labelText: getTranslated(context, "password"),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return getTranslated(
                                context, "empty_password_err_mess");
                          } else if (!isPasswordValid(value)) {
                            return getTranslated(
                                context, "invalid_password_err_mess");
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: getTranslated(context, "confirm_password"),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return getTranslated(
                                context, "empty_password_err_mess");
                          } else if (!isCorrectConfirmPass(value)) {
                            return getTranslated(
                                context, "wrong_confirm_password_error_mess");
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FilledButton(
                        onPressed: _submitForm,
                        child: Text(
                          getTranslated(context, "sign_up"),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(getTranslated(context, 'old_user'),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16)),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: handleSignInRoute,
                            child: Text(getTranslated(context, 'sign_in'),
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 16)),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
