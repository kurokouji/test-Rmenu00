<!-- ------------------------------------------------------------- -->
<!--             ドキュメントロード時の初期処理                    -->
<!-- ------------------------------------------------------------- -->
$(document).ready(function(){
  Rmenu.log("document ready GO !!!!!!!!!!!!!!");
  var app     = Rmenu.Application.ParallelDivisionList;
  var appspec = new app.AppSpec("ParallelDivisionList");
  appspec.initialSetting(app);
});
