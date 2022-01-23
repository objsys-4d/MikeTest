//%attributes = {}
#DECLARE($import_country_code : Text)

// We make sure that the country code of the import is a valid one

If (ds:C1482.Countries.get($import_country_code)#Null:C1517)
	
	// We load all name impurities for that country
	
	//QUERY(; [Name_impurities:9]country:2=$import_country_code; *)
	//QUERY(;  & ; [Name_impurities:9]type:5="suffix")
	//SELECTION TO ARRAY([Name_impurities:9]string:3; Tab_Suffix; [Name_impurities:9]replaceby:4; Tab_Suffix_Replace)
	
	//QUERY(; [Name_impurities:9]country:2=$import_country_code; *)
	//QUERY(;  & ; [Name_impurities:9]type:5="prefix")
	//SELECTION TO ARRAY([Name_impurities:9]string:3; Tab_Prefix; [Name_impurities:9]replaceby:4; Tab_Prefix_Replace)
	
Else 
	
	TRACE:C157  // We need to correct the import's country code before launching the job
	
End if 