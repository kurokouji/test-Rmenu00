/* ************************************************************************* */
/*  マウスの移動でテーブル要素の色を変える                                   */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */
// 仕様方法
// テーブル行の色を変える
			//this.setTRColor("#mainTableH");
			//var self = this;
      //$("#mainTableH tr").click(function(){
      //  self.setTRColor("#mainTableH");
      //  self.clickTRColor($(this));
      //});			
// セルの色を変える
			//this.setTDColor("#mainTableH");
			//var self = this;
      //$("#mainTableH td").click(function(){
      //  self.setTDColor("#mainTableH");
      //  self.clickTDColor($(this));
      //});			
// ヘッダーのTHの色を変える
			//this.setTHColor("#mainTableH");
			//var self = this;
      //$("#mainTableH th").click(function(){
      //  self.setTHColor("#mainTableH");
      //  self.clickTHColor($(this));
      //});			
      //$("#mainTableH td").click(function(){
      //  self.setTHColor("#mainTableH");
      //  self.clickTDTHColor($(this));
      //});			
/* ************************************************************************* */
/*  2014/08/16 tadashi shimoji                                               */
/* ************************************************************************* */

(function($, $R){
  // 名前空間を設定する
  var App = $R.Library;

  // 関数を追加する
  App.TableViewMixin = {
    // ------------------------------
    //  行の初期値を設定する
    // ------------------------------
    setTRColor: function(tableID) {
      $R.log("View setTRColor : start");

      var tableTR = tableID + " tr";
      $(tableTR).css("background-color","#ffffff");
			
      $(tableTR).mouseover(function(){
        $(this).css("background-color","#CCFFCC") .css("cursor","pointer")
      });
			
      $(tableTR).mouseout(function(){
        $(this).css("background-color","#ffffff") .css("cursor","normal")
      });

      $R.log("View setTRColor : end");
    }

    // ------------------------------
    //  カラムの初期値を設定する
    // ------------------------------
   ,setTDColor: function(tableID) {
      $R.log("View setTDColor : start");

      var tableTD = tableID + " td";
      $(tableTD).css("background-color","#ffffff");
			
      $(tableTD).mouseover(function(){
        $(this).css("background-color","#CCFFCC") .css("cursor","pointer")
      });
			
      $(tableTD).mouseout(function(){
        $(this).css("background-color","#ffffff") .css("cursor","normal")
      });

      $R.log("View setTDColor : end");
    }

    // ------------------------------
    //  THカラムの初期値を設定する
    // ------------------------------
   ,setTHColor: function(tableID) {
      $R.log("View setTHColor : start");

			// th
      var tableTD = tableID + " thead th";
      $(tableTD).css("background-color","#ffffff");

      $(tableTD).mouseover(function(){
			  var col     = $(this).closest("tr th").prevAll("tr th").length += 1;
			  if (col > 1 && col < 13) {
			    var tableTH = tableID + " th:nth-child(" + col + ")";
          $(tableTH).css("background-color","#d5ffdf") .css("cursor","pointer")
			  }
      });
			
      $(tableTD).mouseout(function(){
			  var col     = $(this).closest("tr th").prevAll("tr th").length += 1;
        var tableTH = tableID + " th:nth-child(" + col + ")";
        $(tableTH).css("background-color","#ffffff") .css("cursor","normal")
      });

			// td
      var tableTD = tableID + " tbody td";
      $(tableTD).mouseover(function(){
			  var col     = $(this).closest("tr td").prevAll("tr td").length += 1;
			  if (col > 1 && col < 13) {
			    var tableTH = tableID + " th:nth-child(" + col + ")";
          $(tableTH).css("background-color","#d5ffdf") .css("cursor","pointer")
			  }
      });
			
      $(tableTD).mouseout(function(){
			  var col     = $(this).closest("tr td").prevAll("tr td").length += 1;
        var tableTH = tableID + " th:nth-child(" + col + ")";
        $(tableTH).css("background-color","#ffffff") .css("cursor","normal")
      });

      $R.log("View setTHColor : end");
    }

    // ----------------------------------------------------------
    //  テーブル明細の行をクリック（クリックした行の色が変わる）
    // ----------------------------------------------------------
   ,clickTRColor: function(tableObj) {
      $R.log("View clickTRColor : start");

      tableObj.css("background-color","#e49e61");
			
      tableObj.mouseover(function(){
        $(this).css("background-color","#CCFFCC") .css("cursor","pointer")
      });
			
      tableObj
			.mouseout(function(){
        $(this).css("background-color","#e49e61") .css("cursor","normal")
      });

      $R.log("View clickTRColor : end");
    }

    // ----------------------------------------------------------
    //  テーブル明細のTDをクリック（クリックしたせるの色が変わる）
    // ----------------------------------------------------------
   ,clickTDColor: function(tableObj) {
      $R.log("View clickTDColor : start");

      tableObj.css("background-color","#e49e61");
			
      tableObj.mouseover(function(){
        $(this).css("background-color","#CCFFCC") .css("cursor","pointer")
      });
			
      tableObj.mouseout(function(){
        $(this).css("background-color","#e49e61") .css("cursor","normal")
      });

      $R.log("View clickTDColor : end");
    }

    // -------------------------------------------
    //  テーブルヘッダーのTHをクリック
    // -------------------------------------------
   ,clickTHColor: function(tableObj) {
      $R.log("View clickTHColor : start");

			var col = $(tableObj).closest("tr th").prevAll("tr th").length += 1;
			if (col == 1 || col == 13) {
        $R.log("View clickTHColor : end");
				return;
			}


      tableObj.css("background-color","#d5ffdf");
			
      tableObj.mouseover(function(){
        $(this).css("background-color","#d5ffdf") .css("cursor","pointer")
      });
			
      tableObj.mouseout(function(){
        $(this).css("background-color","#d5ffdf") .css("cursor","normal")
      });
			
			
      $R.log("View clickTHColor : end");
    }

    // -------------------------------------------
    //  テーブル明細のTDをクリック
    // -------------------------------------------
   ,clickTDTHColor: function(tableObj) {
      $R.log("View clickTDTHColor : start");

			var col = $(tableObj).closest("tr td").prevAll("tr td").length += 1;
			if (col == 1 || col == 13) {
        $R.log("View clickTDTHColor : end");
				return;
			}

      var tableTH = "#" + tableObj[0].offsetParent.id + " th:nth-child(" + col + ")";
      $(tableTH).css("background-color","#d5ffdf");

			
      tableObj.mouseover(function(){
        $(tableTH).css("background-color","#d5ffdf") .css("cursor","pointer")
      });
			
      tableObj.mouseout(function(){
        $(tableTH).css("background-color","#d5ffdf") .css("cursor","normal")
      });

			// clickTHColor
			$(tableTH).mouseover(function(){
        $(tableTH).css("background-color","#d5ffdf") .css("cursor","pointer")
      });
			
      $(tableTH).mouseout(function(){
        $(tableTH).css("background-color","#d5ffdf") .css("cursor","normal")
      });

      $R.log("View clickTDTHColor : end");
    }

  };
}(jQuery, Rmenu));
