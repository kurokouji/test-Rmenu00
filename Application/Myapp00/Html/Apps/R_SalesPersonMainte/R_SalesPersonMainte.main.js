<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.R_SalesPersonMainte;
  var appspec = new app.AppSpec("R_SalesPersonMainte");
  appspec.initialSetting(app);
});
