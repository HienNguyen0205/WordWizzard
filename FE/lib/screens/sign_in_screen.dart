// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/auth/auth_provider.dart';
import 'package:wordwizzard/constants/constants.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/widgets/icon_btn.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      final authProvider = Provider.of<AuthProvider>(context);
      form.save();
      authProvider.logIn(_email, _password).then(
        (val) => {
          
        }
      );
    }
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    final RegExp passwordRegex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void handleForgetPass() {}

  void handleSignUpRoute() {}

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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return getTranslated(
                                context, "empty_email_err_mess");
                          } else if (!isEmailValid(value)) {
                            return getTranslated(
                                context, "invalid_email_err_mess");
                          } else {
                            return null;
                          }
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
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
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 12, bottom: 24),
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: handleForgetPass,
                          child: Text(
                            getTranslated(context, 'forget_pass'),
                            style: const TextStyle(color: Colors.blue),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: iconList
                              .map((item) => IconBtn(imgUrl: item))
                              .toList(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(getTranslated(context, 'new_user'),
                              style: const TextStyle(
                                color: Colors.black,
                              )),
                          const SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: handleSignUpRoute,
                            child: Text(getTranslated(context, 'sign_up'),
                                style: const TextStyle(
                                  color: Colors.blue,
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
