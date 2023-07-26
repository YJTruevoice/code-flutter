import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:ncchannel/nc_channel.dart';
import 'package:ncchannel/nc_flutter_plugin_name.dart';

import 'interface_channel_handler.dart';

/// Channel处理器分发
class ChannelDispatcher {
  static ChannelDispatcher? _instance;

  ChannelDispatcher._internal() {
    _instance = this;
  }

  factory ChannelDispatcher() => _instance ?? ChannelDispatcher._internal();

  //HashMap<Plugin所属业务空间(NCFlutterPluginName中查看), HashMap<当前PluginID,当前Plugin>>
  Map<String, HashMap<String, IChannelHandler>> _pluginMap =
      new HashMap<String, HashMap<String, IChannelHandler>>();

  dispatch(MethodCall call) {
    String pluginName = call.method;
    Map<dynamic, dynamic>? arguments = call.arguments;
    String? methodName = arguments?.remove(NCChannel.KEY_NC_METHOD_NAME);
    String pluginId = arguments?.remove(NCChannel.KEY_PLUGIN_ID) ?? BaseFlutterPlugin.DEFAULT_PLUGIN_ID;

    print("ChannelDispatcher dispatch: pluginName=$pluginName, methodName=$methodName, arguments=$arguments");
    if (methodName != null && methodName.isNotEmpty && arguments != null) {
      _pluginMap[pluginName]?[pluginId]?.handler(methodName, arguments);
    }
  }

  addPlugin(BaseFlutterPlugin? plugin) {
    if (plugin != null) {
      HashMap<String, IChannelHandler>? plugins = _pluginMap[_pluginName(plugin)];
      if (plugins == null) {
        plugins = new HashMap<String, IChannelHandler>();
        _pluginMap[_pluginName(plugin)] = plugins;
      }
      plugins[plugin.pluginId] = plugin;
    }
  }

  removePlugin(BaseFlutterPlugin? plugin) {
    if (plugin != null) {
      _pluginMap[_pluginName(plugin)]?.remove(plugin);
    }
  }

  String _pluginName(BaseFlutterPlugin plugin) {
    return FindPluginName().find(plugin.getName());
  }
}
