//%attributes = {"invisible":true,"preemptive":"capable"}
// Controller_SearchResults (url; hasAuthorized; httpRequest)
// 
// DESCRIPTION
//   Handles "/" url.
//   
#DECLARE($url : Text; $hasAuthorized : Boolean; $httpRequest : Object)
// ----------------------------------------------------
ASSERT:C1129(Count parameters:C259=3)

HttpResponse_ApplyHeaders($httpRequest)

WEB SEND TEXT:C677(HTML_GetPrivateFile("search_results.txt"))
//WEB SEND TEXT("Hello<br/><pre>"+JSON Stringify($httpRequest; *)+"</pre>")
