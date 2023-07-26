# 下载脚本
cd /Users/nowcoder_mobile/Desktop/Nowcoder/NC_iOS/app-iOS-script
git pull


rm -r /Users/nowcoder_mobile/Desktop/Nowcoder/NC_Flutter_Framework/app-flutter-iOS-binary
cp -r /Users/nowcoder_mobile/Desktop/Nowcoder/NC_iOS/app-iOS-script/app-flutter-iOS-binary /Users/nowcoder_mobile/Desktop/Nowcoder/NC_Flutter_Framework/app-flutter-iOS-binary


# Flutter工程分支
FlutterBranchParam=${FlutterBranch#*origin*/}

# 是否更新Flutter.xcframework
update_flutter_engie_param=${update_flutter_engie}

# 是否是正式版
IsReleaseParam=${IsRelease}

# 该次打包生成版本
BinaryVersionParam=$(echo ${BinaryVersion} | sed "s/,//g")

# 更新日志、去除里面的空格
descriptionParam=${description}

# 执行范围
# all iOS Android
typeParam=${type}


## iOS执行

if [ "${typeParam}" == "all" ] || [ "${typeParam}" == "iOS" ]; then

	cd /Users/nowcoder_mobile/Desktop/Nowcoder/NC_Flutter_Framework/app-flutter-iOS-binary/Shell
	sh flutterPackage.sh $FlutterBranchParam $update_flutter_engie_param ${IsReleaseParam} ${BinaryVersionParam}
    
    ios_version=$BinaryVersionParam
    
    info='
    {
    "msgtype": "markdown",
    "markdown": {
        "content": "🎉🎉🎉 iOS Flutter 二进制有了新版本了 🎉🎉🎉\n版本号：<font color=\"info\"> **'${ios_version}'** </font>\n分支：<font color=\"info\"> **'${FlutterBranchParam}'** </font>\n备注：<font color=\"info\"> **'${descriptionParam}'** </font>\n请相关同事注意。"
     }
   }'
   
   curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=189a4268-9ce4-4aac-abe4-9fe02bf6e4a3' \
    -H 'Content-Type: application/json' \
    -d "${info}"


fi


## Android执行
if [ "${typeParam}" == "all" ] || [ "${typeParam}" == "Android" ]; then

	cd /Users/nowcoder_mobile/Desktop/Nowcoder/NC_Flutter_Framework/ncflutter_android
    
    git fetch
    git checkout $FlutterBranchParam
    git pull
    

    chmod 777 ./uploadAndroid/build_flutter_aar_jenkins.sh
    sh uploadAndroid/build_flutter_aar_jenkins.sh $FlutterBranchParam ${IsReleaseParam} ${BinaryVersionParam} 
    android_version=$BinaryVersionParam


	info='
   {
    "msgtype": "markdown",
    "markdown": {
        "content": "🎉🎉🎉 Android Flutter 二进制有了新版本了 🎉🎉🎉\n版本号：<font color=\"info\"> **'${android_version}'** </font>\n分支：<font color=\"info\"> **'${FlutterBranchParam}'** </font>\n备注：<font color=\"info\"> **'${descriptionParam}'** </font>\n请相关同事注意。"
    }
   }'
   
    curl 'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=189a4268-9ce4-4aac-abe4-9fe02bf6e4a3' \
    -H 'Content-Type: application/json' \
    -d "${info}"
   
fi




