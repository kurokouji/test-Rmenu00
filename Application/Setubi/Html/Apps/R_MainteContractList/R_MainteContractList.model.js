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

      var date = new Date();
      var year = date.getFullYear()
      var mon  = date.getMonth()+1; //１を足すこと
      var day  = date.getDate();
      var hour = date.getHours();
      var min  = date.getMinutes();
      var sec  = date.getSeconds();

      var pdfname = responseData["pdfinfo"]["pdfname"]
      var tpdfname = pdfname.split(/.pdf$/)

      var argHash  = new Object();
      argHash["file"]   = responseData["pdfinfo"]["pdffile"];
      argHash["download"] = tpdfname[0]
          + "_"
          + ( '0000' + year ).slice( -4 )
          + ( '0000' + mon  ).slice( -2 )
          + ( '0000' + day  ).slice( -2 )
          + "_"
          + ( '0000' + hour  ).slice( -2 )
          + ( '0000' + min  ).slice( -2 )
          + ( '0000' + sec  ).slice( -2 )
          + ".pdf"
      ;
      argHash["type"]   = "pdf";
      argHash["delete"] = "yes";
      this.postDownloadRack(argHash);

      $R.log("Model onＰＤＦ表示OfEditResponseData : end");
    }

   ,onＰＤＦ作成バッチOfEditResponseData: function(responseData, mode) {
      $R.log("Model onＰＤＦ作成バッチOfEditResponseData : start");


      $R.log("Model onＰＤＦ作成バッチOfEditResponseData : end");
    }


  });

}(jQuery, Rmenu));