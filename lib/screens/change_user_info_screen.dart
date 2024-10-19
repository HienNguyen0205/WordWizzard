import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/user.dart';
import 'package:wordwizzard/stream/user_stream.dart';
import 'package:wordwizzard/utils/image_picker_controller.dart';
import 'package:wordwizzard/utils/verify.dart';
import 'package:wordwizzard/widgets/avatar.dart';
import 'package:wordwizzard/widgets/custom_toast.dart';

class ChangeUserInfoScreen extends StatefulWidget {
  const ChangeUserInfoScreen({super.key});

  @override
  ChangeUserInfoScreenState createState() => ChangeUserInfoScreenState();
}

class ChangeUserInfoScreenState extends State<ChangeUserInfoScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String? fullname = '';
  String? phone = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  late FToast fToast;
  ImagePickerController imagePicker = ImagePickerController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    UserStream().getUserData();
  }

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void handleChangeAvatar() async {
    XFile? image = await handleGetAvatar();
    if (image != null) {
      dynamic res = await handleUpdateAvatar(image);
      if (res["status"]) {
        UserStream().getUserData();
      }
    }
  }

  void _submitForm() {
    final FormState? form = _form.currentState;
    if (form != null && form.validate()) {
      form.save();
      handleUpdateUserInfo(fullname as String, phone as String).then((val) {
        if (val["code"] == 0) {
          UserStream().getUserData();
          fToast.showToast(
              child: const CustomToast(
                  text: "update_profile_success"),
              gravity: ToastGravity.BOTTOM);
        }
      });
    }
  }

  Future<XFile?> handleGetAvatar() async {
    return imagePicker.getImage();
  }

  handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "edit_profile"),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
          onPressed: handleBack,
          icon: const FaIcon(FontAwesomeIcons.chevronLeft),
        ),
      ),
      body: StreamBuilder(
        stream: UserStream().userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic data = snapshot.data["data"];
            emailController = TextEditingController(text: data["email"]);
            fullNameController = TextEditingController(text: data["fullname"]);
            phoneController = TextEditingController(text: data["phone"]);
            fullname = data["fullname"];
            phone = data["phone"];
            return Container(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: GestureDetector(
                            onTap: handleChangeAvatar,
                            child:
                                Avatar(publicId: data["image"], radius: 48))),
                    Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 32),
                        child: Text(
                          data["username"],
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        )),
                    Form(
                        key: _form,
                        child: Column(children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                              labelText: getTranslated(context, "full_name"),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(),
                              errorBorder: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val!.length > 30) {
                                return getTranslated(
                                    context, "exceed_full_name");
                              }
                              return null;
                            },
                            onSaved: (val) {
                              fullname = val!;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).nextFocus();
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: getTranslated(context, "phone_number"),
                              border: const OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(),
                              errorBorder: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if (!isPhoneNumberValid(val as String) && val.isNotEmpty) {
                                return getTranslated(
                                    context, "invalid_phone_number");
                              }
                              return null;
                            },
                            onSaved: (val) {
                              phone = val!;
                            },
                            onEditingComplete: _submitForm,
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton(
                              onPressed: _submitForm,
                              child: Text(
                                getTranslated(context, "update"),
                              ),
                            ),
                          ),
                        ]))
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            context.read<AuthProvider>().logOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(signInRoute, (route) => false);
          }
          return Center(
            child: Lottie.asset('assets/animation/loading.json', height: 80),
          );
        },
      ),
    );
  }
}
