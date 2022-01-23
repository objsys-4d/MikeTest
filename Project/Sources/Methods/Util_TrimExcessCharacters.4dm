//%attributes = {"invisible":true,"preemptive":"capable"}
// Util_TrimExcessCharacters (srcTxt; character to trim) : resultTxt
// 
// DESCRIPTION
//   Trims the specified character from the beginning and from
//   the end of the supplied source string.
//
C_TEXT:C284($1; $vt_srcText)
C_TEXT:C284($2; $vt_characterToTrim)
C_TEXT:C284($0; $vt_resultText)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=2)
$vt_srcText:=$1
$vt_characterToTrim:=$2
$vt_resultText:=""


C_LONGINT:C283($vl_trimLength)
$vl_trimLength:=Length:C16($vt_characterToTrim)

If (Length:C16($vt_srcText)>0) & ($vl_trimLength>0)
	
	// Trim from the beginning
	C_BOOLEAN:C305($done)
	$done:=False:C215
	While (Not:C34($done))
		Case of 
			: (Length:C16($vt_srcText)<$vl_trimLength)
				$done:=True:C214
				
			: (Substring:C12($vt_srcText; 1; $vl_trimLength)#$vt_characterToTrim)
				$done:=True:C214
				
			Else 
				$vt_srcText:=Delete string:C232($vt_srcText; 1; $vl_trimLength)
				$done:=False:C215
		End case 
	End while 
	
	
	// Trim from the end
	$done:=False:C215
	While (Not:C34($done))
		Case of 
			: (Length:C16($vt_srcText)<$vl_trimLength)
				$done:=True:C214
				
			: (Substring:C12($vt_srcText; Length:C16($vt_srcText)-$vl_trimLength+1)#$vt_characterToTrim)
				$done:=True:C214
				
			Else 
				$vt_srcText:=Substring:C12($vt_srcText; 1; Length:C16($vt_srcText)-$vl_trimLength)
				$done:=False:C215
		End case 
	End while 
	
End if 

$vt_resultText:=$vt_srcText
$0:=$vt_resultText