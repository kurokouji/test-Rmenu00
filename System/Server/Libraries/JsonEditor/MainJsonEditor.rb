# coding: UTF-8

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'RmenuTsvForExcel'
require 'RmenuJsonDatasetEditor'
require 'RmenuJsonValidationEditor'
require 'RmenuJsonTranEditor'
require 'RmenuJsonSqlEditor'

# エクセルからCSVファイル（タブ区切り）を作成する
csv = RmenuTsvForExcel.new("editor");
csv.call(ARGV[0]);

# dataset.jsonを作成する
dataset = RmenuJsonDatasetEditor.new("editor");
dataset.call(ARGV[0]);

# validation.jsonを作成する
validation = RmenuJsonValidationEditor.new("editor");
validation.call(ARGV[0]);

# tran.jsonを作成する
tran = RmenuJsonTranEditor.new("editor");
tran.call(ARGV[0]);

# sql.jsonを作成する
sql = RmenuJsonSqlEditor.new("editor");
sql.call(ARGV[0]);

