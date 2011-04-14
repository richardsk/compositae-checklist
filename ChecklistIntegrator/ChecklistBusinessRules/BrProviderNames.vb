Imports ChecklistDataAccess
Imports ChecklistObjects


Public Class BrProviderNames

    Private Shared mappings As List(Of NameMapping)

    Public Shared ReadOnly Property NameMappings() As List(Of NameMapping)
        Get
            If mappings Is Nothing Then
                mappings = NameData.GetNameMappings()
            End If
            Return mappings
        End Get
    End Property

    ''' <summary>
    ''' Unlinks all provider names for all child names below the specified name (nameGuid)
    ''' Then deprecates all the child names.
    ''' This will be done when a consensus name is "deleted", so all child names need to be un-hooked
    ''' </summary>
    ''' <param name="nameGuid"></param>
    ''' <remarks></remarks>
    Public Shared Sub UnlinkChildNames(ByVal nameGuid As String)
        Dim names As List(Of Name) = NameData.GetNameChildren(Nothing, nameGuid)

        For Each cn As Name In names
            'recurse children
            UnlinkChildNames(cn.Id)

            'unlink prov names & concepts
            Dim provNames As DataSet = NameData.GetProviderNameRecords(nameGuid)

            For Each pnRow As DataRow In provNames.Tables(0).Rows
                Dim pn As New ProviderName(pnRow, pnRow("PNPk").ToString, True)
                UpdateProviderNameLink(pn, Nothing) 'last unlink will deprecate consensus name
                UpdateProviderConceptLinks(pn)
            Next

            'unlink concepts
            BrNames.UpdateProviderConceptLinks(cn.Id)
        Next
    End Sub

    ''' <summary>
    ''' Splits a provider name from its currently linked cchecklist name
    ''' A new checklist name is created based on this provider name
    ''' </summary>
    ''' <param name="PNPk">Id of Provider Name to create a new Name for</param>
    ''' <returns>The new Name created for this provider name</returns>
    ''' <remarks></remarks>
    Public Shared Function SplitOffProviderName(ByVal PNPk As Integer) As Name
        Dim pn As ProviderName = NameData.GetProviderName(PNPk)

        Dim oldId As String = pn.PNNameFk

        Dim newName As Name = Name.FromProviderName(pn, NameMappings)

        'if new record has no parent then add to unknown node?
        'If newName.NameParentFk Is Nothing Then newName.NameParentFk = NameData.GetUknownTaxaGuid()

        NameData.InsertName(newName, SessionState.CurrentUser.Login)

        NameData.SetNameRelationships(newName.Id, pn.IdAsInt, SessionState.CurrentUser.Login)
        NameData.LinkNameRank(newName.Id, SessionState.CurrentUser.Login)

        NameData.UpdateProviderNameLink(PNPk, newName.Id, LinkStatus.ManualInsert.ToString, SessionState.CurrentUser.Login)

        pn.PNNameFk = newName.Id
        UpdateProviderConceptLinks(pn)

        'update old name data
        BrNames.RefreshNameData(oldId, False)

        BrNames.RefreshNameData(newName.Id, False)

        'refresh concepts
        BrNames.UpdateProviderConceptLinks(newName.Id)
        BrNames.UpdateProviderConceptLinks(oldId)

        newName = NameData.GetName(Nothing, newName.Id)

        Return newName
    End Function

    Public Shared Sub DiscardProviderName(ByVal PNPk As Integer)
        Dim pn As ProviderName = NameData.GetProviderName(PNPk)

        Dim oldId As String = pn.PNNameFk
        NameData.UpdateProviderNameLink(pn.IdAsInt, Nothing, LinkStatus.Discarded.ToString, SessionState.CurrentUser.Login)

        Dim provDs As DataSet = NameData.GetProviderNameRecords(oldId)
        If provDs.Tables.Count = 0 OrElse provDs.Tables(0).Rows.Count = 0 Then
            'name is deleted
            Dim nm As DataSet = NameData.GetNameDs(Nothing, oldId)

            'delete concepts as well
            Dim concds As DataSet = ConceptData.GetNameConceptsDs(oldId)
            If concds.Tables.Count > 0 Then
                For Each cr As DataRow In concds.Tables(0).Rows
                    ConceptData.DeleteConcept(cr("ConceptLSID").ToString, "unlinked", SessionState.CurrentUser.Login)
                Next
            End If

            'delete name
            NameData.DeleteNameRecord(Nothing, nm.Tables(0).Rows(0)("NameLSID").ToString, "unlinked", SessionState.CurrentUser.Login)
        End If

        'update associated concepts
        pn.PNNameFk = Nothing
        UpdateProviderConceptLinks(pn)

        If oldId IsNot Nothing Then
            BrNames.UpdateProviderConceptLinks(oldId)
        End If

        'update name data
        Dim rf As New List(Of RefreshData)
        rf.Add(New RefreshData(oldId, Nothing, False))
        BrNames.RefreshNameData(rf, True)

    End Sub

    ''' <summary>
    ''' Splits a provider name from its currently linked cchecklist name
    ''' and linked to the new specified name
    ''' </summary>
    ''' <param name="PNPk">Id of Provider Name to re-link</param>
    ''' <param name="linkToNameGuid">Id of name to link to, if null then Provider name is left un-linked</param>
    ''' <remarks>All concepts associated with the original provider name for the specified name are update to link to the updated names</remarks>
    Public Shared Sub SplitOffProviderName(ByVal PNPk As Integer, ByVal linkToNameGuid As String)
        Dim pn As ProviderName = NameData.GetProviderName(PNPk)

        Dim oldId As String = pn.PNNameFk
        Dim status As String = LinkStatus.ManualMatch.ToString
        If linkToNameGuid Is Nothing OrElse linkToNameGuid.Length = 0 Then status = LinkStatus.Unmatched.ToString
        NameData.UpdateProviderNameLink(pn.IdAsInt, linkToNameGuid, status, SessionState.CurrentUser.Login)

        'if no prov names left then name is deprecated, so remove all child names
        'If linkToNameGuid Is Nothing Then
        '    Dim pns As DataSet = NameData.GetProviderNameRecords(oldId)
        '    If pns.Tables(0).Rows.Count = 0 Then
        '        UnlinkChildNames(oldId)
        '    End If
        'End If

        'update associated concepts
        pn.PNNameFk = linkToNameGuid
        UpdateProviderConceptLinks(pn)
        BrNames.UpdateProviderConceptLinks(oldId)
        If linkToNameGuid IsNot Nothing Then
            BrNames.UpdateProviderConceptLinks(linkToNameGuid)
            'NameData.UpdateProviderConceptLinks(PNPk, SessionState.CurrentUser.Login)
        Else
            'update provider name concept links as it has been unlinked
            'NameData.UpdateProviderConceptLinks(PNPk, SessionState.CurrentUser.Login)
        End If

        'update name data
        Dim rf As New List(Of RefreshData)
        rf.Add(New RefreshData(oldId, Nothing, False))
        If linkToNameGuid IsNot Nothing Then rf.Add(New RefreshData(linkToNameGuid, Nothing, False))
        BrNames.RefreshNameData(rf, True)

    End Sub

    Public Shared Function GetProviderNameForName(ByVal nameGuid As String, ByVal providerPk As Integer) As ProviderName
        Dim pn As ProviderName

        Dim ds As DataSet = NameData.GetProviderNameRecords(nameGuid)
        For Each r As DataRow In ds.Tables(0).Rows
            If r("ProviderPk") = providerPk Then
                pn = New ProviderName(r, r("PNPk").ToString, True)
                Exit For
            End If
        Next

        Return pn
    End Function

    Private Shared Function GetMatchingNames(ByVal pn As ProviderName, ByRef matchScore As Integer) As List(Of NameMatch)
        Dim results As DataSet = Nothing
        Dim done As Boolean = False

        'TODO - get from xml config file
        Dim routines As New List(Of INameMatcher)
        routines.Add(New NamesWithSameParent(1, 2, 2))
        routines.Add(New NamesAtRankWithAncestor(2, -1, 3))
        routines.Add(New NamesWithExactCanonical(3, -1, 4))
        routines.Add(New NamesWithYear(4, -1, 5))
        routines.Add(New NamesWithAuthors(5, -1, -1))

        Dim nm As INameMatcher = routines(0)

        While Not done

            Dim tmpRes As DataSet = Nothing
            If results IsNot Nothing Then tmpRes = results.Copy()

            If results Is Nothing Then
                results = nm.GetMatchingNames(pn)
            Else
                nm.RemoveNonMatches(pn, results)
            End If

            'get next matcher
            Dim nextId As Integer = -1
            If results.Tables(0).Rows.Count = 0 Then
                'revert to last set then go to fail id
                If nm.FailId = -1 Then
                    'failed
                    done = True
                Else
                    results = tmpRes
                    nextId = nm.FailId
                End If
            Else
                nextId = nm.SuccessId
            End If

            If nextId <> -1 Then
                For Each m As INameMatcher In routines
                    If m.Id = nextId Then
                        nm = m
                        Exit For
                    End If
                Next
            Else
                done = True
            End If

        End While

        Dim names As New List(Of NameMatch)
        For Each row As DataRow In results.Tables(0).Rows
            Dim match As New NameMatch
            match.NameFull = row("NameFull").ToString
            match.NameId = row("NameGuid").ToString
            names.Add(match)
        Next

        Return names
    End Function

    ''' <summary>
    ''' Finds Name matches for a provider name and updates the provider name to point to the matched name
    ''' If 0 matches then a new Name is inserted (added to Unknown taxa tree node if parent is unknown/null)
    ''' If 1 match then the Provider Name record is linked to this Name, and Provider Concepts are linked to associated conecpts
    ''' If >1 mathes then a 'multiple match' status is set
    ''' </summary>
    ''' <param name="provName"></param>
    ''' <returns>The integration result</returns>
    ''' <remarks>
    ''' The rank is first linked to the equivalent rank in the tblRank table.  
    ''' This must be done first so mathces on the rank are more efficient.
    ''' </remarks>
    Public Shared Function MatchAndUpdateProviderName(ByVal provName As ProviderName) As MatchResult
        Dim res As New MatchResult

        'update ranks and relationships
        provName.PNNameRankFk = NameData.LinkProviderNameRank(Nothing, provName.IdAsInt, SessionState.CurrentUser.Login)

        'update authors
        'NameData.UpdateProviderNameAuthors(Nothing, provName.IdAsInt, SessionState.CurrentUser.Login)
        UpdateProviderNameAuthors(provName)

        'rank, canonical must be non null
        If provName.PNNameRankFk = -1 OrElse provName.PNNameCanonical Is Nothing OrElse provName.PNNameCanonical.Length = 0 Then
            provName.PNLinkStatus = LinkStatus.DataFail.ToString
            provName.PNNameFk = Nothing
            NameData.InsertUpdateProviderNameRecord(provName, SessionState.CurrentUser.Login)

            Dim msg As String = "Failed to integrate record with Id : " + provName.Id + " : NameRank '" + provName.PNNameRank + "' is not recognised or the NameCanonical is empty."
            Throw New ChecklistException(msg)
        Else
            Dim matchScore As Integer = -1

            Dim matches As List(Of NameMatch) = NameData.GetMatchingNames(provName.IdAsInt, matchScore)

            'Dim matches As List(Of NameMatch) = GetMatchingNames(provName, matchScore)

            If matches.Count = 0 Then
                'insert new name for this record?

                Dim parentPN As ProviderName = ConceptData.GetParentProviderName(provName.IdAsInt)
                Dim parFk As String = Nothing
                Dim parNameFull As String = String.Empty

                Dim provPk As Integer = -1
                Dim pcr As ProviderConceptRelationship

                If parentPN IsNot Nothing AndAlso parentPN.PNNameFk Is Nothing Then
                    'parent has not been linked up so we cant add this name
                    res.Status = LinkStatus.ParentNotIntegrated
                    provName.PNLinkStatus = res.Status.ToString
                    NameData.InsertUpdateProviderNameRecord(provName, SessionState.CurrentUser.Login)
                Else
                    Dim newName As Name = Name.FromProviderName(provName, NameMappings)

                    'if no parent, then is there a possible parent concept from matching?
                    If parentPN Is Nothing Then
                        Dim parName As Name = NameData.GetMatchedParentName(provName.IdAsInt)
                        If parName IsNot Nothing Then
                            If parName.Id = Guid.Empty.ToString Then
                                res.Status = LinkStatus.MultipleParent
                            Else
                                parFk = parName.Id
                                parNameFull = parName.NameFull
                            End If
                        End If
                    Else
                        parFk = parentPN.PNNameFk
                        parNameFull = parentPN.PNNameFull
                    End If

                    If res.Status = LinkStatus.MultipleParent Then
                        provName.PNLinkStatus = LinkStatus.MultipleParent.ToString
                        NameData.InsertUpdateProviderNameRecord(provName, SessionState.CurrentUser.Login)
                    Else
                        'if new record has no parent then set to parentMissing OR add to unknown node ??
                        If parFk Is Nothing Then
                            If Configuration.ConfigurationManager.AppSettings.Get("AddNamesToUnknownNode").ToLower = "true" Then
                                newName.NameParentFk = NameData.GetUknownTaxaGuid()
                            Else
                                provName.PNLinkStatus = LinkStatus.ParentMissing.ToString
                                res.Status = LinkStatus.ParentMissing

                                NameData.InsertUpdateProviderNameRecord(provName, SessionState.CurrentUser.Login)
                            End If
                        Else
                            newName.NameParentFk = parFk
                            newName.NameParent = parNameFull
                        End If


                        If res.Status <> LinkStatus.ParentMissing Then
                            NameData.InsertName(newName, SessionState.CurrentUser.Login)
                            provName.PNLinkStatus = LinkStatus.Inserted.ToString
                            provName.PNNameFk = newName.Id


                            NameData.InsertUpdateProviderNameRecord(provName, SessionState.CurrentUser.Login)

                            'update authors
                            BrNames.UpdateConsensusAuthors(newName)

                            'hook up to consensus concept
                            If pcr IsNot Nothing Then
                                ConceptData.InsertConceptRelationshipFromProviderConceptRelationship(pcr.IdAsInt, SessionState.CurrentUser.Login)
                            End If

                            res.MatchedId = newName.Id
                            res.MatchedName = newName.NameFull
                            res.Status = LinkStatus.Inserted
                        End If
                    End If
                End If
            ElseIf matches.Count = 1 Then
                'exact match
                provName.PNLinkStatus = LinkStatus.Matched.ToString
                provName.PNNameFk = matches(0).NameId
                provName.PNNameMatchScore = matchScore

                res.MatchedId = matches(0).NameId
                res.MatchedName = matches(0).NameFull
                res.Status = LinkStatus.Matched

                NameData.InsertUpdateProviderNameRecord(provName, SessionState.CurrentUser.Login)
            Else
                'multiple matches - will need manual correction
                provName.PNLinkStatus = LinkStatus.Multiple.ToString
                provName.PNNameMatchScore = matchScore
                res.Status = LinkStatus.Multiple

                NameData.InsertUpdateProviderNameRecord(provName, SessionState.CurrentUser.Login)
            End If

            If res.Status = LinkStatus.Inserted And provName.PNNameFk IsNot Nothing Then
                NameData.SetNameRelationships(provName.PNNameFk, provName.IdAsInt, SessionState.CurrentUser.Login)
            End If

            If res.Status = LinkStatus.Matched Then
                BrNames.RefreshNameData(res.MatchedId, True)
            End If
        End If

        Return res
    End Function


    ''' <summary>
    ''' Update Provider Name to link to specified Name id
    ''' </summary>
    ''' <param name="provName"></param>
    ''' <param name="nameGuid"></param>
    ''' <remarks>Sets the link status to ManualMatch as this match has been done by manual intervention</remarks>
    Public Shared Sub UpdateProviderNameLink(ByVal provName As ProviderName, ByVal nameGuid As String)
        Dim oldId As String = provName.PNNameFk

        provName.PNNameFk = nameGuid
        provName.PNLinkStatus = LinkStatus.ManualMatch.ToString
        If nameGuid Is Nothing OrElse nameGuid.Length = 0 Then provName.PNLinkStatus = LinkStatus.Unmatched.ToString

        NameData.UpdateProviderNameLink(provName.IdAsInt, provName.PNNameFk, provName.PNLinkStatus, SessionState.CurrentUser.Login)

        If oldId IsNot Nothing Then
            'update associated concepts
            BrNames.UpdateProviderConceptLinks(oldId)
            If nameGuid IsNot Nothing Then BrNames.UpdateProviderConceptLinks(nameGuid)
        Else
            Dim updatedNames As DataSet = NameData.UpdateProviderNameConceptLinks(provName.IdAsInt, SessionState.CurrentUser.Login)
            If updatedNames IsNot Nothing AndAlso updatedNames.Tables.Count > 0 Then
                For Each row As DataRow In updatedNames.Tables(0).Rows
                    BrNames.RefreshNameData(row("NameGuid").ToString, False)
                Next
            End If
        End If

        'update name data
        Dim rf As New List(Of RefreshData)
        If nameGuid IsNot Nothing Then rf.Add(New RefreshData(nameGuid, Nothing, False))
        If oldId IsNot Nothing Then rf.Add(New RefreshData(oldId, Nothing, False))
        BrNames.RefreshNameData(rf, True)
    End Sub

    Public Shared Sub UpdateProviderConceptLinks(ByVal pn As ProviderName)
        If pn.PNNameFk Is Nothing Then
            'unlink
            NameData.UnlinkProviderConcepts(pn.IdAsInt, SessionState.CurrentUser.Login)
        Else
            Dim refreshedPCs As New ArrayList
            Dim ds As DataSet = NameData.GetProviderNameConcepts(pn.IdAsInt)
            For Each row As DataRow In ds.Tables(0).Rows
                If Not refreshedPCs.Contains(row("PCRPk")) Then
                    ConceptData.InsertConceptRelationshipFromProviderConceptRelationship(row("PCRPk"), SessionState.CurrentUser.Login)
                    refreshedPCs.Add(row("PCRPk"))
                End If
            Next
        End If
    End Sub

    Public Shared Function UpdateProviderNameAuthors(ByVal provName As ProviderName) As ProviderNameAuthors

        Dim pna As New ProviderNameAuthors

        NameData.DeleteProviderNameAuthors(provName.IdAsInt)

        Dim nameAuth As DataSet = Nothing

        'bas
        If provName.PNBasionymAuthors IsNot Nothing Then
            Dim authors As String = ""

            Dim basAuth As Author = BrAuthors.GetAuthorByName(provName.PNBasionymAuthors)
            Dim basEx As String = BrAuthors.GetExAuthors(provName.PNBasionymAuthors)

            If basAuth IsNot Nothing Then
                'exact match
                authors = basAuth.AuthorPk.ToString
            Else
                authors = BrAuthors.ParseAuthors(provName.PNBasionymAuthors)
            End If

            nameAuth = NameData.InsertUpdateProviderNameAuthor(-1, provName.IdAsInt, authors, Nothing, basEx, Nothing, False, SessionState.CurrentUser.Login)

            pna.BasionymAuthors = authors
            pna.BasionymExAuthors = basEx
        End If


        'comb
        If provName.PNCombinationAuthors IsNot Nothing Then
            Dim authors As String = ""

            Dim combAuth As Author = BrAuthors.GetAuthorByName(provName.PNCombinationAuthors)
            Dim combEx As String = BrAuthors.GetExAuthors(provName.PNCombinationAuthors)

            If combAuth IsNot Nothing Then
                'exact match
                authors = combAuth.AuthorPk.ToString
            Else
                authors = BrAuthors.ParseAuthors(provName.PNCombinationAuthors)
            End If

            If nameAuth Is Nothing Then
                NameData.InsertUpdateProviderNameAuthor(-1, provName.IdAsInt, Nothing, authors, Nothing, combEx, False, SessionState.CurrentUser.Login)
            Else
                'reuse name authors used to create bas authors
                Dim ar As DataRow = nameAuth.Tables(0).Rows(0)
                NameData.InsertUpdateProviderNameAuthor(ar("PNAPk"), provName.IdAsInt, ar("PNABasionymAuthors").ToString, authors, ar("PNABasExAuthors").ToString, combEx, False, SessionState.CurrentUser.Login)
            End If

            pna.CombinationAuthors = authors
            pna.CombinationExAuthors = combEx
        End If

        Return pna
    End Function



    ''' <summary>
    ''' Delete the Provider Name specified, then update the data of the Name it used to link to 
    ''' </summary>
    ''' <param name="PNPk"></param>
    ''' <param name="user"></param>
    ''' <remarks></remarks>
    Public Shared Sub DeleteProviderName(ByVal PNPk As Integer, ByVal user As String)
        Dim pn As ProviderName = NameData.GetProviderName(PNPk)
        NameData.DeleteProviderName(PNPk)

        If pn.PNNameFk IsNot Nothing Then BrNames.RefreshNameData(pn.PNNameFk, True)
    End Sub

    ''' <summary>
    ''' Inserts or updates an existing system ProviderName
    ''' </summary>
    ''' <param name="nameGuid">The Id of the name to insert a system provider name for</param>
    ''' <param name="existingPN">The existing provider name, if one exists</param>
    ''' <remarks></remarks>
    Public Shared Sub InsertUpdateSystemProviderName(ByVal nameGuid As String, ByVal existingPN As ProviderName)
        If existingPN Is Nothing Then existingPN = New ProviderName

        existingPN.PNNameFk = nameGuid
        existingPN.PNLinkStatus = LinkStatus.Inserted.ToString

        If existingPN.PNProviderImportFk = -1 Then
            Dim curImp As ProviderImport = BrUser.GetSystemProviderImport()
            existingPN.PNProviderImportFk = curImp.IdAsInt
        End If

        If existingPN.PNNameId Is Nothing OrElse existingPN.PNNameId.Length = 0 Then
            existingPN.PNNameId = Guid.NewGuid.ToString
        End If

        NameData.InsertUpdateProviderNameRecord(existingPN, SessionState.CurrentUser.Login)

        BrNames.RefreshNameData(nameGuid, False)
    End Sub

End Class
