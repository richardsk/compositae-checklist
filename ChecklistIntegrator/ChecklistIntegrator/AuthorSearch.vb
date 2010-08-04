Imports ChecklistBusinessRules
Imports ChecklistDataAccess

Public Class AuthorSearch

    Public AuthorResults As DataSet

    Private Sub SearchButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        Try

            AuthorResults = AuthorData.ListAuthors(searchText.Text, AnywhereCheck.Checked)
            AuthorResults.Tables(0).Columns(0).AutoIncrement = True
            AuthorResults.AcceptChanges()

            ResultsGrid.DataSource = AuthorResults
            ResultsGrid.DataMember = AuthorResults.Tables(0).TableName

            ResultsGrid.Columns("AuthorPk").ReadOnly = True
            ResultsGrid.Columns("CorrectAuthorFk").HeaderText = "Correct Author"

        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            MsgBox(ex.Message)
        End Try
    End Sub
End Class
