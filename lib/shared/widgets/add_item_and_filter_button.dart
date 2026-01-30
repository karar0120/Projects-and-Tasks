import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/styles/Sizes.dart';

class AddGeneralSquareButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const AddGeneralSquareButton({required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: ColorConsts.gunmetalBlue,
        child: SizedBox(
          height: SizeConsts.s35,
          width: SizeConsts.s35,
          child: Transform.scale(
            scale: 1.4,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


class FilterGeneralSquareButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const FilterGeneralSquareButton({required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: ColorConsts.whiteColor,
        child: SizedBox(
          height: SizeConsts.s35,
          width: SizeConsts.s35,
          child: Transform.scale(
            scale: 1.4,
            child:  SvgPicture.asset(
              ImageConsts.filterBTNSquare,
            ),
          ),
        ),
      ),
    );
  }
}


class SortGeneralSquareButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const SortGeneralSquareButton({required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: ColorConsts.whiteColor,
        child: SizedBox(
          height: SizeConsts.s35,
          width: SizeConsts.s35,
          child: Transform.scale(
            scale: 1.4,
            child:  const Icon(
              Icons.filter_list,
              color: ColorConsts.gunmetalBlue,
            ),
          ),
        ),
      ),
    );
  }
}


class ShareGeneralSquareButton extends StatelessWidget {
  final GestureTapCallback onTap;

  const ShareGeneralSquareButton({required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        color: ColorConsts.whiteColor,
        child: SizedBox(
          height: SizeConsts.s35,
          width: SizeConsts.s35,
          child: Transform.scale(
            scale: 1.4,
            child:  SvgPicture.asset(
                ImageConsts.share),
          ),
        ),
      ),
    );
  }
}
