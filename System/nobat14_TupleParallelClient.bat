@echo on

rem タプルクライアントファルダーに移動する
cd ../System/Server/Libraries/Main/

rem タプルクライアントを起動する
ruby TupleParallelClient.rb

exit