#!/bin/sh

# 起動対象のRubyプログラム
exec_path="${HOME}/Rmenu/System/Server/Libraries/Main/PrintServer.rb"

# 前処理:コマンドラインオプションの確認
#-l:  起動前に最新のログファイルを削除する
#-la: 起動前に全てのログファイルを削除する
for args in $@; do
	case "${args}" in
	"-l" )
		log_dir="${HOME}/Rmenu/System/Server/Logs"
		rm -f ${log_dir}/PrintController.log
		rm -f ${log_dir}/printmodel.log
		rm -f ${log_dir}/printmodelDB.log
		rm -f ${log_dir}/printview.log
		rm -f ${log_dir}/pdfcontroller.log
		rm -f ${log_dir}/pdfcreate.log
		;;
	"-la" )
		log_dir="${HOME}/Rmenu/System/Server/Logs"
		rm -f ${log_dir}/PrintController.log*
		rm -f ${log_dir}/printmodel.log*
		rm -f ${log_dir}/printmodelDB.log*
		rm -f ${log_dir}/printview.log*
		rm -f ${log_dir}/pdfcontroller.log*
		rm -f ${log_dir}/pdfcreate.log*
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
	echo "プリントサーバを起動する"
	ruby ${exec_path##/*/}
fi

exit
