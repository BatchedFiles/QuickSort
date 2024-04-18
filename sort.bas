Type Point2d
	x As Double
	y As Double
End Type

Dim Shared qscount As Integer
Dim Shared Vector(0 To (50000000-1)) As Point2d

Private Operator < (ByRef lhs As Point2d, ByRef rhs As Point2d) As Boolean

	If lhs.x < rhs.x Then
		Return True
	End If

	If lhs.x = rhs.x Then
		If lhs.y < rhs.y Then
			Return True
		End If
	End If

	Return False

End Operator

#macro smaller (a, b) 
	a < b
#endmacro

Private Sub QuickSort(byval qs As Point2d Ptr, byval l As Integer, byval r As Integer)

	Dim As Integer size = r - l + 1
	If size < 2 Then
		Exit Sub
	End If

	qscount = qscount + size

	Dim As Integer i = l, j = r
	Dim pivot As Point2d = qs[l + size \ 2]

	Do
		While smaller(qs[i], pivot)
			i += 1
		Wend
		While smaller(pivot, qs[j])
			j -= 1
		Wend

		If i <= j Then
			Swap qs[i], qs[j]
			i += 1
			j -= 1
		End If
	Loop Until i > j


	If l < j Then
		QuickSort(qs, l, j)
	End If

	If i < r Then
		QuickSort(qs, i, r)
	End If

End Sub

Dim As Integer a = LBound(Vector), b = UBound(Vector)

For t As Integer = 1 to 10 
	Print "Generating vector..."
	
	Randomize 0
	qscount = 0
	
	For i As Integer = a To b 
	    Vector(i).x = Rnd()
	    Vector(i).y = Rnd()
	Next
	 
	print "Sorting..."
	
	Dim dStart As Double = Timer()
	QuickSort(@Vector(0), a, b)
	Dim dEnd As Double = Timer()
	
	Dim Elapsed As Integer = CInt(1000.0 * (dEnd - dStart) + 0.5)
	
	Print !"\tsort took msec:", Elapsed
	Print !"\tqscount="; qscount
Next
