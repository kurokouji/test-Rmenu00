# coding: UTF-8

require "RmenuSqlGenMixin"
require 'json'
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

class RmenuParallelControll
  include RmenuSqlGenMixin
  include RmenuJsonMixin

  def initialize(rmenu_db)
    # initialize 開始ログを出力する
    #$Tlog.debug("RmenuParallelControll") {"initialize start"}

    @rmenu_db                 = rmenu_db

    # initialize 終了ログを出力する
    #$Tlog.debug("RmenuParallelControll") {"initialize normal end"}
  end

  # 並列分散管理テーブルの登録
  def controll_insert(sql_data)
    begin
      parallelControll = getJsonChunkById(sql_data, "sqls", "parallelControll")
      parallelRecord   = parallelControll["input"]["record"]

      # テーブル名を設定する
      str_sql1        = "INSERT INTO parallel_controll"

      # 列名・値を設定する
      str_sql2        = " ("
      str_sql3        = " VALUES ("

      parallelRecord.each do |name, value|
        # 列名を設定する
        str_sql2     += "#{name}, "

        # 値を設定する
        if name == "parallel_controll_id"
          str_sql3     += "NEXTVAL('parallel_controll_parallel_controll_id_seq'), "
        else
          if integerString?(value['value'][0]) || floatString?(value['value'][0])
            str_sql3   += "#{value['value'][0].to_s}, "
          else
            w_value     = "\'" + value['value'][0] + "\', "
            str_sql3   += w_value
          end
        end
      end

      str_sql2        = str_sql2.sub(/,\s$/, ')')
      str_sql3        = str_sql3.sub(/,\s$/, ')')

      # INSERT文を生成する
      str_sql         = str_sql1 + str_sql2 + str_sql3
      #$Tlog.debug("RmenuParallelControll") {"並列分散管理テーブル INSERT SQL : #{str_sql}"}

      # INSERT文を実行する
      @rmenu_db["default"].insert(str_sql)
      
      # INSERTした並列分散管理ＩＤを取得する

      str_sql              = "SELECT CURRVAL('parallel_controll_parallel_controll_id_seq')"
      parallel_controll_id = @rmenu_db["default"].select_value(str_sql)
      
      # parallel_controll_idを設定する
      #$Tlog.debug("RmenuParallelControll") {"並列分散管理テーブル 登録parallel_controll_id : #{parallel_controll_id}"}

      parallelRecord["parallel_controll_id"]["value"][0] = parallel_controll_id
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"insert エラー"}
      raise
    end
  end

  # 並列分散管理テーブル（開始日時）の更新
  def update_start_date(parallel_controll_id)
    begin
      # 開始日時を更新する
      str_sql         = "UPDATE parallel_controll SET start_datetime = clock_timestamp() WHERE parallel_controll_id = #{parallel_controll_id}"
      #$Tlog.debug("RmenuParallelControll") {"並列分散管理テーブル（開始日時） UPDATE SQL : #{str_sql}"}

      @rmenu_db["default"].update(str_sql)
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"update_start_date エラー"}
      raise
    end
  end

  # 並列分散管理テーブル（終了日時）の更新
  def update_end_date(parallel_controll_id)
    begin
      # 終了日時を更新する
      str_sql = "UPDATE parallel_controll SET end_datetime = clock_timestamp() WHERE parallel_controll_id = #{parallel_controll_id}"
      #$Tlog.debug("RmenuParallelControll") {"並列分散管理テーブル（終了日時） UPDATE SQL : #{str_sql}"}

      @rmenu_db["default"].update(str_sql)
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"update_end_date エラー"}
      raise
    end
  end
  
  # 並列分散管理テーブル（分割処理終了数・終了日時）の更新
  def update_end_number(parallel_controll_id)
    begin

      parallelData = controll_select_for_update(parallel_controll_id)

      # 分割数と処理終了回数を取得する
      division_number     = parallelData["division_number"].to_i
      division_end_number = parallelData["division_end_number"].to_i + 1

      nextStatus = false
      if division_number == division_end_number
        # 終了回数・終了日時を更新する
        str_sql       = "UPDATE parallel_controll SET division_end_number = #{division_end_number.to_s},"
        str_sql      += " end_datetime = clock_timestamp()"
        str_sql      += " WHERE parallel_controll_id = #{parallel_controll_id}"
        #$Tlog.debug("RmenuParallelControll") {"並列分散管理テーブル（分割処理終了数・終了日時） UPDATE SQL : #{str_sql}"}

        if parallelData["next_process"] != ""
          nextStatus = true
        end
      else
        # 終了回数を更新する
        str_sql       = "UPDATE parallel_controll SET division_end_number = #{division_end_number.to_s}"
        str_sql      += " WHERE parallel_controll_id = #{parallel_controll_id}"
        #$Tlog.debug("RmenuParallelControll") {"並列分散管理テーブル（分割処理終了数） UPDATE SQL : #{str_sql}"}
      end

      @rmenu_db["default"].update(str_sql)
      return nextStatus                                                     # 終了回数
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"update_end_su エラー"}
      raise
    end
  end

  # 並列分散管理テーブル　照会
  def controll_select_for_update(parallel_controll_id)
    begin
      # テーブル名を設定する
      str_sql1        = "SELECT "

      # 列名を設定する
      str_sql2 = "parallel_controll_id, process_name, process_html, process_mode, division_number, next_process, user_id, division_end_number "
      
      # FROM句を設定する
      str_sql3        = "FROM parallel_controll WHERE parallel_controll_id = #{parallel_controll_id} FOR UPDATE"

      # SELECT文を生成する
      str_sql         = str_sql1 + str_sql2 + str_sql3
      #$Tlog.debug("RmenuParallelControll") {"ジョブ管理テーブル SELECT SQL : #{str_sql}"}

      # SELECT文を実行する
      valueArray = @rmenu_db["default"].select_namevalue(str_sql)

      #$Tlog.debug("RmenuParallelControll") {"SQL実行後のジョブ管理データ : #{JSON.dump(valueArray[0])}"}
      return valueArray[0]
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"select エラー"}
      raise
    end
  end

  # 並列分散管理テーブル　照会
  def controll_select(parallel_controll_id)
    begin
      # テーブル名を設定する
      str_sql1        = "SELECT "

      # 列名を設定する
      str_sql2 = "parallel_controll_id, process_name, process_html, process_mode, division_number, next_process, user_id, division_end_number "
      
      # FROM句を設定する
      str_sql3        = "FROM parallel_controll WHERE parallel_controll_id = #{parallel_controll_id}"

      # SELECT文を生成する
      str_sql         = str_sql1 + str_sql2 + str_sql3
      #$Tlog.debug("RmenuParallelControll") {"ジョブ管理テーブル SELECT SQL : #{str_sql}"}

      # SELECT文を実行する
      valueArray = @rmenu_db["default"].select_namevalue(str_sql)

      #$Tlog.debug("RmenuParallelControll") {"SQL実行後のジョブ管理データ : #{JSON.dump(valueArray[0])}"}
      return valueArray[0]
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"select エラー"}
      raise
    end
  end

  # 並列分散キー　テーブルの登録
  def keyvalue_insert(sql_data)
    begin
      parallelControll = getJsonChunkById(sql_data, "sqls", "parallelControll")
      parallelRecord   = parallelControll["input"]["record"]

      # キー値を設定　2015/03/20 shimoji
      parallelKey      = getJsonChunkById(sql_data, "sqls", "parallelKey")
      if parallelKey.key?("output")
        keyRecord        = parallelKey["output"]["record"]
      else
        keyRecord        = parallelKey["input"]["record"]
      end

      # テーブル名を設定する
      str_sql1        = "INSERT INTO parallel_keyvalue"

      # 列名・値を設定する
      str_sql2        = " (parallel_controll_id, json_data)"

      parallel_controll_id = parallelRecord["parallel_controll_id"]["value"][0]
      str_sql3        = " VALUES (#{parallel_controll_id}, '#{JSON.generate(keyRecord)}')"

      # INSERT文を生成する
      str_sql         = str_sql1 + str_sql2 + str_sql3
      #$Tlog.debug("RmenuParallelControll") {"並列分散キー テーブル INSERT SQL : #{str_sql}"}

      # INSERT文を実行する
      @rmenu_db["default"].insert(str_sql)
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"keyvalue_insert エラー"}
      raise
    end
  end

  # 並列分散キーテーブル　ＪＳＯＮＤＡＴＡ　照会
  def keyvalue_select(parallel_controll_id)
    begin
      str_sql   = "SELECT json_data FROM parallel_keyvalue WHERE parallel_controll_id = #{parallel_controll_id}"
      #$Tlog.debug("RmenuParallelControll") {"並列分散キーテーブル keyvalue_select SQL : #{str_sql}"}

      json_data = @rmenu_db["default"].select_value(str_sql)
      return JSON.parse(json_data)
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"keyvalue_select エラー"}
      raise
    end
  end

  # 並列分散パラメータテーブルの登録
  def param_insert(sql_data)
    begin
      parallelControll = getJsonChunkById(sql_data, "sqls", "parallelControll")
      parallelRecord   = parallelControll["input"]["record"]

      parallelParam    = getJsonChunkById(sql_data, "sqls", "parallelParam")
      paramRecord      = parallelParam["input"]["record"]

      # テーブル名を設定する
      str_sql1        = "INSERT INTO parallel_param"

      # 列名・値を設定する
      str_sql2        = " (parallel_controll_id, json_data)"

      parallel_controll_id = parallelRecord["parallel_controll_id"]["value"][0]
      str_sql3        = " VALUES (#{parallel_controll_id}, '#{JSON.generate(paramRecord)}')"

      # INSERT文を生成する
      str_sql         = str_sql1 + str_sql2 + str_sql3
      #$Tlog.debug("RmenuParallelControll") {"並列分散パラメータ テーブル INSERT SQL : #{str_sql}"}

      # INSERT文を実行する
      @rmenu_db["default"].insert(str_sql)
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"param_insert エラー"}
      raise
    end
  end

  # 並列分散パラメータテーブル　ＪＳＯＮＤＡＴＡ　照会
  def param_select(parallel_controll_id)
    begin
      str_sql   = "SELECT json_data FROM parallel_param WHERE parallel_controll_id = #{parallel_controll_id}"
      #$Tlog.debug("RmenuParallelControll") {"並列分散キーテーブル param_select SQL : #{str_sql}"}

      json_data = @rmenu_db["default"].select_value(str_sql)
      return JSON.parse(json_data)
    rescue
      # エラーログを出力する
      #$Tlog.error("RmenuParallelControll") {"param_select エラー"}
      raise
    end
  end

  # 並列帳票管理テーブルの登録
  def print_insert(parallel_controll_id, response_data)
    begin
      # テーブル名を設定する
      str_sql1        = "INSERT INTO parallel_print_controll"

      # 列名・値を設定する
      str_sql2        = " (parallel_controll_id, print_name, print_file_name, output_times)"

      print_name      = response_data["pdfinfo"]["pdfname"]
      print_file_name = response_data["pdfinfo"]["pdffile"]
      str_sql3        = " VALUES (#{parallel_controll_id}, '#{print_name}', '#{print_file_name}', '0')"

      # INSERT文を生成する
      str_sql         = str_sql1 + str_sql2 + str_sql3
      $PSlog.debug("RmenuParallelControll") {"並列帳票管理 テーブル INSERT SQL : #{str_sql}"}

      # INSERT文を実行する
      @rmenu_db["default"].insert(str_sql)
    rescue
      # エラーログを出力する
      $PSlog.error("RmenuParallelControll") {"print_insert エラー"}
      raise
    end
  end

end
