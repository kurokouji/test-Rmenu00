# coding: UTF-8

module RmenuSqlGenMixin
  # SQL文の作成
  def createSql(sql_info)
    begin
      sql_source = sql_info['sql']

      str_sql = "";
      if sql_source.key?('freesql')
        if sql_source['freesql'] != ""
          str_sql       = createFreeSql(sql_info)
          return str_sql
        end
      end

      case sql_source['type']
      when "insert"
        str_sql       = createInsertSql(sql_info)
      when "update"
        str_sql       = createUpdateSql(sql_info)
      when "delete"
        str_sql       = createDeleteSql(sql_info)
      else
        str_sql       = createSelectSql(sql_info)
      end

      return str_sql
    rescue
      # エラーログを出力する
      $Dlog.error("RmenuSqlGenMixin") {"SQL文の作成エラー"}
      
      raise
    end
  end

  # INSERT文の作成
  def createInsertSql(sql_info)
    begin
      sql_source      = sql_info['sql']
      input_record    = sql_info['input']['record']

      # テーブル名の設定
      str_sql1        = "INSERT INTO #{sql_source['genesql']['from']}"

      # 列名・値の設定
      str_sql2        = " ("
      str_sql3        = " VALUES ("
      input_record.each do |name, value|
        # 列名の設定
        if value.has_key?("field")
          str_sql2      += "#{value['field']}, "
        else
          str_sql2      += "#{name}, "
        end

        # 値の設定
        str_sql3      += getFunctStr(value)
      end
      str_sql2        = str_sql2.sub(/,\s$/, ')')
      str_sql3        = str_sql3.sub(/,\s$/, ')')

      return str_sql1 + str_sql2 + str_sql3
    rescue
      # エラーログを出力する
      $Dlog.error("RmenuSqlGenMixin") {"INSERT文の作成エラー"}
      
      raise
    end
  end

  # UPDATE文の作成
  def createUpdateSql(sql_info)
    begin
      sql_source      = sql_info['sql']
      input_record    = sql_info['input']['record']

      # テーブル名の設定
      str_sql1        = "UPDATE #{sql_source['genesql']['from']} SET "

      # 列名・値の設定回数を計算する
      str_where       = " " + sql_source['genesql']['where']
      matched_count   = 0
      str_where.scan(/\?/) do |matched|
        matched_count += 1
      end
      data_count      = input_record.size - matched_count
      count = 0

      # 列名・値の設定
      str_sql2        = ""
      input_record.each do |name, value|
        count += 1
        if count > data_count
          break
        end
        
        if value.key?("field")                                                  # field指定有り
          # 列名の設定
          str_sql2    += "#{value['field']}="

          # 値の設定
          str_sql2    += getFunctStr(value)
        else                                                                    # field指定無し
          str_name    = " " + name + " "
          unless str_where.include?(str_name)                                   # where句に設定無し
            # 列名の設定
            str_sql2  += "#{name}="

            # 値の設定
            str_sql2  += getFunctStr(value)
          end
        end
      end
      str_sql2        = str_sql2.sub(/,\s$/, ' ')

      # WHERE句の設定
      str_sql3        = "WHERE" + str_where

      return str_sql1 + str_sql2 + str_sql3
    rescue
      # エラーログを出力する
      $Dlog.error("RmenuSqlGenMixin") {"UPDATE文の作成エラー"}
      
      raise
    end
  end

  # DELETE文の作成
  def createDeleteSql(sql_info)
    begin
      sql_source      = sql_info['sql']

      # テーブル名の設定
      str_sql1        = "DELETE FROM #{sql_source['genesql']['from']}"

      # WHERE句の設定
      str_sql2        = " WHERE " + sql_source['genesql']['where']

      return str_sql1 + str_sql2
    rescue
      # エラーログを出力する
      $Dlog.error("RmenuSqlGenMixin") {"DELETE文の作成エラー"}
      
      raise
    end
  end

  # SELECT文の作成
  def createSelectSql(sql_info)
    begin
      sql_source      = sql_info['sql']
      output_record   = sql_info['output']['record']

      # DISTINCTの設定
      str_sql1        = "SELECT "
      if sql_source['genesql'].key?("dist")
        if sql_source['genesql']['dist'] == "yes"
          str_sql1    += "DISTINCT "
        end
      end

      # 列名の設定
      output_record.each do |name, value|
        if value.key?('funct')
          if value['funct'] == ""
            str_sql1 += getFieldStr(name, value)
          else
            str_sql1 += "#{value['funct']} AS #{name}, "                        # sql関数の設定
          end
        else
            str_sql1 += getFieldStr(name, value)
        end
      end
      str_sql1        = str_sql1.sub(/,\s$/, ' ')

      # テーブル名の設定
      temp = sql_source['genesql']['from']
      if temp.instance_of?(Array)
        tempFrom = temp.join(' ')
      # freesql が配列でない場合は、そのまま参照
      else
        tempFrom = temp
      end
			
      if tempFrom != ""
        str_sql2        = "FROM #{tempFrom}"
      else
        str_sql2        = ""
      end

      # WHERE句の設定
      if sql_source['genesql'].key?('where')
        if sql_source['genesql']['where'] == ""
            str_sql3  = ""
        else
            str_sql3  = " WHERE " + sql_source['genesql']['where']
        end
      else
        str_sql3      = ""
      end

      # ORDER句の設定
      if sql_source['genesql'].key?('order')
        if sql_source['genesql']['order'] == ""
            str_sql4  = ""
        else
            str_sql4  = " ORDER BY " + sql_source['genesql']['order']
        end
      else
        str_sql4      = ""
      end

      # LIMIT句の設定
      if sql_source['genesql'].key?('limit')
        if sql_source['genesql']['limit'] == ""
            str_sql5  = ""
        else
            str_sql5  = " LIMIT " + sql_source['genesql']['limit']
        end
      else
        str_sql5      = ""
      end
    
      return str_sql1 + str_sql2 + str_sql3 + str_sql4 + str_sql5
    rescue
      # エラーログを出力する
      $Dlog.error("RmenuSqlGenMixin") {"SELECT文の作成エラー"}
      
      raise
    end
  end

  # ＳＱＬ文生成(freesql)
  def createFreeSql(sql_info)
    begin
      temp = sql_info["sql"]["freesql"]
      # freesql が配列の場合は、連結する
      if temp.instance_of?(Array)
        str_sql = temp.join(' ')
      # freesql が配列でない場合は、そのまま参照
      else
        str_sql = temp
      end
      # 戻り値返却
      return str_sql
    rescue
      # エラーログを出力する
      $Dlog.error("RmenuSqlGenMixin") {"フリーＳＱＬ エラー"}
      raise
    end
  end

  # 出力レコード　チェック
  def recordCheck(sql_info, sql_data)
    begin
      check           = sql_info['sql']['check']
      if check == ""
        return;
      end

      errormsg        = sql_info['sql']['errormsg']
      output_record   = sql_info['output']['record']

      $Dlog.debug("RmenuSqlGenMixin") {"チェック処理 : #{check}"}
      output_record.each do |name, value|
        size = value['value'].size
        if check == "not found error"
          if size == 1  && value['value'][0] == ""
            $Dlog.debug("RmenuSqlGenMixin") {"チェック処理エラー　有り"}
            sql_data['message']['status'] = "ERROR"
            sql_data['message']['msg']    = errormsg
            return
          end
        end

        if check == "found error"
          if size >= 1 && value['value'][0] != ""
            $Dlog.debug("RmenuSqlGenMixin") {"チェック処理エラー　有り"}
            sql_data['message']['status'] = "ERROR"
            sql_data['message']['msg']    = errormsg
            return
          end
        end
      end
      $Dlog.debug("RmenuSqlGenMixin") {"チェック処理エラー　無し"}
    rescue
      # エラーログを出力する
      $Dlog.error("RmenuSqlGenMixin") {"recordCheck エラー"}

      raise
    end
  end

  # INSERT文のVALUES文字設定
  # UPDATE文の列？文字設定
  def getFunctStr(value)
    funct_str = ""

    if value.key?('funct')
      if value['funct'] == ""
        funct_str   = "?, "
      else
        funct_str   = "#{value['funct']}, "                                     # 関数の設定
      end
    else
      funct_str     = "?, "
    end

    return funct_str
  end

  # SELECT文の列名文字設定
  def getFieldStr(name, value)
    field_str       = ""

    if value.key?('table')
      if value['table'] != ""
        field_str     = "#{value['table']}."
      end
    end
    
    if value.has_key?("field")
      if value['field'] == ""
        field_str        += "#{name}, "
      else
        field_str        += "#{value['field']} AS #{name}, "
      end
    else
      field_str        += "#{name}, "
    end

    return field_str
  end

  # 値配列の最大行設定
  def getMaxLine(sql_info)
    max_line  = 0
    record    = sql_info['input']['record']

    if sql_info['input']['multiline'] == "no"
      max_line      = 1
    else
      record.each do |name, value|
        n           = value['value'].length
        if n > max_line
          max_line  = n
        end
      end
    end

    return max_line
  end

  
  # バインド変数の値をSQL文に設定する
  def replaceSql(str_sql, input_record, idx)
    input_record.each do |name, value|
      if value.key?('funct')
        if value['funct'] != ""
          if !value['funct'].include?("?")
            next
          end
        end
      end

      valueLength   = value['value'].length - 1 
      
      if idx <= valueLength
        str_value   = value['value'][idx]
      else
        str_value   = value['value'][0]
      end

      if value.key?('empty')
        str_empty     = value["empty"]
        if str_empty != "" && str_value == ""
          str_sql     = str_sql.sub(/\?/, str_empty)
          next
        end
      end

      if value.key?('fieldtype')
        fieldtype     = value["fieldtype"]
        if fieldtype == "char"
          if str_value == ""
            str_null  = "NULL"
            str_sql   = str_sql.sub(/\?/, str_null)
          else
            str_value = "\'" + str_value + "\'"
            str_sql   = str_sql.sub(/\?/, str_value)
          end
          next
        end
        if fieldtype == "noquote"
          if str_value == ""
            str_null  = "NULL"
            str_sql   = str_sql.sub(/\?/, str_null)
          else
            str_sql   = str_sql.sub(/\?/, str_value)
          end
          next
        end
        if fieldtype == "num"
          if str_value == ""
            str_null  = "NULL"
            str_sql   = str_sql.sub(/\?/, str_null)
          else
            str_sql   = str_sql.sub(/\?/, str_value.to_s)
          end
          next
        end
        if fieldtype == "like"
          str_sql   = str_sql.sub(/\?/, str_value)
          next
        end
      end

      if integerString?(str_value) || floatString?(str_value)
        str_sql   = str_sql.sub(/\?/, str_value.to_s)
      else
        if str_value == ""
          str_null  = "NULL"
          str_sql   = str_sql.sub(/\?/, str_null)
        else
          str_value = "\'" + str_value + "\'"
          str_sql   = str_sql.sub(/\?/, str_value)
        end
      end
    end

    return str_sql
  end

  # 数字か
  def integerString?(str)
    begin
      Integer(str)
      true
    rescue ArgumentError
      false
    end
  end

  # 浮動小数点数字か
  def floatString?(str)
    begin
      Float(str)
      true
    rescue ArgumentError
      false
    end
  end
end
