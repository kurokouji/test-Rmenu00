# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuTupleMainServer'

if __FILE__ == $0
  begin
    # タプルサーバのインスタンス
    rmenu_tuple_server = RmenuTupleMainServer.new("tupleserver")
    puts "TapleServer ready"
    rmenu_tuple_server.call()
  rescue => error
    puts error
  end
end
