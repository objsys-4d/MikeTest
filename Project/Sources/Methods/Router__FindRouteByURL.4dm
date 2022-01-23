//%attributes = {"invisible":true,"preemptive":"capable"}
// Router__FindRouteByURL (url; httpRequestMethod) : route
//
// DESCRIPTION
//   Returns the shared route object if it has been defined.
//
var $1; $url : Text
var $2; $httpRequestMethod : Text
var $0; $route : Object
// ----------------------------------------------------
// HISTORY
//   Created by: DB (04/29/2021)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=2)
$url:=$1
$httpRequestMethod:=$2
$route:=Null:C1517

var $matchingURLs : Collection
$matchingURLs:=Storage:C1525.routes.query("url=:1 AND httpRequestMethod=:2"; $url; $httpRequestMethod)

If ($matchingURLs.length>0)
	$route:=$matchingURLs[0]
End if 

$0:=$route