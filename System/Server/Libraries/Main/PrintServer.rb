# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__))

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'drb'                                                                   # dRubyライブラリを読みこむ
require 'RmenuPrintServerMainController'

if __FILE__ == $0
  begin
    # プリントサーバ　メインコントローラのインスタンス＆公開
    DRb.start_service($Rconfig["printserver_uri"], RmenuPrintServerMainController.new("PrintController"))
    puts DRb.uri
    puts "PrintServer ready"
    DRb.thread.join                                                               # joinが有ることで、メインスレッドが終了しない
  rescue => error
    puts error
  end
end
