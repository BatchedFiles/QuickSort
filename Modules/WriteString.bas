#include once "WriteString.bi"

Function WriteStringA Alias "WriteStringA"( _
		ByVal lpBuffer As ZString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	
	Dim hOutput As Handle = GetStdHandle(STD_OUTPUT_HANDLE)
	
	Dim dwCharsWritten2 As DWORD = Any
	Dim res2 As Integer = WriteFile( _
		hOutput, _
		lpBuffer, _
		Cast(DWORD, Length), _
		@dwCharsWritten2, _
		0 _
	)
	Dim dwError As DWORD = GetLastError()
	
	If res2 = 0 Then
		Return HRESULT_FROM_WIN32(dwError)
	End If
	
	Return S_OK
	
End Function

Function WriteStringW Alias "WriteStringW"( _
		ByVal lpBuffer As WString Ptr, _
		ByVal Length As Integer _
	)As HRESULT
	
	Dim hOutput As Handle = GetStdHandle(STD_OUTPUT_HANDLE)
	
	Dim dwCharsWritten1 As DWORD = Any
	Dim res1 As Integer = WriteConsoleW( _
		hOutput, _
		lpBuffer, _
		Cast(DWORD, Length), _
		@dwCharsWritten1, _
		NULL _
	)
	If res1 = 0 Then
		
		Dim CodePage As UINT = GetConsoleOutputCP()
		
		Dim cbMultiByte As Integer = WideCharToMultiByte( _
			CodePage, _
			0, _
			lpBuffer, _
			Cast(DWORD, Length), _
			NULL, _
			0, _
			NULL, _
			NULL _
		)
		
		Dim lpMultiByteStr As ZString Ptr = HeapAlloc( _
			GetProcessHeap(), _
			HEAP_NO_SERIALIZE, _
			cbMultiByte _
		)
		If lpMultiByteStr = NULL Then
			Return E_OUTOFMEMORY
		End If
		
		WideCharToMultiByte( _
			CodePage, _
			0, _
			lpBuffer, _
			Cast(DWORD, Length), _
			lpMultiByteStr, _
			cbMultiByte, _
			NULL, _
			NULL _
		)
		
		Dim dwCharsWritten2 As DWORD = Any
		Dim res2 As Integer = WriteFile( _
			hOutput, _
			lpMultiByteStr, _
			Cast(DWORD, cbMultiByte), _
			@dwCharsWritten2, _
			0 _
		)
		Dim dwError As DWORD = GetLastError()
		
		HeapFree( _
			GetProcessHeap(), _
			HEAP_NO_SERIALIZE, _
			lpMultiByteStr _
		)
		
		If res2 = 0 Then
			Return HRESULT_FROM_WIN32(dwError)
		End If
		
	End If
	
	Return S_OK
	
End Function
