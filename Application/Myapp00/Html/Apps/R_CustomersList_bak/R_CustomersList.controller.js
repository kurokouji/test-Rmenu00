(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_CustomersList;

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

     on帳票: function(event) {
      $R.log("Controller on帳票 : start");

      this.ajaxExecute("print01");

      $R.log("Controller on帳票 : end");
    }
    ,on帳票バッチ: function(event) {
      $R.log("Controller on帳票バッチ : start");

      this.ajaxExecute("batchprint");

      $R.log("Controller on帳票バッチ : end");
    }
   ,onダウンロード: function(event) {
      $R.log("Controller onダウンロード : start");

      this.ajaxExecute("download");

      $R.log("Controller onダウンロード : end");
    }
   ,onエクセル: function(event) {
      $R.log("Controller onエクセル : start");

      this.ajaxExecute("workbook");

      $R.log("Controller onエクセル : end");
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
   ,onダウンロードOfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onダウンロードOfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller onダウンロードOfCheckRequestData : end");
      return status;
    }
   ,onエクセルOfCheckRequestData: function(requestData, mode) {
      $R.log("Controller onエクセルOfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller onエクセルOfCheckRequestData : end");
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

   ,onダウンロードOfEditResponseData: function(responseData, mode) {
      $R.log("Controller onダウンロードOfEditResponseData : start");

      this.model.onダウンロードOfEditResponseData(responseData);

      $R.log("Controller onダウンロードOfEditResponseData : end");
    }
   ,onエクセルOfEditResponseData: function(responseData, mode) {
      $R.log("Controller onエクセルOfEditResponseData : start");

      this.model.onエクセルOfEditResponseData(responseData);

      $R.log("Controller onエクセルOfEditResponseData : end");
    }


    
  });

}(jQuery, Rmenu));