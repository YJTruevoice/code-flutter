import 'package:ncchannel/nc_channel.dart';

import 'nc_flutter_plugin_name.dart';

/// 统一的channel处理器接口
abstract class IChannelHandler {
  handler(String methodName, Map<dynamic, dynamic> params);
}

abstract class BaseFlutterPlugin extends IChannelHandler {
  // 默认的pluginId
  static const String DEFAULT_PLUGIN_ID = "default";
  NCFlutterPluginName pluginName;

  // 跟原生沟通的唯一绑定pluginId 即使每个Plugin的[pluginName]有可能相同，但是pluginId是唯一的
  String pluginId;

  BaseFlutterPlugin(this.pluginName, {this.pluginId = DEFAULT_PLUGIN_ID});

  /// 获取当前plugin名
  NCFlutterPluginName getName() {
    return pluginName;
  }

  /// 调用channel方法
  Future<T?> invokeMethod<T>(String methodName, {Map<String, dynamic>? params}) {
    return NCChannel().invoke(methodName, params: params, pluginName: getName(), pluginId: pluginId);
  }
}
