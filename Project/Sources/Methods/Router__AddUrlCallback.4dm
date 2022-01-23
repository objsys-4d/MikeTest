//%attributes = {"invisible":true,"preemptive":"capable"}
// Router__AddUrlCallback (url, callbackMethod, tabName, httpRequestMethod)
//
// DESCRIPTION
//   This internal method registers a URL to be handled by the
//   the specified callback method for the HTTP Request method.
//
var $1; $url : Text
var $2; $callbackMethod : Text
var $3; $appliesToTabName : Text
var $4; $httpRequestMethod : Text
// ----------------------------------------------------
// HISTORY
//   Created by: DB (04/29/2021)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=4)
$url:=$1
$callbackMethod:=$2
$appliesToTabName:=$3
$httpRequestMethod:=$4

ASSERT:C1129($url#""; "A non-blank url must be provided.")
ASSERT:C1129($callbackMethod#""; "A callback method must be provided.")

Router_Init

var $route : Object
$route:=Router__FindRouteByURL($url; $httpRequestMethod)

If ($route=Null:C1517)
	$route:=New shared object:C1526
	Storage:C1525.routes.push($route)
End if 

Use ($route)
	$route.url:=$url
	$route.callbackMethod:=$callbackMethod
	$route.appliesToTab:=$appliesToTabName
	$route.httpRequestMethod:=$httpRequestMethod
	$route.isValidByDirectLink:=False:C215
End use 

Use (Storage:C1525)
	Storage:C1525.routes:=Storage:C1525.routes.orderBy("url, httpRequestMethod")
End use 
