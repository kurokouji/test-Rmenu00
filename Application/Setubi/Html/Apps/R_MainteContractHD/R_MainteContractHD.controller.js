(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteContractHD;

  // インスタンスプロパティを追加する
  var Controller = App.Controller = new $R.Class($R.Controller);
  Controller.fn.init = function(appspec, model, view) {
    $R.log("Controllerr init : start");

    this.appspec = appspec;
    this.model   = model;
    this.view    = view;
    this.createPubSubEvent();

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
    // 初期処理
    // ---------------------------------------
    on初期処理: function() {
      $R.log("Controller on初期処理 : start");

      var arg = this.model.on初期処理();
      this.view.on初期処理(arg);
      
      var arg = this.model.on選択画面戻り();
      
      // 選択画面処理終り
      if (arg["status"] == "OK") {
        // 選択画面で選択データ無し
        if (arg["selected"] == "CANCEL") {
          var dataSet = this.model.dataset.getData();
          
          // セレクトボックスの一括初期表示（設備タイプ）
          this.onShowSelectBoxAll(dataSet, this.appspec.selectbox);
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        // 選択画面で選択データ有りで後処理無し
        if (arg["selected"] == "NONFUNCTIN") {
          var dataSet = this.model.dataset.getData();
          
          // セレクトボックスの一括初期表示（設備タイプ）
          this.onShowSelectBoxAll(dataSet, this.appspec.selectbox);
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        
        $R.log("Controller on初期処理 : end");
        return;
      }

      // 初期処理：前画面の引き継ぎデータをデータセットに設定する
      var status1 = this.model.setFromBeforeStorageDataToDataset();
      if (status1 == "OK") {
        var dataSet = this.model.dataset.getData();
        this.view.fromJsonDataToView(dataSet);
      }
        
      this.ajaxExecute("init");

      $R.log("Controller on初期処理 : end");
    }
    
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
    // 顧客検索選択画面呼出し
   ,on顧客検索: function(event) {
      $R.log("Controller on顧客検索 : start");

      // 顧客選択画面へ遷移する
      var row = 0;
      this.model.on選択画面遷移(this.appspec.selectStorageRequestData[0], this.appspec.selectStorageResponseData[0], row);

      $R.log("Controller on顧客検索 : end");
    }

    // 標準業者選択画面呼出し
   ,on標準業者: function(event) {
      $R.log("Controller on標準業者 : start");

      var row = event.currentTarget.parentNode.parentNode.rowIndex;
      this.model.on選択画面遷移(this.appspec.selectStorageRequestData[1], this.appspec.selectStorageResponseData[1], row);
      
      $R.log("Controller on標準業者 : end");
    }
    
   ,on作業明細: function(event, arg) {
      $R.log("Controller on作業明細 : start");

      this.onテーブル行クリック(event, arg);
      
      // 次画面の処理モードを設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode = sessionStorage.loadItem("処理モード");
      this.model.saveSessionStorageOfNextMode("R_MainteContractHD1", mode);

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteContractHD1", mode);
      
      $R.log("Controller on作業明細 : end");
    }
    
    // ---------------------------------------
    // チェンジ イベント処理
    // ---------------------------------------
   ,onChange設備タイプ: function(event, arg) {
      $R.log("Controller onChange設備タイプ : start");

      var row = event.currentTarget.parentNode.parentNode.rowIndex;
      this.model.onChangeTableSelectBox(event, row, this.appspec.selectbox);
      
      $R.log("Controller onChange設備タイプ : end");
    }
    
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
   ,on初期処理OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on初期処理OfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller on初期処理OfCheckRequestData : end");
      return status;
    }

    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,on初期処理OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on初期処理OfEditResponseData : start");
      
      var dataSet = this.model.on初期処理OfEditResponseData(responseData, mode);

      // セレクトボックスの一括初期表示（設備タイプ）
      this.onShowSelectBoxAll(responseData, this.appspec.selectbox);

      this.view.on初期処理OfEditResponseData(dataSet, responseData, mode);
      
      // 新規の時：キー無し　新規以外の時：キーが設定される
      this.ajaxExecute("select");

      $R.log("Controller on初期処理OfEditResponseData : end");
    }

    
  });
}(jQuery, Rmenu));