import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/utils/UserDataController.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';

class LanguagePopUpMenuItem extends StatelessWidget {
  final Color? iconColor;
  final Color? backGround;

  const LanguagePopUpMenuItem(
      {Key? key, this.iconColor = ColorConsts.gunmetalBlue, this.backGround})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDataController = Provider.of<UserDataController>(context);
    return PopupMenuButton(
      color: backGround ?? Theme.of(context).scaffoldBackgroundColor,
      icon: SvgPicture.asset(ImageConsts.language,
          color: iconColor, height: 0.05.sw),
      onSelected: (value) {
        userDataController.changeCurrentLanguage(context, value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'ar',
          child:
          Text("${AppLocalizations.of(context)!.trans(StringConsts.ar)}"),
        ),
        PopupMenuItem(
          value: 'en',
          child:
          Text("${AppLocalizations.of(context)!.trans(StringConsts.en)}"),
        ),
      ],
    );
  }
}
