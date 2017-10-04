<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.R_CustomersSelection;
  var appspec = new app.AppSpec("R_CustomersSelection");
  appspec.initialSetting(app);
});
