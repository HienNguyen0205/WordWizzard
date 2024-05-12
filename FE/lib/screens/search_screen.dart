import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/utils/debouncing.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ super.key });

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  List suggestList = [];
  final Debouncer debouncer = Debouncer(milliseconds: 500);

  void handleBack () {
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
  }

  void handleOnChange (String keyWords) {
    if(keyWords.isNotEmpty){
      debugPrint(keyWords);
      debouncer.run(() {
        handleGetAllTopics(1, keyWords, 5).then((val) {
          debugPrint(val.toString());
          setState(() {
            suggestList = val["data"];
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "search"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
        leading: IconButton(
            onPressed: handleBack,
            icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          SearchAnchor(
            viewOnChanged: (val) {
              handleOnChange(val);
            },
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                leading: const Padding(padding: EdgeInsets.symmetric(horizontal: 12),child: FaIcon(FontAwesomeIcons.magnifyingGlass),),
                onTap: () {
                  controller.openView();
                },
              );
            }, 
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              debugPrint('re-render');
              List<Widget> suggestionWidgets = suggestList.map((item) {
                return ListTile(
                  title: Text(item["name"]),
                  onTap: () {
                    setState(() {
                      controller.closeView(item["name"]);
                    });
                  },
                );
              }).toList();
              return suggestionWidgets;
            }),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: const [
                ],
              ),
            )
        ],),
      ),
    );
  }
}