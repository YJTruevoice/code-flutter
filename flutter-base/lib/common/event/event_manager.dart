import 'package:ncchannel/interface_channel_handler.dart';
import 'package:ncflutter/utils/log_util.dart';

import '../flutter_channel_plugins.dart';

/// 事件管理器
class EventManager {
  // 当前对象
  static EventManager? _instance;

  EventManager._internal() {
    _instance = this;
  }

  factory EventManager() => _instance ?? EventManager._internal();

  /// 注册一个事件组
  void addEventObservers(List<String>? eventNames) {}

  /// 注册事件监听
  Future<String?> addEventObserver(String eventName, BaseFlutterPlugin plugin, String callbackId) async {
    if (eventName.isEmpty) {
      LogUtil.e("||||||||||| 请注意：注册事件名 eventName 不能为空 |||||||||||||");
      return "";
    }
    var eventObsId = await plugin.invokeMethod(EventFlutterPlugin.EVENT_ADD_OBSERVER,
        params: {EventParamsKeys.KEY_NAME: eventName, EventParamsKeys.KEY_CALLBACK_ID: callbackId});
    return eventObsId;
  }

  /// 移除事件监听
  void removeEventObserver(List<String> observerIds, BaseFlutterPlugin plugin) {
    if (observerIds.isNotEmpty) {
      plugin.invokeMethod(EventFlutterPlugin.EVENT_REMOVE_OBSERVER, params: {"ids": observerIds});
    }
  }

  /// 发送消息
  void postEvent(String eventName, BaseFlutterPlugin plugin,
      {List<String>? receiveEnv, Map<String, dynamic>? data}) {
    if (eventName.isEmpty) {
      LogUtil.e("||||||||||| 请注意：注册事件名 eventName 不能为空 |||||||||||||");
      return;
    }
    plugin.invokeMethod(EventFlutterPlugin.EVENT_POST_NOTIFICATION, params: {
      EventParamsKeys.KEY_NAME: eventName,
      EventParamsKeys.KEY_RECEIVE_ENV: receiveEnv,
      EventParamsKeys.KEY_PARAM: data
    });
  }

  /// 事件接收到后的预处理 判断事件名和callbackId和当初注册事件[addEventObserver]时的是否一致
  bool preHandleEvent(Map<dynamic, dynamic> params, String originCallbackId) {
    String? eventName = params[EventParamsKeys.KEY_NAME];
    String? callbackId = params[EventParamsKeys.KEY_CALLBACK_ID];
    return eventName != null && eventName.isNotEmpty && callbackId == originCallbackId;
  }

  /// 创建callbackId
  String createEventCallbackId(Object? object) {
    return "eventCallbackId_${identityHashCode(object)}";
  }
}

/// 事件相关的参数key
class EventParamsKeys {
  // 事件名 key
  static const String KEY_NAME = "name";

  // 接收方 key
  static const String KEY_RECEIVE_ENV = "receiveEnvironments";

  // 发送方 key
  static const String KEY_SEND_ENV = "sendEnv";

  // callbackId key
  static const String KEY_CALLBACK_ID = "callbackId";

  // param key
  static const String KEY_PARAM = "param";
}

/// 事件名常量
class EventNameConsts {
  static const String TEST_EVENT = "test_event";
}
