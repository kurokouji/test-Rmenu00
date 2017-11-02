(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.ParallelList;

  // インスタンスプロパティを追加する
  var Model = App.Model = new $R.Class($R.Model);
  Model.fn.init = function(appspec) {
    $R.log("Model init : start");

    this.appspec = appspec;

    $R.log("Model init : end");
  }

  // 共通モジュールを追加する
  Model.include($R.Library.ValidationMixin);
  Model.include($R.Library.ModelMixin);
  Model.include($R.Library.HtmlTransitionMixin);

  // マスター一覧パターン　ミックスインを追加する
  Model.include($R.Library.DataMainteListModelMixin);

  // --------------------------------------------------------
  // パターンに含まれない処理を追加する　　　　　　　　　　　
  // また、パターン内の処理を変更するときは、オーバライドする
  // --------------------------------------------------------
  Model.include({
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
    // 削除処理の実行確認
    onExecuteDialogAfter: function() {
      $R.log("Model onExecuteDialogAfter : start");

      var status = sessionStorage.getItem("executeDialog");
      if (status == 1) {
        var arg = {};
        this.pubsub.publish("on削除実行", arg); 
      }

      $R.log("Model onExecuteDialogAfter : end");
    }
    
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
   ,on処理削除OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on処理削除OfCheckRequestData : start");

      var dataSet       = this.dataset.getData();
      var detailRecord  = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail")["record"];
      var requestRecord = this.appspec.getJSONChunkByIdAtRecords(requestData, "header")["record"];

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var row = sessionStorage.loadItem("クリック行");
      requestRecord["並列分散管理削除ＩＤ"]["value"][0] = detailRecord["並列分散管理ＩＤ"]["value"][row];

      $R.log("Controller on処理削除OfCheckRequestData : end");
      return true;
    }
    
    // -------------------------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------------------------
   ,on処理削除OfEditResponseData: function(responseData) {
      $R.log("Model on処理削除OfEditResponseData : start");

      var status = responseData["message"]["status"];
      var msg    = responseData["message"]["msg"];
      var arg    = {title: "サーバ処理確認", status: status, message: msg};
      this.pubsub.publish("serverDialog", arg);

      $R.log("Model on処理削除OfEditResponseData : end");
    }
    
  });
}(jQuery, Rmenu));