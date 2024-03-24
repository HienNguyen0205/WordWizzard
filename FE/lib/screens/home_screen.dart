// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // void changeLanguage() async {
  //   Locale currentLocale = await getLocale();
  //   Locale locale;
  //   if(currentLocale.languageCode == 'vi'){
  //     locale = await setLocale('en');
  //   }else{
  //     locale = await setLocale('vi');
  //   }
  //   MyApp.setLocale(context, locale);
  // }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView()
    );
  }
}