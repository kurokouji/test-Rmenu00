(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MainteServiceHD1;

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
    // -----------------------------------------------------------------
    //  単価
    // -----------------------------------------------------------------
    check単価: function(arg) {
      $R.log("Model check単価 : start");
      
      var w_単価       = arg["value"];
      var row          = arg["row"];
      var w_数量       = this.dataset.getElementData("数量", row);
      var w_請求フラグ = this.dataset.getElementData("請求フラグ", row);
      
      var arg1 = {};
      arg1["row"]        = row;
      arg1["請求フラグ"] = w_請求フラグ;
      arg1["単価"]       = w_単価;
      arg1["数量"]       = w_数量;

      $R.log("Model check単価 : end");
      return arg1;
    }
    
    // -----------------------------------------------------------------
    //  数量
    // -----------------------------------------------------------------
   ,check数量: function(arg) {
      $R.log("Model check数量 : start");

      var w_数量       = arg["value"];
      var row          = arg["row"];
      var w_単価       = this.dataset.getElementData("単価", row);
      var w_請求フラグ = this.dataset.getElementData("請求フラグ", row);
      
      var arg1 = {};
      arg1["row"]        = row;
      arg1["請求フラグ"] = w_請求フラグ;
      arg1["単価"]       = w_単価;
      arg1["数量"]       = w_数量;
      
      $R.log("Model check数量 : end");
      return arg1;
    }
    
    // -----------------------------------------------------------------
    //  請求額
    // -----------------------------------------------------------------
   ,derive請求額: function(arg) {
      $R.log("Model derive請求額 : start");

      var arg1       = {};
      arg1["row"]    = arg["row"];
      arg1["請求額"] = "";
      
      if (arg["請求フラグ"] != "請求する") {
        $R.log("Model derive請求額 : end");
        return arg1;
      }
      
      
      var w_請求額 = 0;
      var w_数量 = arg["数量"];
      var w_単価 = arg["単価"];
      
      if ( isNaN(w_数量) ) {
        var x_数量 = 0;
      }
      else {
        var x_数量 =  Number(w_数量);
      }
      
      if ( isNaN(w_単価) ) {
        var x_単価 = 0;
      }
      else {
        var x_単価 =  Number(w_単価);
      }
      
      w_請求額 = new BigNumber(x_数量).times(x_単価).toPrecision();
      if (w_請求額 == "") {
        w_請求額 = "0";
      }
      this.dataset.setElementData(w_請求額, "請求額", arg["row"]);
      
      arg1["請求額"] = w_請求額;

      $R.log("Model derive請求額 : end");
      return arg1;
    }
    
    // --------------------------------------------
    //  照会　レスポンスデータ　編集処理
    //  データセット：detail
    //  明細テーブル：#mainTable
    // --------------------------------------------
   ,on照会OfEditResponseData: function(responseData, mode) {
      $R.log("Model on照会OfEditResponseData : start");

      // データセットの明細デフォルト行数を取得
      var dataSet      = this.dataset.getData();
      var detailInfo   = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail");
      
      // レスポンスの明細行数を取得
      var detailRecord = this.appspec.getJSONChunkByIdAtRecords(responseData, "detail")["record"];
      var maxSize      = 0;
      for (var name in detailRecord) {
        maxSize = detailRecord[name]["value"].length
        break;
      }
      
      // データセットのデフォルト行数を置き換える
      detailInfo["defaultline"] = maxSize;

      // レスポンスデータをデータセットにセットする
      this.setJsonRecordsToDataset(responseData, dataSet, this.pubsub);

      $R.log("Model on照会OfEditResponseData : end");
      return dataSet;
    }

  });

}(jQuery, Rmenu));