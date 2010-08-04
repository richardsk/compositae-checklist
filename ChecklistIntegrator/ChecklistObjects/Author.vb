Public Class Author
    Inherits BaseObject

    Public AuthorPk As Integer = -1
    Public IPNIAuthor_id As String = ""
    Public IPNIVersion As String = ""
    Public Abbreviation As String = ""
    Public Forename As String = ""
    Public Surname As String = ""
    Public TaxonGroups As String = ""
    Public Dates As String = ""
    Public IPNIAlternativeNames As String = ""
    Public CorrectAuthorFk As Integer = -1

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub
End Class
