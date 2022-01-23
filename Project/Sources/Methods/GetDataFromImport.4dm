//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mike Beatty
// Date and time: 12/07/21, 06:32:46
// ----------------------------------------------------
// Method: GetDataFromImport
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

//check to determine country, will need country code


//ds_ConnectTest

C_LONGINT:C283($t3; $vlCounter)
C_REAL:C285($average)
C_TIME:C306($t1; $t2)
C_TEXT:C284($tableName_t; $vtMessage)
C_OBJECT:C1216($e; $loop)


dsImport:=ds_Connect("import")
$vlCounter:=0
For ($multiloop; 1; 10)
	
	C_OBJECT:C1216($esRecords)
	
	$esRecords:=dsImport.Records.all()  //.slice(0; 10)
	
	$colCountries:=$esRecords.distinct("country_code")
	
	C_TEXT:C284($tableName_t; $iso3)
	
	$iso3:="USA"
	
	$tableName_t:="Humans_"+$iso3
	
	//TRUNCATE TABLE([Humans_USA])
	
	//$esExists:=ds[$tableName_t].all()
	
	$t1:=Current time:C178
	$t3:=Milliseconds:C459
	
	For each ($loop; $esRecords)
		
		//$esFound:=ds[$tableName_t].query("first_name = :1 & last_name = :2"; $loop.first_name; $loop.last_name)
		//$esFound:=ds[$tableName_t].query("hash_last_name = :1"; Generate digest($loop.last_name; MD5 digest))
		
		//If ($esFound.length=0)
		
		$e:=ds:C1482[$tableName_t].new()
		
		$e.birth_day:=$loop.birth_day
		$e.birth_month:=$loop.birth_month
		$e.birth_place:=$loop.birth_region  //or birth_country?
		$e.birth_year:=$loop.birth_year
		$e.country_code:=$iso3
		$e.death_date:=$loop.death_date
		$e.death_place:=$loop.death_region  //or death_country?
		//$e.first_name:=Proper($loop.first_name)
		
		
		//$e.last_name:=Proper($loop.last_name)
		//$e.maiden_name:=Proper($loop.maiden_name)
		//$e.middle_name:=Proper($loop.middle_name)
		$e.first_name:=($loop.first_name)
		
		
		$e.last_name:=($loop.last_name)
		$e.maiden_name:=($loop.maiden_name)
		$e.middle_name:=($loop.middle_name)
		$e.original_first_name:=""
		$e.original_last_name:=""
		$e.original_maiden_name:=""
		$e.original_middle_name:=""
		$e.sex:=$loop.sex
		
		//$e.index_status:=Return_indexes($old; $country_code)
		//$objIndex:=Return_indexes($old; $country_code)
		
		$e.hash_first_name:=Generate digest:C1147($e.first_name; MD5 digest:K66:1)
		$e.hash_last_name:=Generate digest:C1147($e.last_name; MD5 digest:K66:1)
		$e.hash_middle_name:=Generate digest:C1147($e.middle_name; MD5 digest:K66:1)
		
		
		$success:=$e.save()
		
		//$loop.processed:=1
		//$success:=$loop.save()
		
		//Else 
		
		//record already exists
		//End if 
		$vlCounter:=$vlCounter+1
		If (Mod:C98($vlCounter; 1000)=0)
			$average:=(Milliseconds:C459-$t3)  ///$vlCounter
			MESSAGE:C88(String:C10($vlCounter)+" : "+String:C10($average))
			$t3:=Milliseconds:C459
		End if 
	End for each 
	
End for 
$t2:=Current time:C178

$vtMessage:="Complete: "+String:C10(ds:C1482[$tableName_t].all().length)+Char:C90(13)+"elapsed: "+String:C10($t2-$t1)

ALERT:C41($vtMessage)



