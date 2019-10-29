Type Point2d
	x As Double
	y As Double
End Type

Declare Operator < (ByRef lhs As Point2d, ByRef rhs As Point2d)As Boolean

Operator < (ByRef lhs As Point2d, ByRef rhs As Point2d)As Boolean
	
	If (lhs.x = rhs.x AndAlso lhs.y < rhs.y) OrElse lhs.x < rhs.x Then
		Return True
	End If
	
	Return False
	
End Operator

Function GetPivotIndex( _
		ByVal pVector As Point2d Ptr, _
		ByVal LeftBound As Integer, _
		ByVal RightBound As Integer _
	)As Integer
	
	Dim PivotIndex As Integer = (LeftBound + RightBound) \ 2
	
	Return PivotIndex
	
End Function

Function FindLeftBound( _
		ByVal pVector As Point2d Ptr, _
		ByVal LeftBound As Integer, _
		ByRef Pivot As Point2d _
	)As Integer
	
	Dim i As Integer = LeftBound - 1
	
	Do
		i += 1
	Loop While pVector[i] < Pivot
	
	Return i
	
End Function

Function FindRightBound( _
		ByVal pVector As Point2d Ptr, _
		ByVal RightBound As Integer, _
		ByRef Pivot As Point2d _
	)As Integer
	
	Dim j As Integer = RightBound + 1
	
	Do
		j -= 1
	Loop While Pivot < pVector[j]
	
	Return j
	
End Function

Sub QuickSort( _
		ByVal pVector As Point2d Ptr, _
		ByVal LeftBound As Integer, _
		ByVal RightBound As Integer _
	)
	
	Dim Size As Integer = RightBound - LeftBound + 1
	
	If Size < 2 Then
		Exit Sub
	End If
	
	Dim PivotIndex As Integer = GetPivotIndex(pVector, LeftBound, RightBound)
	
	Dim i As Integer = LeftBound
	Dim j As Integer = RightBound
	
	Do
		i = FindLeftBound(pVector, i, pVector[PivotIndex])
		
		j = FindRightBound(pVector, j, pVector[PivotIndex])
		
		If i <= j Then
			Swap pVector[i], pVector[j]
			i += 1
			j -= 1
		End If
		
	Loop While i <= j
	
	If LeftBound < j Then
		QuickSort(pVector, LeftBound, j)
	End If
	
	If i < RightBound Then
		QuickSort(pVector, i, RightBound)
	End If
	
End Sub

Function GetAverage( _
		ByVal pVector As Integer Ptr, _
		ByVal Length As Integer _
	)As Integer
	
	Dim Average As Integer = pVector[0]
	
	For i As Integer = 1 To Length - 1
		Average += pVector[i]
	Next
	
	Return Average \ Length
	
End Function

Sub MakeVector( _
		ByVal pVector As Point2d Ptr, _
		ByVal Length As Integer _
	)
	
	For i As Integer = 0 To Length - 1
		pVector[i].x = Rnd()
		pVector[i].y = Rnd()
	Next
	
End Sub

' ------=< MAIN >=------

Const ARRAY_LENGTH As Integer = 50 * 1000 * 1000
Const ARRAY_LOWER_BOUND As Integer = 0
Const ARRAY_UPPER_BOUND As Integer = ARRAY_LENGTH - 1

Const SORTED_TIME_COUNT_LENGTH As Integer = 10
Const SORTED_TIME_COUNT_LOWER_BOUND As Integer = 0
Const SORTED_TIME_COUNT_UPPER_BOUND As Integer = 9

Dim Shared Vector(ARRAY_LOWER_BOUND To ARRAY_UPPER_BOUND) As Point2d
Dim Shared SortedTimeCount(SORTED_TIME_COUNT_LOWER_BOUND To SORTED_TIME_COUNT_UPPER_BOUND) As Integer

Randomize Timer

For t As Integer = SORTED_TIME_COUNT_LOWER_BOUND To SORTED_TIME_COUNT_UPPER_BOUND
	
	Print "Generating..."
	MakeVector(@Vector(0), ARRAY_LENGTH)
	
	Print "Sorting..."
	
	Dim tStart As Double = Timer()
	
	QuickSort(@Vector(0), ARRAY_LOWER_BOUND, ARRAY_UPPER_BOUND)
	
	Dim tEnd As Double = Timer()
	
	SortedTimeCount(t) = CInt((tEnd - tStart) * 1000.0 + 0.5)
	
	Print "Sort took ";  SortedTimeCount(t); " milliseconds"
	
Next

Print "Average ";  GetAverage(@SortedTimeCount(0), SORTED_TIME_COUNT_LENGTH); " milliseconds"
