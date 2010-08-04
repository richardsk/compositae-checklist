Public Class ProviderConceptRelationship
    Inherits BaseObject

    Public PCRProviderConceptFk As Integer = -1
    Public PCRProviderImportFk As Integer = -1
    Public PCRLinkStatus As String
    Public PCRMatchScore As Integer = -1
    Public PCRConceptRelationshipFk As String
    Public PCRId As String
    Public PCRConcept1Id As String
    Public PCRConcept2Id As String
    Public PCRRelationship As String
    Public PCRRelationshipId As String
    Public PCRRelationshipFk As Integer = -1
    Public PCRHybridOrder As Integer = -1
    Public PCRIsPreferredConcept As Boolean = False
    Public PCRVersion As String

    Public Sub New()

    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
        If row.Table.Columns.Contains("PCPk") Then PCRProviderConceptFk = row("PCPk")
    End Sub

    Public Sub UpdateFieldsFromProviderConceptRelationship(ByVal pc As ProviderConceptRelationship)
        If pc.PCRId IsNot Nothing Then PCRId = pc.PCRId
        If pc.PCRConcept1Id IsNot Nothing Then PCRConcept1Id = pc.PCRConcept1Id
        If pc.PCRConcept2Id IsNot Nothing Then PCRConcept2Id = pc.PCRConcept2Id
        If pc.PCRRelationship IsNot Nothing Then PCRRelationship = pc.PCRRelationship
        If pc.PCRRelationshipId IsNot Nothing Then PCRRelationshipId = pc.PCRRelationshipId
        If pc.PCRHybridOrder <> -1 Then PCRHybridOrder = pc.PCRHybridOrder
        PCRIsPreferredConcept = pc.PCRIsPreferredConcept
        If pc.PCRVersion IsNot Nothing Then PCRVersion = pc.PCRVersion
    End Sub

End Class
