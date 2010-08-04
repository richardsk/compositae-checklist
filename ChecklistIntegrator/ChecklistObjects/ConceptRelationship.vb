Public Class ConceptRelationship
    Inherits BaseObject

    Public ConceptRelationshipLSID As String
    Public ConceptRelationshipConcept1Fk As Integer = -1
    Public ConceptRelationshipConcept2Fk As Integer = -1
    Public ConceptRelationshipRelationship As String
    Public ConceptRelationshipRelationshipFk As Integer = -1
    Public ConceptRelationshipHybridOrder As Integer = -1

    Public Sub New()

    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub

    Public Shared Function CreateLSID(ByVal conceptRelationshipId As String) As String
        Dim lsid As String = ""
        If conceptRelationshipId IsNot Nothing AndAlso conceptRelationshipId.Length > 0 Then
            lsid = "urn:lsid:compositae.org:concept-relationship:" + conceptRelationshipId.ToUpper()
        End If
        Return lsid
    End Function

End Class
