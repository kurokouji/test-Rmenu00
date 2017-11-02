# coding: UTF-8

require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する
require 'RmenuTupleSpace'
require 'Myapp00/Server/Modules/Myapp00OfMasterMainteOfModelMixin'

class ParallelDivisionList_model
  include RmenuJsonMixin
  include Myapp00OfMasterMainteOfModelMixin

  def initialize(rmenu_dbi, sql_data, request_data)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("ParallelDivisionList_model") {"initialize start"}                   # Logファイル Debug用

      @rmenu_dbi      = rmenu_dbi
      @sql_data       = sql_data
      @request_data   = request_data

      # initialize 終了ログを出力する
      $Mlog.debug("ParallelDivisionList_model") {"initialize normal end"}              # Logファイル Debug用
    rescue Exception
      # エラーログを出力する
      $Mlog.error("ParallelDivisionList_model") {"initialize exception: #{$!}"}        # Logファイル Debug用
      raise
    end
  end

  # 再処理するタプルクライアントをタプルスペースに出力する
  def writeTupleClientOfMyapp00()
    $Mlog.debug("ParallelDivisionList_model") {"writeTupleClientOfMyapp00 start"}                  # Logファイル Debug用

    request_record  = @request_data["records"][0]["record"]
    controllID      = request_record["再処理並列分散管理ＩＤ"]["value"][0].to_i
    divisionID      = request_record["再処理並列分割管理ＩＤ"]["value"][0].to_i
    dbname          = @sql_data["sqls"][0]["output"]["record"]["ＤＢ名"]["value"][0]

    $Mlog.debug("Test_ParallelDivisionList_model") {"再処理並列分散管理ＩＤ : #{controllID}"}
    $Mlog.debug("Test_ParallelDivisionList_model") {"再処理並列分割管理ＩＤ : #{divisionID}"}
    $Mlog.debug("Test_ParallelDivisionList_model") {"ＤＢ名　　　　　       : #{dbname}"}

    tuplespace = RmenuTupleSpace.new()                                                    # タプルスペース
    tuplespace.writeTupleClient(controllID, divisionID, dbname)

    $Mlog.debug("ParallelDivisionList_model") {"writeTupleClientOfMyapp00 end"}                    # Logファイル Debug用
    return "OK"
  end

end
