#include once "QuickSort.bi"
#include once "windows.bi"

Operator < (ByRef lhs As LARGE_DOUBLE, ByRef rhs As LARGE_DOUBLE)As Boolean
	
	If lhs.HighPart < rhs.HighPart Then
		Return True
	End If
	
	If lhs.HighPart = rhs.HighPart Then
		If lhs.LowPart < rhs.LowPart Then
			Return True
		End If
	End If
	
	Return False
	
End Operator

Sub FillVector( _
		ByVal pVector As LARGE_DOUBLE Ptr, _
		ByVal Length As Integer _
	)
	
	For i As Integer = 0 To Length - 1
		pVector[i].HighPart = 1.0 - 1.0 / CDbl(rand())
		pVector[i].LowPart = 1.0 - 1.0 / CDbl(rand())
	Next
	
End Sub

Function QuickSort( _
		ByVal pVector As LARGE_DOUBLE Ptr, _
		ByVal LeftBound As Integer, _
		ByVal RightBound As Integer _
	)As Integer
	
	Dim Size As Integer = RightBound - LeftBound + 1
	
	If Size < 2 Then
		Return 0
	End If
	
	Dim LocalLeftBound As Integer = LeftBound
	Dim LocalRightBound As Integer = RightBound
	
	Scope
		Dim PivotIndex As Integer = LeftBound + Size \ 2
		Dim PivotValue As LARGE_DOUBLE = pVector[PivotIndex]
		
		Do
			Do While pVector[LocalLeftBound] < PivotValue
				LocalLeftBound += 1
			Loop
			
			Do While PivotValue < pVector[LocalRightBound]
				LocalRightBound -= 1
			Loop
			
			If LocalLeftBound <= LocalRightBound Then
				Dim tmp As LARGE_DOUBLE = pVector[LocalLeftBound]
				pVector[LocalLeftBound] = pVector[LocalRightBound]
				pVector[LocalRightBound] = tmp
				
				LocalLeftBound += 1
				LocalRightBound -= 1
			End If
			
		Loop While LocalLeftBound <= LocalRightBound
	End Scope
	
	Scope
		Dim QuickSortCount As Integer = 1
		
		If LeftBound < LocalRightBound Then
			QuickSortCount += QuickSort(pVector, LeftBound, LocalRightBound)
		End If
		
		If LocalLeftBound < RightBound Then
			QuickSortCount += QuickSort(pVector, LocalLeftBound, RightBound)
		End If
		
		Return QuickSortCount
	End Scope
	
End Function
