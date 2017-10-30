(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.TS_EquipmentType;

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

  // 基本名称メンテ　パターン　ミックスインを追加する
  Controller.include($R.Library.BaseDataMainteControllerMixin);

  // --------------------------------------------------------
  // パターンに含まれない処理を追加する　　　　　　　　　　　
  // また、パターン内の処理を変更するときは、オーバライドする
  // --------------------------------------------------------
  Controller.include({
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
     on設備タイプ別作業: function(event) {
      $R.log("Controller on設備タイプ別作業 : start");

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("TS_EquipmentTypeWork", "execute");

      // 次画面に画面遷移する
      this.model.on次画面表示("TS_EquipmentTypeWork", "execute");

      $R.log("Controller on設備タイプ別作業 : end");
    }

  });

}(jQuery, Rmenu));