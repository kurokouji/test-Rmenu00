/* ************************************************************************* */
/*  魚耕システム                                                             */
/*  モデル　ミックスイン                                                     */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.FlowerShopModelMixin = {
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

  };
}(jQuery, Rmenu));
