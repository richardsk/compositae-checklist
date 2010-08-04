
Partial Class Controls_FeedbackControl
    Inherits System.Web.UI.UserControl

    Protected Sub submit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles submit.Click

        If Page.IsPostBack Then
            Try
                Dim from As String = emailText.Text
                Dim confAddr As String = confirmEmailText.Text

                If from <> confAddr Then
                    Dim ctrl As New Web.UI.HtmlControls.HtmlGenericControl()
                    ctrl.Style("color") = "red"
                    ctrl.InnerHtml = Global.Resources.Resource.Feedback_Email_Error
                    MsgPanel.Controls.Add(ctrl)
                Else

                    Dim addr As String = ConfigurationManager.AppSettings.Get("FeedbackEmail")
                    If addr Is Nothing OrElse addr.Length = 0 Then addr = "christinaflann@gmail.com"

                    Dim ss As String = ConfigurationManager.AppSettings.Get("SMTPHost")

                    Dim cl As New System.Net.Mail.SmtpClient(ss)

                    Dim myBody As String = "Name: " & nameText.Text & "<br/><br/>"
                    myBody &= "Email: " & from & "<br/><br/>"
                    myBody &= "TICA Member: " & IIf(ticaCheck.Checked, "Yes", "No") & "<br/><br/>"
                    myBody &= "Feedback: "

                    If Request.QueryString.Get("NameId") IsNot Nothing Then
                        Dim n As ChecklistObjects.Name = ChecklistDataAccess.NameData.GetName(Nothing, Request.QueryString.Get("NameId"))
                        myBody &= "RE : " + n.NameFull + "<br/><br/>"
                    End If

                    myBody &= feedbackText.Text & "<br/><br/>"
                    
                    Dim subj As String = Global.Resources.Resource.Feedback_Email_Subject

                    Dim msg As New System.Net.Mail.MailMessage(from, addr, subj, myBody)
                    msg.IsBodyHtml = True

                    cl.Send(msg)

                    msg = New System.Net.Mail.MailMessage(addr, from, subj, Global.Resources.Resource.Feedback_Email_Confirm)
                    msg.IsBodyHtml = True

                    cl.Send(msg)

                    fPanel.Visible = False
                    MsgPanel.Visible = True

                    Dim ctrl As New Web.UI.HtmlControls.HtmlGenericControl()
                    ctrl.InnerHtml = Global.Resources.Resource.Feedback_Done
                    MsgPanel.Controls.Add(ctrl)
                End If

            Catch ex As Exception
                MsgPanel.Visible = True

                Dim ctrl As New Web.UI.HtmlControls.HtmlGenericControl()
                ctrl.Style("color") = "red"
                ctrl.InnerHtml = Global.Resources.Resource.Feedback_Error
                MsgPanel.Controls.Add(ctrl)
            End Try

        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        
    End Sub
End Class
