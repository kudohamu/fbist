var appName = "FVistFoundation";
//var fvistFoundationApp = angular.module(appName);
var fvistFoundationApp = angular.module(appName, ["ngResource"]);

fvistFoundationApp.config(
  ["$httpProvider", function($httpProvider) {
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = $("meta[name=csrf-token]").attr("content");
  }]
);

fvistFoundationApp.factory("recordFactory", function($resource) {
  return $resource("/api/account/records");
});
