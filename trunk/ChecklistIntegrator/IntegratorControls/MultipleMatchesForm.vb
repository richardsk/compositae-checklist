Imports ChecklistObjects
Imports ChecklistDataAccess

Public Class MultipleMatchesForm

    Public RecordId As Integer = -1
    Public IntegType As IntegrationProcessor.Integrator.InterationTypeEnum = IntegrationProcessor.Integrator.InterationTypeEnum.Names

    Public MatchedId As String = ""
    Public MatchedDetails As String = ""

    Private RecordDs As DataSet

    Private Sub MultipleMatchesForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If RecordId <> -1 Then
            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            Try
                If IntegType = IntegrationProcessor.Integrator.InterationTypeEnum.Names Then
                    RecordDs = ChecklistDataAccess.NameData.GetProviderNameDs(RecordId)
                ElseIf IntegType = IntegrationProcessor.Integrator.InterationTypeEnum.References Then
                    RecordDs = ChecklistDataAccess.ReferenceData.GetProviderReferenceDs(RecordId)
                End If
                RecordDataGrid.DataSource = RecordDs.Tables(0)
            Catch ex As Exception
                MsgBox("Error loading provider name : " + RecordId.ToString)
                ChecklistObjects.ChecklistException.LogError(ex)
            End Try

            Try
                Dim ds As DataSet
                If IntegType = IntegrationProcessor.Integrator.InterationTypeEnum.Names Then
                    ds = ChecklistDataAccess.NameData.GetMatchingNamesDs(RecordId)
                Else
                    Dim matchRuleSet As Integer = -1
                    Try
                        matchRuleSet = Integer.Parse(Configuration.ConfigurationManager.AppSettings.Get("ReferenceMatchRuleSet"))
                    Catch ex As Exception
                    End Try
                    ds = ChecklistDataAccess.ReferenceData.GetMatchingReferencesDs(RecordId, matchRuleSet)
                End If
                MatchesDataGrid.DataSource = ds.Tables(0)
            Catch ex As Exception
                MsgBox("Error loading matches")
                ChecklistObjects.ChecklistException.LogError(ex)
            End Try
            Windows.Forms.Cursor.Current = Cursors.Default
        End If
    End Sub

    Private Sub SelectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectButton.Click
        If MatchesDataGrid.SelectedRows.Count > 0 Then
            Try
                If IntegType = IntegrationProcessor.Integrator.InterationTypeEnum.Names Then
                    MatchedId = MatchesDataGrid.SelectedRows(0).Cells("NameGUID").Value.ToString
                    MatchedDetails = MatchesDataGrid.SelectedRows(0).Cells("NameFull").Value.ToString

                    Dim pn As New ChecklistObjects.ProviderName(RecordDs.Tables(0).Rows(0), RecordId.ToString, True)
                    ChecklistBusinessRules.BrProviderNames.UpdateProviderNameLink(pn, MatchedId)
                Else
                    MatchedId = MatchesDataGrid.SelectedRows(0).Cells("ReferenceGUID").Value.ToString
                    MatchedDetails = MatchesDataGrid.SelectedRows(0).Cells("ReferenceCitation").Value.ToString

                    Dim pr As New ChecklistObjects.ProviderReference(RecordDs.Tables(0).Rows(0), RecordId.ToString())
                    ChecklistBusinessRules.BrProviderReferences.UpdateProviderReferenceLink(pr, MatchedId)
                End If

                DialogResult = Windows.Forms.DialogResult.OK
            Catch ex As Exception
                MsgBox("Failed to update provider record")
                ChecklistObjects.ChecklistException.LogError(ex)
            End Try
        End If
    End Sub

    Private Sub NewNameButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewNameButton.Click
        Try
            Dim pn As New ChecklistObjects.ProviderName(RecordDs.Tables(0).Rows(0), RecordId.ToString, True)

            Dim n As New Name
            n.Id = Guid.NewGuid.ToString
            n.NameLSID = ChecklistObjects.Name.CreateLSID(n.Id)
            n.NameCanonical = pn.PNNameCanonical
            n.NameRank = pn.PNNameRank
            n.NameRankFk = pn.PNNameRankFk

            'parent
            Dim selForm As New SelectNameForm
            selForm.Title = "Select parent name for the new name"
            If selForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                n.NameParentFk = selForm.SelectedNameId
                n.NameParent = selForm.SelectedNameText
            Else
                Exit Sub
            End If

            'rank
            If n.NameRankFk = -1 Then
                Dim rnkForm As New SelectRankForm
                If rnkForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                    n.NameRankFk = rnkForm.SelectedRank.IdAsInt
                    n.NameRank = rnkForm.SelectedRank.Name
                Else
                    Exit Sub
                End If
            End If

            'canonical
            If n.NameCanonical Is Nothing OrElse n.NameCanonical.Length = 0 Then
                Dim grab As New GrabTextForm
                grab.Title = "Enter canonical for new name"
                If grab.ShowDialog = Windows.Forms.DialogResult.OK Then
                    n.NameCanonical = grab.TextValue
                Else
                    Exit Sub
                End If
            End If

            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            n = NameData.InsertName(n, SessionState.CurrentUser.Login)

            MatchedId = n.Id
            MatchedDetails = n.NameFull

            ChecklistBusinessRules.BrProviderNames.UpdateProviderNameLink(pn, MatchedId)

            ChecklistBusinessRules.BrNames.RefreshNameData(MatchedId, True)

            Windows.Forms.Cursor.Current = Cursors.Default

            DialogResult = Windows.Forms.DialogResult.OK
        Catch ex As Exception
            Windows.Forms.Cursor.Current = Cursors.Default
            ChecklistException.LogError(ex)
            MsgBox("Failed to create name")
        End Try
    End Sub
End Class