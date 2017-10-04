# coding: UTF-8

module RmenuParallelDBMixin

  # DB トランザクション スタート
  def transaction(rmenu_db, dbname)
    if $Rconfig['db_pools'] == 0
      rmenu_db["default"].connect(dbname, "");
      rmenu_db["default"].transaction()
    else
      rmenu_db.each do |xdbname, xrmenu_db|
        xrmenu_db.transaction()
      end
    end
  end

  # DB コミット
  def commit(rmenu_db)
    rmenu_db.each do |xdbname, xrmenu_db|
      $Tlog.debug("TupleClientServer") {"コミット DB : #{xdbname}"}
      xrmenu_db.commit()
      xrmenu_db.disconnect()
    end
  end

  # DB ロールバック
  def rollback(rmenu_db)
    rmenu_db.each do |xdbname, xrmenu_db|
      $Tlog.debug("TupleClientServer") {"ロールバック DB : #{xdbname}"}
      xrmenu_db.rollback()
      xrmenu_db.disconnect()
    end
  end

  # DB 切断
  def disconnect(rmenu_db)
    rmenu_db.each do |xdbname, xrmenu_db|
      xrmenu_db.disconnect()
    end
  end

end
