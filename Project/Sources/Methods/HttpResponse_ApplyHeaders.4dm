//%attributes = {"invisible":true,"preemptive":"capable"}
// HttpResponse_ApplyHeaders (httpRequest; header_name; value)
//
// DESCRIPTION
//   Applys all the HTTP headers.
//
#DECLARE($httpRequest : Object)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=1)

Case of 
	: ($httpRequest=Null:C1517)
	: ($httpRequest.response=Null:C1517)
	: ($httpRequest.response.headers=Null:C1517)
	: ($httpRequest.response.headers.length=0)
	Else 
		ARRAY TEXT:C222($responseHeaderNames; 0)
		ARRAY TEXT:C222($responseHeaderValues; 0)
		var $header : Object
		For each ($header; $httpRequest.response.headers)
			APPEND TO ARRAY:C911($responseHeaderNames; $header.name)
			APPEND TO ARRAY:C911($responseHeaderValues; $header.value)
		End for each 
		
		WEB SET HTTP HEADER:C660($responseHeaderNames; $responseHeaderValues)
End case 

