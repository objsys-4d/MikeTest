//%attributes = {}
#DECLARE($old : Integer; $new : Integer)
var $0 : Integer

Case of 
	: ($old=100)  // That certainty cannot be improved. We leave it at 100.
		$0:=1
	: ($old<$new)  // If the new source is more certain than the old one, we keep the new one
		$0:=$new
	: ($old=$new)  // If both sources are equally certain, we bump the certainty by reducing the gap to 100 by 15% (i.e. 70 becomes 74.5)
		$0:=100-((100-$old)*0.85)
	: ($old>$new)  // If the old source is more certain than the new one, we keep the certainty of the old source
		$0:=$old
End case 