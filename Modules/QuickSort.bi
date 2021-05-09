#ifndef QUICKSORT_BI
#define QUICKSORT_BI

Type LARGE_DOUBLE
	LowPart AS Double
	HighPart AS Double
End Type

Declare Operator < (ByRef lhs As LARGE_DOUBLE, ByRef rhs As LARGE_DOUBLE)As Boolean

Declare Function QuickSort( _
	ByVal pVector As LARGE_DOUBLE Ptr, _
	ByVal LeftBound As Integer, _
	ByVal RightBound As Integer _
)As Integer

Declare Sub FillVector( _
	ByVal pVector As LARGE_DOUBLE Ptr, _
	ByVal Length As Integer _
)

#endif