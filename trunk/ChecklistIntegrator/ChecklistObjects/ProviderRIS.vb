Public Class ProviderRIS
    Inherits BaseObject

    Public PRISProviderReferencefk As Integer = -1
    Public PRISRISFk As Integer = -1
    Public PRISId As String
    Public PRISType As String
    Public PRISAuthors As String
    Public PRISTitle As String
    Public PRISDate As String
    Public PRISNotes As String
    Public PRISKeywords As String
    Public PRISStartPage As String
    Public PRISEndPage As String
    Public PRISJournalName As String
    Public PRISStandardAbbreviation As String
    Public PRISVolume As String
    Public PRISIssue As String
    Public PRISCityOfPublication As String
    Public PRISPublisher As String
    Public PRISISSNNumber As String
    Public PRISWebUrl As String
    Public PRISTitle2 As String
    Public PRISTitle3 As String
    Public PRISAuthors2 As String
    Public PRISAuthors3 As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub

    Public Sub UpdatedFieldsFromProviderRIS(ByVal pris As ProviderRIS)
        PRISID = pris.PRISID
        PRISType = pris.PRISType
        PRISAuthors = pris.PRISAuthors
        PRISTitle = pris.PRISTitle
        PRISDate = pris.PRISDate
        PRISNotes = pris.PRISNotes
        PRISKeywords = pris.PRISKeywords
        PRISStartPage = pris.PRISStartPage
        PRISEndPage = pris.PRISEndPage
        PRISJournalName = pris.PRISJournalName
        PRISStandardAbbreviation = pris.PRISStandardAbbreviation
        PRISVolume = pris.PRISVolume
        PRISIssue = pris.PRISIssue
        PRISCityOfPublication = pris.PRISCityOfPublication
        PRISPublisher = pris.PRISPublisher
        PRISISSNNumber = pris.PRISISSNNumber
        PRISWebUrl = pris.PRISWebUrl
        PRISTitle2 = pris.PRISTitle2
        PRISTitle3 = pris.PRISTitle3
        PRISAuthors2 = pris.PRISAuthors2
        PRISAuthors3 = pris.PRISAuthors3
    End Sub
End Class
