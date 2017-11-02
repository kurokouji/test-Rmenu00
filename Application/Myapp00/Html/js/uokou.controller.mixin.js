/* ************************************************************************* */
/*  魚耕システム                                                             */
/*  モデル　ミックスイン                                                     */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.Uoko01ControllerMixin = {
    // ---------------------------------------
    // ボタン・ファンクションキー イベント処理
    // ---------------------------------------
    on前日: function(event) {
      $R.log("Controller on前日 : start");

      this.model.on前日();
			
      $R.log("Controller on前日 : end");
    }
   ,on次日: function(event) {
      $R.log("Controller on次日 : start");

      this.model.on次日();
			
      $R.log("Controller on次日 : end");
    }
   ,on今日: function(event) {
      $R.log("Controller on今日 : start");

      this.model.on今日();
			
      $R.log("Controller on今日 : end");
    }
    // -------------------------------------
    // チェンジ イベント処理（追加処理） datetimepicker用
    // -------------------------------------
   ,onChangeヘッダー日付: function() {
      $R.log("Controller onChange発注日 : start");

      this.model.onChangeヘッダー日付();

      $R.log("Controller onChange発注日 : end");
    }

  };
}(jQuery, Rmenu));
