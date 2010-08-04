Public Class ProviderReference
    Inherits BaseObject

    Public ProviderIsEditor As Boolean = False
    Public PRProviderImportFk As Integer = -1
    Public PRReferenceId As String
    Public PRReferenceFk As String
    Public PRLinkStatus As String
    Public PRCitation As String
    Public PRFullCitation As String
    Public PRXML As String
    Public PRReferenceVersion As String

    Public RISData As DataTable

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub

    Public Sub UpdatedFieldsFromProviderReference(ByVal ref As ProviderReference)
        PRReferenceId = ref.PRReferenceId
        PRCitation = ref.PRCitation
        PRFullCitation = ref.PRFullCitation
        PRXML = ref.PRXML
        PRReferenceVersion = ref.PRReferenceVersion
    End Sub

End Class
