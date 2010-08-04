Imports ChecklistObjects

Public Class UpdateStdOutputForm

    Private Message As String = ""
    Private Errors As String = ""
    Private Progress As Integer = 0
    Private SelProvider As Provider

    Public AutoRun As Boolean = False

    Private Sub UpdateStdOutputForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim allP As New Provider
        allP.Name = "All"
        allP.IdAsInt = -1
        providerCombo.Items.Add(allP)

        Dim ps As Provider() = ChecklistDataAccess.ProviderData.GetProviders()
        For Each p As Provider In ps
            providerCombo.Items.Add(p)
        Next
        providerCombo.SelectedIndex = 0

        If AutoRun Then
            GoButton.Visible = False

            ChecklistBusinessRules.BrOtherData.StatusCallback = New ChecklistBusinessRules.BrOtherData.StatusDelegate(AddressOf StatusHandler)
            Dim t As Threading.Thread = New Threading.Thread(New Threading.ThreadStart(AddressOf Me.UpdateData))

            t.Start()
        End If
    End Sub

    Private Sub UpdateStdOutputForm_FormClosed(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosedEventArgs) Handles Me.FormClosed
        ChecklistBusinessRules.BrOtherData.StatusCallback = Nothing
    End Sub

    'Go / Cancel button
    Private Sub GoButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GoButton.Click
        If GoButton.Text = "Go" Then

            ProgressText.Text = "Getting records to update..."

            ChecklistBusinessRules.BrOtherData.StatusCallback = New ChecklistBusinessRules.BrOtherData.StatusDelegate(AddressOf StatusHandler)
            Dim t As Threading.Thread = New Threading.Thread(New Threading.ThreadStart(AddressOf Me.UpdateData))

            t.Start()
            closeButton.Enabled = False
            GoButton.Text = "Cancel"

        ElseIf GoButton.Text = "Cancel" Then
            ChecklistBusinessRules.BrOtherData.Cancel = True
            Windows.Forms.Cursor.Current = Cursors.WaitCursor
        End If

    End Sub

    Public Sub StatusHandler(ByVal perc As Integer, ByVal msg As String)
        Progress = perc

        If msg.StartsWith("ERROR") Then
            Errors += msg + Environment.NewLine
        Else
            Message = msg
        End If

        Dim mi As New MethodInvoker(AddressOf UpdateStatus)
        Try 'might be disposed
            Me.Invoke(mi)
        Catch ex As Exception
        End Try
    End Sub

    Public Sub UpdateData()
        Dim id As Integer = -1
        If SelProvider IsNot Nothing Then id = SelProvider.IdAsInt

        Dim dt As DataTable = ChecklistDataAccess.OtherData.GetOtherDataForUpdate(id)

        ChecklistBusinessRules.BrOtherData.UpdateOtherDataStandrdOutput(dt)
    End Sub

    Public Sub UpdateStatus()
        ProgressBar1.Value = Progress

        Dim msg As String = ""
        If Message.Length > 0 Then msg = Message + Environment.NewLine
        If Errors.Length > 0 Then msg += Errors + Environment.NewLine

        If Progress = 100 Then
            GoButton.Text = "Go"
            closeButton.Enabled = True
            msg += "Done."
            If AutoRun Then DialogResult = Windows.Forms.DialogResult.OK
        End If

        ProgressText.Text = msg
    End Sub

    Private Sub providerCombo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles providerCombo.SelectedIndexChanged
        If providerCombo.SelectedItem IsNot Nothing Then SelProvider = providerCombo.SelectedItem
    End Sub

    Private Sub closeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles closeButton.Click
        Me.Close()
    End Sub
End Class