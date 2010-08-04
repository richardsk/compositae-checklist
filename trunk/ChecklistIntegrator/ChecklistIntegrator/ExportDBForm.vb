Imports ChecklistObjects
Imports ChecklistDataAccess

Imports System.Net

Public Class ExportDBForm

    Private Sub ExportDBForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Dim dt As DateTime = IntegratorControls.FormSettings.Settings.LastTransferDate
        If dt = DateTime.MinValue Then
            TransferDate.Value = TransferDate.MinDate
            TransferTime.Value = DateTimePicker.MinimumDateTime
        Else
            TransferDate.Value = dt
            TransferTime.Value = dt
        End If

    End Sub

    Private Sub TransferButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TransferButton.Click
        Windows.Forms.Cursor.Current = Cursors.WaitCursor

        Try
            MessagesText.Text = "Retreiving records to transfer..." + Environment.NewLine
            ProgressBar1.Value = 0

            'load
            Dim dt As DateTime = DateTime.MinValue
            If TransferDate.Value <> TransferDate.MinDate Then
                dt = New DateTime(TransferDate.Value.Year, TransferDate.Value.Month, TransferDate.Value.Day, TransferTime.Value.Hour, TransferTime.Value.Minute, TransferTime.Value.Second)
            End If
            Dim ds As DataSet = DataTransferData.GetDataToTransfer(dt)

            Dim fName As String = "export" + DateTime.Now.ToString("yyyyMMdd-hhmm") + ".xml"

            Dim dir As String = AppDomain.CurrentDomain.BaseDirectory + "\" + _
                System.Configuration.ConfigurationManager.AppSettings.Get("ExportDataLocation")
            Dim exportLoc As String = dir + "\" + fName

            If Not IO.Directory.Exists(dir) Then
                IO.Directory.CreateDirectory(dir)
            End If

            Dim xmlWr As New Xml.XmlTextWriter(exportLoc, System.Text.UTF8Encoding.UTF8)
            ds.WriteXml(xmlWr)
            xmlWr.Close()


            '10% through?
            ProgressBar1.Value = 10

            MessagesText.Text += "Transferring data..." + Environment.NewLine


            'transfer
            Dim transferLoc As String = System.Configuration.ConfigurationManager.AppSettings.Get("DataTransferToLocation")
            Dim user As String = System.Configuration.ConfigurationManager.AppSettings.Get("DataTransferFTPUsername")
            Dim pass As String = System.Configuration.ConfigurationManager.AppSettings.Get("DataTransferFTPPassword")
            transferLoc += "\" + fName
            Dim ftp As WebRequest = FtpWebRequest.Create(transferLoc)
            ftp.Credentials = New NetworkCredential(user, pass)
            ftp.Method = WebRequestMethods.Ftp.UploadFile

            Dim str As IO.Stream = ftp.GetRequestStream()

            Dim b As Byte() = IO.File.ReadAllBytes(exportLoc)
            Dim pos As Long = 0
            While pos < b.LongLength
                str.WriteByte(CByte(b.GetValue(pos)))
                pos += 1

                ProgressBar1.Value = CInt(10 + (pos * 90 / b.LongLength))
            End While

            str.Flush()
            str.Close()

            'done
            IntegratorControls.FormSettings.Settings.LastTransferDate = DateTime.Now

            MessagesText.Text += "Completed succesfully" + Environment.NewLine
        Catch ex As Exception
            MsgBox("Failed to transfer DB : " + ex.Message)
            ChecklistException.LogError(ex)
            MessagesText.Text += "Failed." + Environment.NewLine
        End Try

        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click
        Me.Close()
    End Sub
End Class