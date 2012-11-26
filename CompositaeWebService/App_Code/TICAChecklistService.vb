Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Xml
Imports System.Xml.Xsl
Imports System.Data
Imports System.Collections.Generic


<WebService(Namespace:="http://www.compositae.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class TICAChecklistService
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Function GetTICANameRecordTCS(ByVal ticaLSID As String) As XmlDocument
        Return WebDataAccess.DataAccess.GetTICANameRecordTCS(ticaLSID)
    End Function

    <WebMethod()> _
    Public Function GetProviderNameTCS(ByVal providerId As Integer, ByVal providerNameId As String) As XmlDocument
        Return WebDataAccess.DataAccess.GetProviderNameTCS(providerId, providerNameId)
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
            WebDataAccess.Utility.LogError(ex)
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
            WebDataAccess.Utility.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA LSIDs</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetNameRelatedIds(ByVal ticaLSID As String) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim ds As DataSet = ChecklistDataAccess.NameData.GetNameRelatedIds(WebDataAccess.Utility.GetLSIDObjectVal(ticaLSID))
            ds.DataSetName = "DataSet"
            ds.Tables(0).TableName = "ConcensusName"
            ds.Tables(1).TableName = "ProviderName"
            doc.LoadXml(ds.GetXml())
        Catch ex As Exception
            WebDataAccess.Utility.LogError(ex)
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
            WebDataAccess.Utility.LogError(ex)
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
            WebDataAccess.Utility.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA LSIDs</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetTICAReferenceRecord(ByVal ticaLSID As String) As XmlDocument
        Dim doc As New XmlDocument

        Try
            Dim id As String = WebDataAccess.Utility.GetLSIDObjectVal(ticaLSID)
            Dim ds As DataSet = ChecklistDataAccess.ReferenceData.GetReferenceDs(id)
            ds.DataSetName = "DataSet"
            ds.Tables(0).TableName = "Reference"

            Dim risDs As DataSet = ChecklistDataAccess.ReferenceData.GetReferenceRISByReferenceDs(id)
            risDs.Tables(0).TableName = "RIS"

            ds.Merge(risDs)

            doc.LoadXml(ds.GetXml())
        Catch ex As Exception
            WebDataAccess.Utility.LogError(ex)
            doc.LoadXml("<Error>Error retreiving TICA record</Error>")
        End Try

        Return doc
    End Function

    <WebMethod()> _
    Public Function GetProviders() As XmlDocument
        Return WebDataAccess.DataAccess.GetProviders()
    End Function


End Class
