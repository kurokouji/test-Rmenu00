# coding: UTF-8

$LOAD_PATH.push(File.dirname(__FILE__) + "/System/Server/Libraries/Main/")

require './rmenumain'
require './rmenuhtml'
require './rmenulogin.rb'
require './rmenudownload.rb'
require './rmenuupload.rb'
require './rmenudocs'
require './rmenutext'

use Rack::Static, :urls => ["/Application", "/System"]

# 業務画面用 ラック
map '/RmenuRack/RmenuMain.rb' do
  run RmenuMain.new
end

# Html画面用 ラック
map '/RmenuRack/RmenuHtml.rb' do
  run RmenuHtml.new
end

# ログイン用 ラック
map '/RmenuRack/RmenuLogin.rb' do
  run RmenuLogin.new
end

map '/RmenuRack/RmenuDownload.rb' do
  run RmenuDownload.new
end

# アップロード用 ラック
map '/RmenuRack/RmenuUpload.rb' do
  run RmenuUpload.new
end

# ドキュメント画面用 ラック
map '/RmenuRack/RmenuDocs.rb' do
  run RmenuDocs.new
end

# テキストファイル用 ラック
map '/RmenuRack/RmenuText.rb' do
  run RmenuText.new
end
