Public Class ProviderConcept
    Inherits BaseObject

    Public PCProviderImportFk As Integer = -1
    Public PCLinkStatus As String
    Public PCMatchScore As Integer = -1
    Public PCConceptFk As Integer = -1
    Public PCConceptId As String
    Public PCName1 As String
    Public PCName1Id As String
    Public PCAccordingTo As String
    Public PCAccordingToId As String
    Public PCConceptVersion As String

    Public PCRelationships As New ArrayList 'if ProviderConceptRelationship

    Public Sub New()

    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        LoadFieldsFromRow(row)
    End Sub

    Public Sub AddRelationships(ByVal rels As DataRowCollection)
        For Each row As DataRow In rels
            PCRelationships.Add(New ProviderConceptRelationship(row, row("PCRPk").ToString))
        Next
    End Sub

    ''' <summary>
    ''' Update fields from a newly imported Provider Concept (so doesnt have Fks populated)
    ''' </summary>
    ''' <param name="pc"></param>
    ''' <remarks></remarks>
    Public Sub UpdateFieldsFromProviderConcept(ByVal pc As ProviderConcept)
        If pc.PCConceptId IsNot Nothing Then PCConceptId = pc.PCConceptId
        If pc.PCName1 IsNot Nothing Then PCName1 = pc.PCName1
        If pc.PCName1Id IsNot Nothing Then PCName1Id = pc.PCName1Id
        If pc.PCAccordingTo IsNot Nothing Then PCAccordingTo = pc.PCAccordingTo
        If pc.PCAccordingToId IsNot Nothing Then PCAccordingToId = pc.PCAccordingToId
        If pc.PCConceptVersion IsNot Nothing Then PCConceptVersion = pc.PCConceptVersion
    End Sub
End Class
