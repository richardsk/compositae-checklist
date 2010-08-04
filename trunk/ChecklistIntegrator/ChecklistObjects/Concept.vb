Public Class Concept
    Inherits BaseObject

    Public ConceptLSID As String
    Public ConceptName1 As String
    Public ConceptName1Fk As String
    Public ConceptAccordingTo As String
    Public ConceptAccordingToFk As String

    Public Relationships As New ArrayList ' of ConceptRelationship

    Public Sub New()

    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub

    Public Sub AddRelationships(ByVal rels As DataRowCollection)
        For Each row As DataRow In rels
            Relationships.Add(New ConceptRelationship(row, row("ProviderConceptGuid").ToString))
        Next
    End Sub

    Public Shared Function CreateLSID(ByVal conceptId As String) As String
        Dim lsid As String = ""
        If conceptId IsNot Nothing AndAlso conceptId.Length > 0 Then
            lsid = "urn:lsid:compositae.org:concepts:" + conceptId.ToUpper()
        End If
        Return lsid
    End Function
End Class
