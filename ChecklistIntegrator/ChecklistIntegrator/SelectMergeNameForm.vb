Imports ChecklistObjects
Imports ChecklistDataAccess
Imports IntegratorControls

Public Class SelectMergeNameForm

    Public Names As DataSet
    Public SelectedNameGuid As String

    Private Sub SelectMergeNameForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Names Is Nothing Then
            DataGridView1.DataSource = Names
            DataGridView1.DataMember = Names.Tables(0).TableName
        End If
    End Sub

    Private Sub NewButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        Dim n As New Name

        'parent
        Dim selForm As New SelectNameForm
        selForm.Title = "Select parent name for the new name"
        If selForm.ShowDialog = Windows.Forms.DialogResult.OK Then
            n.NameParentFk = selForm.SelectedNameId
            n.NameParent = selForm.SelectedNameText
        End If

        'rank
        Dim rnkForm As New SelectRankForm
        If rnkForm.ShowDialog = Windows.Forms.DialogResult.OK Then
            n.NameRankFk = rnkForm.SelectedRank.IdAsInt
            n.NameRank = rnkForm.SelectedRank.Name
        End If

        'canonical
        Dim grab As New GrabTextForm
        grab.Title = "Enter canonical for new name"
        If grab.ShowDialog = Windows.Forms.DialogResult.OK Then
            n.NameCanonical = grab.TextValue
        End If

        NameData.InsertName(n, SessionState.CurrentUser.Login)

        SelectedNameGuid = n.Id
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub SelectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectButton.Click
        If DataGridView1.SelectedRows.Count > 0 Then
            SelectedNameGuid = DataGridView1.CurrentRow.Cells("NameGuid").Value.ToString
            DialogResult = Windows.Forms.DialogResult.OK
        End If
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub
End Class