(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.Sample_ChildMainte;

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
    //  明細数量
    // -----------------------------------------------------------------
    checkサンプル_明細数量: function(arg) {
      $R.log("Model checkサンプル_明細数量 : start");
      
      var w_明細数量   = arg["value"];
      var row          = arg["row"];
      var w_明細単価   = this.dataset.getElementData("サンプル_明細単価", row);
      
      var arg1         = {};
      arg1["row"]      = row;
      arg1["明細数量"] = w_明細数量;
      arg1["明細単価"] = w_明細単価;

      $R.log("Model checkサンプル_明細数量 : end");
      return arg1;
    }
    
    // -----------------------------------------------------------------
    //  明細単価
    // -----------------------------------------------------------------
   ,checkサンプル_明細単価: function(arg) {
      $R.log("Model checkサンプル_明細単価 : start");

      var w_明細単価   = arg["value"];
      var row          = arg["row"];
      var w_明細数量   = this.dataset.getElementData("サンプル_明細数量", row);
      
      var arg1         = {};
      arg1["row"]      = row;
      arg1["明細単価"] = w_明細単価;
      arg1["明細数量"] = w_明細数量;
      
      $R.log("Model checkサンプル_明細単価 : end");
      return arg1;
    }
    
    // -----------------------------------------------------------------
    //  請求額
    // -----------------------------------------------------------------
   ,deriveサンプル_明細金額: function(arg) {
      $R.log("Model deriveサンプル_明細金額 : start");

      var arg1         = {};
      arg1["row"]      = arg["row"];
      arg1["明細金額"] = "";
      
      var w_明細金額 = 0;
      var w_明細数量 = arg["明細数量"];
      var w_明細単価 = arg["明細単価"];
      
      if ( isNaN(w_明細数量) ) {
        var x_明細数量 = 0;
      }
      else {
        var x_明細数量 =  Number(w_明細数量);
      }
      
      if ( isNaN(w_明細単価) ) {
        var x_明細単価 = 0;
      }
      else {
        var x_明細単価 =  Number(w_明細単価);
      }
      
      w_明細金額 = new BigNumber(x_明細数量).times(x_明細単価).toPrecision();
      if (w_明細金額 == 0) {
        w_明細金額 = "";
      }
      this.dataset.setElementData(w_明細金額, "サンプル_明細金額", arg["row"]);
      
      arg1["明細金額"] = w_明細金額;

      $R.log("Model deriveサンプル_明細金額 : end");
      return arg1;
    }
    
    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
    ,on訂正OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on訂正OfCheckRequestData : start");

      // データセットからリクエストにデータを設定する
      var dataSet = this.dataset.getData();
      //this.setDatasetToJsonRecordsInDeleteLine(dataSet, requestData);    // 削除行をリクエストデータに出力する
      this.setDatasetToJsonRecordsNoDeleteLine(dataSet, requestData);      // 削除行をリクエストデータに出力しない
      
      // ログイン情報を設定する
      var requestRecord = this.appspec.getJSONChunkByIdAtRecords(requestData, "login");
      if (requestRecord) {
        // セッションデータに識別名を設定する
        sessionStorage.setIdName(this.appspec.sysname + ".Login");
        var loginRecord                       = requestRecord["record"];
        loginRecord["ユーザＩＤ"]["value"][0] = sessionStorage.loadItem("ユーザＩＤ");
        loginRecord["ユーザ名称"]["value"][0] = sessionStorage.loadItem("ユーザ名称");
        sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      }
      
      $R.log("Model on訂正OfCheckRequestData : end");
      return true;
    }

    // -------------------------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------------------------
   ,on初期処理OfEditResponseData: function(responseData) {
      $R.log("Model on初期処理OfEditResponseData : start");

      var dataSet = this.dataset.getData();
      this.setJsonRecordsToDataset(responseData, dataSet, this.pubsub);

      $R.log("Model on初期処理OfEditResponseData : end");
      return dataSet;
    }

  });

}(jQuery, Rmenu));