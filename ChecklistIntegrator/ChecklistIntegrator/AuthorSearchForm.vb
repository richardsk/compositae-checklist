Public Class AuthorSearchForm

    Public SelectedAuthorPk As Integer = -1
    Public SelectedAbbreviation As String = ""

    Private Sub SelectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SelectButton.Click
        If AuthorSearch1.AuthorResults IsNot Nothing AndAlso AuthorSearch1.ResultsGrid.SelectedRows.Count > 0 Then
            SelectedAuthorPk = AuthorSearch1.ResultsGrid.SelectedRows(0).Cells("AuthorPk").Value
            SelectedAbbreviation = AuthorSearch1.ResultsGrid.SelectedRows(0).Cells("Abbreviation").Value

            DialogResult = Windows.Forms.DialogResult.OK
        End If
    End Sub

    Private Sub AuthorSearchForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        AcceptButton = AuthorSearch1.SearchButton
    End Sub
End Class