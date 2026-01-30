

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';


import '../../Core/styles/Colors.dart';

class CachedNetworkImageCircular extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double minRadius;
  final double maxRadius;
  final String imageError;
  final double? width;
  const CachedNetworkImageCircular({
    super.key,
    required this.imageUrl,
    this.height = 50,
    this.minRadius = 12,
    this.maxRadius = 28,
    required this.imageError,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return CachedNetworkImage(
      imageUrl:imageUrl,
      height: height,
      width: width,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        minRadius: minRadius,
        maxRadius: maxRadius,
        backgroundImage: imageProvider,
        backgroundColor: ColorConsts.whiteColor,
      ),
      placeholder: (context, url) => Center(
        child: LoadingAnimationWidget.discreteCircle(
            color: ColorConsts.gunmetalBlue,
            size: 30,
            secondRingColor: Colors.transparent,
            thirdRingColor: Colors.transparent
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width:media.width*0.3,
        height:currentOrientation==Orientation.landscape?media.width*0.2:media.height*0.14,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConsts. whiteColor
        ),
        child: Image.asset(
          width:media.width*0.3,
          height:media.height*0.14 ,
          '${ImageConsts.assets}$imageError',
          scale: 0.5,
        ),
      ),
    );
  }
}


class CachedNetworkImageNormal extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double minRadius;
  final double maxRadius;

  const CachedNetworkImageNormal({Key? key,
    required this.imageUrl,
    this.height = 50,
    this.minRadius = 12,
    this.maxRadius = 28,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: height,
        decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider)
        ),
      ),
      placeholder: (context, url) => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(ImageConsts.profile))
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: media.width*0.3,
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color:ColorConsts.imageColor),
        child: Image.asset(
          ImageConsts.profileImagePlaceHolderPng,
        ),
      ),
    );
  }
}




class CachedNetworkImageNo extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  //final double maxRadius;

  const CachedNetworkImageNo({super.key,
    required this.imageUrl,
    this.height=100,
    this.width=90,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        fit: BoxFit.cover,
        width: width,
        placeholder: (context, url) => Center(
          child: LoadingAnimationWidget.discreteCircle(
              color: ColorConsts.gunmetalBlue,
              size: 30,
              secondRingColor: Colors.transparent,
              thirdRingColor: Colors.transparent
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: media.width*0.4,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            // color:  whiteColor
          ),
          child: SvgPicture.asset(
              ImageConsts.serviceImagePlaceHolderFilled),
        ),
      ),
    );
  }
}

