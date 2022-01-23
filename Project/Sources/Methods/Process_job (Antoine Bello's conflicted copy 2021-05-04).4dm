//%attributes = {}
ON ERR CALL:C155("Handle_errors")
C_OBJECT:C1216(record; records; $human; $homonym; $job; $tatement; $sex; $index; $status)
C_LONGINT:C283(t0; $Statement_query_homonyms_id; $Connection_ID_write; $Connection_ID_read)
ARRAY LONGINT:C221($TabProcesses; 0)
$t0:=Milliseconds:C459


/////////////////////////////////////////////// We set the parameters of the job ////////////////////////////////////////////////


$job:=ds:C1482.Jobs.new()
$job.id:=New_UUID
$job.user_id:="38640bd6-3d52-465a-8bdd-255725fdb71d"  // antoine's id

$job.table_name:="Records"
$job.file_name:="Consumer_Name_DOB_Gender_AZ.txt"
$job.source:="State of Arizona"
$job.collection:="Database L2"
$job.country:="USA"
$job.name_structure:=1

$job.calculate_indexes:=True:C214
$job.look_for_duplicates:=False:C215
$job.look_for_homonyms:=True:C214
$job.exclude_1_and_15:=True:C214
$job.exclude_birth_day:=True:C214
$job.women_name_is_their_maiden_name:=False:C215

$job.record_from:=448000
$job.record_to:=892000
$job.records_per_batch:=10000
$job.nb_of_processes:=1

$job.assumed_birth_year:=0
$job.birth_year_confidence_margin:=0
$job.death_year_confidence_margin:=0
$job.first_name_certainty:=0.9
$job.middle_name_certainty:=0.9
$job.maiden_name_certainty:=0.9
$job.sex_certainty:=0.98
$job.birth_date_certainty:=0.9
$job.birth_place_certainty:=1
$job.death_date_certainty:=1
$job.death_place_certainty:=1
$job.pre_comment:=""


///////////////////////////////////////// We prepare the selection before going through each record  ////////////////////////////////////////////////

// We build the selection
records:=ds:C1482[$job.table_name].all()
$job.record_to:=Choose:C955($job.record_to=0; records.length; $job.record_to)
records:=records.slice($job.record_from; $job.record_to)
$job.nb_records:=records.length

// We look for duplicates
If ($job.look_for_duplicates)
	MESSAGE:C88("Deduplicating")
	$job.nb_records_duplicate:=Deduplicate_records
	$job.record_to:=Choose:C955($job.record_to=0; records.length; $job.record_to-$job.nb_records_duplicate)
End if 

// We determine the name structure of the job
If ($job.name_structure=0)
	$job.name_structure:=Determine_name_structure
End if 

// We save the job
$status:=$job.save()


/////////////////////////////////// We establish the connection with Postgres Write and transmit the job instructions ////////////////////////////////////////


MESSAGE:C88("Creating job in Postgres")
$settings:=Settings_postgres_write
$Connection_ID_write:=PgSQL Connect($settings.localhost; $settings.login; $settings.password; $settings.database; $settings.port)
$error:=PgSQL Set Error Handler("Handle_errors")
$affectedRows:=PgSQL Execute($Connection_ID_write; Instructions_to_create_job($job))


////////////////////////////////////////////// We slice the job into several sub-jobs ////////////////////////////////////////

If ($job.nb_of_processes>1)
	
	// We create one process per sub-job
	ARRAY LONGINT:C221($TabProcesses; 0)
	$nb_records_to_process:=$job.record_to-$job.record_from
	$nb_records_per_process:=Int:C8($nb_records_to_process/$job.nb_of_processes)
	
	For ($i; 1; $job.nb_of_processes)
		$sub_job:=New_sub_job($job)
		$sub_job.record_from:=($i-1)*$nb_records_per_process
		$sub_job.record_to:=$sub_job.record_from+$nb_records_per_process
		$sub_job.process:=$i
		$Process_id:=New process:C317("Process_sub_job"; 0; "Sub_job_"+String:C10($i); $sub_job)
		APPEND TO ARRAY:C911($TabProcesses; $Process_id)
	End for 
	
	Repeat   // We wait for the last process to be over
		For ($i; Size of array:C274($TabProcesses); 1; -1)
			DELAY PROCESS:C323(Current process:C322; 60)
			$text:=String:C10($nb_records_to_process; "### ### ##0")+" records to process\n"
			$text:=$text+String:C10(($job.nb_of_processes-Size of array:C274($TabProcesses)))+" processes over out of "+String:C10($job.nb_of_processes)
			MESSAGE:C88($text)
			PROCESS PROPERTIES:C336($TabProcesses{$i}; $ProcessName; $ProcessState; $ProcessTime)
			If (($ProcessState=-1) | ($ProcessState=-100))
				DELETE FROM ARRAY:C228($TabProcesses; $i; 1)
			End if 
		End for 
	Until (Size of array:C274($TabProcesses)=0)
	
Else 
	// We handle the job in the same process
	Process_sub_job($job)
End if 


///////////////////////////////////////////////////////////// We wrap up the job ////////////////////////////////////////////////////////


// We mark the job as processed and close the postgres connection
$affectedRows:=PgSQL Execute($Connection_ID_write; "update app_public.import_jobs set status = 'PROCESSED' where id ="+String_39($job.id))
PgSQL Close($Connection_ID_write)

// We log the duration of the job and display a message
$duration:=Round:C94((Milliseconds:C459-$t0)/1000; 2)
$text:="Job over\n"
$text:=$text+String:C10(records.length; "### ### ##0")+" records processed in "+String:C10($duration; "### ##0.00s")+"\n"
$text:=$text+String:C10(Round:C94((($duration*1000)/records.length); 2); "### ##0.0")+"ms per record"
MESSAGE:C88($text)

// We clear all process variables
Clear_job_variables

TRACE:C157

