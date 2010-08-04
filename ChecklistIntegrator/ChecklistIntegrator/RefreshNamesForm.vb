Imports ChecklistBusinessRules

Public Class RefreshNamesForm

    Public NamesList As ArrayList ' of Name

    Private Message As String = ""
    Private Errors As String = ""
    Private Progress As Integer = 0

    Private Sub RefreshNamesForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If NamesList IsNot Nothing Then
            ProgressText.Text = NamesList.Count.ToString + " names to update.  Press Go to start."
            UpdateAllCheck.Visible = False
        End If
    End Sub

    'Go / Cancel button
    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        If CncButton.Text = "Go" Then

            ProgressText.Text = "Getting names to update..."

            Dim t As Threading.Thread = Nothing

            If NamesList IsNot Nothing Then
                t = New Threading.Thread(New Threading.ThreadStart(AddressOf Me.RefreshList))
            Else
                BrNames.StatusCallback = New BrNames.StatusDelegate(AddressOf StatusHandler)
                t = New Threading.Thread(New Threading.ThreadStart(AddressOf Me.RefreshAll))
            End If

            t.Start()
            CncButton.Text = "Cancel"

        ElseIf CncButton.Text = "Cancel" Then
            BrNames.Cancel = True
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

        ElseIf CncButton.Text = "Close" Then
            Me.Close()

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
        Me.Invoke(mi)
    End Sub

    Public Sub RefreshAll()
        BrNames.RefreshAllNames(UpdateAllCheck.Checked)
    End Sub

    Public Sub RefreshList()
        Dim cnt As Integer = NamesList.Count
        Dim index As Integer = 1

        For Each nm As ChecklistObjects.Name In NamesList
            Dim msg As String = ""
            Try
                BrNames.RefreshNameData(nm.Id, False)
            Catch ex As Exception
                msg = "ERROR : " + ex.Message
                ChecklistObjects.ChecklistException.LogError(ex)
            End Try

            StatusHandler(index * 100 / cnt, msg)
            index += 1
        Next
    End Sub

    Public Sub UpdateStatus()
        ProgressBar1.Value = Progress

        Dim msg As String = ""
        If Message.Length > 0 Then msg = Message + Environment.NewLine
        If Errors.Length > 0 Then msg += Errors + Environment.NewLine

        If Progress = 100 Then
            CncButton.Text = "Close"
            msg += "Done."
        End If

        ProgressText.Text = msg
    End Sub

End Class