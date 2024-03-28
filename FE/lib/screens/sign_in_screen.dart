// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/auth/auth_provider.dart';
// import 'package:wordwizzard/constants/constants.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/screens/forget_pass_screen.dart';
import 'package:wordwizzard/screens/home_screen.dart';
import 'package:wordwizzard/screens/sign_up_screen.dart';
import 'package:wordwizzard/services/auth.dart';
import 'package:wordwizzard/utils/verify.dart';
// import 'package:wordwizzard/widgets/icon_btn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _emailErrMess = '';
  String _passErrMess = '';

  void _submitForm() async {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      form.save();
      final resCode = await handleLogin(_email, _password);
      if (resCode == 0) {
        authProvider.logIn();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else if (resCode == 2 || resCode == 3) {
        setState(() {
          _emailErrMess = getTranslated(context, 'login_error');
          _passErrMess = getTranslated(context, 'login_error');
        });
      } else {
        debugPrint('signIn Error with code: $resCode');
      }
    }
  }

  void handleForgetPass() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ForgetPassScreen(),
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

  void handleSignUpRoute() {
    Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, __, ___) => const SignUpScreen(),
        transitionDuration: const Duration(milliseconds: 300),
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
                            labelText: getTranslated(context, "email"),
                            errorText:
                                _emailErrMess != '' ? _emailErrMess : null),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            setState(() {
                              _emailErrMess = getTranslated(
                                  context, "empty_email_err_mess");
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
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          getTranslated(context, "sign_in"),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 24),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: iconList
                      //         .map((item) => IconBtn(imgUrl: item))
                      //         .toList(),
                      //   ),
                      // ),
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
