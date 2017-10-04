# coding: UTF-8

require 'rubygems'
require 'sequel'
require "RmenuSqlGenMixin"
require 'json'

class RmenuSequel
  include RmenuSqlGenMixin

  def initialize(db, dbname)
    # initialize 開始ログを出力する
    $Dlog.debug("RmenuSequel") {"initialize start"}

    @database = db
    @dbname   = dbname

    # initialize 終了ログを出力する
    $Dlog.debug("RmenuSequel") {"initialize normal end"}
  end

  def getdbname()
    return @dbname
  end

  def connect(dbname, temp_object)
    $Dlog.debug("RmenuSequel") {"connect start"}

    connectdbname = getconnectdb(dbname, temp_object)
    opts_array = $Rconfig['db_options']
    opts_array.each_with_index{|opts, idx|
      if connectdbname
        if connectdbname != opts['db_database']
          next
        end
      end

      dbopts                  = Hash.new
      dbopts[:host]           = opts['db_hostname']
      dbopts[:port]           = opts['db_portno']
      dbopts[:user]           = opts['db_username']
      dbopts[:password]       = opts['db_password']
      dbopts[:database]       = opts['db_database']
      dbopts[:encoding]       = opts['db_encoding']
      dbopts[:compress]       = opts['db_compress']
      @dbname                 = opts['db_database']

      case opts['db_dbdriver']
      when "PostgreSQL"
        @database = Sequel.connect("postgres:/", dbopts)
      when "MySQL"
        @database = Sequel.connect("mysql:/", dbopts)
      else
        $Dlog.error("RmenuSequel") {"Rconfig error: db_dbdriver?"}
        raise
      end
      break
    }

    $Dlog.debug("RmenuSequel") {"connect end"}
  end

  def getconnectdb(dbname, temp_object)
    $Dlog.debug("RmenuSequel") {"getconnectdb start"}

    opts_array = $Rconfig['db_options']
    opts_array.each_with_index{|opts, idx|
      if dbname
        if dbname != opts['db_database']
          next
        end
      end
      
      return dbname
    }

    # 接続DB取得メソッドを動的実行する
    if temp_object
      str_method      = "temp_object.#{dbname}"
      return eval(str_method)
    end

    $Dlog.debug("RmenuSequel") {"connect end"}
    return ""
  end

  def disconnect()
    $Dlog.debug("RmenuSequel") {"disconnect start"}

    @database.disconnect

    $Dlog.debug("RmenuSequel") {"disconnect end"}
  end

  def transaction()
    @database.run("BEGIN")
  end

  def commit()
    @database.run("COMMIT")
  end

  def rollback()
    @database.run("ROLLBACK")
  end

  def getDatabase()
    return @database
  end

  # SQL文の実行
  def doSql(sql_info)
    $Dlog.debug("RmenuSequel") {"doSql start"}

    # パラメータ設定か？
    sql_source = sql_info['sql']
    if sql_source['type'] == "param"
      return
    end

    doGenerateSql(sql_info)


    $Dlog.debug("RmenuSequel") {"doSql end"}
  end

  # SQL文の実行
  def doGenerateSql(sql_info)
    $Dlog.debug("RmenuSequel") {"doGenerateSql start"}

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
      $Dlog.debug("RmenuSequel") {"バインド変数、置換前のSQL : #{before_sql}"}

      if sql_info.key?('input')
        after_sql = replaceSql(before_sql, input_record, idx)                   # RmenuSqlGenMixin メソッド
      else
        after_sql = before_sql
      end
      $Dlog.debug("RmenuSequel") {"バインド変数、置換後のSQL : #{after_sql}"}

      # SQL文を実行する
      if sql_info['sql']['type'] == "doRun"
        @database.run("#{after_sql}")

        idx         = idx + 1
        next
      end

      if sql_info['sql']['type'] != "select"
        state_handle = @database["#{after_sql}"]

        case sql_info['sql']['type']
        when "insert"
          state_handle.insert
        when "update"
          state_handle.update
        when "delete"
          state_handle.delete
        end

        idx         = idx + 1
        next
      end

      output_record = sql_info['output']['record']
      $Dlog.debug("RmenuSequel") {"SQL実行前の出力レコード : #{JSON.dump(output_record)}"}

      # 取得行毎にループ
      result_sw    = 0    # 取得データ有無の判定に使用する
      state_handle = @database["#{after_sql}"]
      state_handle.each do |row|
        result_sw  = 1    # 取得データが有り
        # 各取得行のカラム毎にループ
        row.each do |name, val|
          # output_record 内の項目名と一致するものがあれば、取得値の転送を行う
          if output_record.key?("#{name}")
            if init_sw == 0
              if val
                if integerString?(val) || floatString?(val)                       # RmenuSqlGenMixin メソッド
                  output_record["#{name}"]["value"][0] = val
                else
                  output_record["#{name}"]["value"][0] = val.force_encoding("UTF-8")
                end
              else
                output_record["#{name}"]["value"][0] = ""
              end
            else
              if val
                if integerString?(val) || floatString?(val)                       # RmenuSqlGenMixin メソッド
                  output_record["#{name}"]["value"]   << val
                else 
                  output_record["#{name}"]["value"]   << val.force_encoding("UTF-8")
                end
              else
                output_record["#{name}"]["value"]   << ""
              end
            end
          # output_record 内の項目名と一致しないものは、処理しない
          else
            next
          end
        end
        init_sw     = 1
      end

      # 取得データ　無しの時の処理
      if result_sw == 0
        if sql_info['output'].key?('record')
          if init_sw == 0
            output_record.each_key {|key|
              output_record["#{key}"]["value"][0] = ""
            }
          else
            output_record.each_key {|key|
              output_record["#{key}"]["value"] << ""
            }
          end
        end
        init_sw     = 1
      end

      $Dlog.debug("RmenuSequel") {"SQL実行後の出力レコード : #{JSON.dump(output_record)}"}
      
      idx           = idx + 1
    end

    $Dlog.debug("RmenuSequel") {"doGenerateSql end"}
  end

  def doRun(str_sql)
    @database.run("#{str_sql}")
  end
  
  def insert(str_sql)
    state_handle = @database["#{str_sql}"]
    state_handle.insert
  end
  
  def update(str_sql)
    state_handle = @database["#{str_sql}"]
    state_handle.update
  end
  
  def delete(str_sql)
    state_handle = @database["#{str_sql}"]
    state_handle.delete
  end
  
  def select_record(str_sql, record)
    state_handle = @database["#{str_sql}"]

    init_sw = 0
    state_handle.each do |row|
      row.each do |name, val|
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

  def select_namevalue(str_sql)
    $Dlog.debug("RmenuSequel") {"select_namevalue start"}
    $Dlog.debug("RmenuSequel") {"select_namevalue sql = " + str_sql}

    valueArray = Array.new
    idx        = 0
    state_handle = @database["#{str_sql}"]

    state_handle.each do |row|
      valueHash  = Hash.new
      row.each do |name, val|
        if val
          if integerString?(val) || floatString?(val)                           # RmenuSqlGenMixin メソッド
            valueHash["#{name}"] = val
          else
            valueHash["#{name}"] = val.force_encoding("UTF-8")
          end
        else
          valueHash["#{name}"]   = ""
        end
      end
      valueArray[idx] = valueHash
      idx += 1
    end
    
    $Dlog.debug("RmenuSequel") {"select_namevalue end"}
    return valueArray
  end

  def select_value(str_sql)
    value = nil
    state_handle = @database["#{str_sql}"]

    state_handle.each do |row|
      row.each do |name, val|
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
    state_handle = @database["#{str_sql}"]

    init_sw = 0
    state_handle.each do |row|
      row.each do |name, val|
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
    state_handle = @database["#{str_sql}"]

    row_count = 0
    state_handle.each do |row|
      row_count += 1
    end
    
    return row_count
  end
end
