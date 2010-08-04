Imports System.Xml
Imports System.Xml.Xsl

Imports ChecklistObjects
Imports ChecklistDataAccess

Public Class BrReports

    ''' <summary>
    ''' Runs the given report and converts to html using the reports xslt file.
    ''' </summary>
    ''' <param name="rep"></param>
    ''' <returns>
    ''' The string of html to display.
    ''' </returns>
    ''' <remarks></remarks>
    Public Shared Function RunReport(ByVal rep As Report) As String
        Dim html As String = "<html>Error</html>"

        Dim ds As DataSet = ReportData.GetReportData(rep)
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then

            Dim doc As New XmlDocument
            doc.LoadXml(ds.GetXml)

            Dim xslLoc As String = Configuration.ConfigurationManager.AppSettings.Get("ReportXSLTFilesLocation")
            xslLoc = AppDomain.CurrentDomain.BaseDirectory + "\" + xslLoc
            Dim transform As New XslCompiledTransform()

            transform.Load(xslLoc + "\" + rep.ReportXSLTFilename)

            Dim ms As New IO.MemoryStream()
            Dim writer As New XmlTextWriter(ms, Text.UTF8Encoding.UTF8)
            transform.Transform(doc, writer)

            ms.Position = 0
            html = New IO.StreamReader(ms).ReadToEnd()
        End If

        Return html
    End Function

    Public Shared Function RunNameReport(ByVal rep As Report, ByVal nameId As String) As String
        Dim html As String = "<html>Error</html>"

        Dim ds As DataSet = ReportData.GetNameReportData(rep, nameId)
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 Then

            Dim doc As New XmlDocument
            doc.LoadXml(ds.GetXml)

            Dim xslLoc As String = Configuration.ConfigurationManager.AppSettings.Get("ReportXSLTFilesLocation")
            xslLoc = AppDomain.CurrentDomain.BaseDirectory + "\" + xslLoc
            Dim transform As New XslCompiledTransform()

            transform.Load(xslLoc + "\" + rep.ReportXSLTFilename)

            Dim ms As New IO.MemoryStream()
            Dim writer As New XmlTextWriter(ms, Text.UTF8Encoding.UTF8)
            transform.Transform(doc, writer)

            ms.Position = 0
            html = New IO.StreamReader(ms).ReadToEnd()
        End If

        Return html
    End Function

    ''' <summary>
    ''' Ignores a report error
    ''' </summary>
    ''' <param name="rep"></param>
    ''' <param name="recordId"></param>
    ''' <remarks>A report error is ignored by adding a record to the tblReportError table and setting the status to Ignore.</remarks>
    Public Shared Sub IgnoreReportError(ByVal rep As Report, ByVal recordId As String, ByVal tableName As String)
        ReportData.InsertReportError(rep, recordId, tableName, Report.ReportStatusIgnoreFk, "")
    End Sub
End Class
