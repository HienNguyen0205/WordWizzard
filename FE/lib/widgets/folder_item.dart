import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
            width: 1,
            color: Colors
                .grey[300]!), // Thiết lập độ rộng và màu sắc của đường viền
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
            Row(
              children: [
                Text("${widget.topicQuantity} topics"),
                const VerticalDivider(thickness: 2, color: Colors.black),
                CircleAvatar(
                  radius: 14,
                  child: widget.author["avatar"] != null
                      ? Image.network(widget.author["avatar"])
                      : SvgPicture.asset("assets/images/avatar/avatar.svg"),
                ),
                const SizedBox(width: 8),
                Text(widget.author["name"])
              ],
            )
          ],
        ),
      ),
    );
  }
}
