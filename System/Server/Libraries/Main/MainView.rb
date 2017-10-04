# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'drb'                                                                   # dRubyライブラリを読みこむ
require 'RmenuMainView'

if __FILE__ == $0
  # ビューのインスタンス＆公開
  DRb.start_service($Rconfig["view_uri"], RmenuMainView.new("view"))
  puts DRb.uri
  DRb.thread.join                                                               # joinが有ることで、メインスレッドが終了しない
end

