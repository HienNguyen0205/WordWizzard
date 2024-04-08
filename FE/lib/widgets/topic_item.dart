import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery_actions.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:wordwizzard/localization/language_constant.dart';

class TopicItem extends StatefulWidget {
  const TopicItem(
      {super.key,
      required this.title,
      required this.termQuantity,
      required this.publicId,
      required this.author,
      required this.handleTap});
  final String title;
  final int termQuantity;
  final String publicId;
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
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: CldImageWidget(
                  publicId: widget.publicId,
                  transformation: Transformation()
                    ..delivery(Delivery.format(Format.auto))
                    ..delivery(Delivery.quality(Quality.auto()))
                    ..resize(Resize.fit()
                      ..width(320)
                      ..height(200)),
                  placeholder: (context, url) {
                    return AspectRatio(
                      aspectRatio: 1.6,
                      child: Center(
                        child: Lottie.asset('assets/loading/loading.json',
                            height: 80),
                      ),
                    );
                  },
                  placeholderFadeInDuration: const Duration(milliseconds: 200),
                ),
              ),
              Positioned(
                top: 18,
                left: 18,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.grey),
                  child: Text(
                      "${widget.termQuantity} ${getTranslated(context, "term")}",
                      style: const TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12,),
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
