(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.A_Sample_ParentMainte;

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
    on照会OfEditResponseData: function(dataSet, responseData, mode) {
      $R.log("View on照会OfEditResponseData : start");
      
      // テーブル以外の項目（ヘッダー・フッター）にデータを表示する
      this.fromJsonDataToView(dataSet);
      
      // テーブルにデータを表示する
      var detailInfo  = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail");
      if (detailInfo === undefined) {
      }
      else {
        if (detailInfo["multiline"] == "yes") {
          this.resetJsonDataToTable("#mainTable", dataSet, "detail");
        }
      }
      
      // Ａサンプル_ヘッダＩＤが空の時、サンプル子メンテボタンをハイドにする
      var headerRecord = this.appspec.getJSONChunkByIdAtRecords(dataSet, "header")["record"];
      if (headerRecord["Ａサンプル_ヘッダＩＤ"]["value"][0] == "") {
        $("#サンプル子メンテ").hide();
      }
      else {
        $("#サンプル子メンテ").show();
      }

      $R.log("View on照会OfEditResponseData : end");
    }

    
  });

}(jQuery, Rmenu));