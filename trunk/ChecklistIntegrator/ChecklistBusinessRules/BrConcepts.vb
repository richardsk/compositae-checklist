Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class BrConcepts

    ''' <summary>
    ''' Updates the concept from the linked provider concepts.
    ''' </summary>
    ''' <param name="ConceptPk"></param>
    ''' <remarks></remarks>
    Public Shared Sub RefreshConceptData(ByVal ConceptPk As Integer)
        'ConceptData.RefreshConceptData(ConceptPk, SessionState.CurrentUser.Login)

        'get concept 
        Dim ds As DataSet = ConceptData.GetConceptDs(ConceptPk)
        Dim updateC As DataRow = ds.Tables(0).Rows(0)

        'get provider Cs
        Dim providerCs As DataSet = ConceptData.GetProviderConceptRecords(ConceptPk)

        'calculate consensus values
        For Each cm As ConceptMapping In BrProviderConcepts.ConceptMappings
            Dim sc As String = cm.MappingSourceCol
            If sc = "PCAccordingToId" Then sc = "PRReferenceFk"
            Dim val As Object = GetConsensusValue(providerCs, sc)
            If sc = "PCName1" And val Is DBNull.Value Then
                'just use namefull of name
                Dim nm As Name = NameData.GetName(Nothing, updateC("ConceptName1Fk"))
                val = nm.NameFull
            End If
            updateC(cm.MappingDestCol) = val
        Next

        'update concept
        ConceptData.UpdateConcept(New Concept(updateC, updateC("ConceptPk").ToString), SessionState.CurrentUser.Login)

    End Sub


    Private Shared Function GetConsensusValue(ByVal pcrs As DataSet, ByVal sourceCol As String) As Object
        Dim vals As New Hashtable
        Dim sysVal As Object = DBNull.Value

        For Each row As DataRow In pcrs.Tables(0).Rows
            If row("ProviderIsEditor") AndAlso Not row.IsNull(sourceCol) Then
                sysVal = row(sourceCol)
                Exit For
            End If

            If vals.ContainsKey(row(sourceCol)) Then
                vals(row(sourceCol)) += 1
            Else
                If row(sourceCol) IsNot DBNull.Value Then vals.Add(row(sourceCol), 1)
            End If
        Next

        If sysVal IsNot DBNull.Value Then Return sysVal

        'get majority value (must be > majority than next common value, ie if equal number of 2 diff values, then there is no consensus)
        Dim val As Object = DBNull.Value
        Dim maxNum As Integer = 0
        Dim hasEqual As Boolean = False
        For Each key As Object In vals.Keys
            If vals(key) > maxNum Then
                maxNum = vals(key)
                val = key
                hasEqual = False
            ElseIf vals(key) = maxNum Then
                hasEqual = True
            End If
        Next

        If hasEqual Then Return DBNull.Value

        Return val
    End Function

    Public Shared Sub RefreshConceptRelationshipData(ByVal conceptRelationshipGuid As String)
        'ConceptData.RefreshConceptRelationshipData(conceptRelationshipGuid, SessionState.CurrentUser.Login)

        'get concept relationship
        Dim ds As DataSet = ConceptData.GetConceptRelationshipDs(conceptRelationshipGuid)
        If ds.Tables.Count = 0 OrElse ds.Tables(0).Rows.Count = 0 Then Return

        Dim updateCR As DataRow = ds.Tables(0).Rows(0)

        'get provider CRs
        Dim providerCRs As DataSet = ConceptData.GetProviderConceptRelationshipsForCR(conceptRelationshipGuid)

        'calculate consensus values
        For Each crm As ConceptRelationshipMapping In BrProviderConcepts.ConceptRelationshipMappings
            Dim sc As String = crm.ConceptRelationshipMappingSourceCol
            If sc = "PCRConcept1Id" Then sc = "PCConcept1Fk"
            If sc = "PCRConcept2Id" Then sc = "PCConcept2Fk"
            Dim val As Object = GetConsensusValue(providerCRs, sc)
            updateCR(crm.ConceptRelationshipMappingDestCol) = val
        Next

        'update cr
        ConceptData.UpdateConceptRelationship(New ConceptRelationship(updateCR, updateCR("ConceptRelationshipGuid")), SessionState.CurrentUser.Login)
    End Sub
End Class
