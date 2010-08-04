Public Class SplitForm

    Public SelectedSplitType As ChecklistObjects.SplitType = ChecklistObjects.SplitType.CreateNew

    Private Sub SplitForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        CreateRadio.Checked = True
    End Sub

    Private Sub OkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OkButton.Click
        If CreateRadio.Checked Then SelectedSplitType = ChecklistObjects.SplitType.CreateNew
        If SelectRadio.Checked Then SelectedSplitType = ChecklistObjects.SplitType.SelectExisting
        If UnlinkRadio.Checked Then SelectedSplitType = ChecklistObjects.SplitType.Unlink
        If DiscardRadio.Checked Then SelectedSplitType = ChecklistObjects.SplitType.Discard

        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        Me.Close()
    End Sub

End Class