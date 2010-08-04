
Public Class TaxTreeNode
    Public NameGuid As String = ""
    Public NameLSID As String = ""
    Public FullName As String = ""
    Public RankKey As Integer = 0
    Public RankSort As Integer = 0

    Public Misapplied As Boolean = False
    Public InEd As Boolean = False
    Public Authors As String = ""
    Public YearOf As String = ""

    Public ChildCount As Integer = 0
End Class
