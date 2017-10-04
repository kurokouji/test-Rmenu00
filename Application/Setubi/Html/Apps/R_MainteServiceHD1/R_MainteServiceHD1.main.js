<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.R_MainteServiceHD1;
  var appspec = new app.AppSpec("R_MainteServiceHD1");
  appspec.initialSetting(app);
});
