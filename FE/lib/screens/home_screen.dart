import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void handleChangeLanguage () {
    Locale newLocale = locale('english');
    MyApp.setLocale(context, newLocale);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(getTranslated(context, 'next')),
        OutlinedButton(onPressed: handleChangeLanguage, child: const Text('change'))
      ],
    );
  }
}