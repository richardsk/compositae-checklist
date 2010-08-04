
Partial Class Controls_DetailsHelpControl
    Inherits System.Web.UI.UserControl

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim section As String = Request.QueryString("Section")
        If section IsNot Nothing AndAlso section.Length > 0 Then
            'TODO go to relevant section

        End If
    End Sub
End Class
