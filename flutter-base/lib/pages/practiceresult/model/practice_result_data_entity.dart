import 'package:ncflutter/generated/json/base/json_convert_content.dart';

class PracticeResultDataEntity with JsonConvert<PracticeResultDataEntity> {
  List<PracticeResultDataDoneInfo> doneInfo = [];
  bool isIntelligent = false;
  String rightRate = "";
  double rightRateDouble = 0;
  int wrongCount = 0;
  int notDone = 0;
  List<PracticeResultDataChangeSkillInfos> changeSkillInfos = [];
  int rightTotal = 0;
  bool isWrongSetPaper = false;
  String tags = "";
  int changeScore = 0;
  List<PracticeResultDataSkills> skills = [];
  int score = 0;
  PracticeResultDataPaper paper = PracticeResultDataPaper();
  String costTime = "";
  int rate = 0;
  QuestionJobInfoEntity questionJobInfo = QuestionJobInfoEntity();

  double getRightRate() {
    if (rightRate != null && rightRate.isNotEmpty) {
      return double.parse(rightRate);
    } else {
      return 0;
    }
  }
}

class PracticeResultDataDoneInfo with JsonConvert<PracticeResultDataDoneInfo> {
  int code = 0;
  int duration = 0;
  bool hasDone = false;
  bool mark = false;
  String posTitle = "";
  int position = 0;
  int questionId = 0;
  int questionType = 0;
}

class PracticeResultDataChangeSkillInfos with JsonConvert<PracticeResultDataChangeSkillInfos> {
  int doneCount = 0;
  int newValue = 0;
  int oldValue = 0;
  int rightCount = 0;
  int tagId = 0;
  String tagName = "";
  int totalCount = 0;
}

class PracticeResultDataSkills with JsonConvert<PracticeResultDataSkills> {
  PracticeResultDataSkillsProperties properties = PracticeResultDataSkillsProperties();
}

class PracticeResultDataSkillsProperties with JsonConvert<PracticeResultDataSkillsProperties> {
  String name = "";
  List<PracticeResultDataSkillsPropertiesDetails> details = [];
  int id = 0;
}

class PracticeResultDataSkillsPropertiesDetails with JsonConvert<PracticeResultDataSkillsPropertiesDetails> {
  PracticeResultDataSkillsPropertiesDetailsProperties properties =
      PracticeResultDataSkillsPropertiesDetailsProperties();
}

class PracticeResultDataSkillsPropertiesDetailsProperties
    with JsonConvert<PracticeResultDataSkillsPropertiesDetailsProperties> {
  String score = "";
  String maximumScore = "";
  int totalCnt = 0;
  int avgDiff = 0;
  int bigTagId = 0;
  int tagId = 0;
  String rightRation = "";
  int rightCnt = 0;
  String tagName = "";
  int totalScore = 0;
}

class PracticeResultDataPaper with JsonConvert<PracticeResultDataPaper> {
  int questionCount = 0;
  int diffcult = 0;
  bool hasAppQuestionType = false;
  int difficult = 0;
  bool isIntelligentPaper = false;
  int personTotal = 0;
  bool vCompany = false;
  int duration = 0;
  String imgUrl = "";
  int score = 0;
  String paperName = "";
  String company = ""; // 公司名称
  String position = ""; // 地区
  String testPaperYear = ""; // 年限
  int avgTotal = 0;
  int id = 0;
  int paperId = 0;
}

/// 全行业题库新增参数(埋点需要)
class QuestionJobInfoEntity with JsonConvert<QuestionJobInfoEntity> {
  List<String> jobLevelNames = [];
  String name = "";
  int id = 0;
}
