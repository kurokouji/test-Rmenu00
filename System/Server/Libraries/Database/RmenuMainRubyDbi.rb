# coding: UTF-8

require "dbi"
require "thread"
require "RmenuRubyDbi"

class RmenuMainRubyDbi

  def initialize()
    begin
      # initialize 開始ログを出力する
      $Dlog.debug("RmenuMainRubyDbi") {"initialize start"}
      
      @mdb_queue = Queue.new
      
      # コネクションのキャッシュ処理
      n = $Rconfig['db_pools']
      n.times do
        db_array = Array.new

        opts_array = $Rconfig['db_options']
        opts_array.each do |opts|
          connect_info = "dbi"         + 
              ":"                      +
              opts['db_dbdriver']      +
              ":"                      +
              opts['db_database']      +
              ":"                      +
              opts['db_hostname']

          db = DBI.connect(connect_info, opts['db_username'], opts['db_password'])
          db_array.push(RmenuRubyDbi.new(db))
        end
        
        @mdb_queue.push(db_array)
      end
      
      # initialize 終了ログを出力する
      $Dlog.debug("RmenuMainRubyDbi") {"initialize normal end"}
    rescue DBI::DatabaseError => e
      $Dlog.error("RmenuMainRubyDbi") {"initialize exception:"}
      $Dlog.error("RmenuMainRubyDbi") {"Error code: #{e.err}"}
      $Dlog.error("RmenuMainRubyDbi") {"Error message: #{e.errstr}"}
      raise
    end
  end

  def pop
    if $Rconfig['db_pools'] == 0
      return false
    end

    return @mdb_queue.pop
  end

  def push(rmenu_database)
    if $Rconfig['db_pools'] == 0
      return
    end

    @mdb_queue.push(rmenu_database)
  end
end