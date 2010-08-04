Imports ChecklistBusinessRules
Imports ChecklistDataAccess
Imports ChecklistObjects

Public Class AuthorsForm

    Private results As DataSet
    Private nextId As Integer = -1

    Private Sub SearchButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SearchButton.Click
        Try
            If results.HasChanges Then
                If MsgBox("Save Changes", MsgBoxStyle.YesNo) = MsgBoxResult.Yes Then
                    If Not DoSave() Then Return
                End If
            End If

            results = AuthorData.ListAuthors(searchText.Text, AnywhereCheck.Checked)
            results.AcceptChanges()

            DisplayGrid()
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            MsgBox(ex.Message)
        End Try
    End Sub

    Private Sub DisplayGrid()
        ResultsGrid.DataSource = results
        ResultsGrid.DataMember = results.Tables(0).TableName

        ResultsGrid.Columns("CorrectAuthor").HeaderText = "Correct Author"
    End Sub

    Private Function DoSave() As Boolean
        Try
            BrAuthors.SaveAuthors(results)
            Return True
        Catch ex As Exception
            ChecklistException.LogError(ex)
            MsgBox("Failed to save authors")
        End Try

        Return False
    End Function

    Private Sub SaveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveButton.Click
        If results.HasChanges() Then
            If DoSave() Then
                results.AcceptChanges()
            End If
        End If
    End Sub

    Private Sub saveRefreshButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles saveRefreshButton.Click
        If results.HasChanges() Then
            Cursor.Current = Cursors.WaitCursor
            If DoSave() Then
                'refresh associated names
                For Each row As DataRow In results.GetChanges().Tables(0).Rows
                    Dim names As List(Of Name) = NameData.GetNamesWithAuthor(row("AuthorPk"))

                    For Each n As Name In names
                        BrNames.RefreshNameData(n.Id, False)
                    Next
                Next

                results.AcceptChanges()
            End If
            Cursor.Current = Cursors.Default
        End If
    End Sub

    Private Sub AuthorsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ResultsGrid.AutoGenerateColumns = False

        'default ds
        results = New DataSet
        Dim dt As DataTable = results.Tables.Add("Authors")
        dt.Columns.Add("AuthorPk", GetType(Integer))
        dt.Columns.Add("Abbreviation")
        dt.Columns.Add("Forename")
        dt.Columns.Add("Surname")
        dt.Columns.Add("CorrectAuthor")
        dt.Columns.Add("CorrectAuthorFk", GetType(Integer))

        DisplayGrid()

    End Sub

    Private Sub ResultsGrid_CellContentClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles ResultsGrid.CellContentClick
        If results IsNot Nothing AndAlso e.ColumnIndex = 4 Then
            Dim authSearch As New AuthorSearchForm
            If authSearch.ShowDialog = Windows.Forms.DialogResult.OK Then
                ResultsGrid.Rows(e.RowIndex).Cells("CorrectAuthorFk").Value = authSearch.SelectedAuthorPk

                If authSearch.SelectedAuthorPk = ResultsGrid.Rows(e.RowIndex).Cells("AuthorPk").Value Then
                    ResultsGrid.Rows(e.RowIndex).Cells(4).Value = "<self>"
                Else
                    ResultsGrid.Rows(e.RowIndex).Cells(4).Value = authSearch.SelectedAbbreviation
                End If
            End If
        End If
    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Dim ok As Boolean = True
        If results IsNot Nothing AndAlso results.HasChanges AndAlso _
            MsgBox("Save Changes", MsgBoxStyle.YesNo) = MsgBoxResult.Yes Then
            ok = DoSave()
        End If
        If ok Then DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub


    Private Sub ResultsGrid_CellBeginEdit(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellCancelEventArgs) Handles ResultsGrid.CellBeginEdit
        If e.ColumnIndex = 0 Then
            e.Cancel = True
        Else
            If ResultsGrid.Rows(e.RowIndex).Cells(0).Value Is DBNull.Value Then 'new
                ResultsGrid.Rows(e.RowIndex).Cells(0).Value = nextId
                ResultsGrid.Rows(e.RowIndex).Cells(4).Value = "<self>"
                ResultsGrid.Rows(e.RowIndex).Cells(5).Value = nextId
                nextId -= 1
            Else
                'can only edit correct wuthor for non-new authors
                If ResultsGrid.Rows(e.RowIndex).Cells(0).Value >= 0 AndAlso e.ColumnIndex <> 5 Then
                    e.Cancel = True
                End If
            End If
        End If
    End Sub

    Private Sub ImportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ImportButton.Click
        Dim ofd As New OpenFileDialog
        ofd.InitialDirectory = Application.ExecutablePath
        ofd.Filter = "Access Database (*.mdb)|*.mdb"

        If ofd.ShowDialog = Windows.Forms.DialogResult.OK Then
            Dim imp As New ImportAuthorsForm
            imp.ImportMDBFilename = ofd.FileName
            imp.ShowDialog()
        End If
    End Sub

End Class