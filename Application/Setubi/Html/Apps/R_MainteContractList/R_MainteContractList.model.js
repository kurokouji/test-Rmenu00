(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteContractList;

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
    // -------------------------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------------------------
    onＰＤＦ表示OfEditResponseData: function(responseData, mode) {
      $R.log("Model onＰＤＦ表示OfEditResponseData : start");

      var argHash  = new Object();
      argHash["file"]   = responseData["pdfinfo"]["pdffile"];
      argHash["download"] = responseData["pdfinfo"]["pdfname"];
      argHash["type"]   = "pdf";
      argHash["delete"] = "yes";
      this.postDownloadRack(argHash);

      $R.log("Model onＰＤＦ表示OfEditResponseData : end");
    }


  });

}(jQuery, Rmenu));