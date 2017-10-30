(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.VisualLogs;

  // インスタンスプロパティを追加する
  var View = App.View = new $R.Class($R.View);
  View.fn.init = function(appspec) {
    $R.log("View init : start");

    this.appspec = appspec;

    $R.log("View init : end");
  }

  // 共通モジュールを追加する
  View.include($R.Library.FormatMixin);
  View.include($R.Library.OutlineMixin);
  View.include($R.Library.LoadTemplateMixin);
  View.include($R.Library.ViewMixin);

  // マスター一覧パターン　ミックスインを追加する
  View.include($R.Library.DataMainteListViewMixin);

  // --------------------------------------------------------
  // パターンに含まれない処理を追加する　　　　　　　　　　　
  // また、パターン内の処理を変更するときは、オーバライドする
  // --------------------------------------------------------
  View.include({
    // -----------------------
    //  初期処理
    // -----------------------
    on初期処理: function(arg) {
      $R.log("View on初期処理 : start");

      var dataSet = arg["データセット"];
      
      // テーブルの空行を作成する
      this.resetJsonDataToTable("#mainTable1", dataSet, "detail1");
      this.resetJsonDataToTable("#mainTable2", dataSet, "detail2");
      this.resetJsonDataToTable("#mainTable3", dataSet, "detail3");
      this.resetJsonDataToTable("#mainTable4", dataSet, "detail4");

      $R.log("View on初期処理 : end");
    }

  });

}(jQuery, Rmenu));