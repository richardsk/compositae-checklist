Imports System.Xml

Public Class ImportTransformationForm

    Public TransformationName As String = ""
    Public TransformationDescription As String = ""
    Public TransformationXslt As XmlDocument

    Private Sub btnImportTrans_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnImportTrans.Click
        Dim doc As XmlDocument = GetFileXml()
        If doc IsNot Nothing Then
            TransformationXslt = doc

            Dim ms As New IO.MemoryStream
            Dim wr As New XmlTextWriter(ms, System.Text.Encoding.UTF8)
            wr.Formatting = Formatting.Indented
            doc.WriteTo(wr)
            wr.Flush()

            ms.Position = 0
            Dim rdr As New IO.StreamReader(ms)

            xsltText.Text = rdr.ReadToEnd

            wr.Close()
            rdr.Close()
        End If
    End Sub

    Private Sub okButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles okButton.Click
        TransformationName = TransNameText.Text

        If TransformationName.Length = 0 Then
            MsgBox("Transformation must have a name")
            TransNameText.Focus()
            Return
        End If

        TransformationDescription = DescriptionText.Text
        DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub cncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cncButton.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Public Shared Function GetFileXml() As Xml.XmlDocument
        Dim doc As Xml.XmlDocument = Nothing

        Dim ofd As New OpenFileDialog
        If ofd.ShowDialog = DialogResult.OK Then
            Try
                doc = New Xml.XmlDocument
                doc.Load(ofd.FileName)

            Catch ex As Exception
                MsgBox("Failed to load xml from file : " + ex.Message)
                doc = Nothing
            End Try
        End If

        Return doc
    End Function

End Class