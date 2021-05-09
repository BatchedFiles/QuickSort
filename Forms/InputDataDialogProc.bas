#include once "InputDataDialogProc.bi"
#include once "win\commctrl.bi"
#include once "QuickSort.bi"
#include once "Resources.RH"

#ifdef UNICODE
#define _i64tot(value, buffer, radix) _i64tow(value, buffer, radix)
#else
#define _i64tot(value, buffer, radix) _i64toa(value, buffer, radix)
#endif

#define PM_STARTFILLVECTOR WM_USER
#define PM_ENDFILLVECTOR WM_USER + 1
#define PM_STARTSORTING WM_USER + 2
#define PM_ENDSORTING WM_USER + 3
#define PM_FINISHSORTING WM_USER + 4

Const C_COLUMNS As Integer = 3
Const SORTED_TIME_COUNT As Integer = 10
Const VECTOR_CAPACITY As Integer = 50 * 1000 * 1000

Dim Shared Vector(VECTOR_CAPACITY - 1) As LARGE_DOUBLE
Dim Shared ElapsedTimes(SORTED_TIME_COUNT - 1) As LARGE_INTEGER
Dim Shared QuickSorts(SORTED_TIME_COUNT - 1) As Integer

Function SortVector( _
		ByVal lpParameter As LPVOID _
	)As DWORD
	
	Dim hwndDlg As HWND = Cast(HWND, lpParameter)
	
	Dim LeftBound As Integer = LBound(Vector)
	Dim RightBound As Integer = UBound(Vector)
	Dim VectorLength As Integer = RightBound - LeftBound + 1
	
	For i As Integer = 0 To SORTED_TIME_COUNT - 1
		
		srand(0)
		
		PostMessage(hwndDlg, PM_STARTFILLVECTOR, 0, NULL)
		FillVector(@Vector(0), VectorLength)
		PostMessage(hwndDlg, PM_ENDFILLVECTOR, 0, NULL)
		
		Dim StartTime As LARGE_INTEGER = Any
		QueryPerformanceCounter(@StartTime)
		
		PostMessage(hwndDlg, PM_STARTSORTING, i, NULL)
		QuickSorts(i) = QuickSort(@Vector(0), LeftBound, RightBound)
		PostMessage(hwndDlg, PM_ENDSORTING, i, NULL)
		
		Dim EndTime As LARGE_INTEGER = Any
		QueryPerformanceCounter(@EndTime)
		
		ElapsedTimes(i).QuadPart = EndTime.QuadPart - StartTime.QuadPart
		
	Next
	
	PostMessage(hwndDlg, PM_FINISHSORTING, 0, NULL)
	
	Return 0
	
End Function

Sub ListViewAppendRow( _
		ByVal hListInterest As HWND, _
		ByVal Index As Integer, _
		ByVal Sorts As Integer, _
		ByVal Elapsed As LongInt _
	)
	
	Dim buf(1023) As TCHAR = Any
	
	_i64tot(Index + 1, @buf(0), 10)
	
	Dim Item As LVITEM = Any
	With Item
		.mask = LVIF_TEXT ' Or LVIF_STATE Or LVIF_IMAGE
		.iItem  = Index
		.iSubItem = 0
		' .state = 0
		' .stateMask = 0
		.pszText = @buf(0)
		' .cchTextMax = 0
		' .iImage = i
		' lParam as LPARAM
		' iIndent as long
		' iGroupId as long
		' cColumns as UINT
		' puColumns as PUINT
	End With
	
	ListView_InsertItem(hListInterest, @Item)
	
	_i64tot(Sorts, @buf(0), 10)
	Item.iSubItem = 1
	Item.pszText = @buf(0)
	ListView_SetItem(hListInterest, @Item)
	
	_i64tot(Elapsed, @buf(0), 10)
	Item.iSubItem = 2
	Item.pszText = @buf(0)
	ListView_SetItem(hListInterest, @Item)
	
End Sub

Function InputDataDialogProc( _
		ByVal hwndDlg As HWND, _
		ByVal uMsg As UINT, _
		ByVal wParam As WPARAM, _
		ByVal lParam As LPARAM _
	)As INT_PTR
	
	Select Case uMsg
		
		Case WM_INITDIALOG
			Dim hInst As HINSTANCE = GetModuleHandle(NULL)
			/'
			Dim hIcon As HICON = LoadIcon(hInst, CPtr(LPCTSTR, IDI_MAIN))
			SendMessage(hwndDlg, WM_SETICON, ICON_BIG, Cast(LPARAM, hIcon))
			'/
			
			Dim hListInterest As HWND = GetDlgItem(hwndDlg, IDC_LVW_ELAPSED)
			ListView_SetExtendedListViewStyle(hListInterest, LVS_EX_FULLROWSELECT Or LVS_EX_GRIDLINES)
			
			Scope
				Dim szText(265) As TCHAR = Any
				
				Dim Column As LVCOLUMN = Any
				With Column
					.mask = LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
					.fmt = LVCFMT_RIGHT
					.cx = 50
					.pszText = @szText(0)
					' .cchTextMax = 0
					' iSubItem as long
					' iImage as long
					' iOrder as long
				End With
				
				LoadString(hInst, IDS_NUMBER, @szText(0), 264)
				Column.iSubItem = 0
				ListView_InsertColumn(hListInterest, 0, @Column)
				
				Column.cx = 140
				For i As Integer = 1 To C_COLUMNS - 1
					LoadString(hInst, IDS_NUMBER + i, @szText(0), 264)
					Column.iSubItem = i
					ListView_InsertColumn(hListInterest, i, @Column)
				Next
			End Scope
			
		Case WM_COMMAND
			
			Select Case HIWORD(wParam)
				
				Case 0
					
					Select Case LOWORD(wParam)
						
						Case IDCANCEL
							EndDialog(hwndDlg, 0)
							
						Case IDOK
							Dim hListInterest As HWND = GetDlgItem(hwndDlg, IDC_LVW_ELAPSED)
							ListView_DeleteAllItems(hListInterest)
							
							Dim hwndOK As HANDLE = GetDlgItem(hwndDlg, IDOK)
							EnableWindow(hwndOK, False)
							
							Dim hwndCANCEL As HANDLE = GetDlgItem(hwndDlg, IDOK)
							SetFocus(hwndCANCEL)
							
							Const DefaultStackSize As DWORD = 0
							Const CreationFlags As DWORD = 0
							Dim hThread As HANDLE = CreateThread( _
								NULL, _
								DefaultStackSize, _
								@SortVector, _
								hwndDlg, _
								CreationFlags, _
								NULL _
							)
							CloseHandle(hThread)
							
					End Select
					
				' Case 1
					' Акселератор
					
				' Case Else
					' Элемент управления
					
			End Select
			
		' Case PM_FILLVECTOR
			' Generating
		' Case PM_STARTSORTING
			
		Case PM_ENDSORTING
			Dim Frequency As LARGE_INTEGER = Any
			QueryPerformanceFrequency(@Frequency)
			
			Dim i As Integer = wParam
			Dim ElapsedMicroSeconds As LARGE_INTEGER = Any
			ElapsedMicroSeconds.QuadPart = (ElapsedTimes(i).QuadPart * 1000) \ Frequency.QuadPart
			
			Dim hListInterest As HWND = GetDlgItem(hwndDlg, IDC_LVW_ELAPSED)
			ListViewAppendRow(hListInterest, i, QuickSorts(i), ElapsedMicroSeconds.QuadPart)
			
		Case PM_FINISHSORTING
			Dim Frequency As LARGE_INTEGER = Any
			QueryPerformanceFrequency(@Frequency)
			
			Dim Summ As LARGE_INTEGER = Any
			Summ.QuadPart = ElapsedTimes(0).QuadPart
			
			For i As Integer = 1 To SORTED_TIME_COUNT - 1
				Summ.QuadPart += ElapsedTimes(i).QuadPart
			Next
			
			Dim Average As LARGE_INTEGER = Any
			Average.QuadPart = Summ.QuadPart \ SORTED_TIME_COUNT
			
			Dim AverageElapsedMicroSeconds As LARGE_INTEGER = Any
			AverageElapsedMicroSeconds.QuadPart = (Average.QuadPart * 1000) \ Frequency.QuadPart
			
			Dim buf(1023) As TCHAR = Any
			_i64tot(AverageElapsedMicroSeconds.QuadPart, @buf(0), 10)
			SetDlgItemTextW(hwndDlg, IDC_EDT_AVERAGE, @buf(0))
			
			Dim hwndOK As HANDLE = GetDlgItem(hwndDlg, IDOK)
			EnableWindow(hwndOK, True)
			
		Case WM_CLOSE
			EndDialog(hwndDlg, 0)
			
		Case Else
			Return False
			
	End Select
	
	Return True
	
End Function
