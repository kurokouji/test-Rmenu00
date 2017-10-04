# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuTupleMainClient'

if __FILE__ == $0
  begin
    # タプルクライアントのインスタンス
    rmenu_tuple_client = RmenuTupleMainClient.new("tupleclient")
    puts "TapleClient ready"
    rmenu_tuple_client.call()
  rescue => error
    puts error
  end
end
