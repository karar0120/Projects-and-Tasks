import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/styles/GeneralConstants.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/GeneralComponents.dart';

class ResetFilter extends StatelessWidget {
  final VoidCallback continueButton;
  const ResetFilter({super.key,
    required this.continueButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showAlertDialogContinue(context,
            content: '${AppLocalizations.of(context)!.trans(
                StringConsts.resetAllFields)}?',
            continuePressed: continueButton);
      },
      child: Row(
        children: [
          SvgPicture.asset(
            ImageConsts.notAvailableIcon,color: ColorConsts.tomato,
          ),
          horizontalExtremeSmallSpace,
          Text("${AppLocalizations.of(context)!.trans(StringConsts.resetAllFields)}",style: const TextStyle(color: Colors.red),),
        ],
      ),
    );
  }
}
