Imports ChecklistDataAccess
Imports ChecklistObjects
Imports ChecklistBusinessRules

Public Class Integrator

    Public Enum InterationTypeEnum
        All
        Names
        References
        Concepts
        OtherData
    End Enum

    Public Delegate Sub StatusDelegate(ByVal percComplete As Integer, ByVal msg As String)
    Public Delegate Sub StandardOutputUpdate()

    Public StatusCallback As StatusDelegate
    Public StdOutputCallback As StandardOutputUpdate

    Public Type As InterationTypeEnum = InterationTypeEnum.All
    Public SelProvider As Provider
    Public Results As IntegrationResults
    Public MinRank As Rank
    Public IncludeOtherData As Boolean = False

    Public Success As Boolean = False
    Public Cancel As Boolean = False

    Protected PercentComplete As Integer '0 to 100

    Public ReadOnly Property Complete() As Boolean
        Get
            Return (PercentComplete = 100)
        End Get
    End Property

    Public Sub Reset()
        Cancel = False
        Success = False
        PercentComplete = 0
    End Sub

    ''' <summary>
    ''' Run the integration process for the current unlinked provider names or references
    ''' </summary>
    ''' <remarks>
    ''' Process:
    ''' Set up results table
    ''' Get all names/references that have no Fk to the tblName/tblReference table
    ''' Foreach name/reference
    '''   - if name update the namerankfk
    '''   - get matching names/references
    '''   - if 0 matches then insert new name/reference
    '''   - if 1 match then link to matched name/reference
    '''   - if multiple matches then update ProviderName/Reference status to 'Multiple Matches'
    '''   - add result to results table
    '''   - update progress
    '''   - integration cancelled?
    ''' For each integrated name
    '''   - refresh the name data, update the relationship Fks 
    ''' For each integrated name and ref
    '''   - update concepts for those names/refs
    ''' Finish integration
    ''' </remarks>
    Public Sub RunIntegration()
        Dim recordPosition As Integer = 0
        Try
            PercentComplete = 1 'started

            Results = New IntegrationResults

            NameData.ResetLinkStatuses()

            'Dim names As ProviderName() = NameData.GetUnlinkedProviderNames()
            'Dim refs As ProviderReference() = ReferenceData.GetUnlinkedProviderReferences()
            'Dim concs As ProviderConcept() = ConceptData.GetUnlinkedProviderConcepts()

            Dim provPk As Integer = -1
            If SelProvider IsNot Nothing Then provPk = SelProvider.IdAsInt

            Dim recordCount As Integer = 0

            Dim namesCount As Integer = NameData.GetUnlinkedProviderNamesCount(provPk)
            Dim refsCount As Integer = ReferenceData.GetUnlinkedProviderReferencesCount(provPk)
            Dim concsCount As Integer = ConceptData.GetUnlinkedProviderConceptRelationshipsCount(provPk)
            Dim otherCount As Integer = 0

            If Type = InterationTypeEnum.OtherData Or (Type = InterationTypeEnum.All And IncludeOtherData) Then
                If StdOutputCallback IsNot Nothing Then
                    StdOutputCallback.Invoke()
                End If
                otherCount = OtherData.GetUnlinkedOtherDataCount(provPk)
                recordCount += otherCount
            End If

            If Type = InterationTypeEnum.Names Or Type = InterationTypeEnum.All Then recordCount += namesCount
            If Type = InterationTypeEnum.References Or Type = InterationTypeEnum.All Then recordCount += refsCount
            If Type = InterationTypeEnum.Concepts Or Type = InterationTypeEnum.All Then recordCount += concsCount

            Dim modifiedNames As New List(Of RefreshData)

            Dim done As Boolean = False
            Dim curType As InterationTypeEnum = Type

            curType = Type
            If curType = InterationTypeEnum.All Then curType = InterationTypeEnum.References

            If curType = InterationTypeEnum.References Then
                PostStatusMessage("Integrating References")
                Dim modifiedRefs As New ArrayList

                ReferenceData.InsertReferencesIntegrationOrder(provPk)
                Dim index As Integer = 1
                While index <= refsCount
                    If index Mod 500 = 0 Then
                        GC.Collect()
                    End If

                    Dim pr As ProviderReference = ReferenceData.GetNextUnlinkedProviderReference(index)
                    If Cancel Then
                        PercentComplete = 100
                        Success = False
                        PostStatusMessage("Cancelled")
                        Exit Sub
                    Else
                        recordPosition += 1
                        PercentComplete = 1 + (recordPosition * 94 / recordCount) '5 percent update at end
                        If PercentComplete > 95 Then PercentComplete = 95 ' cant be greater than 95 until DONE
                        Try
                            'match
                            Dim res As MatchResult = BrProviderReferences.MatchAndUpdateProviderReference(pr)

                            If res.Status = LinkStatus.Inserted Then
                                modifiedRefs.Add(res.MatchedId)
                            ElseIf res.Status = LinkStatus.Matched Then
                                modifiedRefs.Add(res.MatchedId)
                            End If

                            Dim linkedTo As String = ""
                            If res.MatchedReference IsNot Nothing Then
                                linkedTo = res.MatchedReference
                            End If
                            Dim cit As String = pr.PRCitation
                            If cit Is Nothing OrElse cit.Length = 0 Then cit = pr.PRFullCitation
                            Results.ResultsTable.AddResultsTableRow(pr.IdAsInt, InterationTypeEnum.References.ToString, cit, pr.PRReferenceFk, linkedTo, pr.PRLinkStatus)

                            PostStatusMessage("") 'just update progress
                        Catch ex As ChecklistException
                            PostStatusMessage(ex.Message)
                            Results.ResultsTable.AddResultsTableRow(pr.IdAsInt, InterationTypeEnum.References.ToString, pr.PRCitation, "", "", ex.Message)

                        Catch ex As Exception
                            Dim msg As String = "ERROR integrating record at position : " + recordPosition.ToString() + " : " + ex.Message + " : " + ex.StackTrace
                            Results.ResultsTable.AddResultsTableRow(pr.IdAsInt, InterationTypeEnum.References.ToString, pr.PRCitation, pr.PRReferenceFk, "", msg)
                            PostStatusMessage(msg)
                            ex.Data.Add("CustomMessage", "Error at record position " + recordPosition.ToString)
                            ChecklistException.LogError(ex)
                        End Try
                    End If

                    index += 1
                End While

                'PostStatusMessage("Updating consensus references (this may take a few minutes)")
                'refresh reference data for integrated refs
                'BrReferences.RefreshReferenceData(modifiedRefs)

                If Type = InterationTypeEnum.All Then curType = InterationTypeEnum.Names
            End If

            If curType = InterationTypeEnum.Names Then
                PostStatusMessage("Integrating Names")

                NameData.InsertNamesIntegrationOrder(provPk)
                Dim index As Integer = 1
                While index <= namesCount
                    If index Mod 500 = 0 Then
                        GC.Collect()
                    End If

                    Dim pn As ProviderName = NameData.GetNextUnlinkedProviderName(index)

                    If MinRank IsNot Nothing Then
                        Dim rnk As Rank = RankData.RankByPk(pn.PNNameRankFk)
                        If rnk.RankSort > MinRank.RankSort Then
                            Exit While
                        End If
                    End If

                    'For Each pn As ProviderName In names
                    If Cancel Then
                        PercentComplete = 100
                        Success = False
                        PostStatusMessage("Cancelled")
                        Exit Sub
                    Else
                        recordPosition += 1
                        PercentComplete = 1 + (recordPosition * 94 / recordCount) '5 percent update at end
                        If PercentComplete > 95 Then PercentComplete = 95 ' cant be greater than 95 until DONE
                        Try
                            'match
                            Dim res As MatchResult = BrProviderNames.MatchAndUpdateProviderName(pn)

                            If res.Status = LinkStatus.Inserted Then
                                modifiedNames.Add(New RefreshData(res.MatchedId, pn.IdAsInt, True))
                            ElseIf res.Status = LinkStatus.Matched Then
                                modifiedNames.Add(New RefreshData(res.MatchedId, pn.IdAsInt, False))
                            End If

                            Dim linkedTo As String = ""
                            If res.MatchedName IsNot Nothing Then linkedTo = res.MatchedName

                            Results.ResultsTable.AddResultsTableRow(pn.IdAsInt, InterationTypeEnum.Names.ToString, pn.PNNameFull, pn.PNNameFk, linkedTo, pn.PNLinkStatus)

                            PostStatusMessage("") 'just update progress
                        Catch ex As ChecklistException
                            PostStatusMessage(ex.Message)
                            Results.ResultsTable.AddResultsTableRow(pn.IdAsInt, InterationTypeEnum.Names.ToString, pn.PNNameFull, "", "", ex.Message)

                        Catch ex As Exception
                            Dim msg As String = "ERROR integrating record at position : " + recordPosition.ToString() + " : " + ex.Message + " : " + ex.StackTrace
                            Results.ResultsTable.AddResultsTableRow(pn.IdAsInt, InterationTypeEnum.Names.ToString, pn.PNNameFull, pn.PNNameFk, "", msg)
                            PostStatusMessage(msg)
                            ex.Data.Add("CustomMessage", "Error at record position " + recordPosition.ToString)
                            ChecklistException.LogError(ex)
                        End Try
                    End If

                    index += 1
                End While

                'PostStatusMessage("Updating consensus names (this may take a few minutes)")
                'refresh name data for integrated names
                'link up the relationships Fks based on first inserted provider name that matches this name
                'BrNames.RefreshNameData(modifiedNames)

                If Type = InterationTypeEnum.All Then curType = InterationTypeEnum.Concepts
            End If

            'done matching, now do concept updates (only if both is selected)
            'this has to be done after name/reference matching so the concepts can be matched according to these links
            If curType = InterationTypeEnum.Concepts Then
                PostStatusMessage("Integrating Concepts")

                ConceptData.InsertConceptsIntegrationOrder(provPk)
                Dim index As Integer = 1
                While index <= concsCount
                    If index Mod 500 = 0 Then
                        GC.Collect()
                    End If

                    Dim pcr As ProviderConceptRelationship
                    Dim details As String = ""
                    Try
                        pcr = ConceptData.GetNextUnlinkedProviderConceptRelationship(index)
                        If pcr Is Nothing Then
                            'no more PCRs - probably because the names for these ones failed to integrate - so jump to end of PCRs
                            index = concsCount
                            PercentComplete = 95 'ending
                            PostStatusMessage("")
                            Exit While
                        End If
                        If Cancel Then
                            PercentComplete = 100
                            Success = False
                            PostStatusMessage("Cancelled")
                            Exit Sub
                        Else
                            recordPosition += 1
                            PercentComplete = 1 + (recordPosition * 94 / recordCount) '5 percent update at end
                            If PercentComplete > 95 Then PercentComplete = 95 ' cant be greater than 95 until DONE

                            details = pcr.PCRConcept1Id + " : " + pcr.PCRRelationship + " : " + pcr.PCRConcept2Id
                            'TODO ? + " : According to - " + Utility.GetDBString(pc.PCAccordingTo).ToString

                            'match
                            Dim res As MatchResult = BrProviderConcepts.MatchAndUpdateProviderConceptRelationship(pcr)
                            If res.MatchedName IsNot Nothing Then
                                modifiedNames.Add(New RefreshData(res.MatchedName, -1, False))
                            End If

                            Dim linkedTo As String = ""
                            If res.MatchedConceptRelationship IsNot Nothing Then linkedTo = res.MatchedConceptRelationship
                            Results.ResultsTable.AddResultsTableRow(pcr.IdAsInt, InterationTypeEnum.Concepts.ToString, details, pcr.PCRConceptRelationshipFk, linkedTo, pcr.PCRLinkStatus)

                            PostStatusMessage("") 'just update progress
                        End If

                    Catch cex As ChecklistException
                        PostStatusMessage(cex.Message)
                        If pcr IsNot Nothing Then
                            Results.ResultsTable.AddResultsTableRow(pcr.IdAsInt, InterationTypeEnum.Concepts.ToString, details, "", "", cex.Message)
                        End If
                    Catch ex As Exception
                        Dim msg As String = "ERROR integrating record at position : " + recordPosition.ToString() + " : " + ex.Message + " : " + ex.StackTrace
                        If pcr IsNot Nothing Then
                            Results.ResultsTable.AddResultsTableRow(pcr.IdAsInt, InterationTypeEnum.Concepts.ToString, details, pcr.PCRConceptRelationshipFk, "", msg)
                        End If
                        PostStatusMessage(msg)
                        ex.Data.Add("CustomMessage", "Error at record position " + recordPosition.ToString)
                        ChecklistException.LogError(ex)
                    End Try

                    index += 1
                End While

                If (Type = InterationTypeEnum.All And IncludeOtherData) Then curType = InterationTypeEnum.OtherData
            End If

            If curType = InterationTypeEnum.OtherData Then
                PostStatusMessage("Integrating Other Data")

                OtherData.InsertOtherDataIntegrationOrder(provPk)
                Dim index As Integer = 1
                While index <= otherCount
                    If index Mod 500 = 0 Then
                        GC.Collect()
                    End If

                    Dim pod As DataRow = Nothing
                    Dim details As String = ""
                    Try
                        pod = OtherData.GetNextUnlinkedOtherData(index) 'gets std output record
                        If pod Is Nothing Then
                            index = otherCount
                            PercentComplete = 95 'ending
                            PostStatusMessage("")
                            Exit While
                        End If
                        If Cancel Then
                            PercentComplete = 100
                            Success = False
                            PostStatusMessage("Cancelled")
                            Exit Sub
                        Else
                            recordPosition += 1
                            PercentComplete = 1 + (recordPosition * 94 / recordCount) '5 percent update at end
                            If PercentComplete > 95 Then PercentComplete = 95 ' cant be greater than 95 until DONE

                            details = pod("PNNameFk").ToString

                            'match
                            Dim res As MatchResult = BrOtherData.UpdateConsensusOtherData(pod("PNNameFk").ToString, CInt(pod("OtherTypeFk")), pod("OtherDataFk").ToString)

                            Dim linkedTo As String = ""
                            If res.MatchedOtherData IsNot Nothing Then linkedTo = res.MatchedOtherData("OtherDataPk").ToString
                            Results.ResultsTable.AddResultsTableRow(pod("PNNameFk"), InterationTypeEnum.OtherData.ToString, details, linkedTo, "<xml...>", res.Status.ToString)

                            PostStatusMessage("") 'just update progress
                        End If


                    Catch cex As ChecklistException
                        PostStatusMessage(cex.Message)
                        If pod IsNot Nothing Then
                            Results.ResultsTable.AddResultsTableRow(pod("PNNameFk").ToString, InterationTypeEnum.OtherData.ToString, details, "", "", cex.Message)
                        End If
                    Catch ex As Exception
                        Dim msg As String = "ERROR integrating record at position : " + recordPosition.ToString() + " : " + ex.Message + " : " + ex.StackTrace
                        If pod IsNot Nothing Then
                            Results.ResultsTable.AddResultsTableRow(pod("PNNameFk").ToString, InterationTypeEnum.OtherData.ToString, details, "", "", msg)
                        End If
                        PostStatusMessage(msg)
                        ex.Data.Add("CustomMessage", "Error at record position " + recordPosition.ToString)
                        ChecklistException.LogError(ex)
                    End Try

                    index += 1
                End While
            End If

            PostStatusMessage("Updating consensus names (this may take a few minutes)")
            'refresh name data for integrated names
            'link up the relationships Fks based on first inserted provider name that matches this name
            BrNames.RefreshNameData(modifiedNames, True)

            'status message for success/failure + perc complete
            PercentComplete = 100
            Success = True
            PostStatusMessage("SUCCESS")
        Catch ex As Exception
            PercentComplete = 100
            Success = False
            PostStatusMessage("FAILED")
            ex.Data.Add("CustomMessage", "Error at record position " + recordPosition.ToString)
            ChecklistException.LogError(ex)
        End Try


    End Sub

    Protected Sub PostStatusMessage(ByVal msg As String)
        If Not StatusCallback Is Nothing Then
            StatusCallback.Invoke(PercentComplete, msg)
        End If
    End Sub



End Class
