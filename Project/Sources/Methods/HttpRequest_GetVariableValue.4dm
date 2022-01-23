//%attributes = {"invisible":true,"preemptive":"capable"}
// HttpRequest_GetVariableValue (httpRequest;requestedVariable) : value
//
// DESCRIPTION
//   returns the value for the named variable.
//
#DECLARE($httpRequest : Object; $var_name : Text)->$value : Text
// ----------------------------------------------------
// HISTORY
//   Created by: DB (11/26/2021)
// ----------------------------------------------------
$value:=""

Case of 
	: ($httpRequest=Null:C1517)
	: ($httpRequest.variables=Null:C1517)
	: ($httpRequest.variables.length=0)
	Else 
		var $matching_values_list : Collection
		$matching_values_list:=$httpRequest.variables.query("name=:1"; $var_name)
		If ($matching_values_list.length>0)
			$value:=$matching_values_list[0].value
		End if 
End case 