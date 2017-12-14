(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.T_Sample_MasterList;

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
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
     on保守契約一覧前処理: function(event) {
      $R.log("Controller on保守契約一覧前処理 : start");
      
      // データセットを設定する
      var dataSet      = this.dataset.getData();
      var headerRecord = this.appspec.getJSONChunkByIdAtRecords(dataSet, "header")["record"];
      var detailRecord = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail")["record"];
      if (headerRecord["検索Ｔサンプル_マスタ項目０１"]["value"][0] != "") {
        return false;
      }

      // 保守契約一覧画面への引継ぎデータ（検索Ｔサンプル_マスタ項目０１）をセット
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var clickRow      = sessionStorage.loadItem("クリック行");

      w_検索Ｔサンプル_マスタ項目０１ = detailRecord["Ｔサンプル_マスタ項目０１"]["value"][clickRow];
      headerRecord["検索Ｔサンプル_マスタ項目０１"]["value"][0] = w_検索Ｔサンプル_マスタ項目０１;
      
      $R.log("Controller on保守契約一覧前処理 : end");
      return true;
    }

    ,on保守契約一覧後処理: function(event) {
      $R.log("Controller on保守契約一覧後処理 : start");

      // セッションストレージ　検索Ｔサンプル_マスタ項目０１　クリア
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      sessionStorage.saveItem("検索Ｔサンプル_マスタ項目０１", "");

    }

    ,onＰＤＦ表示OfEditResponseData: function(responseData, mode) {
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