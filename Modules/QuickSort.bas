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

Operator > (ByRef lhs As LARGE_DOUBLE, ByRef rhs As LARGE_DOUBLE)As Boolean
	
	If lhs.HighPart > rhs.HighPart Then
		Return True
	End If
	
	If lhs.HighPart = rhs.HighPart Then
		If lhs.LowPart > rhs.LowPart Then
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

Function Partition( _
		ByVal pVector As LARGE_DOUBLE Ptr, _
		ByVal LeftBound As Integer, _
		ByVal RightBound As Integer _
	)As Integer
	
	Dim PivotIndex As Integer = (LeftBound + RightBound) \ 2
	
	Dim i As Integer = LeftBound
	Dim j As Integer = RightBound
	
	Do
		Do While pVector[i] < pVector[PivotIndex]
			i += 1
		Loop
		
		Do While pVector[j] > pVector[PivotIndex]
			j -= 1
		Loop
		
		If i >= j Then
			Return j
		End If
		
		Scope
			Dim tmp As LARGE_DOUBLE = pVector[i]
			pVector[i] = pVector[j]
			pVector[j] = tmp
			
			i += 1
			j -= 1
		End Scope
	Loop
	
End Function

Function QuickSort( _
		ByVal pVector As LARGE_DOUBLE Ptr, _
		ByVal LeftBound As Integer, _
		ByVal RightBound As Integer _
	)As Integer
	
	If LeftBound < RightBound Then
		Dim PartitionIndex As Integer = Partition(pVector, LeftBound, RightBound)
		
		Dim PartitionsCount As Integer = 1
		PartitionsCount += QuickSort(pVector, LeftBound, PartitionIndex)
		PartitionsCount += QuickSort(pVector, PartitionIndex + 1, RightBound)
		
		Return PartitionsCount
	End If
	
	Return 0
	
End Function
