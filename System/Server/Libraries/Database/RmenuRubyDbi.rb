# coding: UTF-8

require "dbi"
require "thread"
require "RmenuSqlGenMixin"
require 'json'

class RmenuRubyDbi
  include RmenuSqlGenMixin

  def initialize(db)
    # initialize 開始ログを出力する
    $Dlog.debug("RmenuRubyDbi") {"initialize start"}

    @database = db

    # initialize 終了ログを出力する
    $Dlog.debug("RmenuRubyDbi") {"initialize normal end"}
  end

  def transaction()
    @database['AutoCommit'] = false
  end

  def commit()
    @database.commit
  end

  def rollback()
    @database.rollback
  end

  def getDatabase()
    return @database
  end

  # SQL文の実行
  def doSql(sql_info)
    # パラメータ設定か？
    sql_source = sql_info['sql']
    if sql_source['type'] == "param"
      return
    end
    
    # 入力レコードが定義されているか？
    if sql_info.key?('input')
      input_record = sql_info['input']['record']
      max_line     = getMaxLine(sql_info)                                       # RmenuSqlGenMixin メソッド
    else
      max_line     = 1
    end
    idx            = 0
    init_sw        = 0

    # 入力レコードの件数分、繰り返す（入力レコードが無い時は一回）
    max_line.times do
      before_sql       = createSql(sql_info)                                    # RmenuSqlGenMixin メソッド
      $Dlog.debug("RmenuDbi") {"バインド変数、置換前のSQL : #{before_sql}"}

      if sql_info.key?('input')
        after_sql = replaceSql(before_sql, input_record, idx)                   # RmenuSqlGenMixin メソッド
      else
        after_sql = before_sql
      end
      $Dlog.debug("RmenuDbi") {"バインド変数、置換後のSQL : #{after_sql}"}


      # SQL文を実行する
      state_handle = @database.execute(after_sql)

      # Select文実行の時は、結果をoutput_recordに設定する
      if sql_info['sql']['type'] != "select"
        idx         = idx + 1
        next
      end
      
      output_record = sql_info['output']['record']
      $Dlog.debug("RmenuDbi") {"SQL実行前の出力レコード : #{JSON.dump(output_record)}"}
        
      state_handle.fetch do |row|
        row.each_with_name do |val, name|
          if init_sw == 0
            if val
              if integerString?(val) || floatString?(val)                       # RmenuSqlGenMixin メソッド
                output_record["#{name}"]["value"][0] = val
              else
                output_record["#{name}"]["value"][0] = val.force_encoding("UTF-8")
              end
            else
              output_record["#{name}"]["value"][0]   = ""
            end
          else
            if val
              if integerString?(val) || floatString?(val)                       # RmenuSqlGenMixin メソッド
                output_record["#{name}"]["value"]   << val
              else 
                output_record["#{name}"]["value"]   << val.force_encoding("UTF-8")
              end
            else
              output_record["#{name}"]["value"]     << ""
            end
          end
        end
        init_sw     = 1
      end
      $Dlog.debug("RmenuDbi") {"SQL実行後の出力レコード : #{JSON.dump(output_record)}"}
      
      idx           = idx + 1
    end
  end

  def insert(str_sql)
    @database.execute(str_sql)
  end
  
  def update(str_sql)
    @database.execute(str_sql)
  end
  
  def delete(str_sql)
    @database.execute(str_sql)
  end
  
  def select_record(str_sql, record)
    state_handle = @database.execute(after_sql)

    init_sw = 0
    state_handle.fetch do |row|
      row.each_with_name do |val, name|
        if init_sw == 0
          if val
            if integerString?(val) || floatString?(val)                         # RmenuSqlGenMixin メソッド
              record["#{name}"]["value"][0] = val
            else
              record["#{name}"]["value"][0] = val.force_encoding("UTF-8")
            end
          else
            record["#{name}"]["value"][0]   = ""
          end
        else
          if val
            if integerString?(val) || floatString?(val)                         # RmenuSqlGenMixin メソッド
              record["#{name}"]["value"]   << val
            else 
              record["#{name}"]["value"]   << val.force_encoding("UTF-8")
            end
          else
            record["#{name}"]["value"]     << ""
          end
        end
      end
      init_sw     = 1
    end
  end

  def select_value(str_sql)
    value = nil
    state_handle = @database.execute(after_sql)

    state_handle.fetch do |row|
      row.each_with_name do |val, name|
        if val
          if integerString?(val) || floatString?(val)                           # RmenuSqlGenMixin メソッド
            value = val
          else
            value = val.force_encoding("UTF-8")
          end
        else
          value   = ""
        end
        
        break
      end
      
      break
    end
    
    return value
  end

  def select_array(str_sql)
    array        = Array.new
    state_handle = @database.execute(after_sql)

    init_sw = 0
    state_handle.fetch do |row|
      row.each_with_name do |val, name|
        if init_sw == 0
          if val
            if integerString?(val) || floatString?(val)                         # RmenuSqlGenMixin メソッド
              array[0] = val
            else
              array[0] = val.force_encoding("UTF-8")
            end
          else
            array[0]   = ""
          end

          init_sw     = 1
        else
          if val
            if integerString?(val) || floatString?(val)                         # RmenuSqlGenMixin メソッド
              array   << val
            else 
              array   << val.force_encoding("UTF-8")
            end
          else
            array     << ""
          end
        end
      end
    end
    
    return array
  end

  def select_row_count(str_sql)
    state_handle = @database.execute(after_sql)

    row_count = 0
    state_handle.fetch do |row|
      row_count += 1
    end
    
    return row_count
  end
end