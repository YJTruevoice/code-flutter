import 'package:ncchannel/interface_channel_handler.dart';
import 'package:ncchannel/nc_flutter_plugin_name.dart';
import 'package:ncflutter/common/global.dart';
import 'package:ncflutter/generated/json/base/json_convert_content.dart';
import 'package:ncflutter/pages/account/model/user_entity.dart';
import 'dart:convert' as convert;

/// 通用的channel交互
class BasicFuncFlutterPlugin extends BaseFlutterPlugin {
  BasicFuncFlutterPlugin(NCFlutterPluginName pluginName, {String pluginId = BaseFlutterPlugin.DEFAULT_PLUGIN_ID})
      : super(pluginName, pluginId: pluginId);

  @override
  handler(String methodName, Map<dynamic, dynamic> params) {}
}

/// 用户登录状态交互
class UserInfoFlutterPlugin extends BaseFlutterPlugin {
  UserInfoFlutterPlugin(NCFlutterPluginName pluginName, {String pluginId = BaseFlutterPlugin.DEFAULT_PLUGIN_ID})
      : super(pluginName, pluginId: pluginId);

  @override
  handler(String methodName, Map<dynamic, dynamic> params) {
    if (methodName == "login") {
      String? userJsonStr = params["userInfo"];
      if (userJsonStr != null && userJsonStr.isNotEmpty) {
        Global.user = JsonConvert.fromJsonAsT<UserEntity>(convert.jsonDecode(userJsonStr));
        Global.token = Global.user.token;
        print("新的通用channel处理器 UserInfoPlugin 获取登录成功后的用户信息 $userJsonStr");
      }
    } else if (methodName == "logout") {
      Global.token = "";
      Global.user = UserEntity();
      print("新的通用channel处理器 UserInfoPlugin 获取登出信息");
    }
  }
}

/// 牛聘相关的flutter端处理
class NowPickFlutterPlugin extends BaseFlutterPlugin {
  void Function(String, Map<dynamic, dynamic>) callback;

  NowPickFlutterPlugin(NCFlutterPluginName pluginName, this.callback,
      {String pluginId = BaseFlutterPlugin.DEFAULT_PLUGIN_ID})
      : super(pluginName, pluginId: pluginId);

  @override
  handler(String methodName, Map<dynamic, dynamic> params) {
    callback(methodName, params);
  }
}

/// NPS
class NPSFlutterPlugin extends BaseFlutterPlugin {
  void Function() callback;

  NPSFlutterPlugin(NCFlutterPluginName pluginName, this.callback,
      {String pluginId = BaseFlutterPlugin.DEFAULT_PLUGIN_ID})
      : super(pluginName, pluginId: pluginId);

  @override
  handler(String methodName, Map<dynamic, dynamic> params) {
    if (methodName == "cacheOperation") {
      callback();
    }
  }
}

/// Hybrid 交互
class HybridConnectionFlutterPlugin extends BaseFlutterPlugin {
  void Function(Map<dynamic, dynamic>) callback;

  HybridConnectionFlutterPlugin(NCFlutterPluginName pluginName, this.callback,
      {String pluginId = BaseFlutterPlugin.DEFAULT_PLUGIN_ID})
      : super(pluginName, pluginId: pluginId);

  @override
  handler(String methodName, Map<dynamic, dynamic> params) {
    if (methodName == "selectCompanyPage" || methodName == "selectJobPage" || methodName == "selectQuestionTag") {
      callback(params);
    }
  }
}

/// Event交互
class EventFlutterPlugin extends BaseFlutterPlugin {
  ///方法名s
  // 事件注册
  static const String EVENT_ADD_OBSERVER = "eventAddObserver";

  // 事件解注
  static const String EVENT_REMOVE_OBSERVER = "eventRemoveObserver";

  // 发送事件
  static const String EVENT_POST_NOTIFICATION = "eventPostNotification";

  // 响应事件
  static const String EVENT_CALLBACK = "eventCallBack";

  void Function(String, Map<dynamic, dynamic>)? callback;

  EventFlutterPlugin(NCFlutterPluginName pluginName, this.callback,
      {String pluginId = BaseFlutterPlugin.DEFAULT_PLUGIN_ID})
      : super(pluginName, pluginId: pluginId);

  @override
  handler(String methodName, Map<dynamic, dynamic> params) {
    callback?.call(methodName, params);
  }
}
