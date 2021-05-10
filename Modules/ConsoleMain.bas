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
Const GenerateString = __TEXT(!"Generating...\r\n")
Const SortingString = __TEXT(!"Sorting...\r\n")
Const AverageString = __TEXT(!"Average\t")

Const SORTED_TIME_COUNT As Integer = 10
Const VECTOR_CAPACITY As Integer = 50 * 1000 * 1000

Sub ConsoleAppendRow( _
		ByVal Index As Integer, _
		ByVal Sorts As Integer, _
		ByVal Elapsed As LongInt _
	)
	
	Dim bufIndex(1023) As TCHAR = Any
	_i64tot(Index + 1, @bufIndex(0), 10)
	
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
	
	Dim ElapsedTimes(SORTED_TIME_COUNT - 1) As LARGE_INTEGER = Any
	Dim QuickSorts(SORTED_TIME_COUNT - 1) As Integer = Any
	
	Dim pVector As LARGE_DOUBLE Ptr = VirtualAlloc( _
		NULL, _
		VECTOR_CAPACITY * SizeOf(LARGE_DOUBLE), _
		MEM_COMMIT Or MEM_RESERVE, _
		PAGE_READWRITE _
	)
	
	If pVector <> NULL Then
		Dim Frequency As LARGE_INTEGER = Any
		QueryPerformanceFrequency(@Frequency)
		
		For i As Integer = 0 To SORTED_TIME_COUNT - 1
			
			srand(0)
			
			WriteString(StrPtr(GenerateString), Len(GenerateString))
			Scope
				
				FillVector(pVector, VECTOR_CAPACITY)
				
			End Scope
			WriteString(StrPtr(SortingString), Len(SortingString))
			
			Scope
				Dim StartTime As LARGE_INTEGER = Any
				QueryPerformanceCounter(@StartTime)
				
				QuickSorts(i) = QuickSort(pVector, 0, VECTOR_CAPACITY - 1)
				
				Dim EndTime As LARGE_INTEGER = Any
				QueryPerformanceCounter(@EndTime)
				
				ElapsedTimes(i).QuadPart = EndTime.QuadPart - StartTime.QuadPart
			End Scope
			
			Dim ElapsedMicroSeconds As LARGE_INTEGER = Any
			ElapsedMicroSeconds.QuadPart = (ElapsedTimes(i).QuadPart * 1000) \ Frequency.QuadPart
			
			ConsoleAppendRow(i, QuickSorts(i), ElapsedMicroSeconds.QuadPart)
			
		Next
		
		VirtualFree( _
			pVector, _
			0, _
			MEM_RELEASE _
		)
		
		Dim Summ As LARGE_INTEGER = Any
		Summ.QuadPart = ElapsedTimes(0).QuadPart
		
		For i As Integer = 1 To SORTED_TIME_COUNT - 1
			Summ.QuadPart += ElapsedTimes(i).QuadPart
		Next
		
		Dim Average As LARGE_INTEGER = Any
		Average.QuadPart = Summ.QuadPart \ SORTED_TIME_COUNT
		
		WriteString(StrPtr(AverageString), Len(AverageString))
		Scope
			Dim bufAverage(1023) As TCHAR = Any
			_i64tot(Average.QuadPart, @bufAverage(0), 10)
			WriteString(@bufAverage(0), lstrlen(@bufAverage(0)))
		End Scope
		WriteString(StrPtr(CrLfString), Len(CrLfString))
		
	End If
	
	Return 0
	
End Function