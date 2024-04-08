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
      debouncer.run(() {
        handleGetAllTopics(null, keyWords, 5).then((val) {
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
        title: Text(getTranslated(context, "search")),
        centerTitle: true,
        leading: IconButton(
            onPressed: handleBack,
            icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                autoFocus: true,
                controller: controller,
                leading: const Padding(padding: EdgeInsets.symmetric(horizontal: 12),child: FaIcon(FontAwesomeIcons.magnifyingGlass),),
                onTap: () {
                  controller.openView();
                },
                onChanged: (val) {
                  handleOnChange(val);
                  controller.openView();
                },
                onSubmitted: (val) {
                  controller.closeView(val);
                  handleOnChange(val);
                },
              );
            }, 
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return suggestList.map((item) {
                return ListTile(
                  title: Text(item["name"]),
                  onTap: () {
                    setState(() {
                      controller.closeView(item["name"]);
                    });
                  },
                );
              });
            }),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                ],
              ),
            )
        ],),
      ),
    );
  }
}