import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/topic.dart';
import 'package:wordwizzard/widgets/avatar.dart';

class TopicDetailsScreen extends StatefulWidget {
  final String topicId;
  const TopicDetailsScreen({super.key, required this.topicId});

  @override
  TopicDetailsScreenState createState() => TopicDetailsScreenState();
}

class TopicDetailsScreenState extends State<TopicDetailsScreen> {
  int sliderIndex = 0;

  void handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: handleBack,
              icon: const FaIcon(FontAwesomeIcons.arrowLeft)),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.ellipsis),
            ),
          ],
        ),
        body: FutureBuilder(
          future: handleTopicDetails(widget.topicId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data?["code"] == 0) {
              dynamic data = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      height: 240.0,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.8),
                        itemCount: data["listWords"].length,
                        onPageChanged: (int page) {
                          setState(() {
                            sliderIndex = page;
                          });
                        },
                        itemBuilder: (BuildContext context, int index) {
                          double scaleFactor = 1.0;
                          if (index == sliderIndex) {
                            scaleFactor = 1.0;
                          } else {
                            scaleFactor = 0.7;
                          }
                          return AnimatedContainer(
                              transformAlignment: Alignment.center,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              transform: Matrix4.diagonal3Values(
                                  scaleFactor, scaleFactor, 1.0),
                              child: FlipCard(
                                  fill: Fill.fillBack,
                                  direction: FlipDirection.VERTICAL,
                                  speed: 300,
                                  front: Card(
                                      child: Center(
                                    child: Text(
                                      data["listWords"][index]["word"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 32.0),
                                    ),
                                  )),
                                  back: Card(
                                      child: Center(
                                    child: Text(
                                      data["listWords"][index]["word"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 32.0),
                                    ),
                                  ))));
                        },
                      ),
                    ),
                    Text(
                      data["name"],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: IntrinsicHeight(
                          child: Row(children: [
                            Avatar(
                                publicId: data["createdBy"]["image"],
                                radius: 14),
                            const VerticalDivider(),
                            Text(data["createdBy"]["username"])
                          ]),
                        ))
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data?["code"] == -1) {
              context.read<AuthProvider>().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(signInRoute, (route) => false);
            }
            return Center(
              child: Lottie.asset('assets/animation/loading.json', height: 80),
            );
          },
        ));
  }
}
