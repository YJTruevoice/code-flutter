import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ncflutter/common/nc_colors.dart';

class ColorMap {
  static int themeMode = 0;

  // 主色调
  static Color get primaryColor => themeMode == 1 ? primaryDarkColor : Colors.white;

  // 页面背景色
  static Color get backgroundColor => themeMode == 1 ? primaryDarkColor : NCColor.mainBg;

  static Color get scaffoldBackgroundColor => themeMode == 1 ? primaryDarkColor : NCColor.mainBg;

  // 卡片背景色
  static Color get cardBgColor => themeMode == 1 ? NCDarkColor.cardBg : NCColor.whiteBg;

  static Color get bottomBgColor => themeMode == 1 ? NCDarkColor.blackBg : NCColor.whiteBg;

  static Color get normalBgColor => themeMode == 1 ? NCDarkColor.normalBg : NCColor.whiteBg;

  // title元素颜色
  static Color get navBackIconColor => themeMode == 1 ? NCDarkTextColor.normalColor : NCTextColor.importantColor;

  static Color get pageTitleColor => themeMode == 1 ? NCDarkTextColor.normalColor : NCTextColor.importantColor;

  // 文字色
  static Color get normalTextColor => themeMode == 1 ? NCDarkTextColor.normalColor : NCTextColor.normalColor;

  static Color get contentTextColor => themeMode == 1 ? NCDarkTextColor.contentColor : NCTextColor.contentColor;

  static Color get contentDarkTextColor => themeMode == 1 ? NCDarkTextColor.contentColor : NCTextColor.normalColor;

  // 其他背景色
  static Color get boxShadowColor => themeMode == 1 ? Color(0x0CFFFFFF) : Color(0x0C000000);

  static Color get dividerColor => themeMode == 1 ? Color(0xFF2B2B2B) : Color(0xFFF0F0F0);

  static Color get elementBgColor => themeMode == 1 ? Color(0xFF2B2B2B) : Color(0xFFF0F0F0);

  static Color get btnBgColor => themeMode == 1 ? Color(0xFF0F0F0F) : Color(0xFFFAFAFA);
}
