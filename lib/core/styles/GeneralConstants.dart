// ignore_for_file: file_names

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'Colors.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 5, kToday.month, kToday.day);
const rightRotationAngle = 90 * math.pi / 180;
const leftRotationAngle = 270 * math.pi / 180;

const titleStyle = TextStyle(
    color: ColorConsts.gunmetalBlue,
    fontFamily: 'Almarai-Regular',
    fontSize: 16,
    fontWeight: FontWeight.bold);

const titleStyleDark = TextStyle(
    color: ColorConsts.gunmetalBlue,
    fontFamily: 'Almarai-Regular',
    fontSize: 16,
    fontWeight: FontWeight.bold);

const titleStyle1 = TextStyle(
    color: ColorConsts.gunmetalBlue,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.bold);

const titleStyle2 = TextStyle(
    color: ColorConsts.tealish,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.bold);

const titleSmallStyle = TextStyle(
    color: ColorConsts.brownishGrey,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const titleSmallStyle15 = TextStyle(
    color: Color(0xFF4F4F4F),
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const titleSmallStyleDark = TextStyle(
    color: ColorConsts.whiteColor,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const titleSmallStyle2 = TextStyle(
    color: ColorConsts.pinkishGrey,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const titleSmallStyle4 = TextStyle(
    color: ColorConsts.pinkishGrey,
    fontFamily: 'Almarai-Regular',
    fontSize: 10,
    fontWeight: FontWeight.w600);

const titleSmallStyleGreen = TextStyle(
    color: Colors.green,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const subTitleSmallStyle = TextStyle(
    color: ColorConsts.lightGreyBlue,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const subTitleSmallStyle2 = TextStyle(
    color: ColorConsts.gunmetalBlue,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const subTitleSmallStyle3 = TextStyle(
    color: ColorConsts.tomato,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const titleSmallStyle3 = TextStyle(
    color: ColorConsts.warmGrey,
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const titleSmallStylereadonly = TextStyle(
    color: Color(0xFFBDBDBD),
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

final titleSmallStylereadonlyDark = TextStyle(
    color: Colors.grey[700],
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);

const titleSymmetricPadding = EdgeInsets.only(right: 8, left: 8, top: 8);
const titleMiduimPadding =
    EdgeInsets.only(right: 12, left: 12, top: 12, bottom: 12);
const titleSymmetricPadding2 = EdgeInsets.only(right: 8, left: 8);

const divider = Divider();

const verticalExtremeSmallSpace = SizedBox(height: 8);

const verticalSmallSpace = SizedBox(height: 15);

const verticalMediumSpace = SizedBox(height: 25);

const verticalLargeSpace = SizedBox(height: 35);

const verticalExtremeLargeSpace = SizedBox(height: 100);

const horizontalExtremeSmallSpace = SizedBox(width: 8);

const horizontalSmallSpace = SizedBox(width: 15);

const horizontalMediumSpace = SizedBox(width: 25);

const horizontalLargeSpace = SizedBox(width: 35);

const horizontalExtremeLargeSpace = SizedBox(width: 100);

BoxDecoration defaultDecoration(context) {
  return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(4));
}

final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderSide: const BorderSide(color: ColorConsts.whiteColor2),
  borderRadius: BorderRadius.circular(6),
);

InputBorder noneInputBorder = InputBorder.none;

const textFieldHintStyle = TextStyle(
    color: Color(0xFFBDBDBD),
    fontSize: 14,
    fontFamily: 'Almarai-Regular',
    fontWeight: FontWeight.w600);
final textFieldHintStyleDark = TextStyle(
    color: Colors.grey[700],
    fontSize: 14,
    fontFamily: 'Almarai-Regular',
    fontWeight: FontWeight.w600);

const titleSmallStyle1 = TextStyle(
    color: Color(0xFF4F4F4F),
    fontFamily: 'Almarai-Regular',
    fontSize: 14,
    fontWeight: FontWeight.w600);
