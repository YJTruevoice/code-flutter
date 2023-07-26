def flutter_branch = FlutterBranch
def is_release = IsRelease == "true"
def project_path = "/Users/nowcoder_mobile/Desktop/Nowcoder/NC_Flutter_Framework/ncflutter"

        /// 过滤后前面 origin 的分支
        def branch = ['bash', '-c', '''FlutterBranch=''' + flutter_branch + ''';FlutterBranchParam=${FlutterBranch#*origin*/};echo ${FlutterBranchParam}'''].execute().text.replaceAll("\n", "")

        def checkout_branch = ('cd '  + project_path + ''';
          git branch -r | grep -v \'\\->\' | while read remote;
          do git branch --track \"${remote#origin/}\" \"$remote\"; done;
          git fetch -p && git branch -vv | grep \': gone]\' | awk \'{print $1}\' | xargs git branch -D;
          git checkout ''' + branch + ''' || exit;
          git reset --hard origin/''' + branch + ''';git pull''').replaceAll("\n", "")

        println(checkout_branch)

        /// 切换到指定分支
        ['bash', '-c', checkout_branch].execute()

        /// 延时两秒，避免切换分支之后读取到的版本还是未切换前的
        sleep(2000)

        /// 获取指定分支
        def ncflutter_version = ['bash', '-c', '''
          ncflutter_version_str=`grep -E 'version:' ''' + project_path + '''/pubspec.yaml | tail -n1 | awk '{ print $2}'`
          echo $ncflutter_version_str
        '''].execute().text.replaceAll("\n", "")

        def result_version = ""

        if (branch.contains("version/") || branch.equals("develop")) {
            // 发版分支
            if (is_release) {
                result_version = ncflutter_version.split("\\+")[0]
            } else {
                result_version = ncflutter_version.replaceAll("\\+", ".")
            }
        } else {
            // 功能分支
            if (is_release) {
                result_version = ""
            } else {
                result_version = ncflutter_version.replaceAll("\\+", ".")  +  "."  + System.currentTimeSeconds().toString()
            }
        }

return "<input name=\"value\" value=\"${result_version}\" readonly=\"readonly\" style=\"width: 500px; height: 30px; font-size: 20px; border: none; outline: medium;\">"

