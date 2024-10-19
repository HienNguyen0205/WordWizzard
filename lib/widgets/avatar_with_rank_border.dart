import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:wordwizzard/constants/constants.dart';

class AvatarWithRankBorder extends StatefulWidget {
  final String? publicId;
  final double radius;
  final String rank;
  const AvatarWithRankBorder({ super.key, this.publicId, required this.radius, required this.rank });

  @override
  AvatarWithRankBorderState createState() => AvatarWithRankBorderState();
}

class AvatarWithRankBorderState extends State<AvatarWithRankBorder> {

  late String? publicId;
  late double radius;

  @override
  void initState() {
    publicId = widget.publicId;
    radius = widget.radius;
    super.initState();
  }

  @override
  void didUpdateWidget(AvatarWithRankBorder oldWidget) {
    if (oldWidget.publicId != widget.publicId) {
      setState(() {
        publicId = widget.publicId;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  String getRankBorder(){
    return rank.firstWhere((item) => item.tag == widget.rank).border;
  }

  @override
  Widget build(BuildContext context) {
    double size = radius * (512 / 95);
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
              children: [
                Positioned(
                  top: size / 2 - radius - size * 19 / 512,
                  left: size / 2 - radius,
                  child: CircleAvatar(
                        radius: widget.radius,
                        child: publicId != null
                            ? CldImageWidget(
                                publicId: publicId as String,
                                transformation: Transformation()
                                  ..addTransformation(
                                      "c_thumb,ar_1.0,c_fill,g_face,b_transparent/r_max/f_auto"),
                                placeholder: (context, url) {
                                  return AspectRatio(
                                    aspectRatio: 1.6,
                                    child: Center(
                                      child: Lottie.asset(
                                          'assets/animation/loading.json',
                                          height: 80),
                                    ),
                                  );
                                },
                                placeholderFadeInDuration:
                                    const Duration(milliseconds: 200),
                              )
                            : SvgPicture.asset(
                                "assets/images/avatar/avatar.svg"))
                ),
                Positioned.fill(child: Image.asset(
                getRankBorder(), scale: 1, width: size,),
              )
              ],
            )
    );
  }
}