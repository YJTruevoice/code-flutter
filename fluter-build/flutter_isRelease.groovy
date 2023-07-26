def flutter_branch = FlutterBranch
def branch = ['bash', '-c', '''FlutterBranch=''' + flutter_branch + ''';FlutterBranchParam=${FlutterBranch#*origin*/};echo ${FlutterBranchParam}'''].execute().text.replaceAll("\n", "")

if (branch.contains("version/") || branch == "develop") {
   return [false,true]
} else {
   return [false]
}