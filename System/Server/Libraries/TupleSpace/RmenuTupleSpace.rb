# coding: UTF-8

require 'RmenuConfig'                                                           # 設定情報を読みこむ
require 'drb'                                                                   # dRubyライブラリを読みこむ
require 'RmenuJsonMixin'                                                        # ID名で該当レコードを取得する

class RmenuTupleSpace
  include RmenuJsonMixin

  def initialize()

    DRb.start_service
    @tuplespace = DRbObject.new_with_uri($Rconfig["tuplespace_uri"])

  end

  def writeTupleServer(sql_data)
    parallelControll      = getJsonChunkById(sql_data, "sqls", "parallelControll")
    parallelRecord        = parallelControll["input"]["record"]
    parallel_controll_id  = parallelRecord["parallel_controll_id"]["value"][0].to_i

    # ＤＢ名を設定する
    dbname                = sql_data["dbname"]
    if parallelControll.has_key?("dbname")
      if parallelControll["dbname"] != ""
        dbname = parallelControll["dbname"]
      end
    end

    @tuplespace.write(['TupleServer', parallel_controll_id, dbname])
  end

  def writeTupleServerEnd()
    @tuplespace.write(['TupleServer', 0, ""])
  end

  def takeTupleServer()
    tuple = @tuplespace.take(['TupleServer', Integer, String])
    sleep 2

    return tuple
  end

  def writeTupleClient(parallel_controll_id, parallel_division_id, dbname)
    @tuplespace.write(['TupleClien', parallel_controll_id, parallel_division_id, dbname])
  end

  def writeTupleClientEnd()
    @tuplespace.write(['TupleClien', 0, 0, ""])
  end

  def takeTupleClient()
    tuple = @tuplespace.take(['TupleClien', Integer, Integer, String])
    sleep 1

    return tuple
  end
end
