#!/usr/bin/env bash

# flutter分支
fBranch=$1
# 是否为release版本
isRelease=$2
# 流水线传入的版本号
targetVersion=$3
# 项目根目录
projectRootPath=$4

## flutter分支
#fBranch="feature/flutter_aar_shell"
## 是否为release版本
#isRelease="true"
## 流水线传入的版本号
#targetVersion="1.0.0"

# 计算机密码
password="1234"
# sudo管理员权限
function doSudo() {
  echo $password | sudo -S $*
}

if [[ -z $projectRootPath ]]; then
  echo "cur path $(pwd)"
  projectRootPath=$(pwd)
fi

# 进入到flutter工程根目录下
cd "$projectRootPath" || exit

git fetch origin
bFlutter=${fBranch#*origin*/}
git checkout "$bFlutter"
git pull

echo "flutter clean"
doSudo flutter clean

# 是否为release版本 0:测试；1：线上
IS_RELEASE=0
if [[ "$isRelease" = "true" ]]; then
  IS_RELEASE=1
fi

# 读取flutter版本并升级
cd $projectRootPath || exit

####################################没有版本传入会自动读取pubspec.yaml文件中的版本号#####################################
# 当前分支
CURRENT_BRANCH=$bFlutter
# 将要打出的版本号，优先流水线传入
TARGET_VERSION=$targetVersion

# 如果传进来的版号为空 就直接用./pubspec.yaml文件中的version
if [[ -z $TARGET_VERSION ]]; then
  fVersion=$(grep version ./pubspec.yaml)
  fVersion=${fVersion##*version: }
  echo "fVersion=${fVersion}"

  # 读取上次的build版本
  buildVersion=${fVersion%%+*}
  echo "buildVersion=${buildVersion}"
  TARGET_VERSION=$buildVersion
  # 读取上次的option版本
  optionalVersion=${fVersion##*+}
  echo "optionalVersion=${optionalVersion}"

  # 如果是快照版本就在targetOptionalVersion拼接
  echo "是否为release版本 $IS_RELEASE"
  if ((IS_RELEASE == 0)); then
    if [[ -z $CURRENT_BRANCH ]]; then
      CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
    fi
    if [[ $CURRENT_BRANCH =~ version || $CURRENT_BRANCH =~ develop ]]; then
      TARGET_VERSION=$buildVersion.$optionalVersion
    else
      # 如果是在feature分支 拼接一个时间戳
      TARGET_VERSION=$buildVersion.$optionalVersion.$(date '+%s')
    fi
  fi
fi
####################################没有版本传入会自动读取pubspec.yaml文件中的版本号#####################################

echo "flutter build aar start"
doSudo flutter build aar --no-debug --no-profile --target-platform android-arm,android-arm64 --build-number="$TARGET_VERSION" || exit
echo "flutter build aar end"

echo "upload aar start"
doSudo sh uploadAndroid/repo_migrate.sh $IS_RELEASE $projectRootPath $|| exit
echo "upload aar end"
