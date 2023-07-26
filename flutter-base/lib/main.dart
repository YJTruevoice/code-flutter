import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ume/flutter_ume.dart';
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart';
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart';
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart';
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart';
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:ncflutter/common/nc_colors.dart';
import 'package:ncflutter/common/page_paths.dart';
import 'package:ncflutter/pages/account/bloc/purchased_bloc.dart';
import 'package:ncflutter/pages/account/purchased_page.dart';
import 'package:ncflutter/pages/collection/bloc/collection_bloc.dart';
import 'package:ncflutter/pages/collection/collection_page.dart';
import 'package:ncflutter/pages/courses/bloc/CoursesBloc.dart';
import 'package:ncflutter/pages/courses/courses_page.dart';
import 'package:ncflutter/pages/filter/cpn/company_filter_page.dart';
import 'package:ncflutter/pages/filter/cpn/company_interview_filter_page.dart';
import 'package:ncflutter/pages/filter/cpn/company_interview_question_filter_page.dart';
import 'package:ncflutter/pages/filter/cpn/company_question_filter_page.dart';
import 'package:ncflutter/pages/filter/cpn/school_major_page.dart';
import 'package:ncflutter/pages/header/bloc/HeaderDecorateBloc.dart';
import 'package:ncflutter/pages/header/header_decorate_page.dart';
import 'package:ncflutter/pages/header/header_preview_page.dart';
import 'package:ncflutter/pages/intelliTest/bloc/test_bloc.dart';
import 'package:ncflutter/pages/intelliTest/intelli_page.dart';
import 'package:ncflutter/pages/intelliTest/intelli_test_page.dart';
import 'package:ncflutter/pages/interviewquebank/bloc/interview_que_search_bloc.dart';
import 'package:ncflutter/pages/interviewquebank/interview_question_bank_page.dart';
import 'package:ncflutter/pages/jobSelect/job_select_page.dart';
import 'package:ncflutter/pages/keyword/bloc/keyword_bloc.dart';
import 'package:ncflutter/pages/keyword/keyword_page.dart';
import 'package:ncflutter/pages/message/bloc/chat_bloc.dart';
import 'package:ncflutter/pages/message/chat_page.dart';
import 'package:ncflutter/pages/myCircles/circle_page.dart';
import 'package:ncflutter/pages/myCircles/slide_view.dart';
import 'package:ncflutter/pages/nowpick/chat/bloc/np_chat_bloc.dart';
import 'package:ncflutter/pages/nowpick/chat/np_chat_page.dart';
import 'package:ncflutter/pages/nowpick/job/np_job_filter_page.dart';
import 'package:ncflutter/pages/nowpick/job/np_search_city_page.dart';
import 'package:ncflutter/pages/nowpick/chat/np_search_hr_page.dart';
import 'package:ncflutter/pages/nowpick/setting/chat_setting_page.dart';
import 'package:ncflutter/pages/nowpick/setting/cpn/greeting_add_page.dart';
import 'package:ncflutter/pages/nowpick/setting/cpn/greeting_setting_page.dart';
import 'package:ncflutter/pages/paper/company_paper_page.dart';
import 'package:ncflutter/pages/practiceresult/practice_result_page.dart';
import 'package:ncflutter/pages/program/bloc/program_bloc.dart';
import 'package:ncflutter/pages/program/bloc/program_part_bloc.dart';
import 'package:ncflutter/pages/program/bloc/program_search_bloc.dart';
import 'package:ncflutter/pages/program/cpn/program_question_filter.dart';
import 'package:ncflutter/pages/program/cpn/program_search_page.dart';
import 'package:ncflutter/pages/program/program_page.dart';
import 'package:ncflutter/pages/question/bloc/question_bloc.dart';
import 'package:ncflutter/pages/question/bloc/question_rank_bloc.dart';
import 'package:ncflutter/pages/question/bloc/question_search_bloc.dart';
import 'package:ncflutter/pages/question/bloc/ta_search_bloc.dart';
import 'package:ncflutter/pages/question/question_rank_page.dart';
import 'package:ncflutter/pages/question/question_search_page.dart';
import 'package:ncflutter/pages/question/question_page.dart';
import 'package:ncflutter/pages/question/ta_question_page.dart';
import 'package:ncflutter/pages/recommend/cpn/referral_filter_bottom_sheet.dart';
import 'package:ncflutter/pages/recommend/recommend_all_page.dart';
import 'package:ncflutter/pages/recommend/bloc/recommend_bloc.dart';
import 'package:ncflutter/pages/recommend/recommend_page.dart';
import 'package:ncflutter/pages/setting/push/push_setting_page.dart';
import 'package:ncflutter/pages/social/referral_list_page.dart';
import 'package:ncflutter/pages/talist/ta_list_rank_page.dart';
import 'package:ncflutter/pages/intelliTest/bloc/rank_bloc.dart';
import 'package:ncflutter/pages/intelliTest/cpn/rank_list.dart';
import 'package:ncflutter/pages/school/bloc/school_bloc.dart';
import 'package:ncflutter/pages/school/school_page.dart';
import 'package:ncflutter/pages/paper/bloc/company_paper_bloc.dart';
import 'package:ncflutter/pages/social/bloc/experience_bloc.dart';
import 'package:ncflutter/pages/social/experience_page.dart';
import 'package:ncflutter/pages/talist/bloc/TaListBloc.dart';
import 'package:flutter/foundation.dart';
import 'package:ncflutter/pages/testedpaper/bloc/MyTestsBloc.dart';
import 'package:ncflutter/utils/channel_util.dart';
import 'package:ncflutter/utils/log_util.dart';
import 'package:ncflutter/utils/net/net_utils.dart';
import 'package:ncflutter/utils/ui_utils.dart';
import 'package:ncflutter/widgets/input/bloc/emoji_bloc.dart';
import 'package:ncflutter/widgets/template/cpn/template_filter_page.dart';
import 'package:provider/provider.dart';

import 'common/global.dart';
import 'companyprofile/company_introduce_page.dart';
import 'companyprofile/company_profile_bloc.dart';
import 'menu_list_widget.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }


  Route<dynamic>? routeFactory(RouteSettings settings, String? uniqueId) {
    Function? routeFunction = pagePaths()[settings.name!];

    /**
     * 页面跳转的时候，会调用isFlutterPage
     * 会调用本方法，按旧有逻辑，应该先经过原生
     * 所以这里uniqueId为null时返回null
     */
    if (routeFunction == null || uniqueId == null) {
      return null;
    }

    late Map<String, dynamic> params;
    if (settings.arguments == null) {
      params = {};
    } else {
      params = settings.arguments as Map<String, dynamic>;
    }
    print("routeFactory $uniqueId");
    params["uniqueId"] = uniqueId;

    Widget? page = routeFunction(settings.name, params, uniqueId);

    FlutterBoostRouteFactory func = (settings, uniqueId) {
      return CupertinoPageRoute(builder: (context) {
        print("routeFactory $uniqueId");
        return page!;
      }, settings: settings);
    };
    beforePageOpen();
    print("routeFactory $uniqueId");
    return func(settings, uniqueId);
  }

  Widget appBuilder(Widget home) {
    return MaterialApp(
      home: home,
      title: "牛客",
      theme: getThemeData(),
      debugShowCheckedModeBanner: false,
      // 加入国际化
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,//一定要配置,否则iphone手机长按编辑框有白屏
      ],
      // 支持中文
      supportedLocales: [
        const Locale('zh', 'CN'),
        const Locale('en', 'US'),
      ],

      ///必须加上builder参数，否则showDialog等会出问题
      builder: (_, __) {
        return home;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      routeFactory,
      appBuilder: appBuilder,
      initialRoute: 'main/home',
    );
  }

  /// 页面打开之前的操作
  /// 目前用于更新用户信息
  void beforePageOpen() {
    ChannelUtil.getUser();
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    screenInit(context);
    UIUtils.init(context);
    Global.initVisitorVariable();
    // return QuestionPage(type: 1, taId: 188,); //专题页面
//  return TaListRankPage(taIds: [188,190,191,194], nowId: 194,);
//  return KeywordPage(keyword: "阿里巴巴", type: "tag",); //关键词
//  可选"判断链表中是否有环":"program","leetcode":"other","剑指offer":"other","群面":"tutorial","机器学习":"vod-course","修改简历":"live-course"
//  return SchoolPage(school: "学院",); //学校选择组件
//  return QuestionRank(taId: 13, barHieght: 24,); //专题排行榜
//  return QuestionSearchPage(taId: 88,); //专题搜索页面
//  return RankList(1, 0, "技术（软件）/信息技术类"); //做题排行榜页面，可从专项练习和公司真题中跳入
//  return CompanyPaperPage(recommendCompanyId: 898,); //公司真题
//  return IntelliPage(isPK: 0,isEveryDay: 0,); //专线练习和PK聚合页入口
//  return CompanyPage(id: 179,recommendDiscussId:1);
//  return ExperiencePage(id:639);
//  return ChatPage(conversationId: "197692214_513845795");
//  return TaQuestionPage(taId: 88,questionId: 280803, topicType: "question",),
//  return TaQuestionPage(taId: 88,questionId: 280984,);
//  return GreetingSettingPage();
//  return NPJobFilterPage(filterParam: {"recruitType": 3},);
//  return NPChatPage(conversationId: "2339",hrId: 844401858,hrName: "梁杰2",);
    // return NPSearchCityPage(showAllCity: true);
    // 页面列表页面，后续相关flutter页面建议可以在该页面加上，方便测试
    // return CompanyFilterPage(selectCompanyIds: "138,151", selectCompanyNames: "腾讯,京东", jobId: "1",);
    // 页面列表页面，后续相关flutter页面建议可以在该页面加上，方便测试
    // return MenuListWidget();
    // return GreetingAddPage();
    // return CompanyInterviewFilterPage(companyId: "139",);
    // return CollectionPage(tabName: "post",);
    // return CompanyInterviewFilterPage(categoryId: "0", jobIds: "642", interviewTypeIds: "1",);
    // return CompanyQuestionFilterPage(categoryId: "0", jobIds: "4367,849", yearIds: "651,253", statusIds: "3",);
    // return CompanyInterviewQuestionFilterPage("138", questionJobId: "118", tagIds: "147370,147391", frequency: "3",);
    // return ReferralListPage(companyId: "138",);
    return Container();
  }
}

void main() {
  CustomFlutterBinding();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));

  LogUtil.init(isDebug: kDebugMode,tag: 'NC_FLUTTER');
  LogUtil.v("flutter_main_exe");
  ///添加全局生命周期监听类
  PageVisibilityBinding.instance.addGlobalObserver(AppLifecycleObserver());
  var providerApp = MultiProvider(
    providers: [
      ChangeNotifierProvider<ExperienceBloc>(
        create: (_) => ExperienceBloc(),
      ),
      ChangeNotifierProvider<PurchasedBloc>(
        create: (_) => PurchasedBloc(),
      ),
      ChangeNotifierProvider<ChatBloc>(
        create: (_) => ChatBloc(),
      ),
      ChangeNotifierProvider<EmojiBloc>(
        create: (_) => EmojiBloc(),
      ),
      ChangeNotifierProvider<TestBloc>(
        create: (_) => TestBloc(),
      ),
      ChangeNotifierProvider<QuestionRankBloc>(
        create: (_) => QuestionRankBloc(),
      ),
      ChangeNotifierProvider<CompanyPaperBloc>(
        create: (_) => CompanyPaperBloc(),
      ),
      ChangeNotifierProvider<TaSearchBloc>(
        create: (_) => TaSearchBloc(),
      ),
      ChangeNotifierProvider<QuestionSearchBloc>(
        create: (_) => QuestionSearchBloc(),
      ),
      ChangeNotifierProvider<SchoolBloc>(
        create: (_) => SchoolBloc(),
      ),
      ChangeNotifierProvider<KeywordBloc>(
        create: (_) => KeywordBloc(),
      ),
      ChangeNotifierProvider<HeaderDecorateBloc>(
        create: (_) => HeaderDecorateBloc(),
      ),
      ChangeNotifierProvider<TaListBloc>(
        create: (_) => TaListBloc(),
      ),
      ChangeNotifierProvider<QuestionBloc>(
        create: (_) => QuestionBloc(),
      ),
      ChangeNotifierProvider<NPChatBloc>(
        create: (_) => NPChatBloc(),
      ),
      ChangeNotifierProvider<CoursesBloc>(
        create: (_) => CoursesBloc(),
      ),
      ChangeNotifierProvider<RecommendBloc>(
        create: (_) => RecommendBloc(),
      ),
      ChangeNotifierProvider<ProgramBloc>(
        create: (_) => ProgramBloc(),
      ),
      ChangeNotifierProvider<ProgramPartBloc>(
        create: (_) => ProgramPartBloc(),
      ),
      ChangeNotifierProvider<ProgramSearchBloc>(
        create: (_) => ProgramSearchBloc(),
      ),
      ChangeNotifierProvider<CollectionBloc>(
        create: (_) => CollectionBloc(),
      ),
      ChangeNotifierProvider<InterviewQueSearchBloc>(
        create: (_) => InterviewQueSearchBloc(),
      ),
      ChangeNotifierProvider<MyTestsBloc>(
        create: (_) => MyTestsBloc(),
      ),
      ChangeNotifierProvider<CompanyProfileBloc>(
        create: (_) => CompanyProfileBloc(),
      )
    ],
    child: MyApp(),
  );
  Global.init().then((value) {
    if (kDebugMode) {
      PluginManager.instance
        ..register(WidgetInfoInspector()) // Widget 信息
        ..register(WidgetDetailInspector()) // Widget 详情
        ..register(ColorSucker()) // 对齐标尺
        ..register(AlignRuler()) // 颜色吸管（新）
        ..register(ColorPicker())  // 颜色吸管
        ..register(TouchIndicator()) // 触控标记
        ..register(Performance()) // 内存信息
        ..register(ShowCode()) // 性能浮层
        ..register(MemoryInfoPage()) // CPU 信息
        ..register(CpuInfoPage()) // 设备信息
        ..register(DeviceInfoPanel()) // 代码查看
        ..register(Console()) // 日志展示
        ..register(DioInspector(dio: NetUtils.getDioInstance())); // Dio 网络请求调试工具
      runApp(UMEWidget(child: providerApp, enable: true)); // 初始化
    } else {
      runApp(providerApp);
    }
  });
}

///创建一个自定义的Binding，继承和with的关系如下，里面什么都不用写
class CustomFlutterBinding extends WidgetsFlutterBinding with BoostFlutterBinding {}

///全局生命周期监听示例
class AppLifecycleObserver with GlobalPageVisibilityObserver {
  @override
  void onBackground(Route route) {
    super.onBackground(route);
    print("AppLifecycleObserver - onBackground");
  }

  @override
  void onForeground(Route route) {
    super.onForeground(route);
    print("AppLifecycleObserver - onForground");
  }

  @override
  void onPagePush(Route route) {
    super.onPagePush(route);
    print("AppLifecycleObserver - onPagePush");
  }

  @override
  void onPagePop(Route route) {
    super.onPagePop(route);
    print("AppLifecycleObserver - onPagePop");
  }

  @override
  void onPageHide(Route route) {
    super.onPageHide(route);
    print("AppLifecycleObserver - onPageHide");
  }

  @override
  void onPageShow(Route route) {
    super.onPageShow(route);
    print("AppLifecycleObserver - onPageShow \nname = ${route.settings.name} arguments = ${route.settings.arguments}");
  }
}

///插件要求：context所对应的Widget必须是MaterialApp的子孙，否则不能使用MediaQuery.of(context)
void screenInit(BuildContext context){
  ScreenUtil.init(
      context,
      // Orientation.portrait,
      // 设计尺寸，height高度设置低些，保证.sp与.w值相同
      designSize: Size(375, 20)
  );
}
