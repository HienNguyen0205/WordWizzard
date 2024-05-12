import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class AvatarWithRankBorder extends StatefulWidget {
  final String? publicId;
  final double? radius;
  final String rank;
  const AvatarWithRankBorder({ super.key, this.publicId, this.radius, required this.rank });

  @override
  AvatarWithRankBorderState createState() => AvatarWithRankBorderState();
}

class AvatarWithRankBorderState extends State<AvatarWithRankBorder> {

  late String? publicId;

  @override
  void initState() {
    publicId = widget.publicId;
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 2,
      width: MediaQuery.of(context).size.width / 2,
      child: LayoutBuilder(
          builder: (context, constraints) {
            double avatarRadius = constraints.maxWidth / 5.39;
            return Stack(
              children: [
                Positioned(
                  top: constraints.maxHeight / 2 - avatarRadius - constraints.maxHeight / 20.57,
                  left: constraints.maxWidth / 2 - avatarRadius,
                  child: CircleAvatar(
                        radius: avatarRadius,
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
                Positioned.fill(child: Image.asset('assets/images/ranking/Level_8.png', scale: 1, width: MediaQuery.of(context).size.width / 2,),
              )
              ],
            );
          },
        ),
    );
  }
}