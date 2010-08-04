Imports ChecklistObjects
Imports ChecklistDataAccess
Imports ChecklistBusinessRules

Public Class ReportsControl

    Public Event BeforeBrowse(ByVal e As WebBrowserNavigatingEventArgs, ByVal rep As Report)

    Private Sub ReportsControl_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ReportCombo.Items.Clear()
        Dim reps As List(Of Report) = ReportData.ListReports(False)
        For Each r As Report In reps
            ReportCombo.Items.Add(r)
        Next
    End Sub

    Private Sub RunReportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunReportButton.Click
        If ReportCombo.SelectedIndex <> -1 Then
            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            Try
                Dim rep As Report = ReportCombo.SelectedItem
                Dim html As String = BrReports.RunReport(rep)
                ReportBrowser.DocumentText = html
            Catch ex As Exception
                MsgBox("Failed to run report")
                ChecklistException.LogError(ex)
            End Try
            Windows.Forms.Cursor.Current = Cursors.Default
        End If
    End Sub

    Private Sub ReportBrowser_Navigating(ByVal sender As Object, ByVal e As System.Windows.Forms.WebBrowserNavigatingEventArgs) Handles ReportBrowser.Navigating
        RaiseEvent BeforeBrowse(e, ReportCombo.SelectedItem)
    End Sub

End Class
