<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.R_MainteServiceList;
  var appspec = new app.AppSpec("R_MainteServiceList");
  appspec.initialSetting(app);
});
