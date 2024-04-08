import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class SimpleTopicItem extends StatefulWidget {
  final String title;
  final int term;
  final dynamic author;
  final bool isDraft;
  final void Function() handleTap;
  const SimpleTopicItem(
      {super.key,
      required this.title,
      required this.term,
      required this.author,
      required this.isDraft,
      required this.handleTap});

  @override
  SimpleTopicItemState createState() => SimpleTopicItemState();
}

class SimpleTopicItemState extends State<SimpleTopicItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 12),
            child: Text("${widget.term} ${getTranslated(context, "term")}"),
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
          ),
        ],
      ),
    );
  }
}
