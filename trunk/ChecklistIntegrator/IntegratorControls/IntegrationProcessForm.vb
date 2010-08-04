Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class IntegrationProcessForm

    Private IntegProcessor As New IntegrationProcessor.Integrator
    Private Progress As Integer = 0
    Private Message As String = ""


    Private Sub IntegrationProcessForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If Not CloseButton.Enabled Then
            e.Cancel = True
        End If
    End Sub

    Private Sub IntegrationProcessForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        TypeCombo.SelectedIndex = 0

        Dim allP As New Provider
        allP.Name = "All"
        allP.IdAsInt = -1
        ProviderCombo.Items.Add(allP)

        Dim ps As Provider() = ChecklistDataAccess.ProviderData.GetProviders()
        For Each p As Provider In ps
            ProviderCombo.Items.Add(p)
        Next
        ProviderCombo.SelectedIndex = 0

        Dim allRanks As New Rank
        allRanks.Name = "All ranks"
        rankCombo.Items.Add(allRanks)
        Dim ranks As Rank() = RankData.GetRanks()
        For Each r As Rank In ranks
            If r.RankSort <= 3200 Then 'subgenus and above
                rankCombo.Items.Add(r)
            End If
        Next
        rankCombo.SelectedIndex = 0
    End Sub

    Private Sub RunButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunButton.Click
        RunIntegration()
    End Sub

    Private Sub RunIntegration()
        If RunButton.Text = "Cancel" Then
            IntegProcessor.Cancel = True
            Cursor = Cursors.WaitCursor
            MessagesText.Text += "Cancelling..." + Environment.NewLine
        Else
            'clear
            ProgressBar1.Value = 0
            ProgressBar1.Update()
            MessagesText.Text = "Loading records to integrate" + Environment.NewLine

            'integrate
            RunButton.Text = "Cancel"
            CloseButton.Enabled = False
            ViewRecordsButton.Enabled = False

            IntegProcessor.Reset()

            Dim prov As Provider = ProviderCombo.SelectedItem
            IntegProcessor.SelProvider = prov

            Dim rnk As Rank = rankCombo.SelectedItem
            If rnk.Name <> "All ranks" Then
                IntegProcessor.MinRank = rnk
            End If

            IntegProcessor.StatusCallback = New IntegrationProcessor.Integrator.StatusDelegate(AddressOf IntegratorStatusHandler)
            IntegProcessor.StdOutputCallback = New IntegrationProcessor.Integrator.StandardOutputUpdate(AddressOf UpdateStdOutputRecords)
            IntegProcessor.IncludeOtherData = (inclOtherDataCheck.Enabled AndAlso inclOtherDataCheck.Checked)
            IntegProcessor.Type = [Enum].Parse(GetType(IntegrationProcessor.Integrator.InterationTypeEnum), TypeCombo.Text)

            Dim t As New Threading.Thread(New Threading.ThreadStart(AddressOf IntegProcessor.RunIntegration))
            t.Start()

            'todo - do we need a timer to check the integration process/thread is still running?
            ' at present it relies on a status message when the Integrator is complete
        End If
    End Sub

    Private Sub UpdateStdOutputRecords()
        Dim soFm As New IntegratorControls.UpdateStdOutputForm
        soFm.AutoRun = True
        soFm.ShowDialog()
    End Sub

    Private Sub UpdateStatus()
        ProgressBar1.Value = Progress
        ProgressBar1.Update()
        If Message.Length > 0 Then
            MessagesText.Text += Message + Environment.NewLine
            MessagesText.Update()
        End If

        If IntegProcessor.Complete Then
            RunButton.Text = "Run"
            CloseButton.Enabled = True
            ViewRecordsButton.Enabled = True
            ResultsButton.Enabled = True
            Cursor = Cursors.Default
            If IntegProcessor.Success Then
                If MsgBox("Integration complete.  View Results?", MsgBoxStyle.YesNo) = MsgBoxResult.Yes Then
                    Dim resForm As New IntegratorResultsForm
                    resForm.IntegType = IntegProcessor.Type
                    resForm.Results = IntegProcessor.Results
                    resForm.ShowDialog()
                End If
            Else
                MsgBox("Integration failed.")
            End If
        End If
    End Sub

    Public Sub IntegratorStatusHandler(ByVal perComplete As Integer, ByVal msg As String)
        Progress = perComplete
        Message = msg
        Dim mi As New MethodInvoker(AddressOf UpdateStatus)
        Me.Invoke(mi)
    End Sub

    Private Sub ViewRecordsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ViewRecordsButton.Click
        Try
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Dim recForm As New SourceRecordsForm

            Dim prov As Provider = ProviderCombo.SelectedItem

            If TypeCombo.Text = IntegrationProcessor.Integrator.InterationTypeEnum.Names.ToString _
                Or TypeCombo.Text = IntegrationProcessor.Integrator.InterationTypeEnum.All.ToString Then

                Dim recs As DataSet
                recs = ChecklistDataAccess.NameData.GetUnlinkedProviderNamesDs(prov.IdAsInt)
                recForm.NameRecords = recs.Tables(0)
            End If

            If TypeCombo.Text = IntegrationProcessor.Integrator.InterationTypeEnum.References.ToString _
                Or TypeCombo.Text = IntegrationProcessor.Integrator.InterationTypeEnum.All.ToString Then

                Dim recs As DataSet
                recs = ChecklistDataAccess.ReferenceData.GetUnlinkedProviderReferencesDs(prov.IdAsInt)
                recForm.RefRecords = recs.Tables(0)
            End If

            If TypeCombo.Text = IntegrationProcessor.Integrator.InterationTypeEnum.Concepts.ToString _
            Or TypeCombo.Text = IntegrationProcessor.Integrator.InterationTypeEnum.All.ToString Then
                Dim recs As DataSet = ChecklistDataAccess.ConceptData.GetUnlinkedProviderConceptsDs(prov.IdAsInt)
                recForm.ConceptRecords = recs.Tables(0)
            End If

            If TypeCombo.Text = IntegrationProcessor.Integrator.InterationTypeEnum.OtherData.ToString _
            Or TypeCombo.Text = IntegrationProcessor.Integrator.InterationTypeEnum.All.ToString Then
                Dim recs As DataSet = ChecklistDataAccess.OtherData.GetUnlinkedOtherDataDs(prov.IdAsInt)
                recForm.OtherDataRecords = recs.Tables(0)
            End If

            Windows.Forms.Cursor.Current = Cursors.Default

            recForm.ShowDialog()
        Catch ex As Exception
            MsgBox("Error getting source records : " + ex.Message)
            ChecklistObjects.ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub ErrLogButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ErrLogButton.Click
        Process.Start("eventvwr.exe")
    End Sub

    Private Sub ResultsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResultsButton.Click
        If IntegProcessor.Results IsNot Nothing Then
            Dim resForm As New IntegratorResultsForm
            resForm.IntegType = IntegProcessor.Type
            resForm.Results = IntegProcessor.Results
            resForm.ShowDialog()
        End If
    End Sub

    Private Sub TypeCombo_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TypeCombo.SelectedIndexChanged
        Dim type As IntegrationProcessor.Integrator.InterationTypeEnum = [Enum].Parse(GetType(IntegrationProcessor.Integrator.InterationTypeEnum), TypeCombo.Text)
        If type = IntegrationProcessor.Integrator.InterationTypeEnum.All Then
            inclOtherDataCheck.Enabled = True
        Else
            inclOtherDataCheck.Enabled = False
        End If
    End Sub
End Class