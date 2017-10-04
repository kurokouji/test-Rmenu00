# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'rinda/tuplespace'

if __FILE__ == $0
  # タプルスペースの公開
  $TupleSpace = Rinda::TupleSpace.new(timeout=60)
  DRb.start_service($Rconfig["tuplespace_uri"], $TupleSpace)
  puts "URI:" + DRb.uri
  puts "TapleSpace ready"
  DRb.thread.join                                                               # joinが有ることで、メインスレッドが終了しない
end
