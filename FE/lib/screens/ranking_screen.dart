import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({ super.key });

  @override
  RankingScreenState createState() => RankingScreenState();
}

class RankingScreenState extends State<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "ranking"), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 18, left: 18, right: 18, bottom: 24),
        child: Column(
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 36),
              height: (MediaQuery.of(context).size.width - 36) / 100 * 120,
              child: LayoutBuilder(
              builder:(context, constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: constraints.maxWidth / 100 * 33,
                          height: constraints.maxHeight / 100 * 33,
                          color: Theme.of(context).cardColor,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("C"),
                              Text("1"),
                            ],
                          ),
                        ),
                        // Positioned(
                        //   top: ,
                        //   left: (constraints.maxWidth / 100 * 33) / 50 - ,
                        //   child: 
                        // ),
                      ],
                    )
                  ],
                );
              },
            ),
            )
          ],
        ),
      ),
    );
  }
}