import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/auth/auth_provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/services/auth.dart';
import 'package:wordwizzard/utils/verify.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key, required this.userId});
  final String userId;

  @override
  ChangePassScreenState createState() => ChangePassScreenState();
}

class ChangePassScreenState extends State<ChangePassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  String _password = '';

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      form.save();
      handleChangePass(_password, widget.userId).then((value) {
        if (value["code"] == 0) {
          authProvider.logIn();
          Fluttertoast.showToast(
              msg: getTranslated(context, "change_pass_success"),
              backgroundColor: Colors.green,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          Fluttertoast.showToast(
              msg: getTranslated(context, "change_pass_fail"),
              backgroundColor: Colors.red,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "create_new_pass")),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 200,
                child:
                    SvgPicture.asset('assets/images/reset_pass/reset_pass.svg'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(
                                context, "empty_password_err_mess");
                          } else if (!isPasswordValid(value)) {
                            return getTranslated(
                                context, "invalid_password_err_mess");
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: getTranslated(context, "password"),
                        ),
                        onSaved: (value) {
                          _password = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(
                                context, "empty_password_err_mess");
                          } else if (_passwordController.text != value) {
                            return getTranslated(
                                context, "wrong_confirm_password_error_mess");
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: getTranslated(context, "confirm_password"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                    onPressed: _submitForm,
                    child: Text(
                      getTranslated(context, "save"),
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
