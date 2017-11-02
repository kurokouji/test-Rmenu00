(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.AccessLog;

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
    // -------------------------------------------------------------------
    //  アクセス日付を表示する
    // -------------------------------------------------------------------
    showアクセス日付: function(arg) {
      $R.log("View showアクセス日付 : start");
      
      var today = arg["アクセス日付"];
      $("#アクセス日付").val(today);
      
      $R.log("View showアクセス日付 : end");
    }
    // -------------------------------------------------------------------
    //  ヘッダー曜日を表示する
    // -------------------------------------------------------------------
   ,showアクセス曜日: function(arg) {
      $R.log("View showアクセス曜日 : start");
      
      var wday  = arg["アクセス曜日"];
      $("#アクセス曜日").text(wday);
      
      $R.log("View showアクセス曜日 : end");
    }

  });

}(jQuery, Rmenu));