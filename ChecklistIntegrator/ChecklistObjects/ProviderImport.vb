
Public Class ProviderImport
    Inherits BaseObject

    Public ProviderImportProviderFk As Integer = -1
    Public ProviderImportImportTypeFk As Integer = -1
    Public ProviderImportFileName As String
    Public ProviderImportStatus As String
    Public ProviderImportDate As DateTime = DateTime.MinValue
    Public ProviderImportNotes As String
    Public ProviderImportHigherNameId As String = ""
    Public ProviderImportHigherPNId As String = ""
    Public ProviderImportGenusNameId As String = ""
    Public ProviderImportGenusPNId As String = ""

    Public ProviderName As String = ""

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
        ProviderName = row("ProviderName").ToString
    End Sub

    Public Property ProviderImportPk() As Integer
        Get
            Return IdAsInt
        End Get
        Set(ByVal value As Integer)
            Id = value.ToString
        End Set
    End Property

    Public Property Text() As String
        Get
            Return ToString()
        End Get
        Set(ByVal value As String)
            'do nothing
        End Set
    End Property

    Public Overrides Function ToString() As String
        Dim val As String = ProviderName
        If ProviderImportDate <> DateTime.MinValue Then
            val += " : " + ProviderImportDate.ToString
        End If
        val += " : " + ProviderImportFileName
        Return val
    End Function
End Class
