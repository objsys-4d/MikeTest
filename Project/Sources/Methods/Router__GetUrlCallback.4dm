//%attributes = {"invisible":true,"preemptive":"capable"}
// Router__GetUrlCallback (url; httpRequestMethod) : callbackMethod
//
// DESCRIPTION
//   This method scans the registered URLs and returns the
//   callback that best matches.
//
//   The callback must support 3 paramaters, the URL and a flag
//   that is true if the current user is an administrator.
//   3rd param is the HTTP Request Method.
//
#DECLARE($url : Text; $httpRequestMethod : Text)->$callbackMethod : Text
// ----------------------------------------------------
// HISTORY
//   Created by: DB (11/22/07)
//   Mod: DB (04/29/2021) - Renamed from "WebAction_GetCallbackFromURL"
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=2)
$callbackMethod:=""

$url:=Split string:C1554($url; "?")[0]  // ensure no params or args on URL
$url:=Split string:C1554($url; "&")[0]  // ensure no params or args on URL

var $route : Object
$route:=Router__FindRouteByURL($url; $httpRequestMethod)

If ($route#Null:C1517)
	$callbackMethod:=$route.callbackMethod
End if 
