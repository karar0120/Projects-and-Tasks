// ignore_for_file: body_might_complete_normally_nullable, must_be_immutable, file_names

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';
import 'package:projectsandtasks/core/constants/image_consts.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';
import 'package:projectsandtasks/core/utils/shaking_validator.dart';
import 'package:projectsandtasks/shared/models/environment.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Core/styles/Colors.dart';
import '../../Core/styles/GeneralConstants.dart';
import '../../Core/styles/Sizes.dart';

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

showAlertDialogYESNO(BuildContext context,
    {required Widget alertTitle,
      required String content,
      onOk,
      required continuePressed}) {
  Widget okButton = TextButton(
    child: Text("${AppLocalizations.of(context)!.trans(StringConsts.no)}",
        style: Theme.of(context).textTheme.bodyLarge),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.transparent)),
    onPressed: onOk ??
            () {
          Navigator.pop(context);
        },
  );
  Widget continueButton = TextButton(
    child: Text("${AppLocalizations.of(context)!.trans(StringConsts.yes)}",
        style: Theme.of(context).textTheme.bodyLarge),
    style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorConsts.gunmetalBlue)),
    onPressed: continuePressed,
  );
  AlertDialog alert = AlertDialog(
    backgroundColor: Theme.of(context).cardColor,
    //title: alertTitle,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(content,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: okButton,
      ),
      //horizontalMediumSpace,
      Padding(
        padding: const EdgeInsets.all(20.0),
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

/// YES/NO dialog with a boolean toggle. Calls `onYes` with the selected value.
showAlertDialogYESNOLogout(
    BuildContext context, {
      required String content,
      required String toggleLabel,
      bool initialValue = false,
      required void Function(bool value) onYes,
      VoidCallback? onNo,
    }) {
  bool toggle = initialValue;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title:   Text(
                content,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            
              SizedBox(height: 12.h),
              Row(
                children: [
                  Checkbox(
                    value: toggle,
                    onChanged: (v) => setState(() => toggle = v ?? false),
                  ),
                  Expanded(
                    child: Text(
                      toggleLabel,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.transparent)),
                onPressed: onNo ?? () => Navigator.pop(ctx),
                child: Text(
                  "${AppLocalizations.of(context)!.trans(StringConsts.cancel)}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(ColorConsts.gunmetalBlue)),
                onPressed: () {
                  onYes(toggle);
                },
                child: Text(
                  "${AppLocalizations.of(context)!.trans(StringConsts.logout)}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorConsts.whiteColor),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

enum ErrorAnimationProp { offset }

class ShakingErrorText extends StatelessWidget {
  final ShakingErrorController controller;
  final int timesToShake;
  final MovieTween _tween;

  
  ShakingErrorText({
    super.key,
    required this.controller,
    this.timesToShake = 4,
  }) : _tween = MovieTween() {
    // Build shake animation
    for (var i = 0; i < timesToShake; i++) {
      _tween
        ..tween(
          ErrorAnimationProp.offset,
          Tween<double>(begin: 0, end: 10),
          duration: const Duration(milliseconds: 100),
        )
        ..tween(
          ErrorAnimationProp.offset,
          Tween<double>(begin: 10, end: -10),
          duration: const Duration(milliseconds: 100),
        )
        ..tween(
          ErrorAnimationProp.offset,
          Tween<double>(begin: -10, end: 0),
          duration: const Duration(milliseconds: 100),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
  return ChangeNotifierProvider<ShakingErrorController>.value(
  value: controller,
  child: Consumer<ShakingErrorController>(
    builder: (context, errorController, child) {
      return PlayAnimationBuilder<Movie>(
        tween: _tween,
        duration: _tween.duration,
        curve: Curves.easeOut,
        onCompleted: () {
          // Equivalent to animationStatusListener
          controller.onAnimationStarted();
        },
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value.get(ErrorAnimationProp.offset), 0),
            child: child,
          );
        },
        child: Visibility(
          visible: controller.isVisible && controller.isMounted,
          maintainSize: controller.isMounted,
          maintainAnimation: controller.isMounted,
          maintainState: controller.isMounted,
          child: Text(
            errorController.errorText,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    },
  ),
);

  }
}

Widget noInternetConnected(context) {
  return Center(
    child: Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(ImageConsts.internetError, height: 150),
          verticalLargeSpace,
          Text(
              "${AppLocalizations.of(context)!.trans(StringConsts.noInternetConnection)}"),
        ],
      ),
    ),
  );
}

void exitDialog(
    context,
    ) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "${AppLocalizations.of(context)!.trans(StringConsts.areYouSureYouWantToExit)}",
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          actions: [
            TextButton(
              child: Text(
                  "${AppLocalizations.of(context)!.trans(StringConsts.cancel)}",
                  style: Theme.of(context).textTheme.bodyLarge),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                  "${AppLocalizations.of(context)!.trans(StringConsts.exit)}",
                  style: Theme.of(context).textTheme.bodyLarge),
              onPressed: () async {
                SystemNavigator.pop();
              },
            ),
          ],
        );
      });
}

Widget buildSwitch(
    {required value,
      required ValueChanged<bool>? onChanged,
      Color? inactiveTrackColor}) =>
    Transform.scale(
        scale: 1,
        child: Switch.adaptive(
          inactiveTrackColor: inactiveTrackColor ?? ColorConsts.pinkishGrey,
          activeColor: ColorConsts.gunmetalBlue,
          value: value,
          onChanged: onChanged,
        ));

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


Widget buildNotAuthorized(context) {
  return  Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: ColorConsts.pinkishGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: ColorConsts.pinkishGrey.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.trans(StringConsts.notAuthorized).toString(),
                      style: TextStyle(
                        color: ColorConsts.errorColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                );
}

Widget noRecordFound(context) {
  return SizedBox(
      height: SizeConsts.s70,
      child: Center(
          child: Text(
              "${AppLocalizations.of(context)!.trans(StringConsts.noRecordsFound)}")));
}

Widget mySlotsContact({double? bottomPadding}) {
  return Padding(
    padding:  EdgeInsets.only(bottom: bottomPadding??100, left: 0),
    child: SizedBox(
      height: 0.14.sw,
      child: FloatingActionButton(
        onPressed: () async {
          final url = Environment.mySlotsContact;
          final Uri _url = Uri.parse("${url}");
          await launchUrl(_url, mode: LaunchMode.externalApplication);
        },
        backgroundColor: ColorConsts.gunmetalBlue,
        child: const Icon(
          Icons.chat,
          color: ColorConsts.whiteColor,
        ),
      ),
    ),
  );
}

T? ambiguate<T>(T? object) => object;

Future<TimeOfDay?> timePicker(
    {required context, required TimeOfDay initialTime}) {
  return showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true, textScaler: TextScaler.linear(1.h)),
          child: childWidget!,
        );
      });
}
