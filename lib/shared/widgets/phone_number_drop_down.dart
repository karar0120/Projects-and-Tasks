import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import '../../../Core/styles/Colors.dart';
import '../../../Core/styles/GeneralConstants.dart';


class PhoneNumberDropDown extends StatelessWidget {
  final ValueChanged<PhoneNumber>? onInputChanged;
  final ValueChanged<bool>? onInputValidated;
  final String? locale;
  final TextEditingController? textFieldController;
  final PhoneNumber? initialValue;
  final Widget suffixIcon;
  const PhoneNumberDropDown({
    required this.onInputChanged,
    required this.onInputValidated,
    required this.locale,
    required this.textFieldController,
    required this.initialValue,
    required this.suffixIcon,
    super.key});

  @override
  Widget build(BuildContext context) {
    return  InternationalPhoneNumberInput(
      searchBoxDecoration: InputDecoration(
        //isDense: true,
          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          hintStyle: textFieldHintStyle,
          hintText: "${AppLocalizations.of(context)!.trans(StringConsts.Search)}",
          border: InputBorder.none),
      selectorConfig: SelectorConfig(
        leadingPadding: 5.0.sp,
        selectorType:
        PhoneInputSelectorType.BOTTOM_SHEET,
      ),
      onInputChanged:onInputChanged,
      onInputValidated:onInputValidated,
      cursorColor: ColorConsts.gunmetalBlue,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      locale:locale,
      ignoreBlank: true,
      formatInput: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: Theme.of(context).textTheme.bodyLarge,
      textFieldController:textFieldController,
      spaceBetweenSelectorAndTextField: 0,
      inputBorder: outlineInputBorder,
      initialValue: initialValue,
      textAlign :locale=='ar'? TextAlign.right:TextAlign.start,
      inputDecoration: InputDecoration(
        // contentPadding: const EdgeInsets.symmetric(
        //   horizontal: 10,
        //   vertical: 8,
        // ),
          fillColor: ColorConsts.whiteColor,
          suffixIcon: suffixIcon,
          prefixIcon: Transform.scale(
              scale: 0.4,
              child: SvgPicture.asset(
                  ImageConsts.call)),
          //contentPadding: const EdgeInsets.only(bottom: 2),
          hintText: AppLocalizations.of(context)!
              .trans(StringConsts.phone),
          hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontFamily: StringConsts.familyFontBold),
          labelStyle: const TextStyle(
              color:ColorConsts.black ,
              fontSize: 14,
              fontFamily: StringConsts.familyFontBold),
          errorStyle: TextStyle(
              color: Colors.red[300], fontSize: 11),
          errorBorder: noneInputBorder,
          focusedErrorBorder: noneInputBorder,
          disabledBorder: noneInputBorder,
          enabledBorder: noneInputBorder,
          focusedBorder: noneInputBorder),
      validator: (String? val) {
        if (val == null || val.isEmpty) {
        } else {
        }
        return null;
      },
    );
  }
}
