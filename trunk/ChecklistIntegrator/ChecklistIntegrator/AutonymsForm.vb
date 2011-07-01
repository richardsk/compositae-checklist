Imports ChecklistBusinessRules

Public Class AutonymsForm

    Private Message As String = ""
    Private Status As String = ""
    Private Errors As String = ""
    Private Progress As Integer = 0


    Private doMissingAutonyms As Boolean = True
    Private doUnacceptedAutonyms As Boolean = True
    Private doNoConceptAutonyms As Boolean = True


    Private Sub AutonymIssuesForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub

    'Go / Cancel button
    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        If CncButton.Text = "Go" Then

            ProgressText.Text = "Getting autonym issues to process..."

            doMissingAutonyms = missingAutonyms.Checked
            doUnacceptedAutonyms = UnacceptedAutonyms.Checked
            doNoConceptAutonyms = NoConceptAutonyms.Checked

            Dim t As New Threading.Thread(New Threading.ThreadStart(AddressOf Me.ProcessAutonyms))

            BrNames.StatusCallback = New BrNames.StatusDelegate(AddressOf StatusHandler)

            t.Start()
            CncButton.Text = "Cancel"

            missingAutonyms.Enabled = False
            UnacceptedAutonyms.Enabled = False
            NoConceptAutonyms.Enabled = False

        ElseIf CncButton.Text = "Cancel" Then
            BrNames.Cancel = True
            ProgressText.Text += "Cancelling..." + Environment.NewLine

            missingAutonyms.Enabled = True
            UnacceptedAutonyms.Enabled = True
            NoConceptAutonyms.Enabled = True

            Windows.Forms.Cursor.Current = Cursors.WaitCursor

        ElseIf CncButton.Text = "Close" Then
            Me.Close()

        End If

    End Sub

    Public Sub StatusHandler(ByVal perc As Integer, ByVal msg As String)
        Progress = perc

        If msg.StartsWith("ERROR") Then
            Errors += msg + Environment.NewLine
        ElseIf msg.StartsWith("STATUS") Then
            Status = msg.Substring(msg.IndexOf(":") + 1).Trim() + Environment.NewLine
        Else
            Message += msg + Environment.NewLine
        End If

        Dim mi As New MethodInvoker(AddressOf UpdateStatus)
        Me.Invoke(mi)
    End Sub

    Public Sub ProcessAutonyms()
        BrNames.ProcessAutonymIssues(doMissingAutonyms, doNoConceptAutonyms, doUnacceptedAutonyms)
    End Sub

    
    Public Sub UpdateStatus()
        ProgressBar1.Value = Progress

        Dim msg As String = ""
        If Status.Length > 0 Then msg += Status + Environment.NewLine
        If Message.Length > 0 Then msg += Message + Environment.NewLine
        If Errors.Length > 0 Then msg += Errors + Environment.NewLine

        If Progress = 100 Then
            CncButton.Text = "Close"
            msg += "Done."
        End If

        ProgressText.Text = msg
    End Sub

End Class