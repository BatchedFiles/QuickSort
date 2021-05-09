#include once "windows.bi"

Declare Function wWinMain Alias "wWinMain"( _
	Byval hInst As HINSTANCE, _
	ByVal hPrevInstance As HINSTANCE, _
	ByVal lpCmdLine As LPWSTR, _
	ByVal iCmdShow As Long _
)As Long

Declare Function wMain Alias "wMain"()As Long

#ifdef WITHOUT_RUNTIME
Sub EntryPoint()
#else
'Function main Alias "main"()As Long
#endif
	
	
	Dim RetCode As Long = Any
#ifdef WINDOWS_GUI
	RetCode = wWinMain( _
		GetModuleHandle(0), _
		NULL, _
		GetCommandLineW(), _
		SW_SHOW _
	)
#else
	RetCode = wMain()
#endif
	
#ifdef WITHOUT_RUNTIME
	
	ExitProcess(RetCode)
	
End Sub
#else
	End(RetCode)
#endif
