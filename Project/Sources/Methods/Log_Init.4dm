//%attributes = {"invisible":true,"preemptive":"capable"}
// Log_Init ()
//
// DESCRIPTION
//   Defines the default locations for the log files to be placed.
//
// ----------------------------------------------------
// HISTORY
//   Created by: DB (12/21/2021)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=0)

var $folder : 4D:C1709.Folder
C_TEXT:C284($vt_rootFolder)
If (Application type:C494#4D Remote mode:K5:5)
	$vt_rootFolder:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16); fk platform path:K87:2).parent.platformPath
Else 
	$vt_rootFolder:=File:C1566(Application file:C491; fk platform path:K87:2).parent.platformPath
End if 
$vt_rootFolder:=$vt_rootFolder+"App Logs"+Folder separator:K24:12

C_TEXT:C284($dynamicPortionOfFolderPath)
$dynamicPortionOfFolderPath:="yyyy-mm"+Folder separator:K24:12+"yyyy-mm-dd"+Folder separator:K24:12


// Default for all the other named logs
LogConfig_SetDefaultFolder($vt_rootFolder; $dynamicPortionOfFolderPath)

// Default for the main app logs
LogConfig_SetAppLogFolder($vt_rootFolder; $dynamicPortionOfFolderPath)

LogConfig_SetMaxLinesToCache(0)  // writes to log immediately