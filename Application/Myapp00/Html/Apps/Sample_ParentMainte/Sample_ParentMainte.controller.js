(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.Sample_ParentMainte;

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
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
    onサンプル子メンテ: function(event) {
      $R.log("Controller onサンプル子メンテ : start");
      
      // 次画面の処理モードを設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var mode = sessionStorage.loadItem("処理モード");
      this.model.saveSessionStorageOfNextMode("Sample_ChildMainte", mode);

      // 次画面に画面遷移する
      this.model.on次画面表示("Sample_ChildMainte", mode);

      $R.log("Controller onサンプル子メンテ : end");
    }

    // 顧客検索選択画面呼出し
   ,onサンプル検索: function(event) {
      $R.log("Controller onサンプル検索 : start");

      // 顧客選択画面へ遷移する
      var row = 0;
      this.model.on選択画面遷移(this.appspec.selectStorageRequestData[0], this.appspec.selectStorageResponseData[0], row);

      $R.log("Controller onサンプル検索 : end");
    }

  });
}(jQuery, Rmenu));