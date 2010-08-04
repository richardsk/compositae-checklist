Public Class ReportError
    Inherits BaseObject

    Public ReportErrorTable As String 'tblName, tblConcept, tblReference, tblProviderName, tblProviderConept, tblProviderReference, etc
    Public ReportErrorRecordFk As String
    Public ReportErrorReportFk As Integer = -1
    Public ReportErrorStatusFk As Integer = -1
    Public ReportErrorComment As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub
End Class
