import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/services/user.dart';
import 'package:wordwizzard/utils/verify.dart';
import 'package:wordwizzard/widgets/custom_toast.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key, required this.userId, required this.changeType});
  final String userId;
  final String changeType;

  @override
  ChangePassScreenState createState() => ChangePassScreenState();
}

class ChangePassScreenState extends State<ChangePassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newPwController = TextEditingController();
  String newPw = '';
  String pw = '';
  late FToast fToast;
  late String userId;
  late String changeType;

  @override
  void initState() {
    super.initState();
    changeType = widget.changeType;
    userId = widget.userId;
    fToast = FToast();
    fToast.init(context);
  }

  void _submitForm() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      if(changeType == "reset"){
        handleResetPass(newPw, userId).then((val) {
          changePassRes(val["code"] == 0);
        });
      }else{
        handleChangePw(pw, newPw).then((val) {
          changePassRes(val["code"] == 0);
        });
      }
    }
  }

  void changePassRes(bool status) {
    if (status) {
      fToast.showToast(
          child: CustomToast(
              text: getTranslated(context, "change_pass_success"),
              color: Colors.green),
          gravity: ToastGravity.BOTTOM);
      if(changeType == "reset"){
        Navigator.of(context).popUntil((route) => route.isFirst);
      }else{
        Navigator.of(context).pop();
      }
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "create_new_pass"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
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
                      changeType == "change" ?
                      TextFormField(
                        textInputAction: TextInputAction.next,
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
                          labelText: getTranslated(context, "current_pw"),
                        ),
                        onSaved: (value) {
                          pw = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                      ) : const SizedBox.shrink(),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _newPwController,
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
                          newPw = value!;
                        },
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
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
                          } else if (_newPwController.text != value) {
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
                        onEditingComplete: _submitForm,
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
