import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/providers/auth_provider.dart';
import 'package:wordwizzard/routes/route_contants.dart';
import 'package:wordwizzard/services/ranking.dart';
import 'package:wordwizzard/widgets/avatar.dart';
import 'package:wordwizzard/widgets/avatar_with_rank_border.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  RankingScreenState createState() => RankingScreenState();
}

class RankingScreenState extends State<RankingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "ranking"),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: handleGetRanking(50, 1),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data["code"] == 0){
            List<dynamic> rankingList = snapshot.data["data"];
            List<dynamic> userNotInChart = rankingList.skip(3).toList();
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.width - 36) * 0.6 * 0.33 - 18,
                      left: 18,
                      right: 18,
                      bottom: 18),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 36) * 0.9,
                    height: (MediaQuery.of(context).size.width - 36) * 0.6,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        double itemWidth = constraints.maxWidth * 0.3;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: itemWidth,
                                  height: constraints.maxHeight * 0.35,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7FC7D9),
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(rankingList[2]["username"], textAlign: TextAlign.center, style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(rankingList[2]["points"].toString()),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: -itemWidth - 18,
                                    left: -itemWidth * 0.25 / 1.5,
                                    child: AvatarWithRankBorder(
                                        publicId: rankingList[2]["image"],
                                        rank: rankingList[2]["rank"]["tag"], radius: itemWidth * 0.25)),
                              ],
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: itemWidth,
                                  height: constraints.maxHeight * 0.65,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(rankingList[0]["username"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(rankingList[0]["points"].toString()),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: -itemWidth - 18,
                                    left: -itemWidth * 0.25 / 1.5,
                                    child: AvatarWithRankBorder(
                                        publicId: rankingList[0]["image"],
                                        rank: rankingList[0]["rank"]["tag"], radius: itemWidth * 0.25)),
                              ],
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: itemWidth,
                                  height: constraints.maxHeight / 2,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(18),
                                        topRight: Radius.circular(18)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(rankingList[1]["username"],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(rankingList[1]["points"].toString()),
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: -itemWidth - 18,
                                    left: -itemWidth * 0.25 / 1.5,
                                    child: AvatarWithRankBorder(
                                        publicId: rankingList[1]["image"],
                                        rank: rankingList[1]["rank"]["tag"], radius: itemWidth * 0.25)),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: const Border(top: BorderSide(width: 1, color: Colors.grey)),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
                    ),
                    child: ListView.separated(
                      itemCount: userNotInChart.length,
                      itemBuilder:(context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                  child: Text((index + 4).toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12, bottom: 12, right: 18),
                                  child: Avatar(publicId: userNotInChart[index]["image"], radius: 24),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(userNotInChart[index]["username"], style: const TextStyle(fontWeight: FontWeight.w400)),
                                    Text(userNotInChart[index]["rank"]["name"]),
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: Text(userNotInChart[index]["points"].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                            )
                          ]
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                          indent: 12,
                          endIndent: 12,
                          color: Colors.grey,
                        );
                      }
                    ),
                  ),
                )
              ],
            );
          }else if(snapshot.hasData && snapshot.data["code"] == -1){
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
