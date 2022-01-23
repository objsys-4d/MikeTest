//%attributes = {"invisible":true,"preemptive":"capable"}
// Util_TrimExcessSpaces (inputText) : outputText
//
#DECLARE($inputText : Text)->$outputText : Text
// ----------------------------------------------------
// HISTORY
//   Created by: DB (11/26/2021)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=1)

$outputText:=Util_TrimExcessCharacters($inputText; Char:C90(Space:K15:42))

$outputText:=Util_TrimExcessCharacters($outputText; Char:C90(NBSP ASCII CODE:K15:43))
