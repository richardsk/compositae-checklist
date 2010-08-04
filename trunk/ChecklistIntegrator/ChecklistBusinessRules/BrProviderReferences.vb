Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class BrProviderReferences

    Private Shared mappings As List(Of RISMapping)

    Public Shared ReadOnly Property RISMappings() As List(Of RISMapping)
        Get
            If mappings Is Nothing Then
                mappings = ReferenceData.GetRISMappings()
            End If
            Return mappings
        End Get
    End Property

    ''' <summary>
    ''' Finds Reference matches for a provider reference and updates the provider reference to point to the matched reference
    ''' If 0 matches then a new Reference is inserted
    ''' If 1 match then the Provider Reference record is linked to this Reference
    ''' If >1 mathes then a 'multiple match' status is set
    ''' </summary>
    ''' <param name="provRef"></param>
    ''' <returns>The integration result</returns>
    ''' <remarks>
    ''' RIS data is matched at the same time.
    ''' If the provider reference matches a reference then the provider RIS record is linked to the 
    ''' equivalent RIS record.
    ''' </remarks>
    Public Shared Function MatchAndUpdateProviderReference(ByVal provRef As ProviderReference) As MatchResult
        Dim res As New MatchResult

        Dim provRIS As ProviderRIS = ReferenceData.GetProviderRISByReference(provRef.IdAsInt)

        Dim matchRuleSet As Integer = -1
        Try
            matchRuleSet = Integer.Parse(Configuration.ConfigurationManager.AppSettings.Get("ReferenceMatchRuleSet"))
        Catch ex As Exception
        End Try
        Dim matches As Reference() = ReferenceData.GetMatchingReferences(provRef.IdAsInt, matchRuleSet)

        If matches.Length = 0 Then
            'insert new name for this record
            Dim newRef As Reference = ReferenceData.InsertReferenceFromProviderReference(provRef, SessionState.CurrentUser.Login)
            provRef.PRLinkStatus = LinkStatus.Inserted.ToString
            provRef.PRReferenceFk = newRef.Id

            res.MatchedReference = newRef.ReferenceCitation
            If res.MatchedReference Is Nothing OrElse res.MatchedReference.Length = 0 Then res.MatchedReference = matches(0).ReferenceFullCitation
            res.Status = LinkStatus.Inserted

            'insert RIS record
            If provRIS IsNot Nothing Then
                Dim newId As Integer = ReferenceData.InsertRISRecord(newRef.Id, provRIS, SessionState.CurrentUser.Login)
                provRIS.PRISRISFk = newId
            End If

        ElseIf matches.Length = 1 Then
            'exact match
            provRef.PRLinkStatus = LinkStatus.Matched.ToString
            provRef.PRReferenceFk = matches(0).Id

            res.MatchedReference = matches(0).ReferenceCitation
            If res.MatchedReference Is Nothing OrElse res.MatchedReference.Length = 0 Then res.MatchedReference = matches(0).ReferenceFullCitation
            res.Status = LinkStatus.Matched

            'link up RIS records
            Dim ris As ReferenceRIS = ReferenceData.GetReferenceRISByReference(matches(0).Id)
            If provRIS IsNot Nothing AndAlso ris IsNot Nothing Then provRIS.PRISRISFk = ris.IdAsInt
        Else
            'multiple matches - will need manual correction
            provRef.PRLinkStatus = LinkStatus.Multiple.ToString
            res.Status = LinkStatus.Multiple
        End If

        ReferenceData.InsertUpdateProviderReferenceRecord(provRef, SessionState.CurrentUser.Login)
        If provRIS IsNot Nothing Then ReferenceData.InsertUpdateProviderRISRecord(Nothing, provRef.PRReferenceId, provRIS, SessionState.CurrentUser.Login)

        If res.Status = LinkStatus.Matched Then
            ReferenceData.RefreshReferenceData(res.MatchedId, SessionState.CurrentUser.Login)
        End If
        Return res
    End Function

    ''' <summary>
    ''' Update Provider Name to link to specified Name id
    ''' </summary>
    ''' <param name="provRef"></param>
    ''' <param name="refGuid"></param>
    ''' <remarks></remarks>
    Public Shared Sub UpdateProviderReferenceLink(ByVal provRef As ProviderReference, ByVal refGuid As String)
        provRef.PRReferenceFk = refGuid
        provRef.PRLinkStatus = LinkStatus.Matched.ToString

        ReferenceData.InsertUpdateProviderReferenceRecord(provRef, SessionState.CurrentUser.Login)
    End Sub


    ''' <summary>
    ''' Inserts or updates an existing system ProviderReference
    ''' </summary>
    ''' <param name="refGuid">The Id of the reference to insert a system provider reference for</param>
    ''' <param name="existingPR">The existing provider reference, if it exists</param>
    ''' <remarks></remarks>
    Public Shared Sub InsertUpdateSystemProviderReference(ByVal refGuid As String, ByVal existingPR As ProviderReference, ByVal ris As ProviderRIS)
        If existingPR Is Nothing Then existingPR = New ProviderReference

        existingPR.PRReferenceFk = refGuid
        existingPR.PRLinkStatus = LinkStatus.Inserted.ToString

        If existingPR.PRProviderImportFk = -1 Then
            Dim curImp As ProviderImport = BrUser.GetSystemProviderImport()
            existingPR.PRProviderImportFk = curImp.IdAsInt
        End If

        If existingPR.PRReferenceId Is Nothing OrElse existingPR.PRReferenceId.Length = 0 Then
            existingPR.PRReferenceId = Guid.NewGuid.ToString
        End If

        'If existingPR.IdAsInt <> -1 Then ReferenceData.DeleteSystemProviderRISRecord(existingPR.IdAsInt)

        ReferenceData.InsertUpdateProviderReferenceRecord(existingPR, SessionState.CurrentUser.Login)

        If ris IsNot Nothing Then
            ris.PRISProviderReferencefk = existingPR.IdAsInt
            'ris.IdAsInt = -1 'insert new one
            ReferenceData.InsertUpdateProviderRISRecord(Nothing, refGuid, ris, SessionState.CurrentUser.Login)
            Dim newRIS As Integer = ReferenceData.InsertRISRecord(refGuid, ris, SessionState.CurrentUser.Login)

            'update the PRIS fk to the new RIS record
            ris.PRISRISFk = newRIS
            ReferenceData.InsertUpdateProviderRISRecord(Nothing, refGuid, ris, SessionState.CurrentUser.Login)
        End If

        BrReferences.RefreshReferenceData(New ArrayList(New String() {refGuid}))
    End Sub

    ''' <summary>
    ''' Splits a provider reference from its currently linked checklist reference
    ''' A new checklist reference is created based on this provider reference
    ''' </summary>
    ''' <param name="PRPk">Id of Provider Reference to create a new Reference for</param>
    ''' <returns>The new Reference created for this provider reference</returns>
    ''' <remarks></remarks>
    Public Shared Function SplitOffProviderReference(ByVal PRPk As Integer) As Reference
        Dim pr As ProviderReference = ReferenceData.GetProviderReference(PRPk)

        Dim oldId As String = pr.PRReferenceFk

        Dim newRef As Reference = ReferenceData.InsertReferenceFromProviderReference(pr, SessionState.CurrentUser.Login)

        Dim provRIS As ProviderRIS = ReferenceData.GetProviderRISByReference(PRPk)
        If provRIS IsNot Nothing Then
            ReferenceData.InsertUpdateProviderRISRecord(Nothing, newRef.Id, provRIS, SessionState.CurrentUser.Login)
        End If

        pr.PRReferenceFk = newRef.Id
        ReferenceData.InsertUpdateProviderReferenceRecord(pr, SessionState.CurrentUser.Login)

        BrReferences.RefreshReferenceData(New ArrayList(New String() {newRef.Id, oldId}))

        Return newRef
    End Function

    ''' <summary>
    ''' Splits a provider reference from its currently linked checklist reference
    ''' and linked to the new specified reference
    ''' </summary>
    ''' <param name="PRPk">Id of Provider Reference to re-link</param>
    ''' <param name="linkToRefGuid">Id of reference to link to, if null then Provider reference is left un-linked</param>
    Public Shared Sub SplitOffProviderReference(ByVal PRPk As Integer, ByVal linkToRefGuid As String)
        Dim pr As ProviderReference = ReferenceData.GetProviderReference(PRPk)

        Dim oldId As String = pr.PRReferenceFk

        UpdateProviderReferenceLink(pr, linkToRefGuid)

        BrReferences.RefreshReferenceData(New ArrayList(New String() {linkToRefGuid, oldId}))

    End Sub

End Class
