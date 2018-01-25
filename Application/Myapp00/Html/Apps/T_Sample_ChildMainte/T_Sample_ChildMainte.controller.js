(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.T_Sample_ChildMainte;

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
          
          // セレクトボックスの一括初期表示
          this.onShowSelectBoxAll(dataSet, this.appspec.selectbox);
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        // 選択画面で選択データ有りで後処理無し
        if (arg["selected"] == "NONFUNCTIN") {
          var dataSet = this.model.dataset.getData();
          
          // セレクトボックスの一括初期表示
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
    // チェンジ イベント処理
    // ---------------------------------------
   ,onChangeサンプル_区分ＩＤ: function(event, arg) {
      $R.log("Controller onChangeサンプル_区分ＩＤ : start");

      var row = event.currentTarget.parentNode.parentNode.rowIndex;
      this.model.onChangeTableSelectBox(event, row, this.appspec.selectbox);
      
      $R.log("Controller onChangeサンプル_区分ＩＤ : end");
    }
   ,onChangeサンプル_区分名称: function(event, arg) {
      $R.log("Controller onChangeサンプル_区分名称 : start");

      var row = event.currentTarget.parentNode.parentNode.rowIndex;
      this.model.onChangeTableSelectBox(event, row, this.appspec.selectbox);
      
      $R.log("Controller onChangeサンプル_区分名称 : end");
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