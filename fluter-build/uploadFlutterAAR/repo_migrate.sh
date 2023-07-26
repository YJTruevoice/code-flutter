#!/usr/bin/env bash
#是否正式
isRelease=$1
#项目根目录
projectRootPath=$2
remoteRepoUrl=""
if ((isRelease == 1)); then
  remoteRepoUrl=https://packages.aliyun.com/maven/repository/2132864-release-gYJMkT/
else
  remoteRepoUrl=https://packages.aliyun.com/maven/repository/2132864-snapshot-rM8X5L
fi
echo "remoteRepoUrl=$remoteRepoUrl"
echo "projectRootPath=$projectRootPath"
java -jar uploadAndroid/migrate-local-repo-tool.jar -cd "$projectRootPath/build/host/outputs/repo" -t $remoteRepoUrl -u '62272d4bbc59cfaaf52a8763' -p 'MlFoR5SP4(ti'
