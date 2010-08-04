Imports System.Xml
Imports System.Xml.Xsl

Imports ChecklistObjects

Public Class XMLImporter
    Inherits BaseImporter

    Public Overrides Sub ImportFile()

        If ImportType.FileType = ImportType.FileTypeXML Then
            Try
                'status message for imoprt file, 2 perc complete = started
                PercentComplete = 2
                PostStatusMessage(PercentComplete, "Importing file " + ProvImport.ProviderImportFileName)

                'load data from xml
                Dim doc As New XmlDocument
                doc.Load(ProvImport.ProviderImportFileName)

                'xslt?
                If Not ImportType.XSLTFile Is Nothing AndAlso ImportType.XSLTFile.Length > 0 Then
                    Dim xslLoc As String = Configuration.ConfigurationManager.AppSettings.Get("ImportXSLTFilesLocation")
                    xslLoc = AppDomain.CurrentDomain.BaseDirectory + "\" + xslLoc
                    Dim transform As New XslCompiledTransform()

                    transform.Load(xslLoc + "\" + ImportType.XSLTFile)

                    Dim ms As New IO.MemoryStream()
                    Dim writer As New XmlTextWriter(ms, Text.UTF8Encoding.UTF8)
                    transform.Transform(doc, writer)

                    'load into doc
                    ms.Position = 0
                    Dim str As String = New IO.StreamReader(ms).ReadToEnd()
                    ms.Position = 0
                    doc = New XmlDocument
                    Dim reader As New XmlTextReader(ms)
                    doc.Load(reader)
                End If

                Dim ds As New DataSet
                Dim dsRdr As New XmlTextReader(New IO.StringReader(doc.OuterXml))
                ds.ReadXml(dsRdr)

                If Cancel Then
                    PercentComplete = 100
                    Success = False
                    PostStatusMessage(PercentComplete, "Cancelled")
                Else
                    'loading takes a portion of the time so now roughly 10 percent complete
                    PercentComplete = 10
                    PostStatusMessage(PercentComplete, "Saving to checklist database")

                    'save to database
                    SaveImportedDataset(ds)
                End If

            Catch ex As Exception
                PostStatusMessage(PercentComplete, "ERROR: " + ex.Message)
                ChecklistException.LogError(ex)
            End Try
        Else
            PercentComplete = 100
            PostStatusMessage(PercentComplete, "ERROR: Incorrect file type for importer")
        End If

    End Sub
End Class
