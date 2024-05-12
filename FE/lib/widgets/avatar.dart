import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery.dart';
import 'package:cloudinary_url_gen/transformation/delivery/delivery_actions.dart';
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

  late String? publicId;

  @override
  void initState() {
    publicId = widget.publicId;
    super.initState();
  }

  @override
  void didUpdateWidget(Avatar oldWidget){
    if(oldWidget.publicId != widget.publicId){
      setState(() {
        publicId = widget.publicId;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: widget.radius,
        child: publicId != null
            ? CldImageWidget(
                publicId: publicId as String,
                transformation: Transformation()
                  ..delivery(Delivery.format(Format.auto))
                  ..delivery(Delivery.quality(Quality.auto()))
                  ..addTransformation("ar_1.0,c_fill,w_320/r_max/f_auto"),
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
