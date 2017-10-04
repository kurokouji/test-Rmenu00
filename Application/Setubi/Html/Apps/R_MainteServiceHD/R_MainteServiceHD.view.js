(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteServiceHD;

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
    // -------------------------------------------------------------------------------
    //  照会　レスポンスデータ　編集処理
    //  データセット：detail
    //  明細テーブル：#mainTable
    // -------------------------------------------------------------------------------
    on契約照会OfEditResponseData: function(dataSet, responseData, mode) {
      $R.log("View on契約照会OfEditResponseData : start");
      
      // テーブル以外の項目（ヘッダー・フッター）にデータを表示する
      this.fromJsonDataToView(dataSet);
      
      // テーブルにデータを表示する
      this.resetJsonDataToTable("#mainTable", dataSet, "detail");
      
      $R.log("View on契約照会OfEditResponseData : end");
    }

    
  });

}(jQuery, Rmenu));