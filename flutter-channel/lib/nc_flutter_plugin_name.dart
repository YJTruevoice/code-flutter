/// 寻找插件名的统一入口
class FindPluginName {
  static FindPluginName? _instance;

  FindPluginName._internal() {
    _instance = this;
  }

  factory FindPluginName() => _instance ?? FindPluginName._internal();

  /// 寻找插件名
  String find(NCFlutterPluginName pluginName) {
    String name = "";
    switch (pluginName) {
      case NCFlutterPluginName.UserInfo:
        name = "UserInfo";
        break;
      case NCFlutterPluginName.NPS:
        name = "NPS";
        break;
      case NCFlutterPluginName.InterviewExp:
        name = "InterviewExp";
        break;
      case NCFlutterPluginName.UserSetting:
        name = "UserSetting";
        break;
      case NCFlutterPluginName.QuestionBank:
        name = "QuestionBank";
        break;
      case NCFlutterPluginName.HybridConnection:
        name = "HybridConnection";
        break;
      case NCFlutterPluginName.NowPick:
        name = "NowPick";
        break;
      case NCFlutterPluginName.PushSetting:
        name = "PushSetting";
        break;
      case NCFlutterPluginName.Chat:
        name = "Chat";
        break;
      case NCFlutterPluginName.Event:
        name = "Event";
        break;
      default:
        name = "BasicFunc"; // 默认给通用的plugin
    }
    return name;
  }
}

/// 该枚举类列出了目前所用到的原生/flutter交互的插件名
/// 后期如有新增，统一在这里添加枚举类型
enum NCFlutterPluginName {
  BasicFunc, // 通用基础功能
  UserInfo, // 用户登录信息
  NPS, // NPS相关
  InterviewExp, // 面经攻略筛选
  UserSetting, // 用户设置相关
  QuestionBank, // 题库相关 包括编程题和面试
  HybridConnection, // Hybrid 交互
  NowPick, // 牛聘相关
  PushSetting,// 推送设置
  Chat, //消息相关
  Event, // 事件中心
}
