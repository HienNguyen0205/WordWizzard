import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordwizzard/providers/id_container_provider.dart';
import 'package:wordwizzard/widgets/custom_shadow_box.dart';

class SimpleFolderItem extends StatefulWidget {
  final String id;
  final String title;
  final bool initState;
  const SimpleFolderItem(
      {super.key,
      required this.id,
      required this.title,
      required this.initState});

  @override
  SimpleFolderItemState createState() => SimpleFolderItemState();
}

class SimpleFolderItemState extends State<SimpleFolderItem> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.initState;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isSelected) {
      context.read<IdContainerProvider>().addId(widget.id);
    }
  }

  void onTap() {
    if (isSelected) {
      context.read<IdContainerProvider>().removeId(widget.id);
    } else {
      context.read<IdContainerProvider>().addId(widget.id);
    }
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context)
                  .primaryColor
                  .withOpacity(isSelected ? 1 : 0.5),
              width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            CustomBoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              blurRadius: 4,
            )
          ],
        ),
        child: Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
