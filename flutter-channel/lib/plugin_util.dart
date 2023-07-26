import 'package:flutter/material.dart';

import 'interface_channel_handler.dart';

/// plugin相关工具类
class PluginUtil {
  /// 获取当前widget所在主页面的pluginId
  /// [context] 必须是[StatelessWidget]的[StatelessWidget.build] or [StatefulWidget]的[StatefulWidget.build]方法中的[BuildContext]
  static String getPluginId(BuildContext context) {
    var route = ModalRoute.of(context);
    Map<dynamic, dynamic>? arguments = route?.settings.arguments as Map?;
    return arguments?["uniqueId"] ?? BaseFlutterPlugin.DEFAULT_PLUGIN_ID;
  }
}
