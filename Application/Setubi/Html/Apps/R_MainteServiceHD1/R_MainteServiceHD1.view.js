(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteServiceHD1;

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
    //  発注合計金額を表示する
    // -----------------------------------------------------------------
    derive請求額: function(arg) {
      $R.log("View derive請求額 : start");
      
      var row      = arg["row"];
      var w_請求額 = this.formatExecute.money.format(arg["請求額"]);
      $($(".請求額")[row]).html(w_請求額);
      
      $R.log("View derive請求額 : end");
    }

  });

}(jQuery, Rmenu));