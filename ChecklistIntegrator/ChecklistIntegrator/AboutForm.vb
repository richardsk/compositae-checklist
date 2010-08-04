Public Class AboutForm

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub AboutForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            VersionText.Text = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            VersionText.Text = "1.0"
        End Try
    End Sub
End Class