Public Class ReferenceRIS
    Inherits BaseObject

    Public RISReferenceFk As String
    Public RISID As String
    Public RISType As String
    Public RISAuthors As String
    Public RISTitle As String
    Public RISDate As String
    Public RISNotes As String
    Public RISKeywords As String
    Public RISStartPage As String
    Public RISEndPage As String
    Public RISJournalName As String
    Public RISStandardAbbreviation As String
    Public RISVolume As String
    Public RISIssue As String
    Public RISCityOfPublication As String
    Public RISPublisher As String
    Public RISISSNNumber As String
    Public RISWebUrl As String
    Public RISTitle2 As String
    Public RISTitle3 As String
    Public RISAuthors2 As String
    Public RISAuthors3 As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub
End Class
