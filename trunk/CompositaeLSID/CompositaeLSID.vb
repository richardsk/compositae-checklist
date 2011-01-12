Imports System.IO
Imports System.Xml
Imports System.Xml.Xsl
Imports System.Data
Imports System.Configuration
Imports System.Text

Imports LSIDFramework
Imports LSIDClient
Imports WebDataAccess


Public Class CompositaeLSIDAuthority
    Inherits SimpleResolutionService


    Private Function GetRdf(ByVal lsid As String)
        Dim rdf As String = ""

        If lsid.IndexOf(":names:") <> -1 Then
            rdf = WebDataAccess.DataAccess.GetTICANameRecordTCS(lsid).OuterXml
            'rdf = RDFBuilder.GetNameRdf(lsid)
        ElseIf lsid.IndexOf(":concepts:") <> -1 Then
            'rdf = RDFBuilder.GetConceptRdf(lsid)
        ElseIf lsid.IndexOf(":references:") <> -1 Then
            rdf = WebDataAccess.DataAccess.GetTICAReferenceRecord(lsid).OuterXml
            'rdf = RDFBuilder.GetReferenceRdf(lsid)
        End If

        Return rdf
    End Function

    Public Overrides Function doGetMetadata(ByVal ctx As LSIDFramework.LSIDRequestContext, ByVal acceptedFormats() As String) As LSIDClient.MetadataResponse
        Try
            Dim rdf As String = GetRdf(ctx.Lsid.ToString())

            If rdf.Length > 0 Then
                Dim ms As New MemoryStream

                Dim wr As New StreamWriter(ms)
                wr.WriteLine(rdf)
                wr.Flush()
                ms.Position = 0

                Dim fmt As String = MetadataResponse.RDF_FORMAT

                If ctx.getProtocalHeaders() IsNot Nothing AndAlso ctx.getProtocalHeaders().Item(HTTPConstants.HEADER_ACCEPT) IsNot Nothing AndAlso _
                    ctx.getProtocalHeaders().Item(HTTPConstants.HEADER_ACCEPT).ToString() = HTTPConstants.HTML_CONTENT Then fmt = MetadataResponse.XMI_FORMAT

                Dim resp As New MetadataResponse(New BufferedStream(ms), DateTime.Now.AddDays(30), fmt)

                Return resp
            End If

        Catch ex As Exception
            WebDataAccess.Utility.LogError(ex)
        End Try


        Return Nothing
    End Function

    Protected Overrides Function getServiceName() As String
        Return "GCCLSID"
    End Function

    Protected Overrides Function hasData(ByVal req As LSIDFramework.LSIDRequestContext) As Boolean
        Return False
    End Function

    Protected Overrides Function hasMetadata(ByVal req As LSIDFramework.LSIDRequestContext) As Boolean
        Dim rdf As String = GetRdf(req.Lsid.ToString())
        Return (rdf.Length > 0)
    End Function

    Protected Overrides Sub validate(ByVal req As LSIDFramework.LSIDRequestContext)

    End Sub
    
End Class
