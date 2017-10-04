# coding: UTF-8

class RmenuParallelDivisionControll

  def initialize(rmenu_db)
    # initialize 開始ログを出力する
    $Tlog.debug("RmenuParallelDivisionControll") {"initialize start"}

    @rmenu_db                 = rmenu_db

    # initialize 終了ログを出力する
    $Tlog.debug("RmenuParallelDivisionControll") {"initialize normal end"}

  end

  # 並列分割管理テーブルの登録
  def insert(parallel_controll_id, division_number)
    begin
      # テーブル名を設定する
      str_sql1        = "INSERT INTO parallel_division_controll"

      # 列名を設定する
      str_sql2        = " (parallel_controll_id, parallel_division_id)"

      # JOB_NOの繰り返し処理
      i               = 1
      while i <= division_number
        # 値（JOB_CONTROLL_ID・JOB_NO・JOB_START_DATE）を設定する
        str_sql3      = " VALUES (#{parallel_controll_id}, #{i})"

        # INSERT文を生成する
        str_sql       = str_sql1 + str_sql2 + str_sql3

        # INSERT文を実行する
        @rmenu_db["default"].insert(str_sql)

        i            += 1
      end
    rescue
      # エラーログを出力する
      $Tlog.error("RmenuParallelDivisionControll") {"insert エラー"}
      raise
    end
  end

  # 並列分割管理テーブル（開始日時）の更新
  def update_start_date(parallel_controll_id, parallel_division_id)
    begin
      # 開始日時を更新する
      str_sql         = "UPDATE parallel_division_controll SET start_datetime = clock_timestamp() "
      str_sql        += "WHERE parallel_controll_id = #{parallel_controll_id} AND parallel_division_id = #{parallel_division_id}"
      $Tlog.debug("RmenuParallelDivisionControll") {"並列分割管理テーブル（開始日時） UPDATE SQL : #{str_sql}"}

      @rmenu_db["default"].update(str_sql)
    rescue
      # エラーログを出力する
      $Tlog.error("RmenuParallelDivisionControll") {"update_start_date エラー"}
      raise
    end
  end

  # 並列分割管理テーブル（終了日時）の更新
  def update_end_date(parallel_controll_id, parallel_division_id)
    begin
      # 終了日時を更新する
      str_sql         = "UPDATE parallel_division_controll SET end_datetime = clock_timestamp() "
      str_sql        += "WHERE parallel_controll_id = #{parallel_controll_id} AND parallel_division_id = #{parallel_division_id}"
      $Tlog.debug("RmenuParallelDivisionControll") {"並列分割管理テーブル（終了日時） UPDATE SQL : #{str_sql}"}

      @rmenu_db["default"].update(str_sql)
    rescue
      # エラーログを出力する
      $Tlog.error("RmenuParallelDivisionControll") {"update_end_date エラー"}
      raise
    end
  end
end
