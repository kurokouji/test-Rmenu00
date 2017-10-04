# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'drb'                                                                   # dRubyライブラリを読みこむ
require 'RmenuTupleParallelMainServer'

if __FILE__ == $0
  begin

    # タプル並列サーバのインスタンス
    tuple_parallel_server = RmenuTupleParallelMainServer.new("tupleparallelserver")
	
    # タプル並列サーバの公開
    DRb.start_service($Rconfig["parallelserver_uri"], tuple_parallel_server)
    puts DRb.uri
    puts "TupleParallelServer ready"
    DRb.thread.join          # joinが有ることで、メインスレッドが終了しない
  rescue => error
    puts error
  end
end
