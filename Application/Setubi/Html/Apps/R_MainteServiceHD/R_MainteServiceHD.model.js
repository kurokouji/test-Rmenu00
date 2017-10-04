(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteServiceHD;

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
    // チェンジ イベント処理
    // -------------------------------------
    onChange指示日: function() {
      $R.log("Model onChange指示日 : start");

      var w_指示日 = $("#指示日").val();
      this.dataset.setElementData(w_指示日, "指示日");

      $R.log("Model onChange指示日 : end");
    }

   ,onChange作業予定日: function() {
      $R.log("Model onChange作業予定日 : start");

      var w_作業予定日 = $("#作業予定日").val();
      this.dataset.setElementData(w_作業予定日, "作業予定日");

      $R.log("Model onChange作業予定日 : end");
    }

   ,onChange作業実施日: function() {
      $R.log("Model onChange作業実施日 : start");

      var w_作業実施日 = $("#作業実施日").val();
      this.dataset.setElementData(w_作業実施日, "作業実施日");

      $R.log("Model onChange作業実施日 : end");
    }
    
    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
   ,on契約照会OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on契約照会OfCheckRequestData : start");

      // データセットからリクエストにデータを設定する（削除行を含む）
      var dataSet = this.dataset.getData();
      this.setDatasetToJsonRecordsInDeleteLine(dataSet, requestData);

      $R.log("Model on契約照会OfCheckRequestData : end");
      return true;
    }
    
    // --------------------------------------------
    //  照会　レスポンスデータ　編集処理
    //  データセット：detail
    //  明細テーブル：#mainTable
    // --------------------------------------------
   ,on契約照会OfEditResponseData: function(responseData, mode) {
      $R.log("Model on契約照会OfEditResponseData : start");

      // レスポンスデータをデータセットにセットする
      var dataSet = this.dataset.getData();
      this.setJsonRecordsToDataset(responseData, dataSet, this.pubsub);

      $R.log("Model on契約照会OfEditResponseData : end");
      return dataSet;
    }
    

  });

}(jQuery, Rmenu));