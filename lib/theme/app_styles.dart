import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class Styles {
  static TextStyle tsB22 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsB32 = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsL10 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle tsL12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle tsL14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle tsL16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle tsL18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle tsL20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle tsL24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle tsL30 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w300,
  );

  static TextStyle tsR10 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tsR12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tsR14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tsR16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tsR18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tsR20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tsR24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tsR30 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w400,
  );

  static TextStyle tsM10 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tsM12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tsM14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tsM16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tsM18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tsM20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tsM24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tsM30 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle tsSb10 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tsSb12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tsSb14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tsSb16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tsSb18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tsSb20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tsSb24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tsSb30 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle tsb10 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsb12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsb14 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsb16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsb18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsb20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsb24 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );

  static TextStyle tsb30 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
  );
  static TextStyle tsb7 = TextStyle(
    fontSize: 8.sp,
    fontWeight: FontWeight.w500,
  );

  static void setDeviceOrientationOfApp() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
