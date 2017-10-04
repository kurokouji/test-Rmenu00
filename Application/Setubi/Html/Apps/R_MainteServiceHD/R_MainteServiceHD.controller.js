(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteServiceHD;

  // インスタンスプロパティを追加する
  var Controller = App.Controller = new $R.Class($R.Controller);
  Controller.fn.init = function(appspec, model, view) {
    $R.log("Controllerr init : start");

    this.appspec = appspec;
    this.model   = model;
    this.view    = view;
    this.createPubSubEvent();

    var self = this;

    var api1 = $('#datetimepicker1').datetimepicker({
        format : 'yyyy/MM/dd',
        language : 'ja',
        pickTime : false
    }).data('datetimepicker');
    api1.widget.on('click','td.day',function(){
        api1.hide();
        self.onChange指示日();
    });

    var api2 = $('#datetimepicker2').datetimepicker({
        format : 'yyyy/MM/dd',
        language : 'ja',
        pickTime : false
    }).data('datetimepicker');
    api2.widget.on('click','td.day',function(){
        api2.hide();
        self.onChange作業予定日();
    });

    var api3 = $('#datetimepicker3').datetimepicker({
        format : 'yyyy/MM/dd',
        language : 'ja',
        pickTime : false
    }).data('datetimepicker');
    api3.widget.on('click','td.day',function(){
        api3.hide();
        self.onChange作業実施日();
    });

    $R.log("Controllerr init : end");
  };

  // モジュールを追加する
  Controller.include($R.Library.EnterTabPFKeyMixin);
  Controller.include($R.Library.ControllerMixin);

  // マスターメンテパターン　ミックスインを追加する
  Controller.include($R.Library.DataMainteControllerMixin);

  // --------------------------------------------------------
  // パターンに含まれない処理を追加する　　　　　　　　　　　
  // また、パターン内の処理を変更するときは、オーバライドする
  // --------------------------------------------------------
  Controller.include({
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
    // 業者選択画面を呼び出す
    on業者検索: function(event) {
      $R.log("Controller on業者検索 : start");

      var row = 0;
      this.model.on選択画面遷移(this.appspec.selectStorageRequestData[0], this.appspec.selectStorageResponseData[0], row);
      
      $R.log("Controller on業者検索 : end");
    }
    
    // 保守契約選択画面呼び出し
   ,on契約検索: function(event) {
      $R.log("Controller on契約検索 : start");

      var row = 0;
      this.model.on選択画面遷移(this.appspec.selectStorageRequestData[1], this.appspec.selectStorageResponseData[1], row);
      
      $R.log("Controller on契約検索 : end");
    }
    
    // 保守契約選択画面後処理
   ,on契約検索後処理: function() {
      $R.log("Controller on契約検索後処理 : start");

      // データセットを使って、遷移前の画面を復元する
      var dataSet = this.model.dataset.getData();
      
      // ヘッダー部・明細部　復元
      this.view.fromJsonDataToView(dataSet);

      // 契約保守作業明細　照会処理を実行する
      this.ajaxExecute("contract");
      
      $R.log("Controller on契約検索後処理 : end");
    }
    
   ,on諸掛明細: function(event, arg) {
      $R.log("Controller on諸掛明細 : start");

      this.onテーブル行クリック(event, arg);
      
      // 次画面の処理モードを設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode = sessionStorage.loadItem("処理モード");
      this.model.saveSessionStorageOfNextMode("R_MainteServiceHD1", mode);

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteServiceHD1", mode);
      
      $R.log("Controller on諸掛明細 : end");
    }
    
    // -------------------------------------
    // チェンジ イベント処理（追加処理）
    // -------------------------------------
   ,onChange指示日: function() {
      $R.log("Controller onChange指示日 : start");

      this.model.onChange指示日();
      
      $R.log("Controller onChange指示日 : end");
    }

   ,onChange作業予定日: function() {
      $R.log("Controller onChange作業予定日 : start");

      this.model.onChange作業予定日();
      
      $R.log("Controller onChange作業予定日 : end");
    }

   ,onChange作業実施日: function() {
      $R.log("Controller onChange作業実施日 : start");

      this.model.onChange作業実施日();
      
      $R.log("Controller onChange作業実施日 : end");
    }
    
    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
   ,on契約照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on契約照会OfCheckRequestData : start");

      var status = this.model.on契約照会OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on契約照会OfCheckRequestData : end");
      return status;
    }
    
    // -------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------
   ,on契約照会OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on契約照会OfEditResponseData : start");
      
      var dataSet = this.model.on契約照会OfEditResponseData(responseData, mode);
      this.view.on契約照会OfEditResponseData(dataSet, responseData, mode);

      $R.log("Controller on契約照会OfEditResponseData : end");
    }
    
    
  });
}(jQuery, Rmenu));