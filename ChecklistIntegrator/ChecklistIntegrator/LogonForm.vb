Imports ChecklistObjects
Imports ChecklistDataAccess

Public Class LogonForm

    Public TheUser As User

    Private Sub LogonForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Dim users As User() = UserData.GetUsers()
            For Each u As User In users
                UserCombo.Items.Add(u)
            Next

        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub LoginButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LoginButton.Click
        If Not UserCombo.SelectedItem Is Nothing Then
            Try
                If UserData.Login(UserCombo.SelectedItem, PassText.Text) Then
                    TheUser = UserCombo.SelectedItem
                    DialogResult = Windows.Forms.DialogResult.OK
                Else
                    MsgBox("Log on failed")
                End If
            Catch ex As Exception
                MsgBox("Log on failed")
                ChecklistException.LogError(ex)
            End Try
        End If
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        Me.Close()
    End Sub
End Class