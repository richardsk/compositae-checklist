Public Class IntegratorResultsForm

    Public Results As ChecklistObjects.IntegrationResults
    Public IntegType As IntegrationProcessor.Integrator.InterationTypeEnum = IntegrationProcessor.Integrator.InterationTypeEnum.All

    Private Sub IntegratorResultsForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Results IsNot Nothing Then
            DataGridView1.DataSource = Results.ResultsTable

            For Each row As DataGridViewRow In DataGridView1.Rows
                If row.Cells("Result").Value.ToString = ChecklistObjects.LinkStatus.Multiple.ToString Then
                    row.Cells("Result").Style.ForeColor = Color.Blue
                    Dim fnt As Font = DataGridView1.Font
                    row.Cells("Result").Style.Font = New Font(fnt.FontFamily, fnt.Size, FontStyle.Underline)
                End If
            Next

        End If
    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub DataGridView1_CellContentClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles DataGridView1.CellContentClick
        If e.RowIndex <> -1 Then
            If DataGridView1.Rows(e.RowIndex).Cells(e.ColumnIndex).Style.Font IsNot Nothing AndAlso _
                DataGridView1.Rows(e.RowIndex).Cells(e.ColumnIndex).Style.Font.Underline Then
                'a link
                Try
                    Dim matchesForm As New MultipleMatchesForm
                    Dim iType As String = DataGridView1.Rows(e.RowIndex).Cells("Type").Value.ToString
                    matchesForm.IntegType = [Enum].Parse(GetType(IntegrationProcessor.Integrator.InterationTypeEnum), iType)
                    matchesForm.RecordId = Integer.Parse(DataGridView1.Rows(e.RowIndex).Cells(0).Value.ToString)
                    If matchesForm.ShowDialog() = Windows.Forms.DialogResult.OK Then
                        'update record in grid
                        Results.ResultsTable(e.RowIndex).Result = ChecklistObjects.LinkStatus.Matched.ToString
                        Results.ResultsTable(e.RowIndex).Linked_To = matchesForm.MatchedId
                        Results.ResultsTable(e.RowIndex).Linked_To_Details = matchesForm.MatchedDetails

                        DataGridView1.Rows(e.RowIndex).Cells(e.ColumnIndex).Style.ForeColor = Color.Black
                        DataGridView1.Rows(e.RowIndex).Cells(e.ColumnIndex).Style.Font = DataGridView1.Font
                    End If
                Catch ex As Exception
                    MsgBox("Error loading multiple matches form")
                    ChecklistObjects.ChecklistException.LogError(ex)
                End Try
            End If
        End If
    End Sub
End Class