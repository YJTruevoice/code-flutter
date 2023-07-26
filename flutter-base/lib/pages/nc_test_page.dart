import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ncflutter/common/event/event_manager.dart';
import 'package:ncflutter/common/nc_colors.dart';
import 'package:ncflutter/common/nc_text_style.dart';
import 'package:ncflutter/common/screens/nc_text.dart';
import 'package:ncflutter/common/screens/unit_extension.dart';
import 'package:ncflutter/widgets/base/nc_base.dart';
import 'package:ncflutter/widgets/nc_switch.dart';
import 'package:ncflutter/widgets/nc_ui_widget.dart';

class NCTestPage extends NCBaseStatefulWidget<_NCTestPageState> {
  @override
  _NCTestPageState create() => _NCTestPageState();
}

class _NCTestPageState extends NCBaseState<NCTestPage> with SingleTickerProviderStateMixin {
  bool _stateValue = false;

  Map<dynamic, dynamic>? data;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print("子类  dispose");
    super.dispose();
  }

  @override
  List<String> appendEvent() {
    return [EventNameConsts.TEST_EVENT];
  }

  @override
  void handleEvent(String eventName, Map<dynamic, dynamic>? data) {
    if (eventName == EventNameConsts.TEST_EVENT) {
      this.data = data;
      setStateSafely();
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Platform.isIOS ? 44.w : kToolbarHeight),
          child: AppBar(
            elevation: 0,
            leading: ncNavBack(
              context: context,
              iconColor: ncFont,
            ),
            title: NCText(
              "测试页面",
              style: TextStyle(color: NCTextColor.normalColor, fontSize: 16.w, fontWeight: NCFontWeight.medium),
            ),
            centerTitle: true,
          ),
        ),
        body: Center(
          child: Column(
            children: [
              NCSwitch(
                value: _stateValue,
                onChanged: (value) {
                  _stateValue = value;
                  setState(() {});
                  // do something
                },
              ),
              Container(
                height: 20.dp,
              ),
              MaterialButton(
                child: NCText(
                  "发送消息",
                  style: TextStyle(color: NCTextColor.white, fontSize: 14.w),
                ),
                color: NCColor.mainColor,
                onPressed: () {
                  postEvent(EventNameConsts.TEST_EVENT,
                      receiveEnv: ["native"],
                      data: {"testParam": "test", "time": DateTime.now().millisecondsSinceEpoch});
                },
              ),
              Container(
                height: 20.dp,
              ),
              NCText(
                "${this.data ?? "空数据"}",
                maxLines: 999,
                style: TextStyle(color: NCTextColor.contentColor, fontSize: 12.w),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
        ));
  }
}
