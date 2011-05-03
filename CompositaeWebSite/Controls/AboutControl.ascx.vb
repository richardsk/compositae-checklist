
Partial Class Controls_AboutControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Try
            Dim tab As String = Request.QueryString.Get("Tab")
            Dim ctrl As New HtmlGenericControl
            If tab = "Tree" Then
                ctrl.InnerHtml = IO.File.ReadAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "About/Tree.htm"), Text.UTF8Encoding.UTF8)
            ElseIf tab = "Taxonomy" Then
                ctrl.InnerHtml = IO.File.ReadAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "About/Taxonomy.htm"), Text.UTF8Encoding.UTF8)
            ElseIf tab = "Cite" Then
                ctrl.InnerHtml = IO.File.ReadAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "About/How to cite.htm"), Text.UTF8Encoding.UTF8)
            ElseIf tab = "Ack" Then
                ctrl.InnerHtml = IO.File.ReadAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "About/Acknowledgements.htm"), Text.Encoding.UTF8)
            ElseIf tab = "SearchHelp" Then
                ctrl.InnerHtml = IO.File.ReadAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "About/Search Help.htm"), Text.UTF8Encoding.UTF8)
            Else
                ctrl.InnerHtml = IO.File.ReadAllText(IO.Path.Combine(Request.PhysicalApplicationPath, "About/About.htm"), Text.UTF8Encoding.UTF8)
            End If

            aboutPlaceHolder.Controls.Add(ctrl)

        Catch ex As Exception
            WebDataAccess.Utility.LogError(ex)
        End Try
    End Sub
End Class
