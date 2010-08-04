Imports ChecklistDataAccess
Imports ChecklistObjects
Imports ChecklistBusinessRules

Imports System.Data
Imports CrystalDecisions.Shared
Imports CrystalDecisions.ReportSource
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Web

Partial Class Controls_ReportControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            'Dim reportId As String = Request.QueryString("ReportId")
            'Dim download As String = Request.QueryString("Download")
            'Dim nameId As String = Request.QueryString("NameId")

            'If nameId Is Nothing Then 'browsing the tree?
            '    'a bit of a jack so we can keep the previous report details on the screen
            '    Dim reportHtml As String = Session("ReportHtml")
            '    If reportHtml IsNot Nothing Then
            '        PlaceholderLabel.Text = reportHtml
            '    End If
            'Else
            '    Dim id As Integer = Integer.Parse(reportId)

            '    If download IsNot Nothing AndAlso download = "1" Then
            '        DownloadReport(id, nameId)
            '    Else
            '        DisplayReport(id, nameId)
            '    End If
            'End If


        Catch ex As Exception
            DataAccess.Utility.LogError(ex)
        End Try
    End Sub

    Private Sub DownloadReport(ByVal reportId As Integer, ByVal nameId As String)
        'Response.BufferOutput = True
        'Response.Clear()
        'Response.ClearHeaders()
        'Response.ClearContent()

        'Dim objReport As New ReportDocument
        'Dim strReportFileName As String = String.Empty

        'strReportFileName = Hosting.HostingEnvironment.MapPath("~\Reports\CompositaeDownload.rpt")

        'objReport.Load(strReportFileName)

        'Dim rep As ChecklistObjects.Report = ChecklistDataAccess.ReportData.GetReport(reportId)
        'Dim html As String = BrReports.RunNameReport(rep, nameId)

        'objReport.SetParameterValue("ReportHtml", html)

        'Using objMemoryStream As IO.MemoryStream = DirectCast(objReport.ExportToStream(ExportFormatType.PortableDocFormat), IO.MemoryStream)
        '    Response.ContentType = "application/pdf"
        '    Response.AddHeader("Content-Length", objMemoryStream.ToArray.Length.ToString)
        '    Response.AppendHeader("content-disposition", "attachment; filename=Compositae.pdf")
        '    Response.BinaryWrite(objMemoryStream.ToArray())
        '    Response.Flush()
        '    HttpContext.Current.ApplicationInstance.CompleteRequest()
        '    Response.Close()
        '    Response.End()

        '    objMemoryStream.Close()
        'End Using

    End Sub

    Private Sub DisplayReport(ByVal reportId As Integer, ByVal nameId As String)
        'Dim rep As ChecklistObjects.Report = ChecklistDataAccess.ReportData.GetReport(reportId)
        'Dim html As String = BrReports.RunNameReport(rep, nameId)

        'PlaceholderLabel.Text = html

        'Session("ReportHtml") = html
    End Sub

    Public Sub Display()

    End Sub

    Protected Sub genRepButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles genRepButton.Click
        Dim nameId As String = Request.QueryString("NameId")
        Dim names As DataSet = NameData.GetNameDs(Nothing, nameId)

        If childrenCheck.Checked Then
            Dim children As DataSet = NameData.GetChildNames(nameId, True)
            names.Merge(children)
        End If

        If names IsNot Nothing AndAlso names.Tables.Count > 0 AndAlso names.Tables(0).Rows.Count > 0 Then
            Dim doc As String = DataAccess.Report.GetNamesReport(names, conflictCheck.Checked, IncludeDistCheck.Checked)

            Dim fname As String = Guid.NewGuid.ToString + ".rtf"
            IO.File.WriteAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "temp\" + fname), doc)

            Response.Redirect(Request.ApplicationPath + "\temp\" + fname)

        End If
    End Sub
End Class
