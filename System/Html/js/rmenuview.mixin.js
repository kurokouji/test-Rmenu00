(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // データフォーマット関数
  App.FormatMixin = {
    formatExecute: {
      yyyySmmSdd: {
        format: function(value) {
          if (value == "") return value;
          var yyyy = value.substring(0, 4);
          var mm   = value.substring(4, 6);
          var dd   = value.substring(6, 8);
          return yyyy + "/" + mm + "/" + dd;
        }
       ,unformat: function(value) {
          if (value == "") return value;
          return new String(value).replace( /\//g, "" );
        }
      }
     ,yyyyNmmTddH: {
        format: function(value) {
          if (value == "") return value;
          var yyyy      = value.substring(0, 4);
          var mm        = value.substring(4, 6);
          var dd        = value.substring(6, 8);
          return yyyy + "年" + mm + "月" + dd + "日";
        }
       ,unformat: function(value) {
          if (value == "") return value;
          var yyyy = value.substring(0, 4);
          var mm   = value.substring(5, 7);
          var dd   = value.substring(8, 10);
          return yyyy + mm + dd;
        }
      }
     ,quantity: {
        format: function(value) {
          if (value == "") return value;
          var formatvalue = String(value);
          return formatvalue.replace(/(\d)(?=(\d\d\d)+$)/g, "$1,");
        //for(i = 0; i < formatvalue.length/3; i++){
        //  return formatvalue.replace(/^([+-]?\d+)(\d\d\d)/,"$1,$2");
        //}
        }
       ,unformat: function(value) {
          if (value == "") return value;
          return new String(value).replace( /,/g, "" );
        }
      }
     ,price: {
        format: function(value) {
          if (value == "") return value;
          var formatvalue = String(value);
          return formatvalue.replace(/(\d)(?=(\d\d\d)+$)/g, "$1,");
        //for(i = 0; i < formatvalue.length/3; i++){
        //  return formatvalue.replace(/^([+-]?\d+)(\d\d\d)/,"$1,$2");
        //}
        }
       ,unformat: function(value) {
          if (value == "") return value;
          return new String(value).replace( /,/g, "" );
        }
      }
     ,money: {
        format: function(value) {
          if (value == "") return value;
          var formatvalue = String(value);
          return formatvalue.replace(/(\d)(?=(\d\d\d)+$)/g, "$1,");
        //for(i = 0; i < formatvalue.length/3; i++){
        //  return formatvalue.replace(/^([+-]?\d+)(\d\d\d)/,"$1,$2");
        //}
        }
       ,unformat: function(value) {
          if (value == "") return value;
          return new String(value).replace( /,/g, "" );
        }
      }
    }
    // 値をフォーマットする
   ,onDataFormat: function(arg) {
      $R.log("FormatMixin dataFormat : start");

      var value = arg["value"];
      var rule  = arg["rule"];
      if (rule in this.formatExecute) {
        value = this.formatExecute[rule].format(value);
      }

      $R.log("FormatMixin dataFormat : end");
      return value;
    }
    // フォーマットを元の値に戻す
   ,onDataUnformat: function(arg) {
      $R.log("FormatMixin dataUnformat : start");

      var value = arg["value"];
      var rule  = arg["rule"];
      if (rule in this.formatExecute) {
        value = this.formatExecute[rule].unformat(value);
      }

      $R.log("FormatMixin dataUnformat : end");
      return value;
    }
  };
  // アウトライン関数
  App.OutlineMixin = {
    // アウトラインのイベント設定
    outlineEvent: [
      ["#headerTable td input", "mouseover", "span_mouseover"]
     ,["#headerTable td input", "mouseout",  "span_mouseout"]
     //,["#headerTable td input", "focus",     "span_focus"]
     //,["#headerTable td input", "blur",      "span_blur"]
     ,["#detailTable td input", "mouseover", "td_mouseover"]
     ,["#detailTable td input", "mouseout",  "td_mouseout"]
     //,["#detailTable td input", "focus",     "td_focus"]
     //,["#detailTable td input", "blur",      "td_blur"]
    ]
    // アウトラインプロパティを設定する
   ,setOutlineProperty: function() {
      this.focusName;
      this.focusCurRow    = 0;
      this.focusCurCell   = 0;
      this.focusIndex     = 0;
      this.blurName;
      this.blurCurRow     = 0;
      this.blurCurCell    = 0;
      this.blurIndex      = 0;
      this.rmenuspanhover = "rmenuspanhover";
      this.rmenuspanfocus = "rmenuspanfocus";
      this.rmenutdhover   = "rmenutdhover";
      this.rmenutdfocus   = "rmenutdfocus";
    }
    // アウトラインイベントを設定し、コールバック関数を指定する
   ,setOutlineEvent: function(outlineEvent) {
      $R.log("OutlineMixin setOutlineEvent : start");

      this.setOutlineProperty();
      var event = this.event["outline"] = new $R.Event;               // イベントクラスを作成する
      if (arguments.length == 0) {
        outlineEvent = this.outlineEvent;
      }
      event.setEvent(this, outlineEvent);                             // アウトラインイベントを設定する

      $R.log("OutlineMixin setOutlineEvent : end");
    }


    // ヘッダコントロールにカーソルが乗った時、クラス名を付ける
   ,span_mouseover: function(event) {
      $(event.target).parent("span").addClass(this.rmenuspanhover);
    }

    // ヘッダコントロールからカーソルが離れた時、クラス名を削除する
   ,span_mouseout: function(event) {
      $(event.target).parent("span").removeClass(this.rmenuspanhover);
    }

    // 明細コントロールにカーソルが乗った時、クラス名を付ける
   ,td_mouseover: function(event) {
      $(event.target).parent("td").addClass(this.rmenutdhover);
    }

    // 明細コントロールからカーソルが離れた時、クラス名を削除する
   ,td_mouseout: function(event) {
      $(event.target).parent("td").removeClass(this.rmenutdhover);
    }

    // 明細ラジオボタンのchangeイベント処理
   ,td_radiochange: function(event) {
      var target = event.target;
      if (target.checked){
        this.focusName    = target.name;
        this.focusCurRow  = target.parentNode.parentNode.rowIndex - 1;
        this.focusCurCell = target.parentNode.cellIndex;
      }
    }
  };

  // 関数を追加する
  App.ViewMixin = {
    onFocus: function(event, value) {
      $R.log("ViewMixin onFocus : start");

      var target = event.target;
      if (target.type != "button") {
        target.value = value;
      }

      $R.log("ViewMixin onFocus : end");
    }
   ,onBlur: function(event) {
      $R.log("ViewMixin onBlur : start");

      // 入力データをフォーマットし再表示する
      var target = event.target;
      var value  = target.value;
      var rule   = this.format[target.name];
      var arg    = {value: value, rule: rule};
      if (target.type != "button") {
        value    = this.onDataFormat(arg);
        target.value = value;
      }

      $R.log("ViewMixin onBlur : end");
    }
    // ガイドメッセージを表示する arg = {status: ステータス, message: メッセージ}
   ,onGuideMessage: function(arg) {
      $R.log("ViewMixin onGuideMessage : start");

      if (this.guidemessage) {
        $("#footer_status").html(arg["status"]);
        $("#footer_message").html(arg["message"]);
      }

      $R.log("ViewMixin onGuideMessage : end");
    }
    // エラーツールチップを表示する
    // arg = {target: イベントターゲット, message: エラーメッセージ, multiline: yes or no}
   ,onErrorToolTip: function(arg) {
      $R.log("ViewMixin onErrorToolTip : start");

      var toolTip = function(target, errorText, multiline) {
        var idname  = "#error" + target.name
        var pos     = $(target).offset();
        var posTop  = pos.top - 10;
        var posLeft = pos.left + $(target).width() + 3;

        if (multiline == "yes") {
          posTop = pos.top + $(target).height() + 2;
          posLeft = pos.left;
        }

        var errorToolTip = $('<div id=\"error' + target.name + '\" class=\"errorToolTip\"></div>');
        $('body').append(errorToolTip);
        $(idname)
          .stop(true,true)
          .fadeIn('fast')
          .text(errorText)
          .css({
             position: 'absolute',
             top: posTop,
             left: posLeft
           })
      }

      var length    = arg["message"].length;
      var errorText = "";
      for (var i = 0; i < length; i++) {
        errorText += arg["message"][i];
      }
      toolTip(arg["target"], errorText, arg["multiline"]);

      $R.log("ViewMixin onErrorToolTip : end");
    }
    // エラーツールチップを削除する arg = {target: イベントターゲット}
   ,onRemoveToolTip: function(arg) {
      $R.log("ViewMixin onRemoveToolTip : start");

      var idname = "#error" + arg["target"].name;
      if(!$(idname)) return;
      $(idname).hide();
      $(idname).remove();

      $R.log("ViewMixin onRemoveToolTip : end");
    }
    // 警告ダイアログ 初期設定
   ,initAlertDialog: function() {
      $R.log("ViewMixin initAlertDialog : start");

      var alertDialog = $('<div id="alertDialog" title=""><p></p></div>');
      $("body").append(alertDialog);

      var d = $("#alertDialog");
      d.dialog({
        autoOpen: false,
        title: "警告",
        modal: true,
        width: 340,
        buttons:{
            "ＯＫ": function(){
            $(this).dialog("close");
          }
        }
      });

      $R.log("ViewMixin initAlertDialog : end");
    }
    // 警告ダイアログを表示する
   ,onAlertDialog: function(arg) {
      $R.log("ViewMixin onAlertDialog : start");

      $("#alertDialog p").text(arg["message"]);
      $("#alertDialog").dialog({title: arg["title"]});
      $("#alertDialog").dialog("open");

      $R.log("ViewMixin onAlertDialog : end");
    }
    // 確認ダイアログ 初期設定
   ,initConfirmDialog: function(object) {
      $R.log("ViewMixin initConfirmDialog : start");

      var self          = object;
      var confirmDialog = $('<div id="confirmDialog" title=""><p></p></div>');
      $("body").append(confirmDialog);

      var d = $("#confirmDialog");
      d.dialog({
        autoOpen: false,
        title: "確認",
        modal: true,
        width: 340,
        buttons:{
         "はい": function(){
           var arg    = {status: true};
           var status = self.pubsub.publish("confirmDialogAfter", arg);
           $(this).dialog("close");
         },
         "いいえ":function(){
           var arg    = {status: false};
           var status = self.pubsub.publish("confirmDialogAfter", arg);
           $(this).dialog("close");
         }
       }
      });

      $R.log("ViewMixin initConfirmDialog : end");
    }
    // 確認ダイアログを表示する
   ,onConfirmDialog: function(arg) {
      $R.log("ViewMixin onConfirmDialog : start");

      $("#confirmDialog p").text(arg["message"]);
      $("#confirmDialog").dialog({title: arg["title"]});
      $("#confirmDialog").dialog("open");

      $R.log("ViewMixin onConfirmDialog : end");
    }
    // 実行確認ダイアログ 初期設定
   ,initExecuteDialog: function(object) {
      $R.log("ViewMixin initExecuteDialog : start");

      var self          = object;
      var executeDialog = $('<div id="executeDialog" title=""><p></p></div>');
      $("body").append(executeDialog);

      var d = $("#executeDialog");
      d.dialog({
        autoOpen: false,
        title: "確認",
        modal: true,
        width: 340,
        buttons:{
         "はい": function(){
           var arg    = {status: true, title: this.title};
           var status = self.pubsub.publish("executeDialogAfter", arg);
           $(this).dialog("close");
         },
         "いいえ":function(){
           var arg    = {status: false, title: this.title};
           var status = self.pubsub.publish("executeDialogAfter", arg);
           $(this).dialog("close");
         }
       }
      });

      $R.log("ViewMixin initExecuteDialog : end");
    }
    // 実行確認ダイアログを表示する
   ,onExecuteDialog: function(arg) {
      $R.log("ViewMixin onExecuteDialog : start");

      $("#executeDialog p").text(arg["message"]);
      $("#executeDialog").dialog({title: arg["title"]});
      $("#executeDialog").dialog("open");

      $R.log("ViewMixin onExecuteDialog : end");
    }
    // サーバ確認ダイアログ 初期設定
   ,initServerDialog: function(object) {
      $R.log("ViewMixin initServerDialog : start");

      var self         = object;
      var serverDialog = $('<div id="serverDialog" title=""><p></p></div>');
      $("body").append(serverDialog);

      var d = $("#serverDialog");
      d.dialog({
        autoOpen: false,
        title: "サーバ確認",
        modal: true,
        width: 340,
        buttons:{
            "ＯＫ": function(){
            var arg    = {status: false, title: this.title};
            var status = self.pubsub.publish("serverDialogAfter", arg);
            $(this).dialog("close");
          }
        }
      });

      $R.log("ViewMixin initServerDialog : end");
    }
    // サーバ確認ダイアログを表示する
   ,onServerDialog: function(arg) {
      $R.log("ViewMixin onServerDialog : start");

      $("#serverDialog p").text(arg["message"]);
      $("#serverDialog").dialog({title: arg["title"]});
      $("#serverDialog").dialog("open");

      $R.log("ViewMixin onServerDialog : end");
    }
    // テーブルの明細行を作成する
   ,createTableRows: function(tableid, defaultline) {
      $R.log("ViewMixin createTableRows : start");

      var i;
      defaultline = defaultline - 1;
      for (i = 0; i < defaultline; i++) {
        $(tableid  + " tbody tr").eq(0).clone(true).insertAfter($(tableid  + " tbody tr").eq(i));
      }

      $R.log("ViewMixin createTableRows : end");
    }
  };
}(jQuery, Rmenu));
