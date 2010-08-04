Imports System.Collections.Specialized
Imports C1.Win.C1FlexGrid

Public Class NameDetailsForm

    Public NameData As DataTable

    Private Sub MergeForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        SetupGrid()

    End Sub

    Private Sub SetupGrid()
        Try
            Dim dt As New DataTable
            dt.Columns.Add("Field")
            dt.Columns.Add("Value")

            For Each col As DataColumn In NameData.Columns
                dt.Rows.Add(New Object() {col.ColumnName, NameData.Rows(0)(col.ColumnName).ToString})
            Next

            DetailsGrid.DataSource = dt

            DetailsGrid.Cols(0).Style.BackColor = Color.WhiteSmoke
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
        End Try

    End Sub

    Private Sub MergeDetailsGrid_BeforeEdit(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles DetailsGrid.BeforeEdit
        If e.Col <> 3 Then e.Cancel = True
    End Sub
End Class