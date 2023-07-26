import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {



  AppConfig({
    required Widget child,
  }) : super(child: child);

  // 方便其子Widget在Widget树中找到它
  static AppConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  // 判断是否需要子Widget更新。由于是应用入口，无需更新
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
