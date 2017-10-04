#!/bin/tcsh
#-- 停止 -----
# MainView の停止
#set pids = (`ps x | grep ruby | grep MainView | awk '{print $1}'`)
#if ($#pids == 1) then
#	kill -9 $pids
#endif
# MainModel の停止
#set pids = (`ps x | grep ruby | grep MainModel | awk '{print $1}'`)
#if ($#pids == 1) then
#	kill -9 $pids
#endif
# MainController の停止
set pids = (`ps x | grep ruby | grep MainController | awk '{print $1}'`)
if ($#pids == 1) then
	kill -9 $pids
endif

# PrintServer の停止
set pids = (`ps x | grep ruby | grep PrintServer | awk '{print $1}'`)
if ($#pids == 1) then
	kill -9 $pids
endif
# TupleClient の停止
${home}/Rmenu/System/no19_TupleClientEnd.sh
# TupleServer の停止
${home}/Rmenu/System/no18_TupleServerEnd.sh
# TupleSpace の停止
set pids = (`ps x | grep ruby | grep TupleSpace | awk '{print $1}'`)
if ($#pids == 1) then
	kill -9 $pids
endif


#-- 起動 -----
# TupleSpace の起動(ログ削除も実行)
${home}/Rmenu/System/no11_TupleSpace.sh -la &
sleep 1
# TupleServer の起動(ログ削除も実行)
${home}/Rmenu/System/no12_TupleServer.sh -la &
sleep 1
# TupleClient の起動(ログ削除も実行)
${home}/Rmenu/System/no13_TupleClient.sh -la &
sleep 1

# PrintServer の起動
${HOME}/Rmenu/System/no4_PrintServer.sh -la &
sleep 1

# MainModel の起動(ログ削除も実行)
#${home}/Rmenu/System/no2_MainModel.sh -la &
#sleep 1
# MainView の起動(ログ削除も実行)
#${home}/Rmenu/System/no3_MainView.sh -la &
#sleep 1
# MainController の起動(ログ削除も実行)
${home}/Rmenu/System/no1_MainController.sh -la &
