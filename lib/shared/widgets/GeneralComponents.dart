// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable, file_names

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/button_widget.dart';
import '../../Core/styles/Colors.dart';

void navigateTo({required context, required widget, required String name}) =>
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => widget,
          settings: RouteSettings(
            name: name,
          )),
    );

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final double? leadingWidth;
  final bool? centerTitle;
  final double? padding;
  final Color? appBarColor;
  final Widget? leading;
  final List<Widget>? actions;
  final double? elevation;
  final double? appbarPreferredSize;
  final Color? appbarBackButtonColor;
  final bool isLtr;

  const GeneralAppBar({
    Key? key,
    this.title,
    this.leadingWidth,
    this.centerTitle,
    this.appBarColor,
    this.leading,
    this.actions,
    this.appbarPreferredSize = 80,
    this.elevation = 0.0,
    this.padding = 0.0,
    this.isLtr = false,
    this.appbarBackButtonColor = ColorConsts.whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidth,
      backgroundColor: appBarColor ?? Theme.of(context).colorScheme.primary,
      centerTitle: centerTitle ?? false,
      title: title,
      elevation: 0, // no shadow
      shadowColor: Colors.transparent, // remove default shadow
      surfaceTintColor: Colors.transparent, // remove Material 3 overlay
      scrolledUnderElevation: 0, // remove scroll effect border
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // remove rounded corners/border
        side: BorderSide.none, // no border line
      ),
      leading: leading ??
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: appbarBackButtonColor,
              size: 18,
            ),
          ),
      actions: actions,
    );

    if (isLtr) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Padding(
          padding: EdgeInsets.all(padding!),
          child: appBar,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(padding!),
        child: appBar,
      );
    }
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(appbarPreferredSize ?? kToolbarHeight);
}

void showCustomBottomSheet(BuildContext context,
    {required Widget bottomSheetContent,
      required double bottomSheetHeight,
      Color? backgroundColor}) {
  // Dismiss keyboard before showing bottom sheet
  FocusScope.of(context).unfocus();
  
  showModalBottomSheet(
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: bottomSheetHeight.sh,
          child: Stack(
            children: [
              Positioned(
                right: 0.4.sw,
                left: 0.4.sw,
                top: 10,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: 5,
                  decoration: BoxDecoration(
                      color: ColorConsts.pinkishGrey,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              bottomSheetContent
            ],
          ),
        );
      }).whenComplete(() {
        // Ensure keyboard stays dismissed after bottom sheet closes
        FocusScope.of(context).unfocus();
      });
}

showAlertDialog(
    BuildContext context, {
      required Widget alertTitle,
      required String content,
      onOk,
      GestureTapCallback? onTap,
      bool? isMore = false,
      TextStyle? textStyle,
    }) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("${AppLocalizations.of(context)!.trans(StringConsts.ok)}",
        style: Theme.of(context).textTheme.bodyLarge),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorConsts.gunmetalBlue)),
    onPressed: onOk ??
            () {
          Navigator.pop(context);
        },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Theme.of(context).cardColor,
    title: alertTitle,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          content,
          textAlign: TextAlign.center,
          style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
        ),
        isMore == true
            ? DefaultTextButton(
          onTap: onTap,
          title:
          "${AppLocalizations.of(context)!.trans(StringConsts.seeMore)}",
          color: Theme.of(context).unselectedWidgetColor,
          fontWeight: FontWeight.bold,
          // screen: ForgetCompanyScreen(),
        )
            : const SizedBox(),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: okButton,
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


showAlertDialogContinue(BuildContext context,
    {required String content,
      Widget? widgetContent,
      onOk,
      TextStyle? textStyle,
      Widget? buttonText,
      required VoidCallback continuePressed}) {
  Widget okButton = TextButton(
    child: Text(
      "${AppLocalizations.of(context)!.trans(StringConsts.cancel)}",
      style: Theme.of(context).textTheme.bodyLarge,
    ),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent)),
    onPressed: onOk ??
            () {
          Navigator.pop(context);
        },
  );
  Widget continueButton = TextButton(
    child: buttonText ??
        Text(
          "${AppLocalizations.of(context)!.trans(StringConsts.Continue)}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorConsts.gunmetalBlue)),
    onPressed: continuePressed,
  );

  AlertDialog alert = AlertDialog(
    //title: alertTitle,
    backgroundColor: Theme.of(context).cardColor,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: widgetContent ??
          Text(
            content,
            textAlign: TextAlign.center,
            style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
          ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: okButton,
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: continueButton,
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


void errorBotToast({required String title}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    BotToast.showSimpleNotification(
        title: title,
        titleStyle: const TextStyle(
          fontSize: 14,
          color: ColorConsts.whiteColor,
          fontWeight: FontWeight.w600,
        ),
        onClose: () {
          return;
        },
        closeIcon: const Icon(Icons.close_rounded),
        hideCloseButton: false,
        subTitleStyle: const TextStyle(
          color: ColorConsts.whiteColor,
          fontSize: 14,
        ),
        backgroundColor: ColorConsts.tomato,
        borderRadius: 14.0);
  });
}

void doneBotToast({required String title}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    BotToast.showSimpleNotification(
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: ColorConsts.whiteColor,
        ),
        onClose: () {
          return;
        },
        closeIcon: const Icon(Icons.check),
        hideCloseButton: false,
        title: title,
        subTitleStyle: const TextStyle(
          color: ColorConsts.whiteColor,
          fontSize: 14,
        ),
        backgroundColor: Colors.green,
        borderRadius: 14.0);
  });
}

