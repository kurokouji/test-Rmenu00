(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.A_Sample_ParentChildMainte;

  // インスタンスプロパティを追加する
  var View = App.View = new $R.Class($R.View);
  View.fn.init = function(appspec) {
    $R.log("View init : start");

    this.appspec = appspec;

    $R.log("View init : end");
  }

  // モジュールを追加する
  View.include($R.Library.FormatMixin);
  View.include($R.Library.OutlineMixin);
  View.include($R.Library.LoadTemplateMixin);
  View.include($R.Library.ViewMixin);

  // マスターメンテパターン　ミックスインを追加する
  View.include($R.Library.DataMainteViewMixin);

  // --------------------------------------------------------
  // パターンに含まれない処理を追加する　　　　　　　　　　　
  // また、パターン内の処理を変更するときは、オーバライドする
  // --------------------------------------------------------
  View.include({
    // -----------------------------------------------------------------
    //  明細金額を表示する
    // -----------------------------------------------------------------
    deriveＡサンプル_明細金額: function(arg) {
      $R.log("View deriveＡサンプル_明細金額 : start");
      
      var row        = arg["row"];
      var w_明細金額 = this.formatExecute.money.format(arg["明細金額"]);
      $($(".Ａサンプル_明細金額")[row]).html(w_明細金額);
      
      $R.log("View deriveＡサンプル_明細金額 : end");
    }

    // -------------------------------------------------------
    //  メインテーブル照会　レスポンスデータ　編集処理
    // -------------------------------------------------------
   ,on初期処理OfEditResponseData: function(dataSet, responseData, mode) {
      $R.log("View on初期処理OfEditResponseData : start");

      //this.fromJsonDataToView(responseData);
      this.resetJsonDataToTable("#mainTable", dataSet, "detail");

      $R.log("View on初期処理OfEditResponseData : end");
    }
    
  });

}(jQuery, Rmenu));