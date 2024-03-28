// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/auth/auth_provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/screens/otp_verify_screen.dart';
import 'package:wordwizzard/services/auth.dart';
import 'package:wordwizzard/utils/verify.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passInputController = TextEditingController();
  String _userName = '';
  String _email = '';
  String _password = '';
  String emailErrMess = '';

  void _submitForm() async {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      form.save();
      final res = await handleRegister(_userName, _email, _password);
      if(res['code'] == 0){
        authProvider.logIn();
        Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => OtpVerifyScreen(email: _email, userId: res['userId'], action: 'sign_up',),
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
      }else if(res['code'] == 2){
        setState(() {
          emailErrMess = getTranslated(context, 'exist_email');
        });
      }else{
        debugPrint('signUp Error with code: $res');
      }
    }
  }

  bool isCorrectConfirmPass(String confirmPass) {
    if(confirmPass == passInputController.text){
      return true;
    }
    return false;
  }

  void handleSignInRoute() {
    if(Navigator.of(context).canPop()){
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
                            return getTranslated(context, "empty_name_err_mess");
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
                              emailErrMess = getTranslated(context, "empty_email_err_mess");
                            });
                          } else if (!isEmailValid(val)) {
                            setState(() {
                              emailErrMess = getTranslated(context, "invalid_email_err_mess");
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
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          getTranslated(context, "sign_up"),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 24,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(getTranslated(context, 'old_user'),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16
                              )),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: handleSignInRoute,
                            child: Text(getTranslated(context, 'sign_in'),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16
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