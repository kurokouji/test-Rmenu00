#!/bin/sh

# 起動対象のRubyプログラム
exec_path="${HOME}/Rmenu/System/Server/Libraries/Main/MainController.rb"

# 前処理:コマンドラインオプションの確認
#-l:  起動前に最新のログファイルを削除する
#-la: 起動前に全てのログファイルを削除する
for args in $@; do
	case "${args}" in
	"-l" )
		log_dir="${HOME}/Rmenu/System/Server/Logs"
		rm -f ${log_dir}/ParallelStartUp.log
		rm -f ${log_dir}/controller.log
		rm -f ${log_dir}/model.log
		rm -f ${log_dir}/modelDB.log
		rm -f ${log_dir}/view.log
		;;
	"-la" )
		log_dir="${HOME}/Rmenu/System/Server/Logs"
		rm -f ${log_dir}/ParallelStartUp.log*
		rm -f ${log_dir}/controller.log*
		rm -f ${log_dir}/model.log*
		rm -f ${log_dir}/modelDB.log*
		rm -f ${log_dir}/view.log*
		;;
	esac
done

# 主処理
if [ -f $exec_path ]; then
	# カレントディレクトリ変更
	echo "カレントディレクトリ変更"
	echo "${exec_path%/*}"
	cd ${exec_path%/*}
	# Ruby プログラムの実行
	echo "メインコントローラを起動する"
	ruby ${exec_path##/*/}
fi

exit
