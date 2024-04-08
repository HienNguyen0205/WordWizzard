import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class SettingAccessScope extends StatefulWidget {
  const SettingAccessScope(
      {super.key, required this.accessScope, required this.setAccessScope});
  final String accessScope;
  final void Function(String scope) setAccessScope;

  @override
  SettingAccessScopeState createState() => SettingAccessScopeState();
}

class SettingAccessScopeState extends State<SettingAccessScope> {
  late List<String> accessScopeItem;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    accessScopeItem = ['PRIVATE', 'PUBLIC'];
    selectedIndex = accessScopeItem.indexOf(widget.accessScope);
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
    widget.setAccessScope(accessScopeItem[selectedIndex]);
    handleBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "who_can_see")),
        centerTitle: true,
        leading: IconButton(
            onPressed: handleBack,
            icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
        actions: [
          TextButton(
              onPressed: handleDone,
              child: Text(getTranslated(context, "done"),
                  style: Theme.of(context).textTheme.titleLarge))
        ],
      ),
      body: ListView.builder(
          itemCount: 2,
          itemBuilder: (contex, index) {
            return ListTile(
              title: Text(getTranslated(context, accessScopeItem[index])),
              trailing: selectedIndex == index
                  ? const FaIcon(FontAwesomeIcons.check)
                  : null,
              onTap: () {
                handleSelectAccessScope(index);
              },
            );
          }),
    );
  }
}
