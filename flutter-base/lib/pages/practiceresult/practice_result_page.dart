import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:ncchannel/nc_channel.dart';
import 'package:ncchannel/nc_flutter_plugin_name.dart';
import 'package:ncflutter/common/global.dart';
import 'package:ncflutter/common/nc_colors.dart';
import 'package:ncflutter/common/nc_text_style.dart';
import 'package:ncflutter/common/screens/nc_text.dart';
import 'package:ncflutter/pages/common/model/question_bank_activity_entity.dart';
import 'package:ncflutter/pages/practiceresult/cpn/progress_painter.dart';
import 'package:ncflutter/pages/practiceresult/theme/theme_mode_color_map.dart';
import 'package:ncflutter/utils/channel_util.dart';
import 'package:ncflutter/utils/net/net_utils.dart';
import 'package:ncflutter/utils/ui_utils.dart';
import 'package:ncflutter/widgets/base/nc_base.dart';
import 'package:ncflutter/widgets/dialog/loading.dart';
import 'package:ncflutter/widgets/dialog/toast.dart';
import 'package:ncflutter/widgets/nc_ui_widget.dart';
import 'package:ncflutter/common/screens/unit_extension.dart';

import '../../main.dart';
import 'model/practice_result_data_entity.dart';

class PracticeResultPage extends NCBaseStatefulWidget<_PracticeResultState> {
  final int tId;

  // themeMode主题样式 0：白天模式（默认） 1：夜间模式
  final int themeMode;
  final bool flutterPush;

  PracticeResultPage(this.tId, {this.themeMode = 0, this.flutterPush = false})
      : super(key: Key(themeMode.toString())) {
    print('传入 themeMode ： $themeMode');
  }

  @override
  _PracticeResultState create() => _PracticeResultState();
}

class _PracticeResultState extends NCBaseState<PracticeResultPage> with SingleTickerProviderStateMixin {
  PracticeResultDataEntity _data = PracticeResultDataEntity();

  List<bool> skillLoadedEnds = [];

  // 题库活动入口信息
  bool _showQuestionBankActivityEnter = false;
  QuestionBankActivityEntity? activityInfo;

  bool activityEnterFold = false; // 活动入口是否收起状态
  bool isScrolling = false; // 是否正在滑动
  double activityEnterMarginRight = 0;

  @override
  PracticeResultPage get widget => super.widget as PracticeResultPage;

  @override
  void initState() {
    super.initState();
    if (widget.tId == 0) {
      _gioData(_data, isSuccess: false);
      NCToast.show("数据出错");
    } else {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _getData();
      });
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    ColorMap.themeMode = widget.themeMode;
    print('themeMode ColorMap 赋值： ${ColorMap.themeMode}');
    return Theme(
        key: Key(ColorMap.themeMode.toString()),
        data: ThemeData(
            brightness: widget.themeMode == 1 ? Brightness.dark : Brightness.light,
            primaryColor: ColorMap.primaryColor,
            primaryColorLight: primaryColor,
            primaryColorDark: primaryDarkColor,
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent //Tabbar背景颜色
            ),
            backgroundColor: ColorMap.backgroundColor,
            scaffoldBackgroundColor: ColorMap.scaffoldBackgroundColor),
        child: _buildWidget(context));
  }

  @override
  void dispose() {
    ColorMap.themeMode = 0;
    print('themeMode dispose ColorMap 重置： ${ColorMap.themeMode}');
    super.dispose();
  }

  Widget _buildWidget(BuildContext context) {
    return Scaffold(
        key: Key(ColorMap.themeMode.toString()),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Platform.isIOS ? 44.w : kToolbarHeight),
          child: AppBar(
            elevation: 0,
            leading:
                ncNavBack(context: context, flutterPush: widget.flutterPush, iconColor: ColorMap.navBackIconColor),
            title: NCText(
              "练习报告",
              style: TextStyle(color: ColorMap.pageTitleColor, fontSize: 16.w, fontWeight: NCFontWeight.medium),
            ),
            centerTitle: true,
          ),
        ),
        body: Stack(children: <Widget>[
          NotificationListener<ScrollNotification>(
              child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(children: <Widget>[
                    _examinationPagerNameWidget(context),
                    _answerSituationWidget(context),
                    _answerSheetWidget(context),
                    _abilityChangeWidget(context)
                  ])),
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollUpdateNotification) {
                  if (!activityEnterFold) {
                    setState(() {
                      activityEnterFold = true;
                    });
                  }
                  isScrolling = true;
                } else if (scrollNotification is ScrollEndNotification) {
                  Future.delayed(Duration(milliseconds: 2000)).whenComplete(() {
                    if (activityEnterFold && isScrolling) {
                      isScrolling = false;
                      setState(() {
                        activityEnterFold = false;
                      });
                    }
                  });
                }
                return false;
              }),
          if (_showQuestionBankActivityEnter) _buildQuestionBankActivityEnter()
        ]),
        bottomNavigationBar: _bottomActionsWidget(context));
  }

  /// 试卷名称
  Widget _examinationPagerNameWidget(BuildContext context) {
    return AspectRatio(
        aspectRatio: 7 / 6,
        child: Container(
            width: UIUtils.screenWidth(context),
            decoration: ShapeDecoration(
                color: ColorMap.cardBgColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(10.0)))),
            padding: EdgeInsetsDirectional.fromSTEB(12.0.w, 14.5.w, 12.0.w, 14.5.w),
            margin: EdgeInsetsDirectional.only(start: 12.0.w, top: 8.0.w, end: 12.0.w),
            child: Stack(children: <Widget>[
              _moduleLabelTextWidget("试卷名称"),
              Positioned(
                  top: 28.0.w,
                  child: NCText(_data.paper.paperName,
                      style: TextStyle(color: ColorMap.contentTextColor, fontSize: 14.sp), maxLines: 1)),
              Positioned(
                  right: .0,
                  child: Container(
                      alignment: Alignment.center,
                      height: 24.w,
                      padding: EdgeInsetsDirectional.only(start: 8.0.w, end: 8.0.w),
                      decoration: ShapeDecoration(
                          color: ColorMap.cardBgColor,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: ColorMap.contentTextColor, width: 0.5.w),
                              borderRadius: BorderRadiusDirectional.all(Radius.circular(12.0)))),
                      child: NCText(_data.costTime,
                          style: TextStyle(color: ColorMap.contentTextColor, fontSize: 12.sp)))),
              Positioned(
                  left: 75.0.w,
                  right: 75.0.w,
                  bottom: 40.0.w,
                  child: Container(
                      width: 170.0.w,
                      height: 170.0.w,
                      child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
                        Container(
                          width: 155.0.w,
                          height: 155.0.w,
                          decoration: ShapeDecoration(
                              color: ColorMap.normalBgColor,
                              shape: CircleBorder(),
                              shadows: [
                                BoxShadow(color: ColorMap.boxShadowColor, blurRadius: 30.0, spreadRadius: 0)
                              ]),
                        ),
                        Container(
                            width: 170.0.w,
                            height: 170.0.w,
                            child: TweenAnimationBuilder(
                                tween: Tween(begin: 0.0, end: _data.rightRateDouble / 100),
                                duration: Duration(seconds: 1),
                                builder: (BuildContext context, double value, Widget? child) {
                                  return CustomPaint(
                                      painter: CircleProgressPainter(value),
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                NCText("${(value * 100).toStringAsFixed(2)}%",
                                                    style: TextStyle(
                                                        color: ColorMap.normalTextColor,
                                                        fontSize: 32.sp,
                                                        fontWeight: NCFontWeight.medium)),
                                                SizedBox(height: 12.0.w),
                                                _moduleLabelTextWidget("正确率")
                                              ])));
                                }))
                      ])))
            ])));
  }

  /// 作答情况
  Widget _answerSituationWidget(BuildContext context) {
    return Container(
        width: UIUtils.screenWidth(context),
        decoration: ShapeDecoration(
            color: ColorMap.cardBgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(10.0)))),
        padding: EdgeInsetsDirectional.fromSTEB(12.0.w, 14.5.w, 12.0.w, 14.5.w),
        margin: EdgeInsetsDirectional.only(start: 12.0.w, top: 8.0.w, end: 12.0.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          _moduleLabelTextWidget("作答情况"),
          Container(
              margin: EdgeInsets.only(top: 21.0.w),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      NCText("${_data.paper.questionCount}",
                          style: TextStyle(
                              color: ColorMap.normalTextColor, fontSize: 20.sp, fontWeight: NCFontWeight.normal)),
                      SizedBox(height: 9.0.w),
                      NCText("共计", style: TextStyle(color: ColorMap.contentTextColor, fontSize: 12.sp))
                    ])),
                Container(width: 1.0.w, height: 16.0.w, color: ColorMap.dividerColor),
                Container(
                    alignment: Alignment.center,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      NCText("${_data.rightTotal}",
                          style: TextStyle(
                              color: NCColor.mainColor, fontSize: 20.sp, fontWeight: NCFontWeight.normal)),
                      SizedBox(height: 9.0.w),
                      NCText("答对", style: TextStyle(color: ColorMap.contentTextColor, fontSize: 12.sp))
                    ])),
                Container(width: 1.0.w, height: 16.0.w, color: ColorMap.dividerColor),
                Container(
                    alignment: Alignment.center,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      NCText("${_data.wrongCount}",
                          style: TextStyle(
                              color: Color(0xFFFF5A47), fontSize: 20.sp, fontWeight: NCFontWeight.normal)),
                      SizedBox(height: 9.0.w),
                      NCText("答错", style: TextStyle(color: ColorMap.contentTextColor, fontSize: 12.sp))
                    ])),
                Container(width: 1.0.w, height: 16.0.w, color: ColorMap.dividerColor),
                Container(
                    alignment: Alignment.center,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      NCText("${_data.notDone}",
                          style: TextStyle(
                              color: ColorMap.contentDarkTextColor,
                              fontSize: 20.sp,
                              fontWeight: NCFontWeight.normal)),
                      SizedBox(height: 9.0.w),
                      NCText("未作答", style: TextStyle(color: ColorMap.contentTextColor, fontSize: 12.sp))
                    ]))
              ]))
        ]));
  }

  /// 答题卡
  Widget _answerSheetWidget(BuildContext context) {
    return Container(
        width: UIUtils.screenWidth(context),
        decoration: ShapeDecoration(
            color: ColorMap.cardBgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(10.0)))),
        padding: EdgeInsetsDirectional.fromSTEB(12.0.w, 14.5.w, 12.0.w, 14.5.w),
        margin: EdgeInsetsDirectional.only(start: 12.0.w, top: 8.0.w, end: 12.0.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          _moduleLabelTextWidget("答题卡"),
          Container(
              margin: EdgeInsets.only(top: 9.w),
              child: Row(children: <Widget>[
                Container(
                  width: 8.0.w,
                  height: 8.0.w,
                  decoration: BoxDecoration(color: NCColor.mainColor, shape: BoxShape.circle),
                ),
                SizedBox(width: 4.0.w),
                NCText("正确", style: TextStyle(color: ColorMap.contentTextColor, fontSize: 12.sp)),
                SizedBox(width: 28.0.w),
                Container(
                  width: 8.0.w,
                  height: 8.0.w,
                  decoration: BoxDecoration(color: Color(0xFFFF5A47), shape: BoxShape.circle),
                ),
                SizedBox(width: 4.0.w),
                NCText("错误", style: TextStyle(color: ColorMap.contentTextColor, fontSize: 12.sp)),
                SizedBox(width: 28.0),
                Container(
                  width: 8.0.w,
                  height: 8.0.w,
                  decoration: BoxDecoration(color: ColorMap.elementBgColor, shape: BoxShape.circle),
                ),
                SizedBox(width: 4.0.w),
                NCText("未作答", style: TextStyle(color: ColorMap.contentTextColor, fontSize: 12.sp)),
              ])),
          SizedBox(height: 12.0.w),
          Container(
              margin: EdgeInsets.all(8.0.w),
              child: GridView.builder(
                // 自身自适应填充到父布局
                shrinkWrap: true,
                // 组织滑动，避免跟外部的SingleChildScrollView产生滑动冲突
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, mainAxisSpacing: 16.0.w, crossAxisSpacing: 38.0.w),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        width: 32.0.w,
                        height: 32.0.w,
                        decoration: _getDoneDecoration(_data.doneInfo[index]),
                        child: NCText("${_data.doneInfo[index].posTitle}",
                            style: TextStyle(
                                color: (_data.doneInfo[index].hasDone)
                                    ? NCTextColor.white
                                    : ColorMap.contentTextColor,
                                fontSize: 14.sp,
                                fontFamily: 'SanFranciscoText')),
                      ),
                      onTap: () {
                        _gotoQuestionTerminal(pos: index);
                      });
                },
                itemCount: _data.paper.questionCount,
              ))
        ]));
  }

  /// 获取答题卡 背景的 Decoration
  BoxDecoration _getDoneDecoration(PracticeResultDataDoneInfo info) {
    if (info.hasDone) {
      if (info.code == 1) {
        return BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [NCColor.greenBtnStartBg, NCColor.greenBtnEndBg]));
      } else {
        return BoxDecoration(color: Color(0xFFFF5A47), shape: BoxShape.circle);
      }
    }
    return BoxDecoration(color: ColorMap.elementBgColor, shape: BoxShape.circle);
  }

  /// 能力变化widget
  Widget _abilityChangeWidget(BuildContext context) {
    if (_data.changeSkillInfos != null && _data.changeSkillInfos.isNotEmpty) {
      return Container(
          width: UIUtils.screenWidth(context),
          decoration: ShapeDecoration(
              color: ColorMap.cardBgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.all(Radius.circular(10.0)))),
          padding: EdgeInsetsDirectional.fromSTEB(12.0.w, 14.5.w, 12.0.w, 14.5.w),
          margin: EdgeInsetsDirectional.fromSTEB(12.0.w, 8.0.w, 12.0.w, 8.0.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            _moduleLabelTextWidget("能力变化"),
            if (_data.changeSkillInfos != null && _data.changeSkillInfos.isNotEmpty)
              Column(
                children: _skillChangeItemWidget() ?? <Widget>[],
              )
          ]));
    } else
      return SizedBox(height: 8.w);
  }

  List<Widget>? _skillChangeItemWidget() {
    List<PracticeResultDataChangeSkillInfos?> skillChanges = _data.changeSkillInfos;
    if (skillChanges != null && skillChanges.isNotEmpty) {
      int len = skillChanges.length;
      var children = List<Widget>.filled(len, Container(), growable: false);
      for (int i = 0; i < len; i++) {
        PracticeResultDataChangeSkillInfos info = skillChanges[i]!;
        print("oldValue = ${info.oldValue}   newValue = ${info.newValue}");
        children[i] = Container(
            margin: EdgeInsets.only(top: 2.0.w),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
              NCText(info.tagName, style: TextStyle(color: ColorMap.contentDarkTextColor, fontSize: 14.sp)),
              SizedBox(width: 8.0.w),
              Expanded(
                  child: Stack(alignment: AlignmentDirectional.bottomCenter, children: <Widget>[
                Container(
                    // 指定stack内部空间高度，不然就会无限高
                    height: 40.0.w),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 5.0.w,
                    child: Container(
                        height: 8.0.w,
                        child: CustomPaint(painter: LineProgressPainter(1, colorValue: ColorMap.elementBgColor)))),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 5.0.w,
                    child: Container(
                        height: 8.0.w,
                        child: TweenAnimationBuilder(
                          tween: Tween(begin: 0.0, end: info.newValue / 100),
                          duration: Duration(seconds: 1),
                          builder: (BuildContext context, double value, Widget? child) {
                            return CustomPaint(painter: LineProgressPainter(value, colorValue: Color(0xFFB2F0E3)));
                          },
                          onEnd: () {
                            setState(() {
                              skillLoadedEnds[i] = true;
                            });
                          },
                        ))),
                if (skillLoadedEnds[i] && (info.newValue > info.oldValue))
                  Positioned(
                      top: 0,
                      right: 30.w,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(5.0.w, 6.0.w, 5.0.w, 10.0.w),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/zhuanxiang/ic_skill_changed_pop_arraw.webp"))),
                          child: NCText("+${info.newValue - info.oldValue}",
                              style: TextStyle(color: NCTextColor.white, fontSize: 12.w)))),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 5.0.w,
                    child: Container(
                        height: 8.0.w,
                        child: TweenAnimationBuilder(
                            tween: Tween(begin: 0.0, end: info.oldValue / 100),
                            duration: Duration(seconds: 1),
                            builder: (BuildContext context, double value, Widget? child) {
                              return CustomPaint(
                                  painter:
                                      LineProgressPainter(value, colorValue: NCColor.mainColor, isGradient: true));
                            })))
              ])),
              SizedBox(width: 12.0.w),
              NCText("${info.newValue}",
                  style: TextStyle(
                      color: NCColor.mainColor, fontSize: 16.sp, fontWeight: NCFontWeight.medium))
            ]));
      }
      return children;
    } else {
      return null;
    }
  }

  /// 底部操作按钮（全部解析 & 错题解析）
  Widget _bottomActionsWidget(BuildContext context) {
    if (_data.paper.paperName.isNotEmpty)
      return Container(
          color: ColorMap.bottomBgColor,
          width: UIUtils.screenWidth(context),
          height: 96.0.w,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(width: 12.0.w),
            Expanded(
              child: GestureDetector(
                  child: Container(
                      alignment: Alignment.center,
                      child: NCText("全部解析",
                          style: TextStyle(
                              color: ColorMap.contentTextColor, fontSize: 16.sp, fontWeight: NCFontWeight.medium)),
                      decoration: ShapeDecoration(
                          color: ColorMap.btnBgColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusDirectional.all(Radius.circular(24.0)))),
                      margin: EdgeInsetsDirectional.only(top: 24.0.w, bottom: 24.0.w)),
                  onTap: () {
                    _gotoQuestionTerminal();
                    print('跳转 全部解析 页面');
                  }),
            ),
            SizedBox(width: 12.0.w),
            Expanded(
                child: GestureDetector(
                    child: Container(
                        alignment: Alignment.center,
                        child: NCText("错题解析",
                            style: TextStyle(
                                color: NCTextColor.white, fontSize: 16.sp, fontWeight: NCFontWeight.medium)),
                        decoration: ShapeDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [NCColor.greenBtnStartBg, NCColor.greenBtnEndBg]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusDirectional.all(Radius.circular(24.0)))),
                        margin: EdgeInsetsDirectional.only(top: 24.0.w, bottom: 24.0.w)),
                    onTap: () {
                      if (_data.paper.questionCount - _data.rightTotal == 0) {
                        NCToast.show("没有错题");
                      } else {
                        _gotoQuestionTerminal(onlyWrong: "1");
                      }
                      print('跳转 错题解析 页面');
                    })),
            SizedBox(width: 12.0.w)
          ]));
    else
      return Container(height: 10.w);
  }

  /// 创建本页面每个模块标签名
  Widget _moduleLabelTextWidget(String label) {
    return NCText(label,
        style: TextStyle(color: ColorMap.normalTextColor, fontSize: 16.sp, fontWeight: NCFontWeight.medium));
  }

  /// 创建题库活动入口按钮
  Widget _buildQuestionBankActivityEnter() {
    Global.gioStatistics(key: "activityItemView", params: {
      "activityName_var": "APP12月刷题活动",
      "pageName_var": "练习报告",
    });
    return Positioned(
        right: activityEnterFold ? -25.0.w : 0,
        bottom: 42.w,
        child: GestureDetector(
          child: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: activityEnterFold ? 0 : 20),
            child: Image.network(
              activityInfo!.imageUrl,
              width: 50,
              height: 50,
            ),
          ),
          onTap: () {
            BoostNavigator.instance.push(activityInfo!.indexUrl);
            Global.gioStatistics(key: "activityItemClick", params: {
              "activityName_var": "APP12月刷题活动",
              "pageName_var": "练习报告",
            });
          },
        ));
  }

  _initQuestionBankActivityEnter() async {
    activityInfo = await ChannelUtil.getQuestionBankActivityData();
    setState(() {
      var currentTimeMillis = new DateTime.now().millisecondsSinceEpoch;
      if (activityInfo != null && activityInfo!.isStart == 1 && currentTimeMillis < activityInfo!.endTime) {
        _showQuestionBankActivityEnter = true;
      } else {
        _showQuestionBankActivityEnter = false;
      }
    });
  }

  _gotoQuestionTerminal({String onlyWrong = "0", int pos = -1}) {
    if (Platform.isIOS) {
      //question/list?tagId=${that.$query.tid}&source=${bAll ? 'resultAll' : 'resultWrong'}&index=${nIndex}&changeScore=${that.item.changeScore}&tags=${that.item.tags}

      /// 新页面 question/analysis
      BoostNavigator.instance.push("question/analysis", arguments: <String, dynamic>{
        "tagId": widget.tId,
        "source": onlyWrong == "0" ? 'resultAll' : 'resultWrong',
        "index": pos,
        "changeScore": _data.changeScore,
        "tags": _data.tags,
        "themeMode": widget.themeMode //themeMode主题样式 0：白天模式（默认） 1：夜间模式
      });
    } else {
      Map<String, String> params = {
        "tId": "${widget.tId}",
        "type": "1",
        "totalCount": "${_data.paper.questionCount}",
        "totalRight": "${_data.rightTotal}",
        "paperName": "${_data.paper.paperName}",
        "onlyWrong": "$onlyWrong",
        "testType": "${_data.isIntelligent ? 1 : 2}",
        "pagerId": "${_data.paper.paperId}",
        "testTagId": "${_data.tags}",
        "changeScore": "${_data.changeScore}",
        "difficult": "${_data.paper.difficult}",
        "pos": "$pos",
        "themeMode": "${widget.themeMode}" //themeMode主题样式 0：白天模式（默认） 1：夜间模式
      };
      NCChannel().invoke("questionTerminal", params: params, pluginName: NCFlutterPluginName.QuestionBank, pluginId: pluginId);
    }
  }

  /// 请求练习结果
  _getData() async {
    Loading.showLoading();
    NetUtils.request<PracticeResultDataEntity>("/test/get-test-result", params: {"tid": widget.tId}).then((data) {
      if (data != null) {
        setState(() {
          _data = data;
          List<PracticeResultDataChangeSkillInfos> skillChanges = _data.changeSkillInfos;
          if (skillChanges != null && skillChanges.isNotEmpty) {
            int len = skillChanges.length;
            for (int i = 0; i < len; i++) {
              skillLoadedEnds.add(false);
            }
          }
        });
        _gioData(data);
      }
    }).catchError((e) {
      NCToast.show(e.toString());
    }).whenComplete(() {
      _initQuestionBankActivityEnter();
      Loading.hideLoading();
    });
  }

  /// 统计
  _gioData(PracticeResultDataEntity data, {bool isSuccess = true}) {
    Global.gioStatistics(key: "answerEnd", params: {
      "questionBankType_var": data.isIntelligent ? "专项练习" : "公司真题",
      "company_var": data.paper.company.isEmpty ? "" : data.paper.company,
      "position_var": data.paper.position.isEmpty ? "" : data.paper.position,
      "testPaperID_var": data.paper.id.toString(),
      "testPaperYear_var": data.paper.testPaperYear.isEmpty ? "" : data.paper.testPaperYear,
      "testPaperName_var": data.paper.paperName.isEmpty ? "" : data.paper.paperName,
      "questionMode_var": "练习模式",
      "difficulty_var": ["不限", "入门", "简单", "中等", "较难", "困难"][data.paper.diffcult],
      "isSubmitSuccess_var": isSuccess ? "是" : "否",
      "correctRate_var": data.rightRate.toString() + "%",
      "answerNumber_var": data.paper.questionCount.toString(),
      "answerEndReason_var": "交卷",
      "questionBankcategory1_var": data.isIntelligent ? _getTrackParamsBankLevelValue(data, 1) : "",
      "questionBankcategory2_var": data.isIntelligent ? _getTrackParamsBankLevelValue(data, 2) : "",
      "questionBankcategory3_var": data.isIntelligent ? _getTrackParamsBankLevelValue(data, 3) : ""
    });
  }

  /// 埋点 获取题库级别分类
  String _getTrackParamsBankLevelValue(PracticeResultDataEntity data, int level) {
    var jobLevelNames = data.questionJobInfo.jobLevelNames;
    if (data != null && data.questionJobInfo != null && jobLevelNames.isNotEmpty) {
      switch (level) {
        case 1:
          return jobLevelNames[0];
        case 2:
          return jobLevelNames.length >= 2 ? jobLevelNames[1] : "";
        case 3:
          return jobLevelNames.length >= 3 ? jobLevelNames[2] : "";
      }
    }
    return "";
  }
}
