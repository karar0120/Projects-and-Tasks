import 'package:flutter/material.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/styles/GeneralConstants.dart';
import 'package:projectsandtasks/core/styles/Sizes.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';

class DividerWithPadding extends StatelessWidget {
  final double horizontalPadding;

  const DividerWithPadding({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: divider);
  }
}

class DividerOr extends StatelessWidget {
  const DividerOr({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(
                left: PaddingConsts.p10, right: PaddingConsts.p15),
            child: const Divider()),
      ),
      Text("${AppLocalizations.of(context)!.trans(StringConsts.or)}"),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(
                left: PaddingConsts.p15, right: PaddingConsts.p10),
            child: const Divider()),
      ),
    ]);
  }
}
