import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/providers/theme_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/stream/user_stream.dart';
import 'package:wordwizzard/widgets/avatar_with_rank_border.dart';
import 'package:wordwizzard/widgets/setting_section.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {

  @override
  void initState() {
    super.initState();
    UserStream().getUserData();
  }

  void handleUpdateUserInfo() {}

  void hanleChangeLanguage() {
    Navigator.of(context).pushNamed(changeLanguageRoute);
  }

  void handleChangeThemeMode() {
    context.read<ThemeProvider>().changeThemeMode();
  }

  void handleLogOut() {
    context.read<AuthProvider>().logOut();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(signInRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "setting"),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: UserStream().userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dynamic userData = snapshot.data["data"];
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AvatarWithRankBorder(publicId: userData["image"], radius: 36, rank: ''),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(userData["username"],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600)),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ListView(
                          children: [
                            SettingSection(
                                title: getTranslated(context, "account"),
                                settingsOptions: [
                                  ListTile(
                                    leading: Container(
                                        alignment: Alignment.center,
                                        width: 32,
                                        height: 32,
                                        child: const FaIcon(
                                            FontAwesomeIcons.solidAddressBook)),
                                    trailing: const FaIcon(
                                        FontAwesomeIcons.angleRight),
                                    title: Text(
                                        getTranslated(context, "edit_profile")),
                                    onTap: () {},
                                  ),
                                  const Divider(height: 0, indent: 0, thickness: 2),
                                  ListTile(
                                    leading: Container(
                                        alignment: Alignment.center,
                                        width: 32,
                                        height: 32,
                                        child: const FaIcon(
                                            FontAwesomeIcons.language)),
                                    trailing: const FaIcon(
                                        FontAwesomeIcons.angleRight),
                                    title: Text(
                                        getTranslated(context, "languages")),
                                    onTap: hanleChangeLanguage,
                                  ),
                                ]),
                            SettingSection(
                                title: getTranslated(context, "display"),
                                settingsOptions: [
                                  ListTile(
                                      leading: Container(
                                          alignment: Alignment.center,
                                          width: 32,
                                          height: 32,
                                          child: const FaIcon(
                                              FontAwesomeIcons.moon)),
                                      trailing: Switch(
                                        onChanged: (val) {
                                          handleChangeThemeMode();
                                        },
                                        value: context.watch<ThemeProvider>().mode == ThemeMode.dark ? true : false,
                                      ),
                                      title: Text(
                                          getTranslated(context, "dark_mode")))
                                ]),
                            const SizedBox(height: 18),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    Colors.red,
                                borderRadius: BorderRadius.circular(
                                    8),
                              ),
                              child: FilledButton(
                                style: FilledButton.styleFrom(backgroundColor: Colors.red, shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                                  onPressed: handleLogOut,
                                  child: Text(
                                    getTranslated(context, "log_out"),
                                    style: const TextStyle(fontSize: 18),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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
