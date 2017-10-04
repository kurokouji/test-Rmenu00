@echo on

rem タプルサーバファルダーに移動する
cd ../System/Server/Libraries/Main/

rem タプルサーバを終了させる
ruby TupleServerEnd.rb

exit