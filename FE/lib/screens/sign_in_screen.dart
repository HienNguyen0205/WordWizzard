import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/auth.dart';
import 'package:wordwizzard/utils/verify.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _emailErrMess = '';
  String _passErrMess = '';

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      handleLogin(_email, _password).then((value) {
        if (value == 0) {
          context.read<AuthProvider>().signIn();
          Navigator.of(context).pushNamedAndRemoveUntil(bottomNavRoute, (route) => false);
        } else if (value == 2 || value == 3) {
          setState(() {
            _emailErrMess = getTranslated(context, 'login_error');
            _passErrMess = getTranslated(context, 'login_error');
          });
        } else {
          debugPrint('signIn Error with code: $value');
        }
      });
    }
  }

  void handleForgetPass() {
    Navigator.of(context).pushNamed(forgetPassRoute);
  }

  void handleSignUpRoute() {
    Navigator.of(context).pushNamed(signUpRoute);
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: getTranslated(context, "email"),
                            errorText:
                                _emailErrMess != '' ? _emailErrMess : null),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _emailErrMess = getTranslated(
                                  context, "require_input");
                            });
                          } else if (!isEmailValid(value)) {
                            setState(() {
                              _emailErrMess = getTranslated(
                                  context, "invalid_email_err_mess");
                            });
                          } else {
                            setState(() {
                              _emailErrMess = '';
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
                        decoration: InputDecoration(
                            labelText: getTranslated(context, "password"),
                            errorText:
                                _passErrMess != '' ? _passErrMess : null),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _passErrMess = getTranslated(
                                  context, 'empty_password_err_mess');
                            });
                          } else if (!isPasswordValid(value)) {
                            setState(() {
                              _passErrMess = getTranslated(
                                  context, 'invalid_password_err_mess');
                            });
                          } else {
                            setState(() {
                              _passErrMess = '';
                            });
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value!;
                        },
                        onFieldSubmitted: (value) {
                          _submitForm();
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 12, bottom: 24),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: handleForgetPass,
                          child: Text(
                            getTranslated(context, 'forget_pass'),
                            style: const TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: _submitForm,
                        child: Text(
                          getTranslated(context, "sign_in"),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(getTranslated(context, 'new_user'),
                              style: const TextStyle(
                                fontSize: 16,
                              )),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: handleSignUpRoute,
                            child: Text(getTranslated(context, 'sign_up'),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                )),
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
