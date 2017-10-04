(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.AccessLog;

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
    // -------------------------------------------------------------------
    //  初期処理
    // -------------------------------------------------------------------
    on初期処理: function() {
      $R.log("Model on初期処理 : start");
      
      // アクセス日付と曜日を設定する
      var today = this.getシステム日付();
      var wday  = this.get曜日(today);
      this.dataset.setElementData(today, "アクセス日付");
      
      var arg = {アクセス日付: today};
      this.pubsub.publish("showアクセス日付", arg);

      var arg  = {アクセス曜日: wday};
      this.pubsub.publish("showアクセス曜日", arg);
      
      
      var arg     = {};
      var dataSet = this.dataset.getData();
      arg["データセット"] = dataSet;

      $R.log("Model on初期処理 : end");
      return arg;
    }
    
    // -------------------------------------
    // チェンジ イベント処理
    // -------------------------------------
   ,onChangeアクセス日付: function() {
      $R.log("Model onChangeアクセス日付 : start");

      var createDate   = $("#アクセス日付").val();
      this.dataset.setElementData(createDate, "アクセス日付");
      
      var wday = this.get曜日(createDate);
      var arg  = {アクセス曜日: wday};
      this.pubsub.publish("showアクセス曜日", arg);

      $R.log("Model onChangeアクセス日付 : end");
    }

    // -------------------------------------------------------------------
    //  システム日付を取得する
    // -------------------------------------------------------------------
   ,getシステム日付: function() {
      $R.log("Model getシステム日付 : start");

      var date  = new Date();
      var year  = date.getFullYear();
      var month = date.getMonth() + 1;
      var day   = date.getDate();
      
      if (month < 10) {
        month = "0" + month;
      }
      
      if (day < 10) {
        day = "0" + day;
      }
      
      var today = year + "/" +month + "/" + day;

      $R.log("Model getシステム日付 : end");
      return today;
    }
    // -------------------------------------------------------------------
    //  曜日を取得する
    // -------------------------------------------------------------------
   ,get曜日: function(date) {
      $R.log("Model get曜日 : start");

      var today   = new Date(date) ;
      var weekday = ["日", "月", "火", "水", "木", "金", "土"] ;
      var wday    = "（" + weekday[today.getDay()] + "）" ;

      $R.log("Model get曜日 : end");
      return wday;
    }

  });

}(jQuery, Rmenu));