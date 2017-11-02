/* ************************************************************************* */
/*  ログイン　パターン                                                       */
/*  モデル　ミックスイン                                                     */
/*  2014/10/01 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.LoginModelMixin = {
    // --------
    // 処理開始
    // --------
    initExecute: function() {
      $R.log("Model initExecute : start");

      this.dataset.clearDataValue();                   // Datasetの値をクリアする
      this.dataset.clearFormElementNo();               // フォームオブジェクトの要素番号をクリアする
      this.dataset.setFormElementNo();                 // フォームオブジェクトの要素番号を設定する

      $R.log("Model initExecute : end");
    }
    // -------------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------------
   ,onチェックOfEditResponseData: function(responseData) {
      $R.log("Model onチェックOfEditResponseData : start");

      // ユーザ情報をセッションストレージに格納する
      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + ".Login");

      // セッションデータに項目データを設定する
      var responseRecord = this.appspec.getJSONChunkByIdAtRecords(responseData, "header");
      var userid   = responseRecord["record"]["ユーザＩＤ"]["value"][0];
      var username = responseRecord["record"]["ユーザ名称"]["value"][0];
      var menuname = responseRecord["record"]["メニュー名"]["value"][0];
      var date     = new Date();
      var datetime = date.getFullYear()    + "/"
                   + (date.getMonth() + 1) + "/"
                   + date.getDate()        + " "
                   + date.getHours()       + ":"
                   + date.getMinutes();

      sessionStorage.saveItem("ユーザＩＤ", userid);
      sessionStorage.saveItem("ユーザ名称", username);
      sessionStorage.saveItem("メニュー名", menuname);
      sessionStorage.saveItem("ログイン時刻", datetime);

      var weekday = ["日", "月", "火", "水", "木", "金", "土"] ;
      var	wday    = "（" + weekday[date.getDay()] + "）" ;

      // 西暦⇒和暦
      var jdate = "平成" + (date.getFullYear() - 1988) + "年" + (date.getMonth() + 1) + "月" + date.getDate() + "日" + wday;
      sessionStorage.saveItem("ログイン和暦", jdate);
			
      if (responseRecord["record"]["メニュー名"]["value"][0] != "") {
				this.appspec.nextname = responseRecord["record"]["メニュー名"]["value"][0];
			}
			
      $R.log("Model onチェックOfEditResponseData : end");
    }
    // -------------------------------------------
    //  ローカルストレージの情報を取得する
    // -------------------------------------------
   ,getローカルストレージ: function(sysName) {
      $R.log("Model getローカルストレージ : start");
			
			var userJson = localStorage.getItem(sysName);
			var userObj  = {};
			if (userJson) {
			  userObj  = JSON.parse(userJson);
			}

      $R.log("Model getローカルストレージ : end");
			return userObj;
    }

    // -------------------------------------------
    //  ローカルストレージに格納
    // -------------------------------------------
   ,setローカルストレージ: function(sysName, userObj) {
      $R.log("Model setローカルストレージ : start");
			
			var userJson = JSON.stringify(userObj);
			localStorage.setItem(sysName, userJson);
			
      $R.log("Model setローカルストレージ : end");
    }

    // -------------------------------------------
    //  ユーザ情報をデータセットに設定する
    // -------------------------------------------
   ,setユーザ情報: function(userObj) {
      $R.log("Model setユーザ情報 : start");
			
      this.dataset.setElementData("", "ログインＩＤ");
      this.dataset.setElementData("", "パスワード");

			if (userObj["ログインＩＤ"]) {
        this.dataset.setElementData(userObj["ログインＩＤ"], "ログインＩＤ");
			}
			if (userObj["パスワード"]) {
        this.dataset.setElementData(userObj["パスワード"], "パスワード");
			}
			
      $R.log("Model setユーザ情報 : end");
    }

  };
}(jQuery, Rmenu));
