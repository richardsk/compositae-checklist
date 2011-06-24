Imports System.Collections.Generic

Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class BrNames

    Public Delegate Sub StatusDelegate(ByVal percComplete As Integer, ByVal msg As String)

    Public Shared StatusCallback As StatusDelegate
    Public Shared Cancel As Boolean = False

    ''' <summary>
    ''' Refreshes Name record data
    ''' Update relationships links (rank, parent, preferred, basiony, homonym, etc ...)
    ''' based on the existing relationships for the specified ProviderName (if provided).
    ''' Then update all Name data from source ProviderName records
    ''' </summary>
    ''' <param name="refreshList">List of RefreshData - NameGuids (keys) and ProviderName Pks (value) for Names to update</param>
    ''' <remarks></remarks>
    Public Shared Sub RefreshNameData(ByVal refreshList As List(Of RefreshData), ByVal includeConcepts As Boolean)
        Dim refreshedNames As String = " "

        For Each rf As RefreshData In refreshList
            If refreshedNames.IndexOf(" " + rf.NameGuid + " ") = -1 Then
                refreshedNames += rf.NameGuid + " "

                'rank
                NameData.LinkNameRank(rf.NameGuid, SessionState.CurrentUser.Login)

                'update relationships (if provider pk exists - for inserted/new names)
                If rf.IsNew Then
                    NameData.SetNameRelationships(rf.NameGuid, rf.PNPk, SessionState.CurrentUser.Login)
                ElseIf rf.PNPk <> -1 Then
                    'otherwise update provider name relationships for existing names
                    NameData.UpdateProviderNameRelationships(rf.PNPk, SessionState.CurrentUser.Login)
                End If

                'refresh Name data
                RefreshNameData(rf.NameGuid, includeConcepts)
            End If
        Next
    End Sub

    Private Shared Function GetConsensusValue(ByVal provRecords As DataSet, ByVal sourceCol As String) As Object
        Dim vals As New Hashtable
        Dim sysVal As Object = DBNull.Value

        For Each row As DataRow In provRecords.Tables(0).Rows
            If Not row.IsNull("ProviderIsEditor") AndAlso row("ProviderIsEditor") AndAlso Not row.IsNull(sourceCol) Then
                sysVal = row(sourceCol)
                Exit For
            End If

            If row(sourceCol).ToString.Length > 0 Then
                If vals.ContainsKey(row(sourceCol)) Then
                    vals(row(sourceCol)) += 1
                Else
                    If row(sourceCol) IsNot DBNull.Value Then vals.Add(row(sourceCol), 1)
                End If
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

        'always return something for canonical name
        If sourceCol = "PNNameCanonical" Then Return val

        If hasEqual Then Return DBNull.Value

        'if authors is null then see if we can get a corrected author
        If sourceCol = "PNNameAuthors" Then

        End If

        Return val
    End Function

    Private Shared Function CalculateMatchScore(ByVal concName As DataRow, ByVal provName As DataRow) As Integer
        Dim match As Integer = 0

        Dim tally As Integer = 0
        Dim count As Integer = 0

        For Each nm As NameMapping In BrProviderNames.NameMappings
                If provName(nm.NameMappingSourceCol).ToString <> concName(nm.NameMappingDestCol).ToString Then
                tally += nm.MatchWeighting
            End If
            count += 1
        Next

        match = 100 - (tally * 100 / BrProviderNames.NameMappings.Count)

        Return match
    End Function


    ''' <summary>
    ''' Refresh the Name data from the source Provider Name records.
    ''' Only the fields are refreshed.  The rank is not updated.
    ''' Parent and Preferred Fks are updated from the Concepts.
    ''' </summary>
    ''' <param name="nameGuid"></param>
    ''' <remarks></remarks>
    Public Shared Sub RefreshNameData(ByVal nameGuid As String, ByVal includeConcepts As Boolean)

        'get name
        Dim ds As DataSet = NameData.GetNameDs(Nothing, nameGuid)
        If ds.Tables(0).Rows.Count = 0 Then Return 'has been deprecated

        Dim updateName As DataRow = ds.Tables(0).Rows(0)

        'get provider names
        Dim providerNames As DataSet = NameData.GetProviderNameRecords(nameGuid)

        Dim updatedPns As DataSet = providerNames.Clone
        For Each pn As DataRow In providerNames.Tables(0).Rows
            Dim newPn As DataRow = NameData.UpdateProviderNameRelationships(pn("PNPk"), SessionState.CurrentUser.Login)
            If newPn IsNot Nothing Then
                updatedPns.Tables(0).ImportRow(newPn)
            Else
                updatedPns.Tables(0).ImportRow(pn) 'is a system provider name
            End If
        Next

        'calculate consensus values
        For Each nm As NameMapping In BrProviderNames.NameMappings
            If nm.NameMappingSourceCol <> "PNParentNameFk" Then 'dont update parent as this upsets the tree
                Dim val As Object = GetConsensusValue(updatedPns, nm.NameMappingSourceCol)
                updateName(nm.NameMappingDestCol) = val
            End If
        Next

        'set rank string
        If Not updateName.IsNull("NameRankFk") Then
            For Each r As Rank In RankData.GetRanks()
                If r.IdAsInt = updateName("NameRankFk") Then
                    updateName("NameRank") = r.Name
                    Exit For
                End If
            Next
        End If

        'name reference
        Dim ref As String = NameData.GetNameRefCitation(nameGuid)
        If ref IsNot Nothing Then updateName("NamePublishedIn") = ref

        'update name
        Dim uName As New Name(updateName, nameGuid)
        NameData.UpdateName(uName, SessionState.CurrentUser.Login)


        'update match scores
        For Each pn As DataRow In updatedPns.Tables(0).Rows
            Dim match As Integer = CalculateMatchScore(updateName, pn)
            NameData.UpdateProviderNameMatchScore(pn("PNPk"), match, SessionState.CurrentUser.Login)
            BrProviderNames.UpdateProviderNameAuthors(New ProviderName(pn, pn("PNPk").ToString, True))
        Next

        'update authors
        UpdateConsensusAuthors(uName)

        'other data
        BrOtherData.RefreshNameOtherData(nameGuid)

        If includeConcepts Then
            Dim concs As DataSet = RefreshNameConcepts(nameGuid)
            NameData.RefreshNameRelationData(nameGuid, SessionState.CurrentUser.Login)

        End If
    End Sub

    Public Shared Sub UpdateConsensusAuthors(ByVal updateName As Name)

        Dim hasEdBas As Boolean = False
        Dim hasEdComb As Boolean = False
        Dim basVal As Object = Nothing
        Dim combVal As Object = Nothing
        Dim basExVal As Object = Nothing
        Dim combExVal As Object = Nothing

        'update editor prov name authors?
        Dim sysPn As ProviderName = NameData.GetSystemProviderNameForName(updateName.Id)
        If sysPn IsNot Nothing AndAlso sysPn.PNLinkStatus <> LinkStatus.Discarded.ToString Then
            Dim pna As ProviderNameAuthors = BrProviderNames.UpdateProviderNameAuthors(sysPn)

            If sysPn.PNBasionymAuthors IsNot Nothing Then
                hasEdBas = True
                basVal = pna.BasionymAuthors
                basExVal = pna.BasionymExAuthors
            End If

            If sysPn.PNCombinationAuthors IsNot Nothing Then
                hasEdComb = True
                combVal = pna.CombinationAuthors
                combExVal = pna.CombinationExAuthors
            End If
        End If

        'get majority authors from prov names 

        Dim provNames As DataSet = NameData.GetProviderNameAuthors(updateName.Id)

        'update prov records to corrected values
        For Each row As DataRow In provNames.Tables(0).Rows
            If Not row.IsNull("PNABasionymAuthors") Then row("PNABasionymAuthors") = BrAuthors.GetCorrectedAuthors(row("PNABasionymAuthors").ToString)
            If Not row.IsNull("PNACombinationAuthors") Then row("PNACombinationAuthors") = BrAuthors.GetCorrectedAuthors(row("PNACombinationAuthors").ToString)
            If Not row.IsNull("PNABasExAuthors") Then row("PNABasExAuthors") = BrAuthors.GetCorrectedAuthors(row("PNABasExAuthors").ToString)
            If Not row.IsNull("PNACombExAuthors") Then row("PNACombExAuthors") = BrAuthors.GetCorrectedAuthors(row("PNACombExAuthors").ToString)
        Next

        If Not hasEdBas Then
            basVal = GetConsensusValue(provNames, "PNABasionymAuthors").ToString
            basExVal = GetConsensusValue(provNames, "PNABasExAuthors").ToString
        End If
        If Not hasEdComb Then
            combVal = GetConsensusValue(provNames, "PNACombinationAuthors").ToString
            combExVal = GetConsensusValue(provNames, "PNACombExAuthors").ToString
        End If

        'corrected author ids
        'Dim basAuth As String = BrAuthors.GetCorrectedAuthors(basVal.ToString)
        'Dim combAuth As String = BrAuthors.GetCorrectedAuthors(combVal.ToString)
        'Dim basEx As String = BrAuthors.GetCorrectedAuthors(basExVal.ToString)
        'Dim combEx As String = BrAuthors.GetCorrectedAuthors(combExVal.ToString)

        Dim nameAuth As DataSet = NameData.GetNameAuthors(updateName.Id)
        If nameAuth IsNot Nothing AndAlso nameAuth.Tables.Count > 0 AndAlso nameAuth.Tables(0).Rows.Count > 0 Then
            Dim ar As DataRow = nameAuth.Tables(0).Rows(0)
            NameData.InsertUpdateNameAuthor(ar("NameAuthorsPk"), updateName.Id, basVal, combVal, basExVal, combExVal, True, SessionState.CurrentUser.Login)
        Else
            NameData.InsertUpdateNameAuthor(-1, updateName.Id, basVal, combVal, basExVal, combExVal, True, SessionState.CurrentUser.Login)
        End If

        Dim fullAuth As String = BrAuthors.GetFullAuthorString(basVal, combVal, basExVal, combExVal, True)

        updateName.NameBasionymAuthors = BrAuthors.GetFullAuthorString(basVal, "", basExVal, "", False)
        updateName.NameCombinationAuthors = BrAuthors.GetFullAuthorString("", combVal, "", combExVal, False)
        updateName.NameAuthors = fullAuth

        NameData.UpdateName(updateName, SessionState.CurrentUser.Login)
    End Sub

    Public Shared Function RefreshNameConcepts(ByVal nameGuid As String) As DataSet
        Dim refreshedConcs As New ArrayList
        Dim refreshedCRs As New ArrayList

        Dim concs As DataSet = ConceptData.GetNameConceptRelationshipRecordsDs(nameGuid, True)

        For Each row As DataRow In concs.Tables(0).Rows
            If Not refreshedConcs.Contains(row("ConceptRelationshipConcept1Fk")) AndAlso _
                row("ConceptName1Fk").ToString = nameGuid Then
                BrConcepts.RefreshConceptData(row("ConceptRelationshipConcept1Fk"))
                refreshedConcs.Add(row("ConceptRelationshipConcept1Fk"))
            End If
            If Not refreshedConcs.Contains(row("ConceptRelationshipConcept2Fk")) AndAlso _
                row("ConceptToName1Fk").ToString = nameGuid Then
                BrConcepts.RefreshConceptData(row("ConceptRelationshipConcept2Fk"))
                refreshedConcs.Add(row("ConceptRelationshipConcept2Fk"))
            End If
            If Not refreshedCRs.Contains(row("ConceptRelationshipGuid")) Then
                BrConcepts.RefreshConceptRelationshipData(row("ConceptRelationshipGuid"))
                refreshedCRs.Add(row("ConceptRelationshipGuid"))
            End If
        Next

        Return concs
    End Function

    ''' <summary>
    ''' Refresh all name fields that are links to other names.
    ''' Eg NamePreferred is updated to the NameFull of the Name pointed to by NamePreferredFk.
    ''' </summary>
    ''' <param name="nameGuid"></param>
    ''' <remarks></remarks>
    Public Shared Sub RefreshNameLinkData(ByVal nameGuid As String)
        NameData.RefreshNameLinkData(nameGuid, SessionState.CurrentUser.Login)
    End Sub


    ''' <summary>
    ''' Refreshes all name data for the children of the specified name.
    ''' This will ensure that the NameParent links and details are up to date
    ''' </summary>
    ''' <param name="nameGuid"></param>
    ''' <remarks></remarks>
    Public Shared Sub RefreshChildNames(ByVal nameGuid As String)
        Dim children As List(Of Name) = NameData.GetNameChildren(Nothing, nameGuid)
        For Each n As Name In children
            RefreshNameData(n.Id, True)
        Next
    End Sub

    ''' <summary>
    ''' Refreshes all names that need to be refreshed, ie the names that have an older updated date than
    ''' their provider names
    ''' </summary>
    ''' <remarks></remarks>
    Public Shared Sub RefreshAllNames(ByVal forceAll As Boolean)
        Try
            Cancel = False
            Dim names As DataSet
            If forceAll Then
                names = NameData.GetAllNamesForUpdate(Nothing)
            Else
                names = NameData.GetNamesForUpdate(Nothing)
            End If
            If StatusCallback IsNot Nothing Then StatusCallback.Invoke(1, "Updating names")

            Dim index As Integer = 1
            If names IsNot Nothing AndAlso names.Tables.Count > 0 Then
                For Each row As DataRow In names.Tables(0).Rows
                    Dim perc As Integer = index * 100 / names.Tables(0).Rows.Count

                    Try
                        RefreshNameData(row("NameGuid"), True)
                        RefreshNameLinkData(row("NameGuid"))
                    Catch ex As Exception
                        ChecklistException.LogError(ex)
                        If StatusCallback IsNot Nothing Then StatusCallback.Invoke(perc, "ERROR : Failed to update name " + row("NameFull").ToString + " (" + row("NameGuid").ToString + ")")
                    End Try

                    If perc > 99 Then perc = 99
                    If perc < 1 Then perc = 1
                    If StatusCallback IsNot Nothing Then StatusCallback.Invoke(perc, "Updating name " + index.ToString + " of " + names.Tables(0).Rows.Count.ToString)
                    index += 1
                    If Cancel Then Exit For
                Next
            End If

            If Cancel Then
                If StatusCallback IsNot Nothing Then StatusCallback.Invoke(100, "Cancelled")
            Else
                If StatusCallback IsNot Nothing Then StatusCallback.Invoke(100, "Complete")
            End If
        Catch ex As Exception
            ChecklistException.LogError(ex)
            If StatusCallback IsNot Nothing Then StatusCallback.Invoke(100, "Update failed")
        End Try

    End Sub

    Public Shared Function GetNamesInReference(ByVal refGuid As String) As ArrayList
        Dim names As New ArrayList

        Dim ds As DataSet = NameData.GetNamesInReference(refGuid)
        If ds.Tables.Count > 0 Then
            For Each row As DataRow In ds.Tables(0).Rows
                Dim nm As New Name(row, row("NameGuid").ToString)
                names.Add(nm)
            Next
        End If

        Return names
    End Function

    ''' <summary>
    ''' Merges two names
    ''' Deletes the nameToMerge name and links all provider names that were to this name, to 
    ''' the nameToKeep
    ''' The nameToKeep is then refreshed so the merged provider data influences the name data
    ''' </summary>
    ''' <param name="nameToKeepId"></param>
    ''' <param name="nameToMergeId"></param>
    ''' <returns>The DataRow of the name to keep details before the merge</returns>
    ''' <remarks>
    ''' Any Concepts that linked to the old name will need to link to the new name.
    ''' Any children of the old name will need to point at the new name.
    ''' </remarks>
    Public Shared Function MergeNames(ByVal nameToKeepId As String, ByVal nameToMergeId As String) As DataRow
        Dim keepNameRow As DataRow
        Dim cnn As SqlClient.SqlConnection

        If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Started Merge, " + DateTime.Now.ToString())

        Try
            cnn = New SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString)
            cnn.Open()

            'set all provider names for other name to this name
            NameData.RelinkProviderNames(Nothing, nameToMergeId, nameToKeepId, LinkStatus.Merge.ToString, SessionState.CurrentUser.Login)

            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Relinked Provider Names, " + DateTime.Now.ToString())

            'move any children of other name
            BrNames.MoveNameChildren(nameToMergeId, nameToKeepId, SessionState.CurrentUser.Login)

            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Moved Children of Merged Name, " + DateTime.Now.ToString())

            ConceptData.MergeNameConcepts(Nothing, nameToKeepId, nameToMergeId, SessionState.CurrentUser.Login)

            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Merged Concepts, " + DateTime.Now.ToString())

            Dim oldName As Name = NameData.GetName(Nothing, nameToMergeId)
            Dim keepName As Name = NameData.GetName(Nothing, nameToKeepId)

            keepNameRow = NameData.GetNameDs(Nothing, nameToKeepId).Tables(0).Rows(0)

            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Name LSIDs selected, " + DateTime.Now.ToString())

            'delete other name
            NameData.DeleteNameRecord(Nothing, oldName.NameLSID, keepName.NameLSID, SessionState.CurrentUser.Login)

            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Deleted other Name, " + DateTime.Now.ToString())

            'update associated concepts
            'ConceptData.UpdateConceptLinks(nameToMergeId, SessionState.CurrentUser.Login)
            'ConceptData.UpdateConceptLinks(nameToKeepId, SessionState.CurrentUser.Login)

            UpdateProviderConceptLinks(nameToMergeId)
            UpdateProviderConceptLinks(nameToKeepId)

            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Updated Concept Links to Megred Names, " + DateTime.Now.ToString())

            'refresh this names data
            RefreshNameData(nameToKeepId, True) ' SessionState.CurrentUser.Login)

            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Refreshed Name Data, " + DateTime.Now.ToString())

            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Merge Complete, " + DateTime.Now.ToString())
        Catch ex As Exception
            If ChecklistGlobal.DoLogging Then ChecklistException.LogMessage("Merge Failed, " + DateTime.Now.ToString())

            Throw New ChecklistException("Failed to merge names : " + ex.Message)
        Finally
            If cnn IsNot Nothing Then cnn.Close()
        End Try

        Return keepNameRow
    End Function

    'update all provider concepts for the name to make sure they point to the correct consensus concepts
    Public Shared Sub UpdateProviderConceptLinks(ByVal nameGuid As String)
        Dim insPCRs As New ArrayList
        Dim provCR As DataSet = ConceptData.GetProviderConceptRelationshipRecords(nameGuid, True)

        For Each row As DataRow In provCR.Tables(0).Rows
            If Not insPCRs.Contains(row("PCRPk")) Then
                ConceptData.InsertConceptRelationshipFromProviderConceptRelationship(row("PCRPk"), SessionState.CurrentUser.Login)
                insPCRs.Add(row("PCRPk"))
            End If
        Next
    End Sub

    Public Shared Sub MoveNameChildren(ByVal fromNameGuid As String, ByVal toNameGuid As String, ByVal user As String)
        Dim children As DataSet = NameData.GetChildNames(fromNameGuid, False)

        NameData.MoveNameChildren(Nothing, fromNameGuid, toNameGuid, user)

        'add system parent concept for each child name
        For Each cn As DataRow In children.Tables(0).Rows
            BrProviderConcepts.InsertUpdateSystemProviderConcept(cn("NameGuid").ToString, toNameGuid, RelationshipType.RelationshipTypeParent, Nothing)
        Next
    End Sub

    Public Shared Sub MoveName(ByVal nameId As String, ByVal newParentId As String)
        BrProviderConcepts.InsertUpdateSystemProviderConcept(nameId, newParentId, RelationshipType.RelationshipTypeParent, Nothing)
    End Sub

    'Public Shared Sub DeleteName(ByVal nameGuid As String)
    '    Dim cnn As SqlClient.SqlConnection
    '    Dim trans As SqlClient.SqlTransaction
    '    Try
    '        cnn = New SqlClient.SqlConnection(Configuration.ConfigurationManager.ConnectionStrings("compositae").ConnectionString)
    '        cnn.Open()
    '        trans = cnn.BeginTransaction()

    '        'update provider names that pointed to this name to point to no name
    '        NameData.RelinkProviderNames(trans, nameGuid, Nothing, SessionState.CurrentUser.Login)

    '        'delete name
    '        ChecklistDataAccess.NameData.DeleteNameRecord(trans, nameGuid)

    '        trans.Commit()
    '    Catch ex As Exception
    '        If trans IsNot Nothing Then trans.Rollback()
    '        Throw New ChecklistException("Failed to delete name : " + ex.Message)
    '    Finally
    '        If cnn IsNot Nothing Then cnn.Close()
    '    End Try
    'End Sub

    ''' <summary>
    ''' Update Name that have the same basionym to point to the same preferred name 
    ''' This follows the principle that all names with the same basionym should be pointing to the 
    ''' same current name
    ''' </summary>
    ''' <param name="nameGuid"></param>
    ''' <param name="preferredNameGuid"></param>
    ''' <param name="accordingToFk"></param>
    ''' <remarks></remarks>
    Public Shared Sub UpdateNamesWithSameBasionym(ByVal nameGuid As String, ByVal preferredNameGuid As String, ByVal accordingToFk As String)
        Dim names As List(Of Name) = NameData.GetNamesWithSameBasionym(nameGuid)

        For Each nm As Name In names
            If nm.Id <> nameGuid Then
                BrProviderConcepts.InsertUpdateSystemProviderConcept(nm.Id, preferredNameGuid, RelationshipType.RelationshipTypePreferred, accordingToFk)
            End If
        Next

    End Sub

    ''' <summary>
    ''' Get the provider concept for the specified name and accordingTo, for the specified provider
    ''' If the ProviderConcept doesnt exist, then Nothing is returned
    ''' </summary>
    ''' <param name="nameGuid"></param>
    ''' <param name="providerPk"></param>
    ''' <param name="accToFk"></param>
    ''' <returns></returns>
    ''' <remarks></remarks>
    Public Shared Function GetProviderConceptForName(ByVal nameGuid As String, ByVal providerPk As Integer, ByVal accToFk As String)
        Dim pc As ProviderConcept

        Dim accordingTo As String = ""
        If accToFk IsNot Nothing Then accordingTo = accToFk

        Dim conc As Concept
        Dim cs As DataSet = ConceptData.GetNameConceptsDs(nameGuid)
        For Each r As DataRow In cs.Tables(0).Rows
            If r("ConceptName1Fk").ToString = nameGuid And r("ConceptAccordingToFk").ToString = accordingTo Then

                Dim pcs As DataSet = ConceptData.GetProviderConceptRecords(r("ConceptPk"))
                For Each pcr As DataRow In pcs.Tables(0).Rows
                    If pcr("ProviderPk") = providerPk Then
                        pc = New ProviderConcept(pcr, pcr("PCPk").ToString)
                        Exit For
                    End If
                Next

                Exit For

            End If
        Next

        Return pc
    End Function

    Public Shared Sub ProcessAutonymNames()
        Dim msg As String = ""
        Cancel = False

        Try
            Dim prog As Integer = 0

            Dim ds As DsAutonymIssues = NameData.GetNameAutonymIssues()

            msg = "Starting autonym processing"

            If ds IsNot Nothing Then
                Dim total As Integer = ds.MissingAutonyms.Count + ds.UnacceptedAutonyms.Count + ds.NoConceptAutonyms.Count
                Dim count As Integer = 0

                For Each row As DsAutonymIssues.UnacceptedAutonymsRow In ds.UnacceptedAutonyms
                    If Cancel Then Exit For

                    msg = ""
                    'autonym must be the accepted name
                    Try
                        BrProviderConcepts.InsertUpdateSystemProviderConcept(row.NameGuid.ToString(), row.NameGuid.ToString(), RelationshipType.RelationshipTypePreferred, Nothing)

                    Catch ex As Exception
                        msg = "ERROR : Failed to set autonym as accepted name : " + row("NameFull").ToString + " : " + ex.Message
                    End Try

                    count += 1
                    prog = 100 * count / total

                    If msg = "" Then msg = "Processed " + count.ToString + " of " + total.ToString + " names."

                    If StatusCallback IsNot Nothing Then StatusCallback.Invoke(prog, msg)
                Next

                For Each row As DsAutonymIssues.NoConceptAutonymsRow In ds.NoConceptAutonyms
                    If Cancel Then Exit For

                    msg = ""
                    'autonym must point to parent as accepted name
                    Try
                        BrProviderConcepts.InsertUpdateSystemProviderConcept(row.NameGuid.ToString(), row.NameParentFk.ToString(), RelationshipType.RelationshipTypePreferred, Nothing)

                    Catch ex As Exception
                        msg = "ERROR : Failed to set autonym accepted name to parent : " + row("NameFull").ToString + " : " + ex.Message
                    End Try

                    count += 1
                    prog = 100 * count / total

                    If msg = "" Then msg = "Processed " + count.ToString + " of " + total.ToString + " names."

                    If StatusCallback IsNot Nothing Then StatusCallback.Invoke(prog, msg)
                Next

                'reget missing autonyms in case some new ones were added
                ds = NameData.GetNameAutonymIssues()
                total = ds.MissingAutonyms.Count + ds.UnacceptedAutonyms.Count + ds.NoConceptAutonyms.Count

                For Each row As DsAutonymIssues.MissingAutonymsRow In ds.MissingAutonyms
                    'add system autonym name for this name, for each rank where there is a child with that rank
                    msg = ""

                    If Cancel Then Exit For

                    Try

                        Dim ranks As String() = row.Ranks.Split(",")

                        For Each rankId As String In ranks

                            If Cancel Then Exit For

                            If rankId.Length > 0 Then
                                Dim rnk As Rank = RankData.RankByPk(CInt(rankId))

                                Dim pn As New ProviderName
                                pn.PNNameId = Guid.NewGuid.ToString

                                'work out canonical and rank
                                ' should be [Genus] [species (canonical)] [rankname] [canonical]
                                pn.PNNameCanonical = row.NameCanonical
                                pn.PNNameRank = rnk.Name
                                pn.PNLinkStatus = LinkStatus.Inserted.ToString()

                                Dim sysImp As ProviderImport = BrUser.GetSystemProviderImport()
                                pn.PNProviderImportFk = sysImp.IdAsInt

                                NameData.InsertUpdateProviderNameRecord(pn, SessionState.CurrentUser.Login)

                                Dim pn2 As ProviderName = NameData.GetSystemProviderNameForName(row.NameGuid.ToString())
                                If pn2 Is Nothing Then
                                    'create dummy name
                                    pn2 = New ProviderName
                                    pn2.PNNameFk = row.NameGuid.ToString()
                                    pn2.PNNameId = Guid.NewGuid.ToString
                                    pn2.PNLinkStatus = LinkStatus.Inserted.ToString
                                    pn2.PNProviderImportFk = sysImp.IdAsInt

                                    NameData.InsertUpdateProviderNameRecord(pn2, SessionState.CurrentUser.Login)
                                End If

                                'insert parent concept to hook the new autonym name to the name in question
                                Dim sysPc As New ProviderConcept
                                sysPc.PCLinkStatus = LinkStatus.Unmatched.ToString
                                sysPc.PCProviderImportFk = sysImp.IdAsInt
                                sysPc.PCConceptId = Guid.NewGuid.ToString()
                                sysPc.PCName1Id = pn.PNNameId

                                ConceptData.InsertUpdateSystemProviderConcept(Nothing, sysPc, SessionState.CurrentUser.Login)

                                Dim sysPcTo As ProviderConcept = ConceptData.GetSystemProviderConcept(sysImp.IdAsInt, row.NameGuid.ToString(), Nothing)
                                If sysPcTo Is Nothing Then
                                    sysPcTo = New ProviderConcept
                                    sysPcTo.PCLinkStatus = LinkStatus.Unmatched.ToString
                                    sysPcTo.PCProviderImportFk = sysImp.IdAsInt
                                    sysPcTo.PCConceptId = Guid.NewGuid.ToString()
                                    sysPcTo.PCName1Id = pn2.PNNameId

                                    ConceptData.InsertUpdateSystemProviderConcept(Nothing, sysPcTo, SessionState.CurrentUser.Login)
                                End If

                                Dim sysPCR As New ProviderConceptRelationship
                                sysPCR.PCRLinkStatus = LinkStatus.Unmatched.ToString()
                                sysPCR.PCRProviderImportFk = sysImp.IdAsInt
                                sysPCR.PCRConcept1Id = sysPc.PCConceptId
                                sysPCR.PCRConcept2Id = sysPcTo.PCConceptId
                                sysPCR.PCRRelationshipFk = RelationshipType.RelationshipTypeParent

                                sysPCR = ConceptData.InsertUpdateSystemProviderConceptRelationship(Nothing, sysPc.IdAsInt, sysPCR, SessionState.CurrentUser.Login)

                                Dim mr As MatchResult = BrProviderNames.MatchAndUpdateProviderName(pn)
                                Dim cmr As MatchResult = BrProviderConcepts.MatchAndUpdateProviderConceptRelationship(sysPCR)

                                BrNames.RefreshNameData(mr.MatchedId, True)
                                BrNames.RefreshNameData(row.NameGuid.ToString(), False)

                            End If
                        Next

                    Catch ex As Exception
                        msg = "ERROR : Failed to add missing autonym name : " + row("NameFull").ToString + " : " + ex.Message
                    End Try

                    count += 1
                    prog = 100 * count / total

                    If msg = "" Then msg = "Processed " + count.ToString + " of " + total.ToString + " names."

                    If StatusCallback IsNot Nothing Then StatusCallback.Invoke(prog, msg)
                Next
            End If

        Catch ex As Exception
            msg = "ERROR : Process Failed : " + ex.Message
        End Try

        If StatusCallback IsNot Nothing Then StatusCallback.Invoke(100, msg)
    End Sub
End Class
