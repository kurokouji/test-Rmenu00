<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.R_MainteContractHD1;
  var appspec = new app.AppSpec("R_MainteContractHD1");
  appspec.initialSetting(app);
});
