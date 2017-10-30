(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.VisualClient;

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
    // 初期処理
    // ---------------------------------------
    on初期処理: function() {
      $R.log("Controller on初期処理 : start");

      var arg = this.model.on初期処理();
      this.view.on初期処理(arg);

      var status = this.model.on選択画面戻り();
      
      // 選択画面処理終り
      if (arg["status"] == "OK") {
        // 選択画面で選択データ無し
        if (arg["selected"] == "CANCEL") {
          var dataSet = this.model.dataset.getData();
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        // 選択画面で選択データ有りで後処理無し
        if (arg["selected"] == "NONFUNCTIN") {
          var dataSet = this.model.dataset.getData();
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        
        $R.log("Controller on初期処理 : end");
        return;
      }

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var currentpage = sessionStorage.loadItem("カレントページ");
      
      if (currentpage === undefined) {
        // メニュー画面または別一覧画面から呼び出された時
        // 別の一覧画面からの引き継ぎデータをデータセットに設定する
        this.model.setFromBeforeStorageDataToDataset();
        
        // この部分を修正
        //this.on最初のページ();
        //this.ajaxExecute("init");
      }
      else {
        // 次画面から戻って来た時
        var dataSet = this.model.on初期リロード前処理();
        this.view.on初期リロード前処理(dataSet);
        this.onリロード();
      }

      $R.log("Controller on初期処理 : end");
    }


    
  });

}(jQuery, Rmenu));