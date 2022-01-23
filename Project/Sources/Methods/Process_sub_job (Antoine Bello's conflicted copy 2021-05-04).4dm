//%attributes = {}
ON ERR CALL:C155("Handle_errors")
C_LONGINT:C283($nb_of_records; $nb_of_batches; $nb_records_created; ; $nb_records_updated; $nb_records_dropped; nb_postgres_errors)
C_LONGINT:C283($Connection_ID_read; $Connection_ID_write; $t0; $t1; $t2; $t3; $t4; $t5; $t6; $Batch_number; $line)
C_OBJECT:C1216($status; $record; job; $masterjob; $name; $info; $0; $1)
C_BLOB:C604(blob_imported_humans; blob_humans; blob_human_countries; blob_empty)
ARRAY REAL:C219($Time_Building_Humans; 0)
ARRAY REAL:C219($Time_Preparing_Query; 0)
ARRAY REAL:C219($Time_Retrieving_Homonyms; 0)
ARRAY REAL:C219($Time_Writing_Instructions; 0)
ARRAY REAL:C219($Time_Sending_Blobs; 0)
ARRAY REAL:C219($Time_Sending_Blobs_Humans; 0)
ARRAY REAL:C219($Time_Sending_Blobs_Imported; 0)
ARRAY REAL:C219($Time_Full_Batch; 0)
SET BLOB SIZE:C606(blob_empty; 0)
ARRAY OBJECT:C1221($Tab_Human; 0)
C_TEXT:C284($summary; $country; $message_stats)
job:=$1


////////////////////////////////////////////////////////// We load country-related arrays //////////////////////////////////////////////////////


Load_country_related_arrays
Load_index_logarithmic_scale
Reset_blobs


////////////////////////////////////////////////////////// We build our selection or records ////////////////////////////////////////////


records:=ds:C1482[job.table_name].all().slice(job.record_from; job.record_to)
$nb_records:=records.length
$nb_batches:=Choose:C955(Mod:C98(records.length; job.records_per_batch)=0; records.length/job.records_per_batch; Int:C8(records.length/job.records_per_batch)+1)
$nb_records_created:=0
$nb_records_updated:=0
$nb_records_dropped:=0
nb_errors:=0
$t0:=Milliseconds:C459


//////////////////////////////////////////////////// We can now process the records one by one /////////////////////////////////////////////////////////////



For each (record; records)
	
	$Message:="Batch "+String:C10(($Batch_number+1))+"/"+String:C10($nb_batches)+": Building humans\n"
	$Message:=$Message+"Number of Postgres error message: "+String:C10(nb_errors)
	MESSAGE:C88($Message)
	
	$human:=New_human_object
	$human.countries:=Choose:C955(((record.countries#Null:C1517) & (record.countries#"")); record.countries; Choose:C955(job.country#""; job.country; Null:C1517))
	$human.text:=Choose:C955(((record.text#Null:C1517) & (record.text#"")); record.text; Null:C1517)
	$name:=Return_name_info
	$human.first_name:=$name.first_name
	$human.middle_name:=$name.middle_name
	$human.last_name:=$name.last_name
	
	If (($human.first_name#"") & ($human.last_name#""))
		
		$human.full_name:=$human.first_name+"|"+$human.last_name
		
		// Sex
		Case of 
			: ((record.sex="1") | (record.sex="M") | (record.sex="Male"))
				$human.sex:="MALE"
				$human.sex_certainty:=job.sex_certainty
			: ((record.sex="2") | (record.sex="F") | (record.sex="Female") | (record.maiden_name#""))
				$human.sex:="FEMALE"
				$human.sex_certainty:=job.sex_certainty
			Else   // If the sex wasn't imported, we try to guess it based on the first name. We only keep the result it the certainty is greater than 95%
				$country:=Choose:C955($human.countries#Null:C1517; $human.countries; job.country)
				$sex:=Sex_based_on_first_name($human.first_name; $country)
				$human.sex:=Choose:C955($sex.certainty>=0.95; $sex.sex; Null:C1517)
				$human.sex_certainty:=Choose:C955($sex.certainty>=0.95; $sex.certainty; Null:C1517)
		End case 
		
		// The maiden name.
		If ($human.sex="FEMALE")
			$human.maiden_name:=Choose:C955(record.maiden_name#""; record.maiden_name; "")
			If ((job.women_name_is_their_maiden_name) & ($human.maiden_name=""))
				$human.maiden_name:=$human.last_name
				$human.maiden_name:=job.maiden_name_certainty
			End if 
		End if 
		
		// Date and place of birth
		$info:=Return_birth_info
		$human.birth_day:=$info.birth_day
		$human.birth_day_certainty:=$info.birth_day_certainty
		$human.birth_month:=$info.birth_month
		$human.birth_month_certainty:=$info.birth_month_certainty
		$human.birth_year:=$info.birth_year
		$human.birth_year_certainty:=$info.birth_year_certainty
		$human.birth_year_confidence_margin:=$info.birth_year_confidence_margin
		$human.birth_city:=$info.birth_city
		$human.birth_region:=$info.birth_region
		$human.birth_country:=$info.birth_country
		$human.birth_place_certainty:=$info.birth_place_certainty
		
		// Date and place of death
		$info:=Return_death_info
		$human.death_day:=$info.death_day
		$human.death_day_certainty:=$info.death_day_certainty
		$human.death_month:=$info.birth_month
		$human.death_month_certainty:=$info.death_month_certainty
		$human.death_year:=$info.death_year
		$human.death_year_certainty:=$info.death_year_certainty
		$human.death_year_confidence_margin:=$info.death_year_confidence_margin
		$human.death_city:=$info.death_city
		$human.death_region:=$info.death_region
		$human.death_country:=$info.death_country
		$human.death_place_certainty:=$info.death_place_certainty
		
		// Basic and full index. We don't import a human with a full index greater than 0.25.
		If (job.calculate_indexes)
			$index:=Return_indexes($human)
			$human.basic_index:=$index.basic
			$human.full_index:=$index.full
		End if 
	End if 
	
	// We commit the object to $Tab_Human
	If ($human.full_index<=0.25)
		APPEND TO ARRAY:C911($Tab_Human; $human)
	End if 
	
	
	//////////////////////////////////////// Every X number of records, we query postgress for homonyms ////////////////////////////////////////////////////
	
	
	If ((Mod:C98((record.indexOf()+1); job.records_per_batch)=0) | ((record.indexOf()+1)=records.length))
		
		$Batch_number:=$Batch_number+1
		If ($Batch_number>1)
			$Message_stats:="Last batch: "+String:C10(Round:C94($Time_Full_Batch{($Batch_number-1)}; 2))+"s\n"
			$Message_stats:=$Message_stats+"Average time per batch: "+String:C10(Round:C94(Sum:C1($Time_Full_Batch)/($Batch_number-1); 2))+"s"
		End if 
		
		If (job.look_for_homonyms)
			
			// We write the prepared statement to query Postgres about potential homonyms
			MESSAGE:C88("Batch "+String:C10($Batch_number)+"/"+String:C10($nb_batches)+": Preparing homonym query\n"+$message_stats)
			$t1:=Milliseconds:C459
			
			$query:=Size of array:C274($Tab_Human)*Query_homonyms
			$Statement_query_homonyms_id:=PgSQL New SQL Statement($Connection_ID_read; $query)
			For ($i; 1; Size of array:C274($Tab_Human))
				PgSQL Set Text In SQL($Statement_query_homonyms_id; $i; $Tab_Human{$i}.full_name)
			End for 
			
			MESSAGE:C88("Batch "+String:C10($Batch_number)+"/"+String:C10($nb_batches)+": Retrieving homonyms\n"+$message_stats)
			$t2:=Milliseconds:C459
			
			$settings:=Settings_postgres_read
			$Connection_ID_read:=PgSQL Connect($settings.localhost; $settings.login; $settings.password; $settings.database; $settings.port; "multi-results=true")
			$rowset:=PgSQL Select($Connection_ID_read; ""; $Statement_query_homonyms_id)
			$rowcount:=PgSQL Get Row Count($rowset)
			
			ARRAY OBJECT:C1221(Tab_all_homonyms_object; 0)
			ARRAY TEXT:C222(Tab_all_homonyms_name; 0)
			For ($i; 1; $rowcount)
				$object:=PgSQL Row To Object($rowset)
				APPEND TO ARRAY:C911(Tab_all_homonyms_object; $object)
				APPEND TO ARRAY:C911(Tab_all_homonyms_name; $object.first_name+"_"+$object.last_name)
				$result:=PgSQL Next Row($rowset)
			End for 
			PgSQL Delete Row Set($rowset)
			PgSQL Close($Connection_ID_read)
		End if 
		
		MESSAGE:C88("Batch "+String:C10($Batch_number)+"/"+String:C10($nb_batches)+": Writing instructions\n"+$message_stats)
		$t3:=Milliseconds:C459
		
		For ($i; 1; Size of array:C274($Tab_Human))  // Depending on whether the new human has homonyms, we create a new profile or enrich an existing one
			
			$human:=$Tab_Human{$i}
			$best_homonym:=Return_best_homonym($human)
			
			If ($best_homonym.similarity=0)  // If we have no similar human, we write txt instructions for Postgres
				TEXT TO BLOB:C554(Txt_create_human($human); blob_humans; UTF8 text without length:K22:17; *)
				TEXT TO BLOB:C554($human.id+"\t"+job.id+"\n"; blob_imported_humans; UTF8 text without length:K22:17; *)
				$nb_records_created:=$nb_records_created+1
				
			Else   // If we have a similar human, we merge the two records and send the instructions to Postgres
				$human:=Combine_humans($human; $best_homonym)
				TEXT TO BLOB:C554(Txt_create_human($human); blob_humans; UTF8 text without length:K22:17; *)
				TEXT TO BLOB:C554($human.id+"\t"+job.id+"\n"; blob_imported_humans; UTF8 text without length:K22:17; *)
				DELETE FROM ARRAY:C228(Tab_all_homonyms_object; $best_homonym.line_in_array; 1)
				DELETE FROM ARRAY:C228(Tab_all_homonyms_name; $best_homonym.line_in_array; 1)
				$nb_records_updated:=$nb_records_updated+1
			End if 
		End for 
		
		ARRAY OBJECT:C1221($Tab_Human; 0)
		ARRAY OBJECT:C1221(Tab_all_homonyms_object; 0)
		ARRAY TEXT:C222(Tab_all_homonyms_name; 0)
		
		
		//////////////////////////////////////// At the end of the cycle, we send the data to Postgres ////////////////////////////////////////////////////
		
		
		$t4:=Milliseconds:C459
		MESSAGE:C88("Batch "+String:C10($Batch_number)+"/"+String:C10($nb_batches)+": Sending blobs to postgres\n"+$message_stats)
		
		$settings:=Settings_postgres_write
		$Connection_ID_write:=PgSQL Connect($settings.localhost; $settings.login; $settings.password; $settings.database; $settings.port; "allow-nulls=true")
		
		$result:=PgSQL Execute($Connection_ID_write; "CREATE TEMP TABLE tmp_humans (LIKE app_public.humans INCLUDING DEFAULTS); ")
		$result:=PgSQL Execute($Connection_ID_write; Instructions_COPY_humans)
		$result:=PgSQL Send Copy Data($Connection_ID_write; blob_humans; $rowCount)
		$result:=PgSQL Send Copy Data($Connection_ID_write; blob_empty; $rowCount)
		$result:=PgSQL Execute($Connection_ID_write; Instruction_Insert)
		$result:=PgSQL Execute($Connection_ID_write; "DROP TABLE tmp_humans;")
		$result:=PgSQL Execute($Connection_ID_write; Instructions_COPY_imported_h)
		$result:=PgSQL Send Copy Data($Connection_ID_write; blob_imported_humans; $rowCount)
		$result:=PgSQL Send Copy Data($Connection_ID_write; blob_empty; $rowCount)
		PgSQL Close($Connection_ID_write)
		$t5:=Milliseconds:C459
		APPEND TO ARRAY:C911($Time_Building_Humans; Round:C94(($t1-$t0)/1000; 2))
		APPEND TO ARRAY:C911($Time_Preparing_Query; Round:C94(($t2-$t1)/1000; 2))
		APPEND TO ARRAY:C911($Time_Retrieving_Homonyms; Round:C94(($t3-$t2)/1000; 2))
		APPEND TO ARRAY:C911($Time_Writing_Instructions; Round:C94(($t4-$t3)/1000; 2))
		APPEND TO ARRAY:C911($Time_Sending_Blobs; Round:C94(($t5-$t4)/1000; 2))
		APPEND TO ARRAY:C911($Time_Full_Batch; Round:C94(($t5-$t0)/1000; 2))
		$t0:=Milliseconds:C459
	End if 
End for each 


//////////////////////////////////////// We wrap up the sub job by appending stats to the job record //////////////////////////////////////////////////////////


$time_total:=Sum:C1($Time_Full_Batch)  // in s
$time_total_per_record:=Round:C94(($time_total*1000)/records.length; 2)  // in ms
$nb_records_dropped:=$nb_records-($nb_records_created+$nb_records_updated)

$summary:="Sub-job "+String:C10(job.process)+"\n"
$summary:=$summary+"Number of records: "+String:C10($nb_records; "### ### ##0")+"\n"
$summary:=$summary+"Number of record per batch: "+String:C10(job.records_per_batch; "### ### ##0")+"\n\n"
$summary:=$summary+"Average time per batch: "+String:C10(Average:C2($Time_Full_Batch); "### ##0.0s")+"\n"
$summary:=$summary+"Build humans: "+String:C10(Average:C2($Time_Building_Humans); "### ##0.0s")+" ("+String:C10(Round:C94(Max:C3($Time_Building_Humans)/Min:C4($Time_Building_Humans); 2))+")\n"
$summary:=$summary+"Prepare query: "+String:C10(Average:C2($Time_Preparing_Query); "### ##0.0s")+" ("+String:C10(Round:C94(Max:C3($Time_Preparing_Query)/Min:C4($Time_Preparing_Query); 2))+")\n"
$summary:=$summary+"Retrieve homonyms: "+String:C10(Average:C2($Time_Retrieving_Homonyms); "### ##0.0s")+" ("+String:C10(Round:C94(Max:C3($Time_Retrieving_Homonyms)/Min:C4($Time_Retrieving_Homonyms); 2))+")\n"
$summary:=$summary+"Write instructions: "+String:C10(Average:C2($Time_Writing_Instructions); "### ##0.0s")+" ("+String:C10(Round:C94(Max:C3($Time_Writing_Instructions)/Min:C4($Time_Writing_Instructions); 2))+")\n"
//$summary:=$summary+"Send blobs humans: "+String(Average($Time_Sending_Blobs_Humans); "### ##0.0s")+" ("+String(Round(Max($Time_Sending_Blobs_Humans)/Min($Time_Sending_Blobs_Humans); 2))+")\n"
//$summary:=$summary+"Send blobs imported humans: "+String(Average($Time_Sending_Blobs_Imported); "### ##0.0s")+" ("+String(Round(Max($Time_Sending_Blobs_Imported)/Min($Time_Sending_Blobs_Imported); 2))+")\n"
$summary:=$summary+"Send blobs: "+String:C10(Average:C2($Time_Sending_Blobs); "### ##0.0s")+" ("+String:C10(Round:C94(Max:C3($Time_Sending_Blobs)/Min:C4($Time_Sending_Blobs); 2))+")\n"
$summary:=$summary+"Number of Postgres error message: "+String:C10(nb_postgres_errors)+"\n"
$summary:=$summary+"Time per record: "+String:C10($time_total_per_record)+"ms"+"\n\n"
$summary:=$summary+"Time of each batch: "
For ($i; 1; Size of array:C274($Time_Full_Batch))
	$summary:=$summary+String:C10($Time_Full_Batch{$i}; "### ##0")+Choose:C955($i<Size of array:C274($Time_Full_Batch); "s - "; "s\n")
End for 
$masterjob:=New shared object:C1526
Use ($masterjob)
	$masterjob:=ds:C1482.Jobs.get(job.id)
	$masterjob.nb_records_created:=$masterjob.nb_records_created+$nb_records_created
	$masterjob.nb_records_updated:=$masterjob.nb_records_updated+$nb_records_updated
	$masterjob.nb_records_dropped:=$masterjob.nb_records_dropped+$nb_records_dropped
	$masterjob.summary:=$masterjob.summary+$summary
	$status:=$masterjob.save()
End use 

Clear_sub_job_variables

ABORT PROCESS BY ID:C1634(Current process:C322)
