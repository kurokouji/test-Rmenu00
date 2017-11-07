<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.R_SalesPersonList;
  var appspec = new app.AppSpec("R_SalesPersonList");
  appspec.initialSetting(app);
});
