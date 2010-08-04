Imports ChecklistDataAccess
Imports ChecklistObjects


Public Class NameRecords

    Public Event LinkNames()
    Public Event MergeNames()

    Public SelectedMergeNames As DataSet
    Public SelectedProviderNames As DataSet


    Private Sub ProviderNameRecords_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            MaxCombo.Items.Add(10)
            MaxCombo.Items.Add(50)
            MaxCombo.Items.Add(100)
            MaxCombo.Items.Add(200)
            MaxCombo.Items.Add(500)
            MaxCombo.SelectedIndex = 2

        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub


    Private Sub DoSearch()
        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        Try
            Dim names As DataSet = NameData.ListNameRecords(FilterText.Text.Trim, MaxCombo.SelectedItem)

            Dim disp As New DataTable
            'disp.Columns.Add("Selected", GetType(Boolean))
            'For Each col As DataColumn In names.Tables(0).Columns
            '    disp.Columns.Add(col.ColumnName, col.DataType)
            'Next
            disp.Merge(names.Tables(0))
            ResultsGrid.DataSource = disp

            DisplayProviderNames()
        Catch ex As Exception
            MsgBox("Failed to get provider records")
            ChecklistException.LogError(ex)
        End Try
        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub DisplayProviderNames()
        Try
            Dim ds As DataSet
            For Each r As DataGridViewRow In ResultsGrid.Rows
                If r.Cells("NameGuid").Value IsNot DBNull.Value Then
                    If ds Is Nothing Then
                        ds = NameData.GetProviderNameRecords(r.Cells("NameGuid").Value.ToString)
                    Else
                        ds.Merge(NameData.GetProviderNameRecords(r.Cells("NameGuid").Value.ToString))
                    End If
                End If
            Next
            ProvNamesGrid.DataSource = ds
            ProvNamesGrid.DataMember = ds.Tables(0).TableName
        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub ListButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ListButton.Click
        DoSearch()
    End Sub

    Private Sub LinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LinkButton.Click
        Try
            If GetSelectedProviderNames() = 0 Then Return
            RaiseEvent LinkNames()
        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Function GetSelectedNames() As Integer
        Dim count As Integer = 0

        SelectedMergeNames = Nothing

        For Each r As DataGridViewRow In ResultsGrid.Rows
            If r.Cells("Selected").Value IsNot DBNull.Value AndAlso r.Cells("Selected").Value Then
                count += 1

                If SelectedMergeNames Is Nothing Then
                    SelectedMergeNames = NameData.GetNameDs(Nothing, r.Cells("NameGuid").Value.ToString)
                Else
                    SelectedMergeNames.Merge(NameData.GetNameDs(Nothing, r.Cells("NameGuid").Value.ToString))
                End If
            End If
        Next

        Return count
    End Function

    Private Function GetSelectedProviderNames() As Integer
        Dim count As Integer = 0

        SelectedProviderNames = Nothing

        For Each r As DataGridViewRow In ProvNamesGrid.Rows
            If r.Cells("PNSelected").Value IsNot DBNull.Value AndAlso r.Cells("PNSelected").Value Then
                count += 1

                If SelectedProviderNames Is Nothing Then
                    SelectedProviderNames = NameData.GetProviderNameDs(r.Cells("PNPk").Value)
                Else
                    SelectedProviderNames.Merge(NameData.GetProviderNameDs(r.Cells("PNPk").Value))
                End If
            End If
        Next

        Return count
    End Function


    Private Sub ResultsGrid_CellBeginEdit(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellCancelEventArgs) Handles ResultsGrid.CellBeginEdit
        If e.ColumnIndex <> 0 Then e.Cancel = True
    End Sub

    Private Sub MergeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MergeButton.Click
        Try
            Dim count As Integer = GetSelectedNames()
            If count = 0 Then Return

            If MsgBox("Are you sure you want to merge all selected provider names into one consensus name?", MsgBoxStyle.YesNo, "Merge") = MsgBoxResult.Yes Then
                'select consensus name
                RaiseEvent MergeNames()
                DoSearch()
            End If
        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try
    End Sub


    Private Sub ProvNamesGrid_CellBeginEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellCancelEventArgs) Handles ProvNamesGrid.CellBeginEdit
        If e.ColumnIndex <> 0 Then e.Cancel = True
    End Sub
End Class
