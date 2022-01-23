//%attributes = {}

// ----------------------------------------------------
// Method: Copy_human
// Description
// 
//
// Parameters
//
// Change History
// ----------------------------------------------------

#DECLARE($old : Object; $new : Object)
var $0 : Object

$new.job_id:=$old.job_id
$new.name:=$old.name
$new.birth:=$old.birth
$new.death:=$old.death
$new.sex:=$old.sex
$new.index:=$old.index  // Modified by: Mike Beatty (10/29/21)

$0:=$new