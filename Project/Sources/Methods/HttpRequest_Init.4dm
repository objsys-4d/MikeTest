//%attributes = {"invisible":true,"preemptive":"capable"}
// HttpRequest_Init (http_header) : httpRequest
//
// DESCRIPTION
//   Populates the httpRequest object with information
//   from the current web session.
//
#DECLARE($http_header : Text)->$httpRequest : Object
// ----------------------------------------------------
// HISTORY
//   Created by: DB (11/26/2021)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=1)
$httpRequest:=New object:C1471
If ($http_header="POST @")
	$httpRequest.method:=HTTP POST method:K71:2
Else 
	$httpRequest.method:=HTTP GET method:K71:1
End if 
$httpRequest.variables:=New collection:C1472
$httpRequest.headers:=New collection:C1472

$httpRequest.response:=New object:C1471
$httpRequest.response.headers:=New collection:C1472

var $i : Integer

// # stored the variables
ARRAY TEXT:C222($namesArr; 0)
ARRAY TEXT:C222($valuesArr; 0)
WEB GET VARIABLES:C683($namesArr; $valuesArr)
For ($i; 1; Size of array:C274($valuesArr))
	$httpRequest.variables.push(New object:C1471(\
		"name"; $namesArr{$i}; \
		"value"; Util_TrimExcessSpaces($valuesArr{$i})))
End for 

// # stored the headers
ARRAY TEXT:C222($namesArr; 0)
ARRAY TEXT:C222($valuesArr; 0)
WEB GET HTTP HEADER:C697($namesArr; $valuesArr)
For ($i; 1; Size of array:C274($valuesArr))
	$httpRequest.headers.push(New object:C1471(\
		"name"; $namesArr{$i}; \
		"value"; Util_TrimExcessSpaces($valuesArr{$i})))
End for 

HttpResponse_SetHeaderValue($httpRequest; "X-VERSION"; "HTTP:1.1")  // default (must be first)
HttpResponse_SetHeaderValue($httpRequest; "X-STATUS"; "200")  // default (must be second)
//HttpResponse_SetHeaderValue($httpRequest; "X-STATUS"; "404 Not Found")  // just here for usage in other parts

HttpResponse_SetHeaderValue($httpRequest; "Content-Type"; "text/html; charset=UTF-8")  // default response as HTML
HttpResponse_SetHeaderValue($httpRequest; "Accept-Charset"; "utf-8")
HttpResponse_SetHeaderValue($httpRequest; "Cache-Control"; "no-cache, no-store, must-revalidate, private")
HttpResponse_SetHeaderValue($httpRequest; "Pragma"; "no-cache")
HttpResponse_SetHeaderValue($httpRequest; "Expires"; String:C10(Current date:C33; Date RFC 1123:K1:11; Current time:C178))

// See http://blogs.msdn.com/b/ieinternals/archive/2010/03/30/combating-clickjacking-with-x-frame-options.aspx
HttpResponse_SetHeaderValue($httpRequest; "X-Frame-Options"; "DENY")

// See https://www.owasp.org/index.php/XSS_(Cross_Site_Scripting)_Prevention_Cheat_Sheet
HttpResponse_SetHeaderValue($httpRequest; "X-XSS-Protection"; "1; mode=block")

// See https://msdn.microsoft.com/library/gg622941(v=vs.85).aspx
HttpResponse_SetHeaderValue($httpRequest; "X-Content-Type-Options"; "nosniff")

If (True:C214)  // The X-Frame-Options HTTP response header can be used to indicate whether or not a browser should be allowed to render a page in a frame, iframe, embed or object. 
	// See http://blogs.msdn.com/b/ieinternals/archive/2010/03/30/combating-clickjacking-with-x-frame-options.aspx
	HttpResponse_SetHeaderValue($httpRequest; "X-Frame-Options"; "deny")
	
Else 
	// https://calibersecurity.com/2020/09/working-with-x-frame-options-and-csp-frame-ancestors/
	HttpResponse_SetHeaderValue($httpRequest; "Content-Security-Policy"; "frame-ancestors 'self';")
	
	// See http://blogs.msdn.com/b/ieinternals/archive/2010/03/30/combating-clickjacking-with-x-frame-options.aspx
	HttpResponse_SetHeaderValue($httpRequest; "X-Frame-Options"; "sameorigin")
End if 