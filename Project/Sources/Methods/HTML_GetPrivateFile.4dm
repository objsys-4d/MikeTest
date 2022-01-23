//%attributes = {"invisible":true,"publishedWeb":true,"preemptive":"capable"}
// HTML_GetPrivateFile (relativeFilePath{, extraParam}) : fileContents
//
// DESCRIPTION
//   Loads, and returns, the contents of file path
//   that is relative to the root of the Web_Private folder.
//
//   The extraParam is meant to be for the page title when
//   including the page_start.txt file.
//
var $1; $relativeFilePath : Text
var $2; extraParam : Text  // optional
var $0; $fileContents : Text
// ----------------------------------------------------
// HISTORY
//   Created by: DB (12/10/2021)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259>=1)
ASSERT:C1129(Count parameters:C259<=2)
$relativeFilePath:=$1
If (Count parameters:C259=2)
	extraParam:=$2
End if 
$fileContents:=""

//Log_INFO(Current method name+": "+$relativeFilePath+" ("+extraParam+")")
If ($relativeFilePath="/@")  // strip out leading "/"
	$relativeFilePath:=Substring:C12($relativeFilePath; 2)
End if 
$relativeFilePath:=Replace string:C233($relativeFilePath; "/"; Folder separator:K24:12)

If ($relativeFilePath#"")
	var $includeFilePath : Text
	$includeFilePath:=Folder:C1567(Get 4D folder:C485(Current resources folder:K5:16); fk platform path:K87:2).parent.platformPath\
		+"Web_Private"+Folder separator:K24:12\
		+$relativeFilePath
	
	If (Test path name:C476($includeFilePath)=Is a document:K24:1)
		$fileContents:=Document to text:C1236($includeFilePath; "utf-8")
	End if 
	
End if 

$0:=$fileContents