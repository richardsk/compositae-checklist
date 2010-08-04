Imports System.Xml
Imports System.Xml.Xsl

Public Class ViewXmlForm

    Public Xml As String = ""
    Public WebHtml As String = ""

    Private Sub ViewXmlForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            displayTypeCombo.SelectedIndex = 0

        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            MsgBox("Failed to display xml")
        End Try
    End Sub

    Private Sub displayTypeCombo_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles displayTypeCombo.SelectedIndexChanged
        Try
            If displayTypeCombo.SelectedIndex = 0 Then
                'xml
                WebBrowser1.Visible = False

                Dim doc As New XmlDocument
                doc.LoadXml(Xml)

                Dim ms As New IO.MemoryStream
                Dim wr As New XmlTextWriter(ms, System.Text.Encoding.UTF8)
                wr.Formatting = Formatting.Indented
                doc.WriteTo(wr)
                wr.Flush()

                ms.Position = 0
                Dim rdr As New IO.StreamReader(ms)
                DisplayText.Text = rdr.ReadToEnd

                rdr.Close()
                wr.Close()
            Else
                'xslt/html
                WebBrowser1.Visible = True

                WebBrowser1.DocumentText = WebHtml
            End If

        Catch ex As Exception
            ChecklistObjects.ChecklistException.LogError(ex)
            MsgBox("Failed to display xml")
        End Try
    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub
End Class