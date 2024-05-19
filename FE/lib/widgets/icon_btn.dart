import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class IconBtn extends StatelessWidget {
  const IconBtn({super.key, required this.imgUrl});

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(200, 18, 18, 18)),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        child: SvgPicture.asset(imgUrl, width: 32, height: 32));
  }
}
