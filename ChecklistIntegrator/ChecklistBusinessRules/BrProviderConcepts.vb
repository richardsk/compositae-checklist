Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class BrProviderConcepts

    Private Shared mappings As List(Of ConceptMapping)
    Private Shared crMappings As List(Of ConceptRelationshipMapping)

    Public Shared ReadOnly Property ConceptMappings() As List(Of ConceptMapping)
        Get
            If mappings Is Nothing Then
                mappings = ConceptData.GetConceptMappings()
            End If
            Return mappings
        End Get
    End Property

    Public Shared ReadOnly Property ConceptRelationshipMappings() As List(Of ConceptRelationshipMapping)
        Get
            If crMappings Is Nothing Then
                crMappings = ConceptData.GetConceptRelationshipMappings()
            End If
            Return crMappings
        End Get
    End Property

    ''' <summary>
    ''' Match the passed in provider concept
    ''' If 0 mathces then a new concept is created
    ''' If 1 match then the provider concept record is linked to that concept record
    ''' If >1 matches then the link status is set to Multiple and the editor must resolve.
    ''' </summary>
    ''' <param name="provConceptRel"></param>
    ''' <returns>The integration result</returns>
    ''' <remarks></remarks>
    Public Shared Function MatchAndUpdateProviderConceptRelationship(ByVal provConceptRel As ProviderConceptRelationship) As MatchResult
        Dim res As New MatchResult

        provConceptRel.PCRRelationshipFk = NameData.LinkProviderConceptRelationship(Nothing, provConceptRel.IdAsInt, SessionState.CurrentUser.Login)

        'get dataset to retreive provider details for this provider concept
        Dim provRelDs As DataSet = ConceptData.GetProviderConceptRelationshipDs(provConceptRel.IdAsInt)

        Dim matches As ConceptRelationship() = ConceptData.GetMatchingConceptRelationships(provConceptRel.IdAsInt)

        Dim provId As Integer = provRelDs.Tables(0).Rows(0)("ProviderPk")

        If matches.Length > 1 Then
            'multiple matches - will need manual correction
            provConceptRel.PCRLinkStatus = LinkStatus.Multiple.ToString
            res.Status = LinkStatus.Multiple
        Else
            'insert new concept for this record, or link to matched concept
            'the InsertConceptRelationshipFromProviderConceptRelationship handles both cases
            Dim newRel As ConceptRelationship = ConceptData.InsertConceptRelationshipFromProviderConceptRelationship(provConceptRel.IdAsInt, SessionState.CurrentUser.Login)
            If newRel IsNot Nothing Then
                provConceptRel.PCRConceptRelationshipFk = newRel.Id

                Dim c As DataSet = ConceptData.GetConceptDs(newRel.ConceptRelationshipConcept1Fk)
                res.MatchedName = c.Tables(0).Rows(0)("ConceptName1Fk").ToString

                res.MatchedConceptRelationship = newRel.ConceptRelationshipRelationship
                If matches.Length = 1 Then
                    provConceptRel.PCRLinkStatus = LinkStatus.Matched.ToString
                    res.Status = LinkStatus.Matched
                Else
                    provConceptRel.PCRLinkStatus = LinkStatus.Inserted.ToString
                    res.Status = LinkStatus.Inserted
                End If
            End If
        End If

        'Dim pc As ProviderConcept = ConceptData.GetProviderConcept(provId, provConceptRel.PCRConcept1Id)
        'pc.PCLinkStatus = provConceptRel.PCRLinkStatus
        'ConceptData.InsertUpdateProviderConcept(Nothing, pc, SessionState.CurrentUser.Login)

        'pc = ConceptData.GetProviderConcept(provId, provConceptRel.PCRConcept2Id)
        'pc.PCLinkStatus = provConceptRel.PCRLinkStatus
        'ConceptData.InsertUpdateProviderConcept(Nothing, pc, SessionState.CurrentUser.Login)

        ConceptData.InsertUpdateProviderConceptRelationship(Nothing, provConceptRel, SessionState.CurrentUser.Login)

        Return res
    End Function

    ''' <summary>
    ''' Insert or update a system editor Provider Concept Relationship record.
    ''' </summary>
    ''' <param name="pc">The rel to insert/update</param>
    ''' <param name="name1Fk">The Guid of name1 to link the concept to</param>
    ''' <param name="pn1">The existing name1 editor's ProviderName if it exists.  Will be created if it doesnt.</param>
    ''' <param name="name2Fk">The Guid of name2 to link the concept to</param>
    ''' <param name="pn2">The existing name2 editor's ProviderName if it exists.  Will be created if it doesnt.</param>
    ''' <param name="refFk">The Guid of the reference to link the concept to</param>
    ''' <param name="pr">The existing editor's ProviderReference for the concept if it exists.  Will be created if it doesnt.</param>
    ''' <remarks>If the provider concept is pointing (PCConceptFk) to "no" concept then a new concept is created for this provider concept.</remarks>
    Public Shared Sub InsertUpdateSystemProviderConcept(ByVal existingCRGuid As String, ByVal pc As ProviderConcept, ByVal pcTo As ProviderConcept, ByVal pcr As ProviderConceptRelationship, ByVal name1Fk As String, ByVal pn1 As ProviderName, ByVal name2Fk As String, ByVal pn2 As ProviderName, ByVal refFk As String, ByVal pr As ProviderReference)

        Dim sysImp As ProviderImport = BrUser.GetSystemProviderImport()

        'link to new provider name?
        If pn1 Is Nothing Then
            'create dummy name
            pn1 = New ProviderName
            pn1.PNNameFk = name1Fk
            pn1.PNNameId = Guid.NewGuid.ToString
            pn1.PNLinkStatus = LinkStatus.Inserted.ToString
            pn1.PNProviderImportFk = sysImp.IdAsInt
        End If

        If pn2 Is Nothing Then
            If name1Fk = name2Fk Then
                pn2 = pn1
            ElseIf name2Fk.Length > 0 Then
                'create dummy name
                pn2 = New ProviderName
                pn2.PNNameFk = name2Fk
                pn2.PNNameId = Guid.NewGuid.ToString
                pn2.PNLinkStatus = LinkStatus.Inserted.ToString
                pn2.PNProviderImportFk = sysImp.IdAsInt
            End If
        End If

        If pr Is Nothing AndAlso refFk IsNot Nothing AndAlso refFk.Length > 0 Then
            pr = New ProviderReference
            pr.PRReferenceFk = refFk
            pr.PRReferenceId = Guid.NewGuid.ToString
            pr.PRLinkStatus = LinkStatus.Inserted.ToString
            pr.PRProviderImportFk = sysImp.IdAsInt
        End If

        pc.PCName1Id = pn1.PNNameId
        If pn2 IsNot Nothing Then pcTo.PCName1Id = pn2.PNNameId
        If pr IsNot Nothing Then
            pc.PCAccordingToId = pr.PRReferenceId
            pcTo.PCAccordingToId = pr.PRReferenceId
        End If

        If pc.PCProviderImportFk = -1 Then
            pc.PCProviderImportFk = sysImp.IdAsInt
        End If

        If pcTo.PCProviderImportFk = -1 Then
            pcTo.PCProviderImportFk = sysImp.IdAsInt
        End If

        NameData.InsertUpdateProviderNameRecord(pn1, SessionState.CurrentUser.Login)
        If pn2 IsNot Nothing Then NameData.InsertUpdateProviderNameRecord(pn2, SessionState.CurrentUser.Login)
        If pr IsNot Nothing Then ReferenceData.InsertUpdateProviderReferenceRecord(pr, SessionState.CurrentUser.Login)

        ConceptData.InsertUpdateSystemProviderConcept(Nothing, pc, SessionState.CurrentUser.Login)
        ConceptData.InsertUpdateSystemProviderConcept(Nothing, pcTo, SessionState.CurrentUser.Login)
        pcr = ConceptData.InsertUpdateSystemProviderConceptRelationship(Nothing, pc.IdAsInt, pcr, SessionState.CurrentUser.Login)

        Dim cr As ConceptRelationship
        If pcr.PCRConceptRelationshipFk Is Nothing Then 'new concept rel
            cr = ConceptData.InsertConceptRelationshipFromProviderConceptRelationship(pcr.IdAsInt, SessionState.CurrentUser.Login)
            pcr.PCRConceptRelationshipFk = cr.Id
            ConceptData.InsertUpdateProviderConceptRelationship(Nothing, pcr, SessionState.CurrentUser.Login)
        Else
            cr = ConceptData.GetConceptRelationship(pcr.PCRConceptRelationshipFk)
        End If

        'deprecate old concept relationship??
        If existingCRGuid IsNot Nothing AndAlso existingCRGuid.Length > 0 Then
            Dim oldCr As ConceptRelationship = ConceptData.GetConceptRelationship(existingCRGuid)
            ConceptData.DeleteConceptRelationship(oldCr.ConceptRelationshipLSID, cr.ConceptRelationshipLSID, SessionState.CurrentUser.Login)
        End If

        If pc.PCConceptFk = -1 Then 'new concept
            pc.PCConceptFk = cr.ConceptRelationshipConcept1Fk
            ConceptData.InsertUpdateSystemProviderConcept(Nothing, pc, SessionState.CurrentUser.Login)
        End If

        If pcTo.PCConceptFk = -1 Then 'new concept
            pcTo.PCConceptFk = cr.ConceptRelationshipConcept2Fk
            ConceptData.InsertUpdateSystemProviderConcept(Nothing, pcTo, SessionState.CurrentUser.Login)
        End If

        BrConcepts.RefreshConceptData(pc.PCConceptFk) ', SessionState.CurrentUser.Login)
        BrConcepts.RefreshConceptData(pcTo.PCConceptFk) ', SessionState.CurrentUser.Login)
        BrConcepts.RefreshConceptRelationshipData(cr.Id)
        BrNames.RefreshNameData(name1Fk, False) ' SessionState.CurrentUser.Login)
    End Sub

    ''' <summary>
    ''' Insert a system provider concept for the specified name and concept type.
    ''' </summary>
    ''' <param name="name1Fk"></param>
    ''' <param name="name2Fk"></param>
    ''' <param name="relTypeFk"></param>    
    ''' <remarks>If the system concept already exists then it is updated, otherwise it is created.
    ''' If no system provider name exists for either of the name1 and name2 specified then a system provider name is created for these.</remarks>
    Public Shared Sub InsertUpdateSystemProviderConcept(ByVal name1Fk As String, ByVal name2Fk As String, ByVal relTypeFk As Integer, ByVal accToFk As String)
        Dim sysImp As ProviderImport = BrUser.GetSystemProviderImport()

        Dim pn1 As ProviderName = NameData.GetSystemProviderNameForName(name1Fk)
        Dim pn2 As ProviderName = NameData.GetSystemProviderNameForName(name2Fk)

        Dim sysPc As ProviderConcept = ConceptData.GetSystemProviderConcept(sysImp.IdAsInt, name1Fk, accToFk)
        If sysPc Is Nothing Then
            sysPc = New ProviderConcept
            sysPc.PCLinkStatus = LinkStatus.Inserted.ToString
            sysPc.PCProviderImportFk = sysImp.IdAsInt
            sysPc.PCConceptId = Guid.NewGuid.ToString()
        End If

        Dim sysPcTo As ProviderConcept = ConceptData.GetSystemProviderConcept(sysImp.IdAsInt, name2Fk, accToFk)
        If sysPcTo Is Nothing Then
            sysPcTo = New ProviderConcept
            sysPcTo.PCLinkStatus = LinkStatus.Inserted.ToString
            sysPcTo.PCProviderImportFk = sysImp.IdAsInt
            sysPcTo.PCConceptId = Guid.NewGuid.ToString()
        End If

        Dim sysPCR As ProviderConceptRelationship = ConceptData.GetSystemProviderConceptRelationship(sysImp.IdAsInt, sysPc.PCConceptId, sysPcTo.PCConceptId, relTypeFk)
        If sysPCR Is Nothing Then
            sysPCR = New ProviderConceptRelationship
            sysPCR.PCRLinkStatus = LinkStatus.Inserted.ToString()
            sysPCR.PCRProviderImportFk = sysImp.IdAsInt
            sysPCR.PCRConcept1Id = sysPc.PCConceptId
            sysPCR.PCRConcept2Id = sysPcTo.PCConceptId
            sysPCR.PCRRelationshipFk = relTypeFk
        End If

        InsertUpdateSystemProviderConcept(sysPCR.PCRConceptRelationshipFk, sysPc, sysPcTo, sysPCR, name1Fk, pn1, name2Fk, pn2, Nothing, Nothing)

        BrNames.RefreshNameData(name1Fk, True) 'SessionState.CurrentUser.Login)
    End Sub

    ''' <summary>
    ''' Deprecate the specified ProviderConcept.
    ''' Set the LinkStatus to Discarded
    ''' </summary>
    ''' <param name="PCPk"></param>
    ''' <remarks></remarks>
    Public Shared Sub DeprecateProviderConcept(ByVal PCPk As Integer)
        ConceptData.UpdateProviderConceptStatus(PCPk, LinkStatus.Discarded.ToString, SessionState.CurrentUser.Login)
    End Sub

End Class
