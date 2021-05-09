#ifndef WRITESTRING_BI
#define WRITESTRING_BI

#include once "windows.bi"

Declare Function WriteStringW Alias "WriteStringW"( _
	ByVal lpBuffer As WString Ptr, _
	ByVal Length As Integer _
)As HRESULT

Declare Function WriteStringA Alias "WriteStringA"( _
	ByVal lpBuffer As ZString Ptr, _
	ByVal Length As Integer _
)As HRESULT

#ifndef UNICODE
Declare Function WriteString Alias "WriteStringA"( _
	ByVal lpBuffer As ZString Ptr, _
	ByVal Length As Integer _
)As HRESULT
#endif

#ifdef UNICODE
Declare Function WriteString Alias "WriteStringW"( _
	ByVal lpBuffer As WString Ptr, _
	ByVal Length As Integer _
)As HRESULT
#endif

#endif
