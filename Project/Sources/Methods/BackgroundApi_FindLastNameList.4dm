//%attributes = {"invisible":true,"preemptive":"capable"}
// BackgroundApi_FindLastNameList (lastname_list, iso3_country_code) : search_result_list
//
// DESCRIPTION
//   Invokes Background's findLastName api and returns
//   the result from a last name search.
//   
//   An empty result indicates that something went wrong.
//
#DECLARE($lastname_list : Collection; $iso3_country_code : Text)->$search_result_list : Collection
// ----------------------------------------------------
$search_result_list:=New collection:C1472()

var $url : Text
$url:=Storage:C1525.background.url+"/api/v1/findListOfLastNames"

var $content : Object
$content:=New object:C1471
$content.country_iso3:=$iso3_country_code
$content.lastname_list:=$lastname_list

var $response : Text
var $httpResponseCode : Integer
ARRAY TEXT:C222($headerNamesArr; 0)
ARRAY TEXT:C222($headerValuesArr; 0)

Remote4DAPI_Set_4DSID(->$headerNamesArr; ->$headerValuesArr)
$httpResponseCode:=HTTP Request:C1158(HTTP POST method:K71:2; $url; $content; $response; $headerNamesArr; $headerValuesArr; *)
Remote4DAPI_Update_4DSID(->$headerNamesArr; ->$headerValuesArr)

If ($httpResponseCode=200) & ($response="{@}")
	var $response_as_object : Object
	$response_as_object:=JSON Parse:C1218($response)
	
	If ($response_as_object.status="success")
		$search_result_list:=$response_as_object.results
	End if 
End if 