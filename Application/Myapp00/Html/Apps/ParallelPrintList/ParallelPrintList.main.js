<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.ParallelPrintList;
  var appspec = new app.AppSpec("ParallelPrintList");
  appspec.initialSetting(app);
});
