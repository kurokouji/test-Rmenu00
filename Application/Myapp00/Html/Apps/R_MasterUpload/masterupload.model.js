(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.R_MasterUpload;

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

  Model.include({
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
    // -------------------------------------------------------------------
    //  セッションストレージからログイン情報を取得し表示イベントを発行する
    // -------------------------------------------------------------------
   ,getログイン情報: function() {
      $R.log("Model getログイン情報 : start");

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + ".Login");

      var username = sessionStorage.loadItem("ユーザ名称");
      var datetime = sessionStorage.loadItem("ログイン時刻");
      var jdate    = "";
      if ( sessionStorage.isKeyExists("ログイン和暦") ) {
        jdate      = sessionStorage.loadItem("ログイン和暦");
      }
      var arg      = {ユーザ名称: username, ログイン時刻: datetime, ログイン和暦: jdate};
      this.pubsub.publish("showログイン情報", arg);

      $R.log("Model getログイン情報 : end");
    }
    // -------------------------------------------------------------------
    //  セッションストレージからログイン情報を取得し表示イベントを発行する
    // -------------------------------------------------------------------
   ,clearページ情報: function() {
      $R.log("Model clearページ情報 : start");


      $R.log("Model clearページ情報 : end");
    }
    // -------------------------------------------------------
    //  得意先　アップロード処理
    // -------------------------------------------------------
   ,on得意先登録: function(self) {
      $R.log("Model on得意先登録 : start");

      var dataString  = "Myapp00/UpLoad/Apps/R_MasterUpload";  // サーバ格納先ディレクトリ名
      dataString     += "#";
      dataString     += "customers.csv";                   // サーバ格納ファイル名
      dataString     += "#";
      dataString     += "得意先選択";                      // ファイル選択のＩＤ名
      $("#得意先選択").upload(
         $R.UploadRackURL                                  // 送信先
        ,{data:dataString}                                 // 同時にPOSTするデータ
        ,function (responseData) {
           self.onCVSアップロードコールバック(responseData, "customers");
         }
        ,'json'                                            // 戻り値の種類
      );

      $R.log("Model on得意先登録 : end");
    }
    // -----------------------------------------------------------
    //  リクエストデータ編集
    // -----------------------------------------------------------
   ,onSetRequestData: function(requestData, mode) {
      $R.log("Model onSetRequestData : start");

      var dataString  = "Myapp00/UpLoad/Apps/R_MasterUpload/";  // サーバ格納先ディレクトリ名
      dataString     += mode;                               // ファイル名
      dataString     += ".csv";                             // ファイル拡張子
      requestData["records"][0]["record"]["マスターファイル名称"]["value"][0] = dataString;

      $R.log("Model onSetRequestData : end");
      return true;
    }
    // -------------------------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------------------------
   ,onEditResponseData: function(responseData, mode) {
      $R.log("ModelonEditResponseData : start");

      var status = responseData["message"]["status"];
      var msg    = responseData["message"]["msg"];
      var arg    = {title: "サーバ処理確認", status: status, message: msg};
      this.pubsub.publish("serverDialog", arg);

      $R.log("Model onEditResponseData : end");
    }
  });
}(jQuery, Rmenu));