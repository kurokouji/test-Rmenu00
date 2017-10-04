(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteServiceList;

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
     on保守サービス指示諸掛明細: function(event) {
      $R.log("Controller on保守サービス指示諸掛明細 : start");

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("R_MainteServiceHD1", "select");

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteServiceHD1", "select");

      $R.log("Controller on保守サービス指示諸掛明細 : end");
    }

    ,on保守契約一覧: function(event) {
      $R.log("保守契約一覧 on保守契約一覧 : start");

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("R_MainteContractList", "select");

      // 次画面に画面遷移する
      this.model.on次画面表示("R_MainteContractList", "select");

      $R.log("保守契約一覧 on保守契約一覧 : end");
    }
    
  });

}(jQuery, Rmenu));