Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class SelectRankForm

    Public SelectedRank As Rank

    Private Sub SelectRankForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        Dim ranks As Rank() = RankData.GetRanks()
        For Each r As Rank In ranks
            RankCombo.Items.Add(r)
        Next
        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub SelectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectButton.Click
        If RankCombo.SelectedIndex = -1 Then
            MsgBox("No rank selected")
        Else
            SelectedRank = RankCombo.SelectedItem
            DialogResult = Windows.Forms.DialogResult.OK
        End If
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        Me.Close()
    End Sub
End Class