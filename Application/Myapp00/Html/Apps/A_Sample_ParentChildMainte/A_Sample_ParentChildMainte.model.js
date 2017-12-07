(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.A_Sample_ParentChildMainte;

  // インスタンスプロパティを追加する
  var Model = App.Model = new $R.Class($R.Model);
  Model.fn.init = function(appspec) {
    $R.log("Model init : start");

    this.appspec = appspec;

    $R.log("Model init : end");
  }

  // モジュールを追加する
  Model.include($R.Library.ValidationMixin);
  Model.include($R.Library.ModelMixin);
  Model.include($R.Library.HtmlTransitionMixin);

  // マスターメンテパターン　ミックスインを追加する
  Model.include($R.Library.DataMainteModelMixin);

  // --------------------------------------------------------
  // パターンに含まれない処理を追加する　　　　　　　　　　　
  // また、パターン内の処理を変更するときは、オーバライドする
  // --------------------------------------------------------
  Model.include({
    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
     on訂正OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on訂正OfCheckRequestData : start");

      // データセットからリクエストにデータを設定する
      var dataSet = this.dataset.getData();
      //this.setDatasetToJsonRecordsInDeleteLine(dataSet, requestData);    // 削除行をリクエストデータに出力する
      this.setDatasetToJsonRecordsNoDeleteLine(dataSet, requestData);      // 削除行をリクエストデータに出力しない
      
      // ログイン情報を設定する
      var requestRecord = this.appspec.getJSONChunkByIdAtRecords(requestData, "login");
      if (requestRecord) {
        // セッションデータに識別名を設定する
        sessionStorage.setIdName(this.appspec.sysname + ".Login");
        var loginRecord                       = requestRecord["record"];
        loginRecord["ユーザＩＤ"]["value"][0] = sessionStorage.loadItem("ユーザＩＤ");
        loginRecord["ユーザ名称"]["value"][0] = sessionStorage.loadItem("ユーザ名称");
        sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      }
      
      $R.log("Model on訂正OfCheckRequestData : end");
      return true;
    }

    // -------------------------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------------------------
   ,on初期処理OfEditResponseData: function(responseData) {
      $R.log("Model on初期処理OfEditResponseData : start");

      var dataSet = this.dataset.getData();
      this.setJsonRecordsToDataset(responseData, dataSet, this.pubsub);

      $R.log("Model on初期処理OfEditResponseData : end");
      return dataSet;
    }

  });

}(jQuery, Rmenu));