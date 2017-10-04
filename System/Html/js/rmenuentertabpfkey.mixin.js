(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  /**
   * Fキー・Tab・Enterの設定
   * 参考URL：http://d.hatena.ne.jp/Hidepyon/
   */
  App.EnterTabPFKeyMixin = {
    setEnterTabPFKey: function(enterTabPFKey) {
      $R.log("EnterTabPFKeyMixin setEnterTabPFKey : start");

      var self = this;
      jQuery.fn.jqKey = function(options){
        window.onhelp=function(){return false;}

        //defaultsにFormsを追加 (20110916 shimoji)
        var defaults = {
          "Enter":false                                     // Enterで次項目へ移動する時は true を設定する
          ,"Tab":false                                      // Tabで次項目へ移動する時は true を設定する
          ,"F1":null
          ,"F2":null
          ,"F3":null
          ,"F4":null
          ,"F5":null
          ,"F6":null
          ,"F7":null
          ,"F8":null
          ,"F9":null
          ,"F10":null
          ,"F11":null
          ,"F12":null
          ,"ESC":null
          ,"Forms":0
        };

        var setting = $.extend(defaults,options);
        var method = function(e){
          var Focus_Move = function(df,shift){
            //フォームオブジェクトが何番目か探す
            var ln = df.length;
            var i;
            for (i=0;i<ln;i++){
              if (df[i]==obj) break;
            }
            //フォーカスを取得できないものは飛ばします
            var mv = (shift?-1:1);                              // shiftキー押下の時、-1 そうで無い時、 1 を返す
            var j = (ln+i+mv) % ln;                             // 次にフォーカスを設定するオブジェクトの番号
            var Fo,Fs;
            while(true){
              Fo = df[j];
              Fs = Fo.style;
              if (Fo.type!="hidden" &&
                Fo.style.visibility!="hidden" &&
                !Fo.disabled &&
                Fo.tabIndex!=-1 &&
                Fs.visibility!="hidden" &&
                Fs.display!="none"){
                //対象のオブジェクトを戻す
                return Fo;
              }
              j=(j+mv+ln) % ln;
            }
            //Hitしない場合
            return df[i];
          }  // Focus_Move 終わり

          //var df = document.forms[0];                         //フォームオブジェクトの取得
          var df = document.forms[setting.Forms];               //20110916 shimoji 訂正
          var k = e.keyCode;
          var s = e.shiftKey;
          var c = e.ctrlKey;
          var a = e.altKey;
          var obj = e.target;                                   // イベント発生時のオブジェクト 
          var blKey = true;
          if (!setting.Enter&&k==13) return true;
          if (!setting.Tab&&k==9) return true;
          switch(k){
            case 13:                                            // ENTER
              switch(obj.type){
              case"button":
                blKey = false;
                break;
              case"file":case"textarea":
                blKey = true;
                break;
//            case"radio":case"checkbox":
//              setTimeout(function(){obj.click();},1)
//              blKey = true;
//              break;
//              case"text":case"select-one":case"select-multiple":
              case"text":
                blKey = false;
                break;
              case"checkbox":                                   // 20120412 追加
                blKey = false;
                break;
              case"radio":                                      // 20120412 追加
                blKey = false;
                break;
              case"select":                                     // 20120412 追加
                blKey = false;
                break;
              default:
                blKey = false;
                break;
              }
              //keyイベントを処理するもののみ抽出
              if (!blKey){
                //次のフォームオブジェクト探す
                obj = Focus_Move(df,s);
              }
              break;
            case 9:                                             // TAB
              switch(obj.type){
              case"file":
                blKey = true;
                break;
              default:
                //次のフォームオブジェクト探す
                obj = Focus_Move(df,s);
                blKey = false;
                break;
              }
              break;
            case 8:                                             // backspace
              switch(obj.type){
              case"text":case"textarea":case"password":
                blKey = true;
                break;
              default:
                if(confirm("backspaceが押されました。\n前ページへ移動しますか？")){
                  blKey = true;
                }else{
                  blKey = false;
                }
                break;
              }
              break;
            case 27:                                            // ESC
              if(setting.ESC){
                eval("self." + setting.ESC + "(e)");             // 20121227 shimoji
                blKey = false;
              }
              break;
            default:
              if(k>=112&&k<=123){                               // F1～F12
                var F = setting["F"+(k-111)];
                //if(F)F(obj,s,c,a);                            // 20110524 shimoji
                if(F) {
                  eval("self." + F + "(e)");                    // 20121227 shimoji
                }
                blKey = false;
              }
              break;
          }  // switch(k) 終わり

          if(!blKey){
            //イベントを伝播しない
            //IEの場合は、KeyCodeに0をセットで、
            //F3検索・F5更新・F11最大化等をキャンセルします。
            if(document.all) window.event.keyCode = 0;
            obj.focus();
            if(obj.select&&obj.type!="button") obj.select();
          }
          return blKey;
        };  // method 終わり

        this.each(function() {
          jQuery(this).keydown(function(e){
            var ret = method(e);
            return ret;
          });
        });
      }

      if (arguments.length == 0) {
        enterTabPFKey = self.appspec.enterTabPFKey;
      }
      jQuery(document).jqKey(enterTabPFKey);

      $R.log("EnterTabPFKeyMixin setEnterTabPFKey : end");
    }
   ,unbindEnterTabPFKey: function() {
      $R.log("EnterTabPFKeyMixin unbindEnterTabPFKey : start");

      jQuery.fn.unbindjqKey = function(){
        this.each(function() {
          jQuery(this).unbind("keydown");
        });
      }

      jQuery(document).unbindjqKey();

      $R.log("EnterTabPFKeyMixin unbindEnterTabPFKey : end");
    }
  };
}(jQuery, Rmenu));
