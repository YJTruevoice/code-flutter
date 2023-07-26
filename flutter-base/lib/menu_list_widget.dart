import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ncflutter/pages/browse/browse_list_page.dart';
import 'package:ncflutter/pages/collection/collection_page.dart';
import 'package:ncflutter/pages/courses/courses_page.dart';
import 'package:ncflutter/pages/filter/cpn/company_filter_page.dart';
import 'package:ncflutter/pages/interviewQuestion/interview_question_filter.dart';
import 'package:ncflutter/pages/interviewquebank/interview_que_bank_search_page.dart';
import 'package:ncflutter/pages/interviewquebank/interview_question_bank_page.dart';
import 'package:ncflutter/pages/jobSelect/job_select_page.dart';
import 'package:ncflutter/pages/message/chat_page.dart';
import 'package:ncflutter/pages/myCircles/circle_page.dart';
import 'package:ncflutter/pages/nc_test_page.dart';
import 'package:ncflutter/pages/nowpick/chat/np_chat_page.dart';
import 'package:ncflutter/pages/nowpick/job/np_job_filter_page.dart';
import 'package:ncflutter/pages/nowpick/job/np_search_city_page.dart';
import 'package:ncflutter/pages/nps/nps_data_collect_page.dart';
import 'package:ncflutter/pages/paper/company_paper_page.dart';
import 'package:ncflutter/pages/practiceresult/practice_result_page.dart';
import 'package:ncflutter/pages/program/program_page.dart';
import 'package:ncflutter/pages/recommend/recommend_all_page.dart';
import 'package:ncflutter/pages/recommend/recommend_page.dart';
import 'package:ncflutter/pages/nowpick/resume/np_myresume_page.dart';
import 'package:ncflutter/pages/setting/privacy/privacy_page.dart';
import 'package:ncflutter/pages/testedpaper/tested_paper_page.dart';

import 'common/nc_colors.dart';
import 'dart:io';

class MenuListWidget extends StatefulWidget {
  MenuListWidget({Key? key}) : super(key: key);

  @override
  _MenuListWidgetState createState() => _MenuListWidgetState();
}

class _MenuListWidgetState extends State<MenuListWidget> {
  var _menuList = [
    {"code": "test", "name": "测试页面"},
    {"code": "jobFilter", "name": "求职筛选"},
    {"code": "coursesList", "name": "课程列表"},
    {"code": "privacy", "name": "隐私设置"},
    {"code": "cityList", "name": "城市列表"},
    {"code": "recommend", "name": "找内推"},
    {"code": "myCircles", "name": "我的圈子"},
    {"code": "filterCompany", "name": "公司筛选"},
    {"code": "myResume", "name": "我的简历"},
    {"code": "companyPaper", "name": "公司真题"},
    {"code": "practiceResult", "name": "练习报告"},
    {"code": "interviewQuestionBank", "name": "面试题库"},
    {"code": "interviewQuestionBank", "name": "面试题库"},
    {"code": "programPage", "name": "编程题库"},
    {"code": "circlePage", "name": "我的圈子"},
    {"code": "recommendPage", "name": "内推"},
    {"code": "recommendAllPage", "name": "全部内推"},
    {"code": "npChatPage", "name": "牛聘机会沟通"},
    {"code": "npsDataCollect", "name": "NPS数据收集"},
    {"code": "jobSearch", "name": "职位搜索"},
    {"code": "chat","name":"私信"},
    {"code": "collection","name":"收藏"},
    {"code": "userBrowse","name":"浏览记录"},
    {"code": "userTests","name":"练习试卷"},
    {"code": "interviewQueBankSearch","name":"面试题库搜索"},
    {"code": "interviewQuestionFilter", "name": "面试题库筛选"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            primary: true,
            backgroundColor: ncNavColor,
            brightness: Brightness.light,
            elevation: 0.5,
            title: Text("页面列表", style: TextStyle(fontSize: 18, color: ncFont)),
          ),
          preferredSize: ui.Size.fromHeight(Platform.isIOS ? 44 : kToolbarHeight)),
      body: ListView.builder(
          itemCount: _menuList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: 52,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _menuList[index]["name"]!,
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Image(
                          width: 14,
                          height: 14,
                          fit: BoxFit.fill,
                          image: AssetImage("images/ic_arrow_right.png"),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _clickItem(_menuList[index]);
                  },
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    height: 1,
                    child: Divider(
                      color: Color(0xFFF7F8F9),
                      height: 1,
                    ))
              ],
            );
          }),
    );
  }

  void _clickItem(Map map) {
    var code = map["code"];
    var name = map["name"];
    switch (code) {
      case "test":
        {
          // 测试页面
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return NCTestPage();
          }));
        }
        break;
      case "jobFilter":
        {
          // 求职筛选项
          // 传入参数必填求职类型，recruitType，1、校招；2、实习；3、社招； 4、公司
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return NPJobFilterPage(filterParam: {"recruitType": 4});
          }));
        }
        break;
      case "coursesList":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return CoursesPage();
          }));
        }
        break;
      case "privacy":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return PrivacyPage();
          }));
        }
        break;
      case "cityList":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return NPSearchCityPage();
          }));
        }
        break;
      case "recommend":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return RecommendPage();
          }));
        }
        break;
      case "myCircles":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return CirclePage();
          }));
        }
        break;
      case "filterCompany":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return CompanyFilterPage();
          }));
        }
        break;
      case "myResume":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return NPMyResumePage();
          }));
        }
        break;
      case "companyPaper":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return CompanyPaperPage(mCompanyList: [], category: null, categoryName: "");
          }));
        }
        break;
      case "practiceResult":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return PracticeResultPage(34489455);
          }));
        }
        break;
      case "interviewQuestionBank":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return InterviewQuestionBankPage();
          }));
        }
        break;
      case "npChatPage":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            // {hrId: 131629163, conversationId: 195020, hrName: 梁女士}
            return NPChatPage(conversationId: '2974', hrId: 946224073, hrName: "梁女士");
          }));
        }
        break;
      case "npsDataCollect":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return NPSDataCollectPage();
          }));
        }
        break;
      case "programPage":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return ProgramPage();
          }));
        }
        break;
      case "circlePage":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return CirclePage();
          }));
        }
        break;
      case "recommendPage":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return RecommendPage();
          }));
        }
        break;
      case "recommendAllPage":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return RecommendAllPage(channel: "",);
          }));
        }
        break;
      case "jobSearch":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return JobSelectPage();
          }));
        }
        break;
      case "chat":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return ChatPage(conversationId: "302384_463550");
          }));
        }
        break;
      case "collection":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return CollectionPage();
          }));
        }
        break;
      case "userBrowse":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return BrowseListPage();
          }));
        }
        break;
      case "userTests":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return TestedPaperPage();
          }));
        }
        break;
      case "interviewQueBankSearch":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return InterviewQueBankSearchPage(questionJobIds: "159,160,161,156,157");
          }));
        }
        break;
      case "interviewQuestionFilter":
        {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return InterviewQuestionFilterPage("160", company: '', tags: '', status: '',);
          }));
        }
        break;
    }
  }
}
