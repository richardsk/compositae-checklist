Imports ChecklistObjects
Imports ChecklistDataAccess
Imports ChecklistBusinessRules

Public Class ImportAnnotationForm

    Private Sub closeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles closeButton.Click
        Me.Close()
    End Sub

    Private Sub ImportAnnotationForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Dim users As User() = UserData.GetUsers()
            For Each u As User In users
                UserCombo.Items.Add(u)
            Next

        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub importButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles importButton.Click
        If UserCombo.SelectedItem IsNot Nothing AndAlso FileText.Text.Length > 0 Then
            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            Try
                Dim edits As List(Of AnnotationEdit) = BrAnnotation.ImportAnnotations(UserCombo.SelectedItem, FileText.Text)

                Dim arf As New AnnotationResultsForm
                arf.Edits = edits
                arf.ShowDialog()

            Catch ex As Exception
                ChecklistObjects.ChecklistException.LogError(ex)
            End Try
            Windows.Forms.Cursor.Current = Cursors.Default
        End If
    End Sub

    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        Dim bf As New OpenFileDialog
        bf.InitialDirectory = Application.StartupPath
        bf.Filter = "All files(*.*)|*.*"
        bf.FilterIndex = 0
        bf.Title = "Select file to import"
        If bf.ShowDialog = Windows.Forms.DialogResult.OK Then
            FileText.Text = bf.FileName
        End If
    End Sub
End Class