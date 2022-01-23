//%attributes = {}
/*  BackgroundAPI_getNameGenderObj ()
 Created by: Kirk as Designer, Created: 12/12/21, 18:38:26
 ------------------
 Purpose: 

*/

#DECLARE($iso3_country_code : Text)->$payload : Object
var $url : Text
var $response : Text
var $httpResponseCode : Integer
var $response_as_object : Object
// ----------------------------------------------------
$payload:=New object:C1471

$url:=Storage:C1525.background.url+"/api/v1/firstNameObj"
$url:=$url+"?country_iso3="+Uppercase:C13($iso3_country_code)

$httpResponseCode:=HTTP Get:C1157($url; $response; *)

If ($httpResponseCode=200) & ($response="{@}")
	$response_as_object:=JSON Parse:C1218($response)
	
	If ($response_as_object.status="success")
		$payload:=$response_as_object.payload
	End if 
End if 