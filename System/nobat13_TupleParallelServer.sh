#!/bin/sh

# 起動対象のRubyプログラム
exec_path="${HOME}/Rmenu/System/Server/Libraries/Main/TupleParallelServer.rb"

# 前処理:コマンドラインオプションの確認
#-l:  起動前に最新のログファイルを削除する
#-la: 起動前に全てのログファイルを削除する
for args in $@; do
	case "${args}" in
	"-l" )
		log_dir="${HOME}/Rmenu/System/Server/Logs"
		rm -f ${log_dir}/tupleclientDB.log
		rm -f ${log_dir}/tupleclient.log
		rm -f ${log_dir}/TupleMainController.log
		;;
	"-la" )
		log_dir="${HOME}/Rmenu/System/Server/Logs"
		rm -f ${log_dir}/tupleclientDB.log*
		rm -f ${log_dir}/tupleclient.log*
		rm -f ${log_dir}/TupleMainController.log*
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
	echo "タプルクライアントを起動する"
	ruby ${exec_path##/*/}
fi

exit
