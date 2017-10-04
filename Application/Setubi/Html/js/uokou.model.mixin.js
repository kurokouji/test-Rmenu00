/* ************************************************************************* */
/*  魚耕システム                                                             */
/*  モデル　ミックスイン                                                     */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.Uoko01ModelMixin = {
    // -------------------------------------------------------------------
    //  システム日付を取得する
    // -------------------------------------------------------------------
    getシステム日付: function() {
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
    //  日付に日数を加算
    // -------------------------------------------------------------------
   ,add日数ＴＯ日付: function(date, days) {
      $R.log("Model add日数ＴＯ日付 : start");
			
      var date  = new Date(date);
			date.setDate(date.getDate() + Number(days));
			
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

      $R.log("Model add日数ＴＯ日付 : end");
			return today;
    }
    // -------------------------------------------------------------------
    //  システム日付を取得する
    // -------------------------------------------------------------------
   ,get曜日: function(date) {
      $R.log("Model get曜日 : start");

      var today   = new Date(date) ;
      var weekday = ["日", "月", "火", "水", "木", "金", "土"] ;
      var	wday    = "（" + weekday[today.getDay()] + "）" ;

      $R.log("Model get曜日 : end");
			return wday;
    }
		
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
   ,on前日: function() {
      $R.log("Model on前日 : start");

			var date  = this.dataset.getElementData("ヘッダー日付");
			var wdate = this.add日数ＴＯ日付(date, -1);
      var wday  = this.get曜日(wdate);
      this.dataset.setElementData(wdate, "ヘッダー日付");
			
      var arg = {ヘッダー日付: wdate};
      this.pubsub.publish("showヘッダー日付", arg);

      var arg  = {ヘッダー曜日: wday};
      this.pubsub.publish("showヘッダー曜日", arg);
			
      $R.log("Model on前日 : end");
    }
   ,on次日: function() {
      $R.log("Model on次日 : start");

			var date  = this.dataset.getElementData("ヘッダー日付");
			var wdate = this.add日数ＴＯ日付(date, 1);
      var wday  = this.get曜日(wdate);
      this.dataset.setElementData(wdate, "ヘッダー日付");
			
      var arg = {ヘッダー日付: wdate};
      this.pubsub.publish("showヘッダー日付", arg);

      var arg  = {ヘッダー曜日: wday};
      this.pubsub.publish("showヘッダー曜日", arg);
			
      $R.log("Model on次日 : end");
    }
   ,on今日: function() {
      $R.log("Model on今日 : start");

			var today = this.getシステム日付();
      var wday  = this.get曜日(today);
      this.dataset.setElementData(today, "ヘッダー日付");
			
      var arg = {ヘッダー日付: today};
      this.pubsub.publish("showヘッダー日付", arg);

      var arg  = {ヘッダー曜日: wday};
      this.pubsub.publish("showヘッダー曜日", arg);

      $R.log("Model on今日 : end");
    }
    // -------------------------------------
    // チェンジ イベント処理
    // -------------------------------------
   ,onChangeヘッダー日付: function() {
      $R.log("Model onChangeヘッダー日付 : start");

      var createDate   = $("#ヘッダー日付").val();
      this.dataset.setElementData(createDate, "ヘッダー日付");
			
      var wday = this.get曜日(createDate);
      var arg  = {ヘッダー曜日: wday};
      this.pubsub.publish("showヘッダー曜日", arg);

      $R.log("Model onChangeヘッダー日付 : end");
    }

    // -------------------------------------
    // ヘッダー日付　設定処理
    // -------------------------------------
   ,setヘッダー日付: function(date) {
      $R.log("Model setヘッダー日付 : start");

      $("#ヘッダー日付").val(date);
      this.dataset.setElementData(date, "ヘッダー日付");
			
      var wday = this.get曜日(date);
      var arg  = {ヘッダー曜日: wday};
      this.pubsub.publish("showヘッダー曜日", arg);

      $R.log("Model setヘッダー日付 : end");
    }

  };
}(jQuery, Rmenu));
