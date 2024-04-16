import 'package:flutter/material.dart';
import 'package:wordwizzard/localization/language_constant.dart';
import 'package:wordwizzard/widgets/avatar.dart';
import 'package:wordwizzard/widgets/custom_shadow_box.dart';

class SimpleTopicItem extends StatefulWidget {
  final String title;
  final int term;
  final dynamic author;
  final bool isDraft;
  final bool isSelected;
  final bool canSelected;
  final void Function() handleTap;
  const SimpleTopicItem(
      {super.key,
      required this.title,
      required this.term,
      required this.author,
      required this.isDraft,
      required this.isSelected,
      required this.canSelected,          
      required this.handleTap});

  @override
  SimpleTopicItemState createState() => SimpleTopicItemState();
}

class SimpleTopicItemState extends State<SimpleTopicItem> {
  late bool isSeleted;

  @override
  void initState() {
    super.initState();
    isSeleted = widget.isSelected;
  }

  void handleTap() {
    setState(() {
      isSeleted = !isSeleted;
    });
    widget.handleTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            boxShadow: [
              CustomBoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                blurRadius: 4,
              )
            ],
            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(isSeleted && widget.canSelected ? 1 : 0.5), width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 12),
              child: Text("${widget.term} ${getTranslated(context, "term")}"),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Avatar(publicId: widget.author["avatar"], radius: 14),
                  const VerticalDivider(),
                  Text(widget.author["name"])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
