import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wordwizzard/widgets/avatar.dart';

class FolderItem extends StatefulWidget {
  const FolderItem(
      {super.key,
      required this.title,
      required this.topicQuantity,
      required this.author,
      required this.handleTap});
  final String title;
  final int topicQuantity;
  final dynamic author;
  final void Function() handleTap;

  @override
  FolderItemState createState() => FolderItemState();
}

class FolderItemState extends State<FolderItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.handleTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1,
              color: Colors
                  .grey[300]!),
          borderRadius: BorderRadius.circular(8), // Thiết lập độ cong của góc
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.folder),
                  const SizedBox(width: 12),
                  Text(widget.title, style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 8),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Text("${widget.topicQuantity} topics"),
                    const VerticalDivider(),
                    Avatar(publicId: widget.author["avatar"], radius: 14),
                    const SizedBox(width: 8),
                    Text(widget.author["name"])
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
