import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ncchannel/interface_channel_handler.dart';
import 'package:ncchannel/nc_channel_handler.dart';
import 'package:ncchannel/nc_flutter_plugin_name.dart';

/// channel调用入口
class NCChannel {
  // 项目中的新的唯一的channel定义
  static MethodChannel? ncChannel;

  // 当前对象
  static NCChannel? _instance;

  // 方法名 key
  static const String KEY_NC_METHOD_NAME = "NCMethodName";

  // pluginID key
  static const String KEY_PLUGIN_ID = "pluginID";

  NCChannel._internal() {
    _instance = this;
  }

  factory NCChannel() => _instance ?? NCChannel._internal();

  /// channel初始化，需要在invoke之前初始化
  init() {
    ncChannel = const MethodChannel('com.nowcoder.app.florida.nc');
    ncChannel?.setMethodCallHandler(NCChannelHandler.ncMethodCallHandler);
    print("新的通用channel NCChannel init: $ncChannel");
  }

  /// 是否初始化过
  bool isInited() {
    return ncChannel != null;
  }

  /// 真正的channel调用方法
  /// @param pluginName 插件名可以为空，为空的话只能就会试图从另一端通用的plugin处理，如果有业务强依赖的channel调用，需要自定义plugin
  /// @param methodName channel 方法名
  /// @param params 参数
  Future<T?> invoke<T>(String methodName,
      {Map<String, dynamic>? params,
      NCFlutterPluginName pluginName = NCFlutterPluginName.BasicFunc,
      String pluginId = BaseFlutterPlugin.DEFAULT_PLUGIN_ID}) {
    Map<String, dynamic> arguments = {};
    arguments[KEY_NC_METHOD_NAME] = methodName;
    arguments[KEY_PLUGIN_ID] = pluginId;
    if (params != null && params.isNotEmpty) {
      arguments.addAll(params);
    }
    if (ncChannel == null) {
      throw FlutterError("ncChannel not init，need invoke {init} function in advance");
    }
    return ncChannel!.invokeMethod(FindPluginName().find(pluginName), arguments);
  }
}
