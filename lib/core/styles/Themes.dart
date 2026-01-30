// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Colors.dart';
import 'GeneralConstants.dart';

ThemeData lightThemeApp = ThemeData(
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.transparent),
  fontFamily: 'Almarai-Bold',
  scaffoldBackgroundColor: ColorConsts.backgroundColor,
  appBarTheme: const AppBarTheme(
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      //statusBarColor: Colors.black54,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(
      fontFamily: 'Almarai-Bold',
      color: Colors.white,
      fontSize: 17.0,
      fontWeight: FontWeight.w700,
    ),
    iconTheme: IconThemeData(color: ColorConsts.gunmetalBlue, size: 14.0),
  ),
  inputDecorationTheme: const InputDecorationTheme(fillColor: Colors.white),
  bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: ColorConsts.whiteColor,
      surfaceTintColor: ColorConsts.backgroundColor),
  cardColor: ColorConsts.whiteColor,
  dividerTheme: const DividerThemeData(color: ColorConsts.pinkishGrey),
  textTheme: TextTheme(
    bodyLarge: titleSmallStyle,
    bodyMedium: titleStyle,
    titleMedium: titleSmallStyle,
    labelLarge: const TextStyle(
      fontFamily: 'Almarai-Bold',
      color: ColorConsts.gunmetalBlue,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
    //titleSmall: titleSmallStylereadonly,
    displayLarge: titleSmallStylereadonly,
    displayMedium: textFieldHintStyle,
    displaySmall: const TextStyle(
      fontFamily: 'Almarai-Bold',
      fontSize: 14,
      color: ColorConsts.gunmetalBlue,
    ),
    headlineMedium: const TextStyle(
      fontFamily: 'Almarai-Bold',
      fontSize: 12,
      color: ColorConsts.gunmetalBlue,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Almarai-Bold',
      fontSize: 13,
      color: Colors.grey[800],
    ),
    titleLarge: const TextStyle(
      fontFamily: 'Almarai-Bold',
      color: ColorConsts.gunmetalBlue,
      fontSize: 12,
    ),
  ),
  indicatorColor: Colors.white,
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(const Color(0xFF060606)),
  ),
  //cardColor:whiteColor,

  timePickerTheme: _timePickerTheme,
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor:
        MaterialStateColor.resolveWith((states) => ColorConsts.whiteColor),
    backgroundColor:
        MaterialStateColor.resolveWith((states) => ColorConsts.gunmetalBlue),
    //overlayColor: MaterialStateColor.resolveWith((states) => Colors.deepOrange),
  )),
  primaryColor: ColorConsts.gunmetalBlue,
  primaryColorLight: ColorConsts.brownishGrey,
  colorScheme: ColorScheme.light(
    primary: ColorConsts.gunmetalBlue,
    onPrimary: ColorConsts.whiteColor,
    onSurface: ColorConsts.brownishGrey, // <
    secondary: ColorConsts.backgroundColor,
    secondaryContainer: ColorConsts.whiteColor,
    onSecondary: ColorConsts.brownishGrey,
    primaryContainer: ColorConsts.dustyTeal,
    background: ColorConsts.whiteColor,
    onBackground: ColorConsts.gunmetalBlue,
    onError: Colors.red,
    onTertiary: ColorConsts.gunmetalBlue,
    onPrimaryContainer: ColorConsts.paleGrey,
    // --
  ),
  //fromSwatch().copyWith(secondary: greenBlue)
  canvasColor: Colors.white,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  focusColor: Colors.transparent,
  shadowColor: Colors.grey.withOpacity(0.5),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  popupMenuTheme: const PopupMenuThemeData(
      color: ColorConsts.whiteColor,
      elevation: 2.0,
      textStyle: TextStyle(
        fontFamily: 'Almarai-Bold',
        color: ColorConsts.gunmetalBlue,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
      )),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: ColorConsts.gunmetalBlue.withOpacity(0.8),
    cursorColor: ColorConsts.gunmetalBlue,
    selectionHandleColor: ColorConsts.gunmetalBlue.withOpacity(0.8),
  ),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(background: Colors.white),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: ColorConsts.gunmetalBlue,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: ColorConsts.gunmetalBlue,
    unselectedItemColor: Colors.grey,
    elevation: 20.0,
    backgroundColor: ColorConsts.whiteColor,
    selectedLabelStyle: TextStyle(
      fontFamily: 'Almarai-Bold',
      color: Colors.white,
      fontSize: 12.0,
//      height: 14.8,
      fontWeight: FontWeight.w400,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: 'Almarai-Bold',
      color: Colors.white,
      fontSize: 12.0,
//      height: 14.8,
      fontWeight: FontWeight.w400,
    ),
  ),
  tabBarTheme: const TabBarThemeData(
    labelStyle: TextStyle(
      fontFamily: 'Almarai-Bold', color: Colors.white,
      fontSize: 12.0,
//      height: 14.8,
      fontWeight: FontWeight.w400,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: 'CairoBold', color: Colors.white,
      fontSize: 12.0,
//      height: 14.8,
      fontWeight: FontWeight.w400,
    ),
  ),
  unselectedWidgetColor: const Color(0xFF060606),
  // cardTheme: const CardTheme(
  //   color: brownishGrey,
  // ),
  cardTheme: const CardThemeData(
    surfaceTintColor: ColorConsts.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      side: BorderSide.none,
    ),
  ),
  datePickerTheme: DatePickerThemeData(
      weekdayStyle: const TextStyle(
        color: ColorConsts.dustyTeal,
      ),
      surfaceTintColor: Colors.transparent,
      todayBackgroundColor: MaterialStateColor.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? ColorConsts.gunmetalBlue
            : Colors.white70,
      ),
      dayBackgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? ColorConsts.gunmetalBlue
            : Colors.transparent,
      )),
);

ThemeData darkThemeApp = ThemeData(
  fontFamily: 'Almarai-Bold',
  scaffoldBackgroundColor: ColorConsts.backgroundDarkMode,
  appBarTheme: const AppBarTheme(
    elevation: 0.0,
    //shadowColor:Colors.white ,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      //statusBarBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(
      fontFamily: 'Almarai-Bold',
      color: Colors.white,
      fontSize: 17.0,
      fontWeight: FontWeight.w700,
    ),

    iconTheme: IconThemeData(color: ColorConsts.gunmetalBlue, size: 14.0),
    backgroundColor: ColorConsts.foregroundDarkMode,
    // backgroundColor: greenBlue
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: ColorConsts.foregroundDarkMode,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: ColorConsts.foregroundDarkMode),
  cardTheme: const CardThemeData(
    color: ColorConsts.foregroundDarkMode,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      side: BorderSide.none,
    ),
  ),
  cardColor: ColorConsts.foregroundDarkMode,
  dividerTheme: const DividerThemeData(color: Colors.white),
  canvasColor: ColorConsts.foregroundDarkMode,
  textTheme: TextTheme(
      bodyLarge: titleSmallStyleDark,
      bodyMedium: titleStyleDark,
      titleMedium: titleSmallStyleDark,
      // titleSmall: titleSmallStylereadonly,
      labelLarge: const TextStyle(
        fontFamily: 'Almarai-Bold',
        color: ColorConsts.gunmetalBlue,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
      displayLarge: titleSmallStylereadonlyDark,
      displayMedium: textFieldHintStyleDark,
      displaySmall: const TextStyle(
        fontFamily: 'Almarai-Bold',
        fontSize: 14,
        color: ColorConsts.gunmetalBlue,
      ),
      headlineMedium: const TextStyle(
        fontFamily: 'Almarai-Bold',
        fontSize: 12,
        color: ColorConsts.gunmetalBlue,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Almarai-Bold',
        fontSize: 13,
        color: Colors.grey[800],
      ),
      titleLarge: const TextStyle(
        fontFamily: 'Almarai-Bold',
        color: ColorConsts.gunmetalBlue,
        fontSize: 12,
      )),
  // textTheme:TextTheme(
  //   bodyLarge: titleSmallStyle,
  //   bodyMedium: titleStyle,
  //   titleMedium:titleSmallStyle,
  //   labelLarge: const TextStyle(
  //     fontFamily: 'Almarai-Bold',
  //     color: ColorConsts.greenBlue,
  //     fontSize: 12,
  //     fontWeight: FontWeight.w700,
  //   ),
  //   //titleSmall: titleSmallStylereadonly,
  //   displayLarge: titleSmallStylereadonly,
  //   displayMedium: textFieldHintStyle,
  //   displaySmall: const TextStyle(
  //     fontFamily: 'Almarai-Bold',
  //     fontSize: 14,
  //     color: ColorConsts.greenBlue,
  //   ),
  //   headlineMedium: const TextStyle(
  //     fontFamily: 'Almarai-Bold',
  //     fontSize: 12,
  //     color: ColorConsts.greenBlue,
  //   ),
  //   headlineSmall: TextStyle(
  //     fontFamily: 'Almarai-Bold',
  //     fontSize: 13,
  //     color: Colors.grey[800],
  //   ),
  //   titleLarge: const TextStyle(
  //     fontFamily: 'Almarai-Bold',
  //     color: ColorConsts.greenBlue,
  //     fontSize: 12,
  //   ),
  // ),
  colorScheme: const ColorScheme.light(
    primary: ColorConsts.foregroundDarkMode,
    onPrimary: ColorConsts.whiteColor,
    onSurface: ColorConsts.whiteColor,
    secondary: Color(0xFF060606),
    secondaryContainer: ColorConsts.gunmetalBlue,
    onSecondary: Colors.white,
    primaryContainer: ColorConsts.whiteColor,
    background: ColorConsts.backgroundDarkMode,
    onBackground: Colors.white,
    onError: Colors.white,
    onTertiary: Colors.transparent,
    onPrimaryContainer: ColorConsts.foregroundDarkMode,
  ),
  indicatorColor: Colors.transparent,
  shadowColor: Colors.transparent,
  unselectedWidgetColor: Colors.white,
  scrollbarTheme: ScrollbarThemeData(
    thumbColor: MaterialStateProperty.all(Colors.white),
  ),
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  focusColor: Colors.transparent,
  datePickerTheme: DatePickerThemeData(
      backgroundColor: ColorConsts.foregroundDarkMode,
      weekdayStyle: const TextStyle(
        color: ColorConsts.dustyTeal,
      ),
      todayBackgroundColor: MaterialStateColor.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? ColorConsts.gunmetalBlue
            : Colors.grey,
      ),
      dayBackgroundColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? ColorConsts.gunmetalBlue
            : Colors.transparent,
      ),
      surfaceTintColor: Colors.transparent),

  timePickerTheme: _timePickerThemeDark,
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor:
        MaterialStateColor.resolveWith((states) => ColorConsts.whiteColor),
    backgroundColor: MaterialStateColor.resolveWith(
        (states) => ColorConsts.foregroundDarkMode),
    //overlayColor: MaterialStateColor.resolveWith((states) => Colors.deepOrange),
  )),
  primaryColor: ColorConsts.gunmetalBlue,
  primaryColorLight: Colors.white,
  primaryColorDark: ColorConsts.foregroundDarkMode,
  //colorScheme: ColorScheme.fromSwatch().copyWith(secondary: greenBlue),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  popupMenuTheme: const PopupMenuThemeData(
      color: ColorConsts.backgroundDarkMode,
      elevation: 2.0,
      textStyle: TextStyle(
        fontFamily: 'Almarai-Bold',
        color: ColorConsts.whiteColor,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
      )),
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: ColorConsts.gunmetalBlue.withOpacity(0.8),
    cursorColor: ColorConsts.gunmetalBlue,
    selectionHandleColor: ColorConsts.gunmetalBlue.withOpacity(0.8),
  ),
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(background: Colors.white),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: ColorConsts.gunmetalBlue,
    unselectedItemColor: Colors.grey,
    elevation: 00.0,
    backgroundColor: ColorConsts.foregroundDarkMode,
    selectedLabelStyle: TextStyle(
      fontFamily: 'Almarai-Bold',
      color: Colors.white,
      fontSize: 12.0,
//      height: 14.8,
      fontWeight: FontWeight.w400,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: 'Almarai-Bold',
      color: Colors.white,
      fontSize: 12.0,
//      height: 14.8,
      fontWeight: FontWeight.w400,
    ),
  ),
  tabBarTheme: const TabBarThemeData(
    labelStyle: TextStyle(
      fontFamily: 'Almarai-Bold', color: Colors.white,
      fontSize: 12.0,
//      height: 14.8,
      fontWeight: FontWeight.w400,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: 'CairoBold', color: Colors.white,
      fontSize: 12.0,
//      height: 14.8,
      fontWeight: FontWeight.w400,
    ),
  ),
  // cardTheme: const CardTheme(
  //   color: brownishGrey,
  // ),

//   fontFamily: 'Almarai-Bold',
//   textSelectionTheme: TextSelectionThemeData(
//     selectionColor: greenBlue.withOpacity(0.8),
//     cursorColor: greenBlue,
//     selectionHandleColor: greenBlue.withOpacity(0.8),
//   ),
//   timePickerTheme: _timePickerTheme,
//   primaryColor: greenBlue,
//   colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightGreyBlue),
//   canvasColor: Colors.transparent,
//   splashColor: Colors.transparent,
//   highlightColor: Colors.transparent,
//   focusColor: Colors.transparent,
//   scaffoldBackgroundColor: Colors.white,
//   cardColor: lightGreyBlue,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   appBarTheme: const AppBarTheme(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         bottom: Radius.circular(25),
//       ),
//     ),
//     elevation: 2.0,
//     titleTextStyle: TextStyle(
//       fontFamily: 'Almarai-Bold',
//       color: Colors.white,
//       fontSize: 17.0,
//       fontWeight: FontWeight.w700,
//     ),
//     iconTheme: IconThemeData(color: greenBlue, size: 14.0),
//   ),
//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: greenBlue,
//   ),
//   bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//     type: BottomNavigationBarType.fixed,
//     selectedItemColor: greenBlue,
//     unselectedItemColor: Colors.grey,
//     elevation: 20.0,
//     backgroundColor: Color(0xFF060606),
//     selectedLabelStyle: TextStyle(
//       fontFamily: 'Almarai-Bold',
//       color: Colors.white,
//       fontSize: 12.0,
// //      height: 14.8,
//       fontWeight: FontWeight.w400,
//     ),
//     unselectedLabelStyle: TextStyle(
//       fontFamily: 'Almarai-Bold',
//       color: Colors.white,
//       fontSize: 12.0,
// //      height: 14.8,
//       fontWeight: FontWeight.w400,
//     ),
//   ),
//   tabBarTheme: const TabBarThemeData(
//     labelStyle: TextStyle(
//       fontFamily: 'Almarai-Bold', color: Colors.white,
//       fontSize: 12.0,
// //      height: 14.8,
//       fontWeight: FontWeight.w400,
//     ),
//     unselectedLabelStyle: TextStyle(
//       fontFamily: 'CairoBold', color: Colors.white,
//       fontSize: 12.0,
// //      height: 14.8,
//       fontWeight: FontWeight.w400,
//     ),
//   ),
//   textTheme: ThemeData.dark().textTheme.copyWith(
//       bodyText1: TextStyle(
//         fontFamily: 'Almarai-Bold',
//         fontSize: 12,
//         color: Colors.grey[800],
//       ),
//       subtitle1: const TextStyle(
//         fontFamily: 'Almarai-Bold',
//         fontSize: 80,
//         fontWeight: FontWeight.w700,
//         color: Color(0xFFFAFAFA),
//       ),
//       button: const TextStyle(
//         fontFamily: 'Almarai-Bold',
//         color: greenBlue,
//         fontSize: 12,
//         fontWeight: FontWeight.w700,
//       ),
//       headline1: const TextStyle(
//           fontFamily: 'Almarai-Bold', fontSize: 20, color: greenBlue),
//       headline2: const TextStyle(
//         fontFamily: 'Almarai-Bold',
//         fontSize: 18,
//         color: Color(0xff598BE6),
//         // fontWeight: FontWeight.bold,
//       ),
//       headline3: const TextStyle(
//         fontFamily: 'Almarai-Bold',
//         fontSize: 14,
//         color: greenBlue,
//       ),
//       headline4: const TextStyle(
//         fontFamily: 'Almarai-Bold',
//         fontSize: 12,
//         color: greenBlue,
//       ),
//       headline5: TextStyle(
//         fontFamily: 'Almarai-Bold',
//         fontSize: 13,
//         color: Colors.grey[800],
//       ),
//       headline6: const TextStyle(
//         fontFamily: 'Almarai-Bold',
//         color: greenBlue,
//         fontSize: 12,
//       )),
);

final _timePickerTheme = TimePickerThemeData(
  backgroundColor: ColorConsts.whiteColor,

  hourMinuteShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: ColorConsts.whiteColor, width: 4),
  ),

  // ✅ Change AM/PM button color based on selection
  dayPeriodColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? ColorConsts.gunmetalBlue
          : ColorConsts.whiteColor),

  // ✅ Change AM/PM text color based on selection
  dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? Colors.white
          : ColorConsts.gunmetalBlue),

  dayPeriodBorderSide: const BorderSide(color: ColorConsts.gunmetalBlue, width: 4),

  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: ColorConsts.gunmetalBlue, width: 4),
  ),

  dayPeriodShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: ColorConsts.gunmetalBlue, width: 4),
  ),

  hourMinuteColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? ColorConsts.gunmetalBlue
          : ColorConsts.whiteColor),

  hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? ColorConsts.whiteColor
          : ColorConsts.gunmetalBlue),

  dialHandColor: ColorConsts.gunmetalBlue,
  dialBackgroundColor: ColorConsts.whiteColor,

  hourMinuteTextStyle:
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  dayPeriodTextStyle:
      const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),

  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    contentPadding: EdgeInsets.all(0),
  ),

  entryModeIconColor: ColorConsts.gunmetalBlue,
);

final _timePickerThemeDark = TimePickerThemeData(
  backgroundColor: Colors.grey.shade900,
  hourMinuteShape: RoundedRectangleBorder(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: Colors.grey.shade900, width: 4),
  ),
  dayPeriodBorderSide: const BorderSide(color: ColorConsts.gunmetalBlue, width: 4),

  // Change AM/PM color based on selection
  dayPeriodColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? ColorConsts.gunmetalBlue
          : Colors.grey.shade900),

  shape: RoundedRectangleBorder(
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: Colors.grey.shade900, width: 4),
  ),
  dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? Colors.white
          : ColorConsts.gunmetalBlue),

  dayPeriodShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    side: BorderSide(color: ColorConsts.tomato, width: 4),
  ),
  hourMinuteColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? ColorConsts.gunmetalBlue
          : Colors.grey.shade900),

  hourMinuteTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? Colors.grey.shade900
          : ColorConsts.gunmetalBlue),

  dialHandColor: ColorConsts.gunmetalBlue,
  dialBackgroundColor: ColorConsts.whiteColor,

  hourMinuteTextStyle:
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  dayPeriodTextStyle:
      const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),

  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
    contentPadding: EdgeInsets.all(0),
  ),
  dialTextColor: MaterialStateColor.resolveWith((states) =>
      states.contains(MaterialState.selected)
          ? ColorConsts.black
          : ColorConsts.black),

  entryModeIconColor: ColorConsts.gunmetalBlue,
);
