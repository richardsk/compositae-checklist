
Partial Class Controls_MapControl
    Inherits System.Web.UI.UserControl

    Private m_TDWGRegions As String = ""

    Public Property TDWGRegions() As String
        Get
            Return m_TDWGRegions
        End Get
        Set(ByVal value As String)
            m_TDWGRegions = value
        End Set
    End Property

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Try
            Dim dist As New DataAccess.Distribution
            Dim img As New Image
            img.ImageUrl = dist.GetMapUrl()
            img.AlternateText = "Distribution Map Image"
            PlaceHolder1.Controls.Add(img)
        Catch ex As Exception
            Dim html As New HtmlGenericControl()
            html.InnerHtml = "Error creating map"
            PlaceHolder1.Controls.Add(html)
            Diagnostics.EventLog.WriteEntry("Application", ex.Message + " : " + ex.StackTrace)
        End Try

    End Sub

End Class
