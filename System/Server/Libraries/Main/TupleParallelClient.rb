# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'drb'                                                                   # dRubyライブラリを読みこむ
require 'RmenuTupleParallelMainClient'

if __FILE__ == $0
  begin
	  # タプル並列サーバへ接続する
    tuple_parallel_server = DRbObject.new_with_uri($Rconfig["parallelserver_uri"])

		# タプル並列クライアントのインスタンス
    tuple_parallel_client = RmenuTupleParallelMainClient.new("tupleparallelclient", tuple_parallel_server)
    puts "TupleParallelClient ready"
    tuple_parallel_client.call()
  rescue => error
    puts error
  end
end
