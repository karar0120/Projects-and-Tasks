
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/utils/UserDataController.dart';

import '../../../Core/styles/Colors.dart';
import '../../../Core/styles/GeneralConstants.dart';

class DefaultFormField extends StatelessWidget {
  final String labelText;
  final ScrollController? scrollController;
  final TextEditingController controller;
  final TextInputType type;
  final Function onSubmit;
  final Function onChange;
  final Function onTap;
  final bool obscureText;
  final Function validate;
  final String? hintText;
  final String? suffixText;
  final Widget? prefixIcon;
  final Function prefixPressed;
  final Widget? suffixIcon;
  final Color suffixColor;
  final int? maxLines;
  final Color prefixColor;
  final dynamic initialValue;
  final Function suffixPressed;
  final bool isClickable;
  final bool readOnly ;
  final bool autoFocus ;
  final FocusNode? focusNode;
  final bool removeBorder;
  final double height;
  final double? width;
  final bool? timePickerFree;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? keyboardType;
  final List<TextInputFormatter>? inputFormat;
  final Iterable<String>? autofillHints;
  final VoidCallback? onEditingComplete;
  final bool disableContextMenu;

  const DefaultFormField(
      {Key? key,
        this.scrollController,
        this.keyboardType,
        required this.labelText,
        required this.controller,
        required this.type,
        required this.onSubmit,
        required this.onChange,
        this.suffixText,
        required this.focusNode,
        required this.onTap,
        this.removeBorder = true,
        this.obscureText = false,
        this.timePickerFree = true,
        required this.validate,
        this.inputFormat,
        this.prefixColor = ColorConsts.gunmetalBlue,
        this.prefixIcon,
        this.onEditingComplete,
        required this.prefixPressed,
        this.suffixIcon,
        this.suffixColor = ColorConsts.gunmetalBlue,
        required this.suffixPressed,
        this.isClickable = true,
        this.readOnly = false,
        this.autofillHints,
        this.contentPadding,
        this.initialValue,
        this.height = 58,
        this.width,
        this.maxLines,
        this.hintText,
        this.autoFocus = false,
        this.disableContextMenu = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(
        onTap: isClickable == false
            ? () {
          onTap();
        }
            : null,
        child: Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          decoration: removeBorder
              ? const BoxDecoration()
              : null,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              onTapOutside: (event){
                FocusManager.instance.primaryFocus?.unfocus();
              },
              // Optionally disable system context menu to avoid TextInput assertions
              contextMenuBuilder: disableContextMenu
                  ? (context, editableTextState) => const SizedBox.shrink()
                  : null,
              key: key,
              inputFormatters: inputFormat,
              scrollController: scrollController,
              textInputAction: keyboardType ?? TextInputAction.done,
            
              autofocus: autoFocus,
              controller: controller,
              focusNode: focusNode,
              keyboardType: type,
              obscureText: obscureText,
              readOnly: readOnly,
              enabled: isClickable,
              initialValue: initialValue,
              onFieldSubmitted: (val) {
                onSubmit();
              },
              onChanged: (val) {
                onChange();
              },
              onTap: () {
                onTap();
              },
              validator: (val) {
                validate;
                return null;
              },
              cursorColor: ColorConsts.gunmetalBlue,
              decoration: InputDecoration(
                  suffixText: suffixText,
                  suffixStyle: const TextStyle(
                      color: ColorConsts.black,
                      fontSize: 14,
                      fontFamily: StringConsts.familyFontBold),
                  labelText: labelText,
                  hintText: hintText,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(
                      //color: Colors.red,
                      color: ColorConsts.whiteColor2,
                      // width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: ColorConsts.whiteColor2,
                      // width: 1.0,
                    ),
                  ),
                  prefixIcon: prefixIcon != null
                      ? IconButton(
                    icon: prefixIcon!,
                    onPressed: () {
                      prefixPressed();
                    },
                  )
                      : null,
                  suffixIcon: suffixIcon != null
                      ? IconButton(
                    onPressed: () {
                      suffixPressed();
                    },
                    icon: suffixIcon!,
                  )
                      : null,
                  hintStyle: textFieldHintStyle,
                  labelStyle: TextStyle(
                      color: isClickable
                          ? Colors.grey[400]
                          : ColorConsts.gunmetalBlue,
                      fontSize: 14),
                  //fillColor: Colors.white,
                  filled: removeBorder ? true : false,
                  errorStyle: const TextStyle(color: ColorConsts.black),
                  //floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.only(
                      right: 10, left: 10, bottom: 10, top: 10)),
              style: (readOnly == true && timePickerFree == false)
                  ? Theme.of(context).textTheme.displayLarge
                  : Theme.of(context).textTheme.bodyLarge,
              autofillHints: autofillHints,
              onEditingComplete: onEditingComplete,
            ),
          ),
        ),
      ),
    );
  }
}


class SpecialDefaultFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType type;
  final Function onSubmit;
  final Function onChange;
  final Function onTap;
  final bool obscureText;
  final Function validate;
  final String hintText;
  final Widget? prefixIcon;
  final Function prefixPressed;
  final Widget? suffixIcon;
  final Color suffixColor;
  final TextInputAction? keyboardType;
  final int? maxLines;
  final Color prefixColor;
  final String? initialValue;
  final Function suffixPressed;
  final bool isClickable;
  final bool readOnly;

  final bool autoFocus;
  final FocusNode? focusNode;
  final bool removeBorder;
  final double height;
  final EdgeInsetsGeometry? contentPadding;

  const SpecialDefaultFormField(
      {Key? key,
        required this.controller,
        required this.type,
        required this.onSubmit,
        required this.onChange,
        required this.focusNode,
        required this.onTap,
        this.removeBorder = true,
        this.obscureText = false,
        required this.validate,
        this.prefixColor = ColorConsts.gunmetalBlue,
        required this.hintText,
        this.prefixIcon,
        required this.prefixPressed,
        this.suffixIcon,
        this.suffixColor = ColorConsts.gunmetalBlue,
        required this.suffixPressed,
        this.isClickable = true,
        this.readOnly = false,
        this.contentPadding,
        this.initialValue,
        this.height = 45,
        this.keyboardType,
        this.maxLines,
        this.autoFocus = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userDataController = Provider.of<UserDataController>(context);
    userDataController.langg ??= "en";
    return SizedBox(
      height: 45,
      child: InkWell(
        onTap: isClickable == false
            ? () {
          onTap();
        }
            : null,
        child: Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          decoration: removeBorder
              ? BoxDecoration(
              color: Theme.of(context).indicatorColor,
              border: Border.all(color: ColorConsts.whiteColor2),
              borderRadius: userDataController.langg == 'ar'
                  ? const BorderRadius.only(
                bottomRight: Radius.circular(6),
                topRight: Radius.circular(6),
              )
                  : const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                topLeft: Radius.circular(6),
              ))
              : null,
          child: TextFormField(

            textAlign: TextAlign.center,
            autofocus: autoFocus,
            controller: controller,
            focusNode: focusNode,
            keyboardType: type,
            obscureText: obscureText,
            readOnly: readOnly,
            enabled: isClickable,
            textInputAction: keyboardType ?? TextInputAction.done,
            initialValue: initialValue,
            onFieldSubmitted: (val) {
              onSubmit();
            },
            onChanged: (val) {
              onChange();
            },
            onTap: () {
              onTap();
            },
            validator: (val) {
              validate;
              return null;
            },
            cursorColor: ColorConsts.gunmetalBlue,
            decoration: InputDecoration(
              // labelText: label,
                hintText: hintText,
                border: InputBorder.none,
                prefixIcon: prefixIcon != null
                    ? IconButton(
                  icon: prefixIcon!,
                  onPressed: () {
                    prefixPressed();
                  },
                )
                    : null,
                suffixIcon: suffixIcon != null
                    ? IconButton(
                  onPressed: () {
                    suffixPressed();
                  },
                  icon: suffixIcon!,
                )
                    : null,
                hintStyle: textFieldHintStyle,
                labelStyle: TextStyle(
                    color:
                    isClickable ? Colors.grey[400] : ColorConsts.gunmetalBlue,
                    fontSize: 12),
                // fillColor: Colors.white,
                filled: true,
                errorStyle: const TextStyle(color: ColorConsts.black),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding:
                contentPadding ?? const EdgeInsets.only(top: 10)),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
