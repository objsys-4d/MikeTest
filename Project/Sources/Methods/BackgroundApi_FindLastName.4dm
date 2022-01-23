//%attributes = {"invisible":true,"preemptive":"capable"}
// BackgroundApi_FindLastName (lastname, iso3_country_code) : search_result
//
// DESCRIPTION
//   Invokes Background's findLastName api and returns
//   the result from a last name search.
//   
//   An empty result indicates that something went wrong.
//
#DECLARE($lastname : Text; $iso3_country_code : Text)->$search_result : Object
// ----------------------------------------------------
$search_result:=New object:C1471

var $url : Text
$url:=Storage:C1525.background.url+"/api/v1/findLastName"
$url:=$url+"?lastname="+$lastname
$url:=$url+"&country_iso3="+Uppercase:C13($iso3_country_code)

var $response : Text
var $httpResponseCode : Integer
ARRAY TEXT:C222($headerNamesArr; 0)
ARRAY TEXT:C222($headerValuesArr; 0)

Remote4DAPI_Set_4DSID(->$headerNamesArr; ->$headerValuesArr)
$httpResponseCode:=HTTP Get:C1157($url; $response; $headerNamesArr; $headerValuesArr; *)
Remote4DAPI_Update_4DSID(->$headerNamesArr; ->$headerValuesArr)

If ($httpResponseCode=200) & ($response="{@}")
	var $response_as_object : Object
	$response_as_object:=JSON Parse:C1218($response)
	
	If ($response_as_object.status="success")
		$search_result:=$response_as_object.result
	End if 
End if 