Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Xml
Imports System.Xml.Xsl
Imports System.Data

<WebService(Namespace:="http://www.compositae.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class TICAChecklistService
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function GetTICANameRecordTCS(ByVal ticaLSID As String) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim id As String = Utility.GetLSIDObjectVal(ticaLSID)

            Dim ds As DataSet = TICADataAccess.GetNameRecordDs(id)
            doc.LoadXml(ds.GetXml())

            Dim attr As XmlAttribute = doc.CreateAttribute("exportDate")
            attr.Value = DateTime.Now.ToString()
            doc.DocumentElement.Attributes.Append(attr)

            Dim tmp As String = ConfigurationManager.AppSettings.Get("TempDir")

            Dim wr As New XmlTextWriter(tmp + "\name.xml", UTF8Encoding.UTF8)
            wr.Indentation = 4
            wr.Formatting = Formatting.Indented
            doc.WriteContentTo(wr)
            wr.Close()

            Dim xslfile As String = System.Configuration.ConfigurationManager.AppSettings.Get("TCSXSLTFile")
            Dim xslLoc = AppDomain.CurrentDomain.BaseDirectory + "XSLT\" + xslfile
            Dim transform As New XslCompiledTransform()

            transform.Load(xslLoc)

            Dim ms As New IO.MemoryStream()
            Dim writer As New XmlTextWriter(ms, Text.UTF8Encoding.UTF8)
            transform.Transform(doc, writer)

            ms.Position = 0
            Dim xml As String = New IO.StreamReader(ms).ReadToEnd()

            doc.LoadXml(xml)
        Catch cex As ChecklistObjects.ChecklistException
            ChecklistObjects.ChecklistException.LogError(cex)
            doc.LoadXml("<Error>" + cex.Message + "</Error>")
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA record</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetProviderNameTCS(ByVal providerId As Integer, ByVal providerNameId As String) As XmlDocument
        Dim doc As New XmlDocument

        Try

            Dim ds As DataSet = TICADataAccess.GetProviderNameRecordDs(providerId, providerNameId)
            doc.LoadXml(ds.GetXml())

            Dim attr As XmlAttribute = doc.CreateAttribute("exportDate")
            attr.Value = DateTime.Now.ToString()
            doc.DocumentElement.Attributes.Append(attr)

            Dim tmp As String = ConfigurationManager.AppSettings.Get("TempDir")

            Dim wr As New XmlTextWriter(tmp + "\provname.xml", UTF8Encoding.UTF8)
            wr.Indentation = 4
            wr.Formatting = Formatting.Indented
            doc.WriteContentTo(wr)
            wr.Close()

            Dim xslfile As String = System.Configuration.ConfigurationManager.AppSettings.Get("ProviderNameXSLTFile")
            Dim xslLoc = AppDomain.CurrentDomain.BaseDirectory + "XSLT\" + xslfile
            Dim transform As New XslCompiledTransform()

            transform.Load(xslLoc)

            Dim ms As New IO.MemoryStream()
            Dim writer As New XmlTextWriter(ms, Text.UTF8Encoding.UTF8)
            transform.Transform(doc, writer)

            ms.Position = 0
            Dim xml As String = New IO.StreamReader(ms).ReadToEnd()

            doc.LoadXml(xml)
        Catch cex As ChecklistObjects.ChecklistException
            ChecklistObjects.ChecklistException.LogError(cex)
            doc.LoadXml("<Error>" + cex.Message + "</Error>")
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA record</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function ResolveDeprecatedLSID(ByVal oldLSID As String) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim lsid As String = ChecklistDataAccess.DBData.ResolveDeprecatedLSID(oldLSID)
            If lsid Is Nothing OrElse lsid.Length = 0 Then
                doc.LoadXml("<Error>TICA LSID does not exist or has not been deprecated</Error>")
            Else
                doc.LoadXml("<DeprecatedTICALSID><OldLSID>" + oldLSID + "</OldLSID><NewLSID>" + lsid + _
                    "</NewLSID></DeprecatedTICALSID>")
            End If
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error resolving deprecated LSID</Error>")
        End Try

        Return doc
    End Function


    <WebMethod()> _
    Public Function GetTICANameIds(ByVal pageNumber As Integer) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim pageSize As Integer = Integer.Parse(ConfigurationManager.AppSettings("ListIdsPageSize"))
            Dim ds As DataSet = ChecklistDataAccess.NameData.GetNameLSIDs(pageNumber, pageSize)
            ds.DataSetName = "DataSet"
            ds.Tables(0).TableName = "Name"
            doc.LoadXml(ds.GetXml())
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA LSIDs</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetNameRelatedIds(ByVal ticaLSID As String) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim ds As DataSet = ChecklistDataAccess.NameData.GetNameRelatedIds(Utility.GetLSIDObjectVal(ticaLSID))
            ds.DataSetName = "DataSet"
            ds.Tables(0).TableName = "ConcensusName"
            ds.Tables(1).TableName = "ProviderName"
            doc.LoadXml(ds.GetXml())
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA records</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetProviderNameRelatedIds(ByVal providerId As Integer, ByVal providerNameId As String) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim ds As DataSet = ChecklistDataAccess.NameData.GetProviderNameRelatedIds(providerId, providerNameId)
            ds.DataSetName = "DataSet"
            ds.Tables(0).TableName = "ConcensusName"
            ds.Tables(1).TableName = "ProviderName"
            doc.LoadXml(ds.GetXml())
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA records</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetTICAReferenceIds(ByVal pageNumber As Integer) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim pageSize As Integer = Integer.Parse(ConfigurationManager.AppSettings("ListIdsPageSize"))
            Dim ds As DataSet = ChecklistDataAccess.ReferenceData.GetReferenceLSIDs(pageNumber, pageSize)
            ds.DataSetName = "DataSet"
            ds.Tables(0).TableName = "Reference"
            doc.LoadXml(ds.GetXml())
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA LSIDs</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetTICAReferenceRecord(ByVal ticaLSID As String) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim id As String = Utility.GetLSIDObjectVal(ticaLSID)
            Dim ds As DataSet = ChecklistDataAccess.ReferenceData.GetReferenceDs(id)
            ds.DataSetName = "DataSet"
            ds.Tables(0).TableName = "Reference"

            Dim risDs As DataSet = ChecklistDataAccess.ReferenceData.GetReferenceRISByReferenceDs(id)
            risDs.Tables(0).TableName = "RIS"

            ds.Merge(risDs)

            doc.LoadXml(ds.GetXml())
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA record</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetProviders() As XmlDocument
        Dim doc As New XmlDocument

        Try

            Dim ds As DataSet = TICADataAccess.GetProvidersDs()
            doc.LoadXml(ds.GetXml())

            Dim xslfile As String = System.Configuration.ConfigurationManager.AppSettings.Get("ProvidersXSLTFile")
            Dim xslLoc = AppDomain.CurrentDomain.BaseDirectory + "XSLT\" + xslfile
            Dim transform As New XslCompiledTransform()

            transform.Load(xslLoc)

            Dim ms As New IO.MemoryStream()
            Dim writer As New XmlTextWriter(ms, Text.UTF8Encoding.UTF8)
            transform.Transform(doc, writer)

            ms.Position = 0
            Dim xml As String = New IO.StreamReader(ms).ReadToEnd()

            doc.LoadXml(xml)
        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA providers</Error>")
        End Try

        Return doc
    End Function

End Class
