#include once "windows.bi"
#include once "QuickSort.bi"
#include once "Resources.RH"
#include once "WriteString.bi"

#ifdef UNICODE
#define _i64tot(value, buffer, radix) _i64tow(value, buffer, radix)
#else
#define _i64tot(value, buffer, radix) _i64toa(value, buffer, radix)
#endif

Const TabString = __TEXT(!"\t")
Const CrLfString = __TEXT(!"\r\n")
Const GenerateString = __TEXT("Generating...")
Const SortingString = __TEXT("Sorting...")

Const SORTED_TIME_COUNT As Integer = 10
Const VECTOR_CAPACITY As Integer = 50 * 1000 * 1000

Dim Shared Vector(VECTOR_CAPACITY - 1) As LARGE_DOUBLE
Dim Shared ElapsedTimes(SORTED_TIME_COUNT - 1) As LARGE_INTEGER
Dim Shared QuickSorts(SORTED_TIME_COUNT - 1) As Integer

Sub ConsoleAppendRow( _
		ByVal Index As Integer, _
		ByVal Sorts As Integer, _
		ByVal Elapsed As LongInt _
	)
	
	Dim bufIndex(1023) As TCHAR = Any
	_i64tot(Index, @bufIndex(0), 10)
	
	Dim bufQuickSorts(1023) As TCHAR = Any
	_i64tot(Sorts, @bufQuickSorts(0), 10)
	
	Dim bufQuickElapsedTime(1023) As TCHAR = Any
	_i64tot(Elapsed, @bufQuickElapsedTime(0), 10)
	
	WriteString(@bufIndex(0), lstrlen(@bufIndex(0)))
	WriteString(StrPtr(TabString), Len(TabString))
	
	WriteString(@bufQuickSorts(0), lstrlen(@bufQuickSorts(0)))
	WriteString(StrPtr(TabString), Len(TabString))
	
	WriteString(@bufQuickElapsedTime(0), lstrlen(@bufQuickElapsedTime(0)))
	WriteString(StrPtr(CrLfString), Len(CrLfString))
	
End Sub

Function wMain Alias "wMain"()As Long
	
	Dim LeftBound As Integer = LBound(Vector)
	Dim RightBound As Integer = UBound(Vector)
	Dim VectorLength As Integer = RightBound - LeftBound + 1
	
	Dim Frequency As LARGE_INTEGER = Any
	QueryPerformanceFrequency(@Frequency)
	
	For i As Integer = 0 To SORTED_TIME_COUNT - 1
		
		srand(0)
		
		WriteString(StrPtr(GenerateString), Len(GenerateString))
		WriteString(StrPtr(CrLfString), Len(CrLfString))
		
		FillVector(@Vector(0), VectorLength)
		
		WriteString(StrPtr(SortingString), Len(SortingString))
		WriteString(StrPtr(CrLfString), Len(CrLfString))
		
		Dim StartTime As LARGE_INTEGER = Any
		QueryPerformanceCounter(@StartTime)
		
		QuickSorts(i) = QuickSort(@Vector(0), LeftBound, RightBound)
		
		Dim EndTime As LARGE_INTEGER = Any
		QueryPerformanceCounter(@EndTime)
		
		ElapsedTimes(i).QuadPart = EndTime.QuadPart - StartTime.QuadPart
		
		Dim ElapsedMicroSeconds As LARGE_INTEGER = Any
		ElapsedMicroSeconds.QuadPart = (ElapsedTimes(i).QuadPart * 1000) \ Frequency.QuadPart
		
		ConsoleAppendRow(i, QuickSorts(i), ElapsedMicroSeconds.QuadPart)
		
	Next
	
	/'
	Dim Summ As LARGE_INTEGER = Any
	Summ.QuadPart = ElapsedTimes(0).QuadPart
	
	' Print WStr(!"#\tQuickSorts\tElapsedTimes")
	' Print 0, QuickSorts(0), ElapsedTimes(0).QuadPart
	
	For i As Integer = 1 To SORTED_TIME_COUNT - 1
		' Print i, QuickSorts(i), ElapsedTimes(i).QuadPart
		Summ.QuadPart += ElapsedTimes(i).QuadPart
	Next
	
	Dim Average As LARGE_INTEGER = Any
	Average.QuadPart = Summ.QuadPart \ SORTED_TIME_COUNT
	
	' Print WStr("Average"), Average.QuadPart
	'/
	
	Return 0
	
End Function