# coding: UTF-8

require 'RmenuMVCMixin'                                                         # before after 動的メソッド実行Mixin
require 'RmenuParallelStartUp'
require 'json'

class RmenuModel
  include RmenuMVCMixin

  def initialize(rmenu_db, request_data, db_queue, parallel_flag, parallel_end)
    begin
      # initialize 開始ログを出力する
      $Mlog.debug("Model") {"initialize start"}

      @rmenu_db               = rmenu_db                                        # Databaseオブジェクト配列
      @request_data           = request_data                                    # リクエストデータ
      @db_queue               = db_queue                                        # リクエストデータ
      @parallel_flag          = parallel_flag                                   # リクエストデータ
      @parallel_end           = parallel_end                                    # リクエストデータ

      # initialize 終了ログを出力する
      $Mlog.debug("Model") {"initialize normal end"}
    rescue
      # エラーログを出力する
      $Mlog.error("Model") {"initialize exception: #{$!}"}
      raise
    end
  end

  # SQL実行処理
  # （SQLデータからsql配列を取り出し実行する）
  def fromRequestToSql(sql_data, temp_object)
    begin
      sql_data["sqls"].each do |sql_info|
			
        # 並列分散処理の時、最終処理以外はパスする
        if sql_info["id"] == "parallelKey"
				  if @parallel_flag
					  if !@parallel_end
						  next
						end
					end
        end
				
        # 並列分散処理の時、最終処理以外はパスする
        if sql_info["id"] == "parallelParam"
				  if @parallel_flag
					  if !@parallel_end
						  next
						end
					end
        end

        # 並列分散処理の時、最終処理以外はパスする
        if sql_info["id"] == "parallelControll"
				  if @parallel_flag
					  if !@parallel_end
						  next
						end
					end
        end

        # sql入力レコードの編集
        $Mlog.debug("Model") {"編集前、入力情報 : #{JSON.dump(sql_info)}"}
        editSqlInputData(sql_info, sql_data)
        $Mlog.debug("Model") {"編集後、入力情報 : #{JSON.dump(sql_info)}"}

        # 並列分散処理　スタート
        if sql_info["id"] == "parallelControll"

					if !@parallel_flag
            $Mlog.debug("Model") {"RmenuParallelStartUp start"}
						
            parallelStartUp = RmenuParallelStartUp.new(@rmenu_db)
            parallelStartUp.call(sql_data)
						
            $Mlog.debug("Model") {"RmenuParallelStartUp normal end"}
					end

          break
        end
				
        # beforeメソッド処理
        result = doBeforeAfterMethod("before", sql_info, temp_object)           # RmenuMVCMixin
        if result == "ERROR" || result == "ALLPASS"
          return
        end

        # SQLの実行
        if result == "OK"
          doSql(sql_info, sql_data)
          if sql_data['message']['status'] == "ERROR"
            return
          end

          # afterメソッド処理
          result = doBeforeAfterMethod("after", sql_info, temp_object)                   # RmenuMVCMixin
          if result == "ERROR" || result == "ALLPASS"
            return
          end
        end
      end
    rescue
      # エラーログを出力する
      $Mlog.error("Model") {"runtime exception: #{$!}"}
      raise
    end
  end

  # SQL実行前処理
  # sql入力レコードの編集
  def editSqlInputData(sql_info, sql_data)

		# sql_infoのinputデータ無し
    return unless sql_info.has_key?("input")

    sql_input_record = sql_info["input"]["record"]
    sql_input_record.each do |name, value|
      # fromtype 処理
      if value.has_key?("fromtype")
        # 違うidのrequestから編集する
        if value["fromtype"] == "request"
          fromRequestEditValue(value, @request_data)                            # RmenuMVCMixin
          next
        end

        # sql_dataのinputから編集する
        if value["fromio"] == "input"
          fromSqlInputEditValue(value, sql_data)                                # RmenuMVCMixin
          next
        end

        # sql_dataのoutputから編集する
        if value["fromio"] == "output"
          fromSqlOutputEditValue(value, sql_data)                               # RmenuMVCMixin
          next
        end
      end

			# 2015/04/03 shimoji
			if sql_info["id"] == "parallelControll"
			  next
			end

      # 同じidのrequestから編集する
      if @request_data.has_key?("records")                                      # リクエストデータ有り
        @request_data["records"].each do |request_info|
          if sql_info["id"] != request_info["id"]
            next
          end
          
          if request_info["record"].has_key?(name)
            value["value"] = request_info["record"][name]["value"]
          end
          break
        end
      end
    end
  end

  # SQL実行
  def doSql(sql_info, sql_data)
    $Mlog.debug("Model") {"doSql start"}                                        # Logファイル Debug用

    # dbnameを設定する
    dbname = "default"
    if sql_info.has_key?("dbname")
      if sql_info['dbname'] != ""
        dbname = sql_info['dbname']
      end
    end

    if sql_info['sql']['type'] != "nosql"
      if @rmenu_db.has_key?(dbname)
        @rmenu_db[dbname].doSql(sql_info)
      else
        @rmenu_db = @db_queue.append(@rmenu_db, dbname)
        @rmenu_db[dbname].connect(dbname, false);
        @rmenu_db[dbname].transaction()
        @rmenu_db[dbname].doSql(sql_info)
      end
    end

    if sql_info['sql'].has_key?("check")
      if @rmenu_db.has_key?(dbname)
        @rmenu_db[dbname].recordCheck(sql_info, sql_data)
      else
        @rmenu_db["default"].recordCheck(sql_info, sql_data)
      end
    end

    $Mlog.debug("Model") {"doSql end"}                                          # Logファイル Debug用
  end

  # DB トランザクション スタート
  def transaction(sql_data, temp_object)
    if $Rconfig['db_pools'] == 0
      if sql_data["dbname"] != ""
        @rmenu_db["default"].connect(sql_data["dbname"], temp_object);
        @rmenu_db["default"].transaction()
      end
    else
      @rmenu_db.each do |dbname, rmenu_db|
        rmenu_db.transaction()
      end
    end
  end

  # DB コミット
  def commit()
    @rmenu_db.each do |dbname, rmenu_db|
      $Mlog.debug("Model") {"コミット DB : #{dbname}"}
      rmenu_db.commit()
      rmenu_db.disconnect()
    end
  end

  # DB ロールバック
  def rollback()
    @rmenu_db.each do |dbname, rmenu_db|
      $Mlog.debug("Model") {"ロールバック DB : #{dbname}"}
      rmenu_db.rollback()
      rmenu_db.disconnect()
    end
  end

  # メイン処理
  def call(def_cache, app_cache)
    begin
      # メイン処理 開始ログを出力する
      $Mlog.debug("Model") {"call start"}                                       # Logファイル Debug用

      # SQLデータを設定
      $Mlog.debug("Model") {"def_cache.getJsonData start"}                      # Logファイル Debug用
      sql_data = def_cache.getJsonData(@request_data)
      $Mlog.debug("Model") {"Json SQLデータ : #{JSON.dump(sql_data)}"}
      $Mlog.debug("Model") {"def_cache.getJsonData normal end"}                 # Logファイル Debug用

      # モデルオブジェクトを動的生成
      $Mlog.debug("Model") {"app_cache.getModelObject start"}                   # Logファイル Debug用
      temp_object = app_cache.getModelObject(@rmenu_db, sql_data, @request_data)
      $Mlog.debug("Model") {"app_cache.getModelObject normal end"}              # Logファイル Debug用

      # SQLを作成し、実行する
      if !@parallel_flag
        $Mlog.debug("Model") {"トランザクション スタート"}
        transaction(sql_data, temp_object)
      end

      $Mlog.debug("Model") {"fromRequestToSql start"}                         # Logファイル Debug用
      fromRequestToSql(sql_data, temp_object)
      $Mlog.debug("Model") {"fromRequestToSql normal end"}                    # Logファイル Debug用

      if !@parallel_flag
        if sql_data['message']['status'] == "OK"
          $Mlog.debug("Model") {"コミットを実行"}
          commit()
        else
          $Mlog.debug("Model") {"ロールバックを実行"}
          rollback()
        end
      end

      # メイン処理 終了ログを出力する
      $Mlog.debug("Model") {"call normal end"}                                  # Logファイル Debug用

      # SQLデータをリターン
      return sql_data
    rescue
      if !@parallel_flag
        $Mlog.debug("Model") {"ロールバックを実行"}
        rollback()
      end

      # エラーログを出力する
      $Mlog.error("Model") {"call exception: #{$!}"}                            # Logファイル Debug用

      sql_data['message']['status'] = "ERROR"
      sql_data['message']['msg']    = "#{$!}"
      return sql_data

      #raise
    end
  end
end
