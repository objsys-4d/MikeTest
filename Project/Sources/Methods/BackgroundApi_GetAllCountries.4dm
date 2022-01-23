//%attributes = {"invisible":true,"preemptive":"capable"}
// BackgroundApi_GetAllCountries () : country_list
//
// DESCRIPTION
//   Invokes Background's getCountries api and returns
//   a collection of the known countries.
//   
//   An empty collection indicates that something went wrong.
//
#DECLARE()->$country_list : Collection
// ----------------------------------------------------
$country_list:=New collection:C1472

OnErr_Install_Handler("OnErr_GENERIC")

var $url : Text
$url:=Storage:C1525.background.url+"/api/v1/getCountries"

var $response; $errMethod : Text
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
		$country_list:=$response_as_object.result.countries
	End if 
End if 

OnErr_Install_Handler()