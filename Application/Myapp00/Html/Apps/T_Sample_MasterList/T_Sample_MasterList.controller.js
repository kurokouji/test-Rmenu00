(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.T_Sample_MasterList;

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

  // 共通モジュールを追加する
  Controller.include($R.Library.EnterTabPFKeyMixin);
  Controller.include($R.Library.ControllerMixin);

  // マスター一覧パターン　ミックスインを追加する
  Controller.include($R.Library.DataMainteListControllerMixin);

  // --------------------------------------------------------
  // パターンに含まれない処理を追加する　　　　　　　　　　　
  // また、パターン内の処理を変更するときは、オーバライドする
  // --------------------------------------------------------
  Controller.include({
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
     on保守契約一覧: function(event) {
      $R.log("Controller on保守契約一覧 : start");
      
      // 保守契約一覧画面への引継ぎデータ（サンプル_マスタ項目０１）をセット
      var status = this.model.on保守契約一覧前処理();
      

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("R_MainteContractList", "select");

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteContractList", "select");
      
      
      if (status) {
        // セッションストレージ　検索サンプル_マスタ項目０１　クリア
        this.model.on保守契約一覧後処理();
      }

      $R.log("Controller on保守契約一覧 : end");
    }

    ,on保守サービス指示一覧: function(event) {
      $R.log("Controller on保守サービス指示一覧 : start");

      // 保守サービス一覧画面への引継ぎデータ（サンプル_マスタ項目０１）をセット
      var status = this.model.on保守契約一覧前処理();
      

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("R_MainteServiceList", "select");

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteServiceList", "select");
      

      if (status) {
        // セッションストレージ　検索サンプル_マスタ項目０１　クリア
        this.model.on保守契約一覧後処理();
      }

      $R.log("Controller on保守サービス指示一覧 : end");
    }


    ,on契約者台帳ＰＤＦ: function(event) {
      $R.log("Controller on契約者台帳ＰＤＦ : start");

      this.ajaxExecute("print01");

      $R.log("Controller on契約者台帳ＰＤＦ : end");
    }

    ,on契約者台帳ＰＤＦバッチ: function(event) {
      $R.log("Controller on契約者台帳ＰＤＦバッチ : start");

      this.ajaxExecute("batchprint");

      $R.log("Controller on契約者台帳ＰＤＦバッチ : end");
    }
    
    
    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
   ,onＰＤＦ作成OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onＰＤＦ作成OfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller onＰＤＦ作成OfCheckRequestData : end");
      return status;
    }
    
   ,onＰＤＦ作成バッチOfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onＰＤＦ作成バッチOfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller onＰＤＦ作成バッチOfCheckRequestData : end");
      return status;
    }

    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
    ,onＰＤＦ作成OfEditResponseData: function(responseData, mode) {
      $R.log("Controller onＰＤＦ作成OfEditResponseData : start");

      this.model.onＰＤＦ表示OfEditResponseData(responseData, mode);

      $R.log("Controller onＰＤＦ作成OfEditResponseData : end");
    }

    ,onＰＤＦ作成バッチOfEditResponseData: function(responseData, mode) {
      $R.log("Controller onＰＤＦ作成バッチOfEditResponseData : start");

      this.model.onＰＤＦ作成バッチOfEditResponseData(responseData, mode);

      $R.log("Controller onＰＤＦ作成バッチOfEditResponseData : end");
    }


  });

}(jQuery, Rmenu));