//%attributes = {"invisible":true,"preemptive":"capable"}
// Router_ProcessUrl (url; hasLoggedIn; httpRequestMethod) : wasHandled
// 
// DESCRIPTION
//   locates a callback associated with the URL and involks it.
//
#DECLARE($url : Text; $hasAuthorized : Boolean; $httpRequest : Object)->$wasHandled : Boolean
// ----------------------------------------------------
// HISTORY
//   Created by: DB (11/22/07)
//   Mod: DB (04/16/2014) - Added some logging
//   Mod: DB (04/29/2021) - Renamed from "WebAction_ProcessBasedOnURL"
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=3)
$wasHandled:=False:C215

// # Trim out any parameters from the URL
C_TEXT:C284($url)
$url:=Split string:C1554($url; "\"")[0]  // trim at first quote, this will only happen if it is a "bad" URL that has been given. Done for security protection.

C_TEXT:C284($callback)
$callback:=Router__GetUrlCallback($url; $httpRequest.method)

If ($callback#"")
	$wasHandled:=True:C214
	EXECUTE METHOD:C1007($callback; *; $url; Choose:C955($hasAuthorized; True:C214; False:C215); $httpRequest)
End if 
