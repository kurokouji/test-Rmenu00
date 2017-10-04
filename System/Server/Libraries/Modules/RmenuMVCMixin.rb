# coding: UTF-8

module RmenuMVCMixin
  # before after メソッド実行
  def doBeforeAfterMethod(type, record_info, temp_object)
    unless record_info.key?(type)
      return "OK"
    end
    if record_info[type] == ""
      return "OK"
    end

    # before after メソッドを動的実行する
    result = "OK"
    case record_info[type].class.name
    # 単一記述の場合
    when "String"
      result = eval("temp_object.#{record_info[type]}")
    # 配列記述の場合
    when "Array"
      # 順に実行(途中で OK 以外の戻り値を得た場合は中断)
      record_info[type].each do |function_name|
        if function_name == ""
          next
        end
        result = eval("temp_object.#{function_name}")
        if result != "OK"
          break
        end
      end
    end
    return result
  end

  # リクエストデータの指定idから、valueデータを編集
  def fromRequestEditValue(value, request_data)
    request_data["records"].each do |request_info|
      if value["fromid"] != request_info["id"]
        next
      end
      
      fromname = value["fromname"]
      if request_info["record"].key?(fromname)
        value["value"] = request_info["record"][fromname]["value"]
      end
      return
    end
  end

  # sqlデータの指定idの入力データから、valueデータを編集
  def fromSqlInputEditValue(value, sql_data)
    sql_data["sqls"].each do |sql_info|
      if value["fromid"] != sql_info["id"]
        next
      end
      
      fromname = value["fromname"]
      if sql_info["input"]["record"].key?(fromname)
        value["value"] = sql_info["input"]["record"][fromname]["value"]
      end
      return
    end
  end

  # sqlデータの指定idの出力データから、valueデータを編集
  def fromSqlOutputEditValue(value, sql_data)
    sql_data["sqls"].each do |sql_info|
      if value["fromid"] != sql_info["id"]
        next
      end
      
      fromname = value["fromname"]
      if sql_info["output"]["record"].key?(fromname)
        value["value"] = sql_info["output"]["record"][fromname]["value"]
      end
      return
    end
  end

end
