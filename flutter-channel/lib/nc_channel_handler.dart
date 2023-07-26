import 'package:flutter/services.dart';
import 'package:ncchannel/channel_dispatcher.dart';

/// 统一channel处理器、具体给ChannelManager去分发
class NCChannelHandler {
  static Future<dynamic> ncMethodCallHandler(MethodCall call) async {
    ChannelDispatcher().dispatch(call);
    return true;
  }
}
