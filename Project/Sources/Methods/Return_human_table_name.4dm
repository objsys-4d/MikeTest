//%attributes = {}
#DECLARE($country_code : Text; $full_name : Text)
C_LONGINT:C283($low; $high; $middle; $nbtries; $line; $nb_of_tables)
C_TEXT:C284($middle_value)
ARRAY TEXT:C222($Tab_rung; 0)
C_TEXT:C284($0)

// We use the right country's ladder
$line:=Find in array:C230(Tab_country_code; $country_code)
If ($line>0)
	$nb_of_tables:=Size of array:C274(Pointer_rung_limit{$line}->)
	If ($nb_of_tables=1)
		$0:="Humans_"+$country_code+"_"+Pointer_rung_limit{$line}->{1}
	Else 
		$low:=0
		$high:=$nb_of_tables
		$middle:=Int:C8(($low+$high)/2)
		$nbtries:=0
		Repeat 
			$nbtries:=$nbtries+1
			$middle_value:=Pointer_rung_limit{$line}->{$middle}
			If ($full_name<=$middle_value)  // We need to go closer to the beginning of the array
				$high:=$middle
				$middle:=Int:C8(($low+$middle)/2)
			Else   // We need to go closer to the end of the array
				$low:=$middle
				$middle:=Int:C8(($middle+$high)/2)
			End if 
		Until (($high=($low+1)) | ($nbtries=500))
		$0:="Humans_"+$country_code+"_"+Pointer_rung_limit{$line}->{$high}
	End if 
Else 
	TRACE:C157
End if 