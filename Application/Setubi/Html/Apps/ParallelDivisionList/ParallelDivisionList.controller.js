(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.ParallelDivisionList;

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
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
    on再処理OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on再処理OfCheckRequestData : start");

      var status = this.model.on再処理OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on再処理OfCheckRequestData : end");
      return status;
    }
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,on再処理OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on再処理OfEditResponseData : start");

      this.onリロード();

      $R.log("Controller on再処理OfEditResponseData : end");
    }
  });
}(jQuery, Rmenu));