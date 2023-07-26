import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:ncchannel/channel_dispatcher.dart';
import 'package:ncchannel/interface_channel_handler.dart';
import 'package:ncchannel/nc_flutter_plugin_name.dart';
import 'package:ncflutter/common/event/event_manager.dart';
import 'package:ncflutter/common/flutter_channel_plugins.dart';
import 'package:ncflutter/utils/log_util.dart';

import '../../main.dart';

/// NCBaseState
/// 注：[PageVisibilityObserver] 是FlutterBoost提供的单页面生命周期回调
abstract class NCBaseState<T extends StatefulWidget > extends State<T> with PageVisibilityObserver {
  // flutter channel plugin
  BaseFlutterPlugin? flutterPlugin;

  // 事件传递plugin
  BaseFlutterPlugin? eventFlutterPlugin;

  // 事件中心观察者ids
  List<String> eventObserverIds = [];

  // 当前页面路由
  Route<dynamic>? route;

  // 页面唯一ID；默认default
  String pluginId = BaseFlutterPlugin.DEFAULT_PLUGIN_ID;

  /// ***************系统带的方法*****************/

  /// init
  @mustCallSuper
  @override
  void initState() {
    super.initState();

    print("nc-base  initState");
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    // 屏幕适配
    screenInit(context);
    return buildWidget(context);
  }

  @protected
  Widget buildWidget(BuildContext context);

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    route = ModalRoute.of(context);
    Map<dynamic, dynamic>? arguments = route?.settings.arguments as Map?;
    print("nc-base  name:${route?.settings.name} argument:$arguments");
    pluginId = arguments?["uniqueId"] ?? BaseFlutterPlugin.DEFAULT_PLUGIN_ID;

    addChannelPlugin();

    _registerEvent();

    ///注册监听器
    PageVisibilityBinding.instance.addObserver(this, route!);
  }

  @mustCallSuper
  @override
  void dispose() {
    print("nc-base  dispose");

    /// 移除监听器
    PageVisibilityBinding.instance.removeObserver(this);

    // 移除事件监听、依赖于channel，必须在channel plugin 移除之前执行
    removeEventObserver();

    /// 移除plugin
    if (flutterPlugin != null) {
      ChannelDispatcher().removePlugin(flutterPlugin);
    }
    if (eventFlutterPlugin != null) {
      ChannelDispatcher().removePlugin(eventFlutterPlugin);
    }

    super.dispose();
  }

  /****************以下是PageVisibilityObserver的生命周期方法***************/

  /// 页面显示
  @override
  void onPageShow() {
    super.onPageShow();
  }

  /// 页面隐藏
  @override
  void onPageHide() {
    super.onPageHide();
  }

  /// 前台
  @override
  void onForeground() {
    super.onForeground();
  }

  /// 后台
  @override
  void onBackground() {
    super.onBackground();
  }

  /****************以上是PageVisibilityObserver的生命周期方法***************/

  /****************以下是自定义公共方法***************/

  /// 创建FlutterPlugin
  /// 默认返回null
  /// 子类如果需要用channel跟原生交互需要重写此方法给一个具体的plugin
  BaseFlutterPlugin? createFlutterPlugin() {
    return null;
  }

  /// 创建EventFlutterPlugin
  /// 默认实现
  /// 子类只需要实现[handleEvent]方法处理具体事件即可
  BaseFlutterPlugin? _createEventFlutterPlugin() {
    return new EventFlutterPlugin(NCFlutterPluginName.Event, (methodName, params) {
      /// 收到事件
      // {
      //   "callbackId": "callbackId",
      //   "name": "event_name",
      //   "sendEnv": ["native", "hybrid"],
      //   "param": {
      //     "param1": "param1",
      //     "param2": "param2"
      //   }
      // }
      if (methodName == EventFlutterPlugin.EVENT_CALLBACK) {
        String? eventName = params[EventParamsKeys.KEY_NAME];
        String? callbackId = params[EventParamsKeys.KEY_CALLBACK_ID];
        Map<dynamic, dynamic>? data = params[EventParamsKeys.KEY_PARAM];
        if (eventName != null && eventName.isNotEmpty && callbackId == eventCallbackId) {
          handleEvent(eventName, data);
        }
      }
    }, pluginId: pluginId);
  }

  String get eventCallbackId => EventManager().createEventCallbackId(this);

  /// 创建并添加plugin
  void addChannelPlugin() {
    flutterPlugin = createFlutterPlugin();
    ChannelDispatcher().addPlugin(flutterPlugin);
  }

  /// 创建并添加事件消息传递的channel plugin
  void _addEventChannelPlugin() {
    if (eventFlutterPlugin == null) {
      eventFlutterPlugin = _createEventFlutterPlugin();
      ChannelDispatcher().addPlugin(eventFlutterPlugin);
    }
  }

  /// 注册事件序列
  /// 必须在[didChangeDependencies]方法获取[pluginId]之后再执行
  void _registerEvent() {
    // 注册事件监听的同时 添加一下事件消息传递的channel plugin
    _addEventChannelPlugin();
    List<String>? eventList = appendEvent();
    if(eventList?.isNotEmpty == true) {
      eventList?.forEach((eventName) {
        _addEventObserver(eventName);
      });
    }
  }

  /// 添加要注册的事件
  /// 子类自行实现
  List<String>? appendEvent() {
    return null;
  }

  /// 注册具体的某一个事件
  void _addEventObserver(String eventName) async {
    LogUtil.e("addEventObserver fire ");
    EventManager()
        .addEventObserver(eventName, eventFlutterPlugin!, eventCallbackId)
        .then((observerId) {
          LogUtil.e("addEventObserver observerId $observerId");
          if (observerId != null && observerId.isNotEmpty) {
            eventObserverIds.add(observerId);
          }
        })
        .timeout(Duration(milliseconds: 500)) //这里设置500毫秒超时，避免主线程阻塞
        .then((value) => {LogUtil.e("addEventObserver timeout $value")});
  }

  /// 解注事件
  void removeEventObserver() {
    if (eventObserverIds.isNotEmpty) {
      EventManager().removeEventObserver(eventObserverIds, eventFlutterPlugin!);
      eventObserverIds.clear();
    }
  }

  /// 发送事件
  void postEvent(String eventName, {List<String>? receiveEnv, Map<String, dynamic>? data}) {
    EventManager().postEvent(eventName, eventFlutterPlugin!, receiveEnv: receiveEnv, data: data);
  }

  /// 处理事件中心转发来的事件
  /// 子类自行实现
  void handleEvent(String eventName, Map<dynamic, dynamic>? data) {
    // 根据eventName处理事件
  }

  /// 避免StatefulElement销毁后调用系统的[setState]方法抛出错误
  /// 这里封装一层判断
  void setStateSafely({VoidCallback? fn}) {
    setState(fn ?? () {});
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
/****************以上是自定义公共方法***************/
}

/// BaseStatefulWidget [State]类型边界限定为自定义的[NCBaseState]
abstract class NCBaseStatefulWidget<T extends NCBaseState> extends StatefulWidget {
  const NCBaseStatefulWidget({Key? key}) : super(key: key);

  @mustCallSuper
  @override
  State<StatefulWidget> createState() => create();

  T create();
}
