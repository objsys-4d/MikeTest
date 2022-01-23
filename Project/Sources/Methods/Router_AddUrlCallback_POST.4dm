//%attributes = {"invisible":true,"preemptive":"capable"}
// Router_AddUrlCallback_POST (url, callbackMethod, tabName)
//
// DESCRIPTION
//   This method registers a URL to be handled by the
//   the specified callback method for a POST HTTP Request.
//
var $1; $url : Text
var $2; $callbackMethod : Text
var $3; $appliesToTabName : Text  // OPTIONAL
// ----------------------------------------------------
// HISTORY
//   Created by: DB (04/29/2021)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259>=2)
ASSERT:C1129(Count parameters:C259<=3)
$url:=$1
$callbackMethod:=$2
If (Count parameters:C259=3)
	$appliesToTabName:=$3
End if 

Router__AddUrlCallback($url; $callbackMethod; $appliesToTabName; HTTP POST method:K71:2)