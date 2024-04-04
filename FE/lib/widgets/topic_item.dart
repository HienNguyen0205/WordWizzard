import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class TopicItem extends StatefulWidget {
  const TopicItem(
      {super.key,
      required this.title,
      required this.termQuantity,
      required this.imgSrc,
      required this.author,
      required this.handleTap});
  final String title;
  final int termQuantity;
  final String imgSrc;
  final dynamic author;
  final void Function() handleTap;

  @override
  TopicItemState createState() => TopicItemState();
}

class TopicItemState extends State<TopicItem> {
  void handleTap() {}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.handleTap,
      child: Card(
        shadowColor: Colors.transparent,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Image.network(widget.imgSrc, scale: 1.6, width: double.infinity),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.grey),
                  child: Text(
                      "${widget.termQuantity} ${getTranslated(context, "term")}",
                      style: const TextStyle(color: Colors.white)),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      child: widget.author["avatar"] != null
                          ? Image.network(widget.author["avatar"])
                          : SvgPicture.asset("assets/images/avatar/avatar.svg"),
                    ),
                    const SizedBox(width: 12),
                    Text(widget.author["name"])
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
