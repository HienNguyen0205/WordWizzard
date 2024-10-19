import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/locale_provider.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({ super.key });

  @override
  ChangeLanguageScreenState createState() => ChangeLanguageScreenState();
}

class ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  List<String> localeOpts = [vietnamese, english];

  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Locale? localeVal = context.watch<LocaleProvider>().localeVal;
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "languages"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(onPressed: handleBack, icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(getTranslated(context, localeOpts[index])),
            trailing: localeVal == locale(localeOpts[index]) ? const FaIcon(FontAwesomeIcons.check, color: Colors.green): null,
            onTap: () {
              context.read<LocaleProvider>().changeLocale(locale(localeOpts[index]));
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 0, indent: 0, thickness: 2),
        itemCount: 2
      ),
    );
  }
}