import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery_actions.dart';
import 'package:cloudinary_url_gen/transformation/resize/resize.dart';
import 'package:cloudinary_url_gen/transformation/transformation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class Avatar extends StatefulWidget {
  final String? publicId;
  final double? radius;
  const Avatar({super.key, this.publicId, this.radius});

  @override
  AvatarState createState() => AvatarState();
}

class AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: widget.radius,
        child: widget.publicId != null
            ? CldImageWidget(
                publicId: widget.publicId as String,
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
                      child: Lottie.asset('assets/animation/loading.json',
                          height: 80),
                    ),
                  );
                },
                placeholderFadeInDuration: const Duration(milliseconds: 200),
              )
            : SvgPicture.asset("assets/images/avatar/avatar.svg"));
  }
}
