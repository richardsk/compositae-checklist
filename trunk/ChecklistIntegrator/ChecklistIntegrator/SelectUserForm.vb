Imports ChecklistObjects
Imports ChecklistDataAccess

Public Class SelectUserForm

    Public SelectedUser As ChecklistObjects.User

    Private Sub LoginButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LoginButton.Click
        SelectedUser = UserCombo.SelectedItem
        If SelectedUser Is Nothing Then
            MsgBox("Select a user first.")
        Else
            Me.DialogResult = Windows.Forms.DialogResult.OK
        End If
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub SelectUserForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Dim users As User() = UserData.GetUsers()
            For Each u As User In users
                UserCombo.Items.Add(u)
            Next

        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub
End Class