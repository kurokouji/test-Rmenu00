(function($, $R){
  // 名前空間を設定する
  var App = $R.Application.AccessLog;

  // インスタンスプロパティを追加する
  var Controller = App.Controller = new $R.Class($R.Controller);
  Controller.fn.init = function(appspec, model, view) {
    $R.log("Controllerr init : start");

    this.appspec = appspec;
    this.model   = model;
    this.view    = view;
    this.createPubSubEvent();

    // 横スクロール　ヘッダー・明細　同期処理
    $("#scrollable-DTable").scroll(function () {
      var dTable = $("#scrollable-DTable");
      
      var hTable = $("#scrollable-HTable");
      hTable.scrollLeft(dTable.scrollLeft());
      
    });

    var self = this;
    var api1 = $('#datetimepicker').datetimepicker({
        format : 'yyyy/MM/dd',
        language : 'ja',
        pickTime : false
    }).data('datetimepicker');
    api1.widget.on('click','td.day',function(){
        api1.hide();
        self.onChangeアクセス日付();
    });

    $R.log("Controllerr init : end");
  };

  // 共通モジュールを追加する
  Controller.include($R.Library.EnterTabPFKeyMixin);
  Controller.include($R.Library.ControllerMixin);

  // マスター一覧パターン　ミックスインを追加する
  Controller.include($R.Library.DataMainteListControllerMixin);

  // --------------------------------------------------------
  // パターンに含まれない処理を追加する　　　　　　　　　　　
  // また、パターン内の処理を変更するときは、オーバライドする
  // --------------------------------------------------------
  Controller.include({
    // ---------------------------------------
    // 初期処理
    // ---------------------------------------
    on初期処理: function() {
      $R.log("Controller on初期処理 : start");

      var arg = this.model.on初期処理();
      this.view.on初期処理(arg);

      var status = this.model.on選択画面戻り();
      
      // 選択画面処理終り
      if (arg["status"] == "OK") {
        // 選択画面で選択データ無し
        if (arg["selected"] == "CANCEL") {
          var dataSet = this.model.dataset.getData();
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        // 選択画面で選択データ有りで後処理無し
        if (arg["selected"] == "NONFUNCTIN") {
          var dataSet = this.model.dataset.getData();
          this.view.on照会OfEditResponseData(dataSet, dataSet, "");
        }
        
        $R.log("Controller on初期処理 : end");
        return;
      }

      // セッションデータに識別名を設定する
      sessionStorage.setIdName(this.appspec.sysname + "." + this.appspec.name);
      var currentpage = sessionStorage.loadItem("カレントページ");
      
      if (currentpage === undefined) {
        // メニュー画面または別一覧画面から呼び出された時
        // 別の一覧画面からの引き継ぎデータをデータセットに設定する
        this.model.setFromBeforeStorageDataToDataset();
        
        // この部分を修正
        //this.on最初のページ();
        this.ajaxExecute("init");
      }
      else {
        // 次画面から戻って来た時
        var dataSet = this.model.on初期リロード前処理();
        this.view.on初期リロード前処理(dataSet);
        this.onリロード();
      }

      $R.log("Controller on初期処理 : end");
    }

    // -------------------------------------
    // ボタン イベント処理
    // -------------------------------------
   ,on照会: function(event) {
      $R.log("Controller on照会 : start");

      this.on最初のページ();
      
      $R.log("Controller on照会 : end");
    }
   ,on削除: function(event) {
      $R.log("Controller on削除 : start");

      this.ajaxExecute("delete");
      
      $R.log("Controller on削除 : end");
    }
    // -------------------------------------
    // チェンジ イベント処理（追加処理）
    // -------------------------------------
   ,onChangeアクセス日付: function(event) {
      $R.log("Controller onChangeアクセス日付 : start");

      this.model.onChangeアクセス日付();
      
      $R.log("Controller onChangeアクセス日付 : end");
    }
    
   ,onChangeログインユーザ選択: function(event) {
      $R.log("Controller onChangeログインユーザ選択 : start");

      var employee = this.model.onChangeSelectBox(event, this.appspec.selectbox);

      $R.log("Controller onChangeログインユーザ選択 : end");
    }

    // -------------------------------------
    //  リクエストデータ　編集・チェック処理
    // -------------------------------------
   ,on初期処理OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on初期処理OfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller on初期処理OfCheckRequestData : end");
      return status;
    }

   ,on削除OfCheckRequestData: function(requestData, mode) {
      $R.log("Controller on削除OfCheckRequestData : start");

      var status = this.checkRequestData(requestData);

      $R.log("Controller on削除OfCheckRequestData : end");
      return status;
    }

    // -------------------------------------
    //  レスポンスデータ　編集処理
    // -------------------------------------
   ,on初期処理OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on初期処理OfEditResponseData : start");

      // セレクトボックスの一括初期表示
      this.onShowSelectBoxAll(responseData, this.appspec.selectbox);
      
      this.on最初のページ();

      $R.log("Controller on初期処理OfEditResponseData : end");
    }

   ,on削除OfEditResponseData: function(responseData, mode) {
      $R.log("Controller on削除OfEditResponseData : start");

      this.on照会OfEditResponseData(responseData, mode);
      
      $R.log("Controller on削除OfEditResponseData : end");
    }

    
  });

}(jQuery, Rmenu));