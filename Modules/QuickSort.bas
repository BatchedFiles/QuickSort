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

/'
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
		Dim PartitionsCount As Integer = 1
		
		If LeftBound < LocalRightBound Then
			PartitionsCount += QuickSort(pVector, LeftBound, LocalRightBound)
		End If
		
		If LocalLeftBound < RightBound Then
			PartitionsCount += QuickSort(pVector, LocalLeftBound, RightBound)
		End If
		
		Return PartitionsCount
	End Scope
	
End Function
'/
/'
algorithm quicksort(A, lo, hi) is
   if lo < hi then
       p:= partition(A, lo, hi)
       quicksort(A, lo, p)
       quicksort(A, p + 1, hi)
algorithm partition(A, low, high) is
   pivot:= A[(low + high) / 2]
   i:= low
   j:= high
   loop forever
       
       while A[i] < pivot 
              i:= i + 1
       while A[j] > pivot
              j:= j - 1
       if i >= j then
           return j
       swap A[i++] with A[j--]
'/

Function Partition( _
		ByVal pVector As LARGE_DOUBLE Ptr, _
		ByVal LeftBound As Integer, _
		ByVal RightBound As Integer _
	)As Integer
	
	Dim PivotIndex As Integer = (LeftBound + RightBound) \ 2
	Dim PivotValue As LARGE_DOUBLE = pVector[PivotIndex]
	
	Dim i As Integer = LeftBound
	Dim j As Integer = RightBound
	
	Do
		Do While pVector[i] < PivotValue
			i += 1
		Loop
		
		Do While pVector[j] > PivotValue
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
		Dim p As Integer = Partition(pVector, LeftBound, RightBound)
		
		Dim PartitionsCount As Integer = 1
		PartitionsCount += QuickSort(pVector, LeftBound, p)
		PartitionsCount += QuickSort(pVector, p + 1, RightBound)
		
		Return PartitionsCount
	End If
	
	Return 0
	
End Function
