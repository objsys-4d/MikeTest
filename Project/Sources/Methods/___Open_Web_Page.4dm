//%attributes = {}
var $port : Integer
WEB GET OPTION:C1209(Web Port ID:K73:14; $port)
OPEN URL:C673("http://127.0.0.1:"+String:C10($port))