fvistFoundationApp.factory("recordTotalFactory", ["$resource", function($resource) {
  return $resource("/api/account/records/total");
}]);

fvistFoundationApp.factory("recordSummaryFactory", ["$resource", function($resource) {
  return $resource("/api/account/records/summary");
}]);
