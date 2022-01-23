//%attributes = {}

var $country_list : Collection
var $firstname_search_result; $lastname_search_result; $name_check_result : Object

var $firstname_list : Collection
var $firstname_search_result_list : Collection
$firstname_List:=New collection:C1472("Dani"; "Guy"; "Kirk"; "Bryan"; "Robert")

var $lastname_list : Collection
var $lastname_search_result_list : Collection
$lastname_List:=New collection:C1472("beaubien"; "smith"; "Anderson"; "grant"\
; "Monk"; "Brown"; "Tremblay"; "Lee"; "Leblanc")

If (True:C214)  // old way
	$country_list:=BackgroundApi_GetAllCountries
	
	$firstname_search_result:=BackgroundApi_FindFirstName("Robert"; "USA")
	$firstname_search_result:=BackgroundApi_FindFirstName("Robert"; "ITA")
	$firstname_search_result:=BackgroundApi_FindFirstName("Robert"; "INT")
	
	$lastname_search_result:=BackgroundApi_FindLastName("Smith"; "USA")
	$lastname_search_result:=BackgroundApi_FindLastName("Anderson"; "CAN")
	$lastname_search_result:=BackgroundApi_FindLastName("Anderson"; "INT")
	
	$firstname_search_result_list:=BackgroundApi_FindFirstNameList($firstname_list; "USA")
	$firstname_search_result_list:=BackgroundApi_FindFirstNameList($firstname_list; "CAN")
	$firstname_search_result_list:=BackgroundApi_FindFirstNameList($firstname_list; "INT")
	
	$lastname_search_result_list:=BackgroundApi_FindLastNameList($lastname_list; "USA")
	$lastname_search_result_list:=BackgroundApi_FindLastNameList($lastname_list; "CAN")
	$lastname_search_result_list:=BackgroundApi_FindLastNameList($lastname_list; "INT")
	
	$name_check_result:=BackgroundApi_GetHowNameUsed("Dani"; "USA")
End if 

If (True:C214)  // new way
	var $backgroundAPI : cs:C1710.BackgroundAPI_Live
	$backgroundAPI:=cs:C1710.BackgroundAPI_Live.new(Storage:C1525.background.url)
	
	$country_list:=$backgroundAPI.getAllCountries()
	
	$firstname_search_result:=$backgroundAPI.findFirstName("Robert"; "USA")
	$firstname_search_result:=$backgroundAPI.findFirstName("Robert"; "ITA")
	$firstname_search_result:=$backgroundAPI.findFirstName("Robert"; "INT")
	
	$lastname_search_result:=$backgroundAPI.findLastName("Smith"; "USA")
	$lastname_search_result:=$backgroundAPI.findLastName("Anderson"; "CAN")
	$lastname_search_result:=$backgroundAPI.findLastName("Anderson"; "INT")
	
	$firstname_search_result_list:=$backgroundAPI.findFirstNameList($firstname_list; "USA")
	$firstname_search_result_list:=$backgroundAPI.findFirstNameList($firstname_list; "CAN")
	$firstname_search_result_list:=$backgroundAPI.findFirstNameList($firstname_list; "INT")
	
	$lastname_search_result_list:=$backgroundAPI.findLastNameList($lastname_list; "USA")
	$lastname_search_result_list:=$backgroundAPI.findLastNameList($lastname_list; "CAN")
	$lastname_search_result_list:=$backgroundAPI.findLastNameList($lastname_list; "INT")
	
	$name_check_result:=$backgroundAPI.getHowNameUsed("Dani"; "USA")
End if 
