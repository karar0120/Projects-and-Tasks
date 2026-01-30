import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/utils/UserDataController.dart';
import 'package:projectsandtasks/shared/widgets/loader_widget.dart';
import '../../../Core/styles/Colors.dart';

class GeneralButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color buttonBackgroundColor;
  final Color? borderColor;
  final Color? texColor;
  final String title;
  final BoxShape? shape;
  /// When true, shows a small loader inside the button instead of the title.
  final bool isLoading;
  /// Size of the in-button loader (fraction of shortest side). Default 0.05 for small loader.
  final double loadingSize;

  const GeneralButton({
    Key? key,
    this.width = double.infinity,
    this.height = 45,
    this.radius = 6,
    this.buttonBackgroundColor = ColorConsts.gunmetalBlue,
    this.borderColor,
    this.texColor,
    required this.title,
    this.shape,
    this.isLoading = false,
    this.loadingSize = 0.05,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? buttonBackgroundColor),
        color: buttonBackgroundColor,
        shape: shape ?? BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: isLoading
            ? LoaderWidget(sizeLoader: loadingSize, color:Colors.white)
            : Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: texColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}

class SpecialGeneralButton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color buttonBackgroundColor;
  final Color? borderColor;
  final Widget iconOrTitle;

  const SpecialGeneralButton(
      {Key? key,
        this.width = double.infinity,
        this.height = 45,
        this.radius = 6,
        this.buttonBackgroundColor = ColorConsts.gunmetalBlue,
        this.borderColor,
        required this.iconOrTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDataController = Provider.of<UserDataController>(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: userDataController.langg == 'ar'
            ? const BorderRadius.only(
            bottomLeft: Radius.circular(6), topLeft: Radius.circular(6))
            : const BorderRadius.only(
            bottomRight: Radius.circular(6), topRight: Radius.circular(6)),
        border: Border.all(color: borderColor ?? buttonBackgroundColor),
        color: buttonBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(child: iconOrTitle),
    );
  }
}

class DefaultTextButton extends StatelessWidget {
  final String title;
  final Widget? screen;
  final Color? color;
  final bool isFinish;
  final GestureTapCallback? onTap;
  final double? fontSize;
  final FontWeight? fontWeight;
  final AlignmentDirectional align;

  const DefaultTextButton(
      {Key? key,
        required this.title,
        this.screen,
        this.fontSize,
        this.fontWeight,
        this.color,
        this.onTap,
        this.isFinish = false,
        this.align = AlignmentDirectional.centerEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: align,
      child: GestureDetector(
        key: key,
        onTap: onTap,
        child: Text(
          key: key,
          title,
          style: TextStyle(
            color: color ?? ColorConsts.gunmetalBlue,
            fontFamily: StringConsts.familyFontRegular,
            fontWeight: fontWeight ?? FontWeight.w500,
            fontSize: fontSize ?? 15,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}


class GeneralButtonWithIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? icon;
  final Widget? title;
  final Color? color;
  final Color? borderColor;
  final double? elevation;

  const GeneralButtonWithIcon(
      {super.key,
        this.width,
        this.height,
        this.title,
        this.icon,
        this.color,
        this.borderColor,
        this.elevation});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? ColorConsts.gunmetalBlue,
      borderRadius: BorderRadius.circular(6),
      elevation: elevation!,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: color ?? ColorConsts.gunmetalBlue,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor!)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon!,
            const SizedBox(
              width: 4,
            ),
            title!
          ],
        ),
      ),
    );
  }
}
