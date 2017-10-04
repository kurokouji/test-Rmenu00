(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteServiceHD1;

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
    // -----------------------------------------------------------------
    //  単価入力後、請求額計算する
    // -----------------------------------------------------------------
    check単価: function(arg) {
      $R.log("Controller check単価 : start");

      var arg1 = this.model.check単価(arg);
      var arg2 = this.model.derive請求額(arg1);
      this.view.derive請求額(arg2);

      $R.log("Controller check単価 : end");
      return arg;
    }
    
    // -----------------------------------------------------------------
    //  単価入力後、請求額計算する
    // -----------------------------------------------------------------
   ,check数量: function(arg) {
      $R.log("Controller check数量 : start");

      var arg1 = this.model.check数量(arg);
      var arg2 = this.model.derive請求額(arg1);
      this.view.derive請求額(arg2);
      
      $R.log("Controller check数量 : end");
      return arg;
    }
    
  });
}(jQuery, Rmenu));