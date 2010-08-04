Imports ChecklistBusinessRules

Public Class MoveDiffParentsForm

    Public NamesList As DataSet
    Public ParentNameId As String = ""

    Private Message As String = ""
    Private Errors As String = ""
    Private Progress As Integer = 0
    Private CompId As String = ""

    Private Sub MoveDiffParentsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        Try
            CompId = ChecklistDataAccess.NameData.GetNamesWithRankAndCanonical(ChecklistDataAccess.RankData.RankByName("Family").IdAsInt, "Compositae").Tables(0).Rows(0)("NameGuid").ToString
            If ParentNameId = "" Then
                ParentNameId = CompId
                parentText.Text = "Compositae"
                NamesList = ChecklistDataAccess.NameData.GetNamesWithDiffPrefParent(ParentNameId)
            End If

            If NamesList IsNot Nothing Then
                ProgressText.Text = NamesList.Tables(0).Rows.Count.ToString + " names to move.  Press Go to start."
            End If

        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            MsgBox("Failed to load form")
        End Try

        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    'Go / Cancel button
    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        If CncButton.Text = "Go" Then

            ProgressText.Text = "Getting names to move..."
            browseButton.Enabled = False
            BrNames.Cancel = False

            Dim t As Threading.Thread = New Threading.Thread(New Threading.ThreadStart(AddressOf Me.MoveList))

            t.Start()
            CncButton.Text = "Cancel"

        ElseIf CncButton.Text = "Cancel" Then
            BrNames.Cancel = True
            browseButton.Enabled = True
            CncButton.Text = "Go"

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


    Public Sub MoveList()
        Dim cnt As Integer = NamesList.Tables(0).Rows.Count
        Dim index As Integer = 1

        For Each row As DataRow In NamesList.Tables(0).Rows
            Dim msg As String = ""
            If BrNames.Cancel Then
                StatusHandler(100, "Cancelled")
                Exit For
            End If

            Try
                BrNames.MoveName(row("NameGuid").ToString, row("NewParentFk").ToString)
            Catch ex As Exception
                msg = "ERROR : " + ex.Message
                ChecklistObjects.ChecklistException.LogError(ex)
            End Try

            StatusHandler(index * 100 / cnt, msg)
            index += 1
        Next

        StatusHandler(100, "")
    End Sub

    Public Sub UpdateStatus()
        ProgressBar1.Value = Progress

        Dim msg As String = ""
        If Message.Length > 0 Then msg = Message + Environment.NewLine
        If Errors.Length > 0 Then msg += Errors + Environment.NewLine

        If Progress = 100 Then
            CncButton.Text = "Close"
            browseButton.Enabled = True
            msg += "Done."
        End If

        ProgressText.Text = msg
    End Sub

    Private Sub browseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles browseButton.Click
        Dim selFm As New IntegratorControls.SelectNameForm
        selFm.Title = "Select parent name of names to move"

        If selFm.ShowDialog = Windows.Forms.DialogResult.OK Then

            CncButton.Text = "Go"
            Progress = 0
            ProgressBar1.Value = 0

            ParentNameId = selFm.SelectedNameId
            parentText.Text = selFm.SelectedNameText

            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            NamesList = ChecklistDataAccess.NameData.GetNamesWithDiffPrefParent(ParentNameId)

            ProgressText.Text = NamesList.Tables(0).Rows.Count.ToString + " names to move.  Press Go to start."

            Windows.Forms.Cursor.Current = Cursors.Default

        End If
    End Sub
End Class