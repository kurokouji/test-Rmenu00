(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.ParallelList;

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
    on分割画面: function(event) {
      $R.log("Controller on分割画面 : start");

      // 次画面の処理モードを設定する
      this.model.saveSessionStorageOfNextMode("ParallelDivisionList", "select");

      // 次画面に画面遷移する
      this.model.on次画面表示("ParallelDivisionList", "select");

      $R.log("Controller on分割画面 : end");
    }
   ,on処理削除: function(event) {
      $R.log("Controller on処理削除 : start");

      if (!this.model.check行選択()) return;
      
      var arg = {};
      arg["title"]   = "削除　実行確認";
      arg["message"] = "削除を実行します。よろしいですか。";
      this.pubsub.publish("executeDialog", arg);    

      $R.log("Controller on処理削除 : end");
    }
    
    // モデルのonExecuteDialogAfterから呼び出される
   ,on削除実行: function() {
      $R.log("Controller on削除実行 : start");

      this.ajaxExecute("delete");

      $R.log("Controller on削除実行 : end");
    }
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
   ,on処理削除OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on処理削除OfCheckRequestData : start");

      var status = this.model.on処理削除OfCheckRequestData(requestData, mode);
      if (status) {
        status = this.checkRequestData(requestData);
      }

      $R.log("Controller on処理削除OfCheckRequestData : end");
      return status;
    }
    // -------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------
   ,on処理削除OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on処理削除OfEditResponseData : start");

      this.model.on処理削除OfEditResponseData(responseData);
      this.onリロード();

      $R.log("Controller on処理削除OfEditResponseData : end");
    }
  });
}(jQuery, Rmenu));