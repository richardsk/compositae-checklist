Public Class Reference
    Inherits BaseObject

    Public ReferenceLSID As String
    Public ReferenceCitation As String
    Public ReferenceFullCitation As String

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub

    Public Shared Function CreateLSID(ByVal refId As String) As String
        Dim lsid As String = ""
        If refId IsNot Nothing AndAlso refId.Length > 0 Then
            lsid = "urn:lsid:compositae.org:references:" + refId.ToUpper()
        End If
        Return lsid
    End Function

    Public Shared Function FromProviderReference(ByVal pr As ProviderReference) As Reference
        Dim r As New Reference
        If pr IsNot Nothing Then
            r.Id = Guid.NewGuid.ToString
            r.ReferenceCitation = pr.PRCitation
            r.ReferenceFullCitation = pr.PRFullCitation
            r.ReferenceLSID = CreateLSID(r.Id)
        End If
        Return r
    End Function

End Class
