Public Class Name
    Inherits BaseObject

    Public NameLSID As String
    Public NameFull As String
    Public NameRank As String
    Public NameRankFk As Integer = -1
    Public NameParentFk As String
    Public NameParent As String
    Public NamePreferredFk As String
    Public NamePreferred As String
    Public NamePreferredFormatted As String
    Public NameCanonical As String
    Public NameAuthors As String
    Public NameBasionymAuthors As String
    Public NameCombinationAuthors As String
    Public NamePublishedIn As String
    Public NameReferenceFk As String
    Public NameYear As String
    Public NameMicroReference As String
    Public NameTypeVoucher As String
    Public NameTypeName As String
    Public NameTypeNameFormatted As String
    Public NameTypeNameFk As String
    Public NameOrthography As String
    Public NameBasionym As String
    Public NameBasionymFormatted As String
    Public NameBasionymFk As String
    Public NameBasedOn As String
    Public NameBasedOnFormatted As String
    Public NameBasedOnFk As String
    Public NameConservedAgainstFormatted As String
    Public NameConservedAgainst As String
    Public NameConservedAgainstFk As String
    Public NameHomonymOf As String
    Public NameHomonymOfFormatted As String
    Public NameHomonymOfFk As String
    Public NameReplacementFor As String
    Public NameReplacementForFormatted As String
    Public NameReplacementForFk As String
    Public NameBlocking As String
    Public NameBlockingFk As String
    Public NameBlockingFormatted As String
    Public NameInCitation As Boolean = False
    Public NameInvalid As Boolean = False
    Public NameIllegitimate As Boolean = False
    Public NameMisapplied As Boolean = False
    Public NameProParte As Boolean = False
    Public NameNomNotes As String
    Public NameStatusNotes As String
    Public NameNotes As String
    Public NameCounter As Integer = -1
    Public NameFullFormatted As String


    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub

    Public Shared Function CreateLSID(ByVal nameId As String) As String
        Dim lsid As String = ""
        If nameId IsNot Nothing AndAlso nameId.Length > 0 Then
            lsid = "urn:lsid:compositae.org:names:" + nameId.ToUpper()
        End If
        Return lsid
    End Function

    ''' <summary>
    ''' Create a Name from a ProviderName.
    ''' </summary>
    ''' <param name="pn"></param>
    ''' <param name="mappings"></param>
    ''' <returns></returns>
    ''' <remarks>
    ''' The NameMappings are used to specified fields that map from ProviderName to Name.
    ''' SourceCol is ProviderName column name and DestCol is Name column name.
    ''' </remarks>
    Public Shared Function FromProviderName(ByVal pn As ProviderName, ByVal mappings As List(Of NameMapping)) As Name
        Dim n As New Name
        If pn IsNot Nothing Then

            For Each nm As NameMapping In mappings
                Dim toField As Reflection.FieldInfo = n.GetType().GetField(nm.NameMappingDestCol)
                Dim fromField As Reflection.FieldInfo = pn.GetType().GetField(nm.NameMappingSourceCol)
                Try
                    toField.SetValue(n, fromField.GetValue(pn))
                Catch ex As Exception
                End Try
            Next

            'Ids
            n.Id = Guid.NewGuid().ToString
            n.NameLSID = CreateLSID(n.Id)

        End If
        Return n
    End Function

End Class
