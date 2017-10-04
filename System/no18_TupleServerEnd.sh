#!/bin/sh

# 起動対象のRubyプログラム
exec_path="${HOME}/Rmenu/System/Server/Libraries/Main/TupleServerEnd.rb"

# 主処理
if [ -f $exec_path ]; then
	# カレントディレクトリ変更
	echo "カレントディレクトリ変更"
	echo "${exec_path%/*}"
	cd ${exec_path%/*}
	# Ruby プログラムの実行
	echo "タプルサーバを終了させる"
	ruby ${exec_path##/*/}
fi

exit
