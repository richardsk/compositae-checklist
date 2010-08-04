Public Class Report
    Inherits BaseObject

    Public ReportDescription As String
    Public ReportStoredProc As String
    Public ReportXSLTFilename As String
    Public ReportIsForWeb As Boolean = False

    Public Shared ReportStatusIgnoreFk As Integer = 3

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
        Name = row("ReportName").ToString
    End Sub

End Class
