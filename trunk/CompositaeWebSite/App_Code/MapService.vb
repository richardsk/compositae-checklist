Imports System.ServiceModel.Activation
Imports System.Collections.Generic
Imports System.Web.Services
Imports System.Web.Services.Protocols

<WebService()> _
<AspNetCompatibilityRequirements(RequirementsMode:=AspNetCompatibilityRequirementsMode.Allowed)> _
Public Class MapService
    Inherits System.Web.Services.WebService

    <WebMethod()> _
    Public Sub GetDistributionMapUrl(nameGuid As String)
        Dim da As New WebDataAccess.Distribution
        Dim geos As List(Of WebDataAccess.TDWGGeo) = da.GetNameDistributionDescendents(nameGuid)

        Dim url As String = ""

        If geos.Count > 0 Then
            url = da.GetMapUrl(geos)
        End If

        Context.Response.Clear()
        Context.Response.ContentType = "application/json"
        Context.Response.Flush()
        Context.Response.Write("""" + url + """")
    End Sub


End Class
