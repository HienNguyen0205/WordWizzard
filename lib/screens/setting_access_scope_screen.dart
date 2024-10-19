import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/access_scope_provider.dart';

class SettingAccessScope extends StatefulWidget {
  const SettingAccessScope(
      {super.key});

  @override
  SettingAccessScopeState createState() => SettingAccessScopeState();
}

class SettingAccessScopeState extends State<SettingAccessScope> {
  List<String> accessScopeItem = ['PRIVATE', 'PUBLIC'];
  late int selectedIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    String accessScope = context.watch<AccessScopeProvider>().accessScope;
    selectedIndex = accessScopeItem.indexOf(accessScope);
  }

  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }

  void handleSelectAccessScope(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void handleDone() {
    int count = 0;
    context.read<AccessScopeProvider>().setAccessScope(accessScopeItem[selectedIndex]);
    Navigator.of(context).popUntil((route) {
      return count++ == 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "who_can_see"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
        centerTitle: true,
        leading: IconButton(
            onPressed: handleBack,
            icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
        actions: [
          TextButton(
              onPressed: handleDone,
              child: Text(getTranslated(context, "done")))
        ],
      ),
      body: ListView.separated(
          itemCount: 2,
          itemBuilder: (contex, index) {
            return ListTile(
              title: Text(getTranslated(context, accessScopeItem[index] == "PUBLIC" ? "everyone" : "only_me")),
              trailing: selectedIndex == index
                  ? const FaIcon(FontAwesomeIcons.check)
                  : null,
              onTap: () {
                handleSelectAccessScope(index);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          ),
    );
  }
}
