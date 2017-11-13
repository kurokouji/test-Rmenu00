(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteContractList;

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
     on契約保守作業明細照会: function(event) {
      $R.log("Controller on契約保守作業明細照会 : start");

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("R_MainteContractHD1", "select");

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteContractHD1", "select");

      $R.log("Controller on契約保守作業明細照会 : end");
    }

    ,on契約保守諸掛明細照会: function(event) {
      $R.log("Controller on契約保守諸掛明細照会 : start");

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("R_MainteContractHD2", "select");

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteContractHD2", "select");

      $R.log("Controller on契約保守諸掛明細照会 : end");
    }

    ,on保守サービス指示一覧: function(event) {
      $R.log("Controller on保守サービス指示一覧 : start");

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("R_MainteServiceList", "select");

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteServiceList", "select");

      $R.log("Controller on保守サービス指示一覧 : end");
    }

    ,on契約者台帳ＰＤＦ: function(event) {
      $R.log("Controller on契約者台帳ＰＤＦ : start");

      this.ajaxExecute("print01");

      $R.log("Controller on契約者台帳ＰＤＦ : end");
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

    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
    ,onＰＤＦ作成OfEditResponseData: function(responseData, mode) {
      $R.log("Controller onＰＤＦ作成OfEditResponseData : start");

      this.model.onＰＤＦ表示OfEditResponseData(responseData, mode);

      $R.log("Controller onＰＤＦ作成OfEditResponseData : end");
    }


  });

}(jQuery, Rmenu));