import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/styles/Sizes.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';


class DescriptionTitle extends StatelessWidget {
  final String descriptionText;
  final double? fonSize;
  const DescriptionTitle({super.key,required this.descriptionText,this.fonSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.info,
          color: ColorConsts.warmGrey,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "${AppLocalizations.of(context)!.trans(descriptionText)}",
          style: TextStyle(
              fontSize:fonSize?? FontSizeConsts.s8.sp,
              color: ColorConsts.pinkishGrey),
        ),
      ],
    );
  }
}
