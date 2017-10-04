# coding: UTF-8

require 'rubygems'
require 'sequel'
require "RmenuSequel"

class RmenuMainSequel

  def initialize()
    begin
      # initialize 開始ログを出力する
      $Dlog.debug("RmenuMainSequel") {"initialize start"}

      @mdb_queue = Queue.new

      # コネクションのキャッシュ処理
      n = $Rconfig['db_pools']                                        # コネクションプール数
      n.times do
        $Dlog.debug("RmenuMainSequel") {"initialize time :  + #{n}"}
        db_hash  = Hash.new

        opts_array = $Rconfig['db_options']                           # 接続DBの配列（複数指定可能）
        opts_array.each_with_index{|opts, idx|
          dbopts                  = Hash.new
          dbopts[:host]           = opts['db_hostname']
          dbopts[:port]           = opts['db_portno']
          dbopts[:user]           = opts['db_username']
          dbopts[:password]       = opts['db_password']
          dbopts[:database]       = opts['db_database']
          dbopts[:encoding]       = opts['db_encoding']
          dbopts[:compress]       = opts['db_compress']
          db_name                 = opts['db_database']

          case opts['db_dbdriver']
          when "PostgreSQL"
            if idx == 0
              db_hash["default"]  = RmenuSequel.new(Sequel.connect("postgres:/", dbopts), db_name)
            else
              db_hash[db_name]    = RmenuSequel.new(Sequel.connect("postgres:/", dbopts), db_name)
            end
          when "MySQL"
            if idx == 0
              db_hash["default"]  = RmenuSequel.new(Sequel.connect("mysql:/", dbopts), db_name)
            else
              db_hash[db_name]    = RmenuSequel.new(Sequel.connect("mysql:/", dbopts), db_name)
            end
          else
            $Dlog.error("RmenuMainSequel") {"Rconfig error: db_dbdriver?"}
            raise
          end
        }

        @mdb_queue.push(db_hash)
      end

      # initialize 終了ログを出力する
      $Dlog.debug("RmenuMainSequel") {"initialize normal end"}
    rescue DBI::DatabaseError => e
      $Dlog.error("RmenuMainSequel") {"initialize exception:"}
      $Dlog.error("RmenuMainSequel") {"Error code: #{e.err}"}
      $Dlog.error("RmenuMainSequel") {"Error message: #{e.errstr}"}
      raise
    end
  end

  def pop
    if $Rconfig['db_pools'] == 0
      db_hash  = Hash.new
      db_hash["default"] = RmenuSequel.new(false, false)
      return db_hash
    end

    return @mdb_queue.pop
  end

  def append(db_hash, dbname)
    db_hash[dbname] = RmenuSequel.new(false, false)
    return db_hash
  end

  def push(rmenu_database)
    if $Rconfig['db_pools'] == 0
      return
    end

    @mdb_queue.push(rmenu_database)
  end
end