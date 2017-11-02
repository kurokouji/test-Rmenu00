(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.ParallelDivisionList;

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
    // -----------------------------------
    //  リクエストデータ　チェック処理
    // -----------------------------------
    on再処理OfCheckRequestData: function(requestData, mode) {
      $R.log("Model on再処理OfCheckRequestData : start");

      var dataSet       = this.dataset.getData();
      var detailRecord  = this.appspec.getJSONChunkByIdAtRecords(dataSet, "detail")["record"];
      var requestRecord = this.appspec.getJSONChunkByIdAtRecords(requestData, "header")["record"];

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var row = sessionStorage.loadItem("クリック行");
      requestRecord["再処理並列分散管理ＩＤ"]["value"][0] = detailRecord["並列分散管理ＩＤ"]["value"][row];
      requestRecord["再処理並列分割管理ＩＤ"]["value"][0] = detailRecord["並列分割管理ＩＤ"]["value"][row];

      $R.log("Model on再処理OfCheckRequestData : end");
      return true;
    }
    
  });
}(jQuery, Rmenu));