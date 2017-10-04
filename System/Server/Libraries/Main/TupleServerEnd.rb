# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuTupleSpace'

if __FILE__ == $0
  begin
    # タプルスペースのインスタンス
    tuplespace = RmenuTupleSpace.new()

    # タプルサーバを終了する
    tuplespace.writeTupleServerEnd()
  rescue => error
    puts error
  end
end
