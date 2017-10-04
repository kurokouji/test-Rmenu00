# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'drb'                                                                   # dRubyライブラリを読みこむ
require 'RmenuMainModel'

if __FILE__ == $0
  # モデルのインスタンス＆公開
  DRb.start_service($Rconfig["model_uri"], RmenuMainModel.new("model"))
  puts DRb.uri
  DRb.thread.join                                                               # joinが有ることで、メインスレッドが終了しない
end
