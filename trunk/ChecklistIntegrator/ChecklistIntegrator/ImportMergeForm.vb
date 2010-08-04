Public Class ImportMergeForm

    Private Importer As New IntegratorImporters.CSVMergeImporter
    Private Progress As Integer = 0
    Private Message As String = ""

    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        Dim bf As New OpenFileDialog
        bf.InitialDirectory = Application.StartupPath
        bf.Filter = "CSV files(*.csv)|*.csv"
        bf.FilterIndex = 0
        bf.Title = "Select merge file to import from"
        If bf.ShowDialog = Windows.Forms.DialogResult.OK Then
            FileText.Text = bf.FileName
        End If
    End Sub

    Private Sub ImportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ImportButton.Click
        If ImportButton.Text = "Cancel" Then
            Importer.Cancel = True
            Cursor = Cursors.WaitCursor
            MessagesText.Text += "Cancelling..." + Environment.NewLine
        Else
            'clear
            ProgressBar1.Value = 0
            ProgressBar1.Update()
            MessagesText.Text = ""

            'import
            ImportButton.Text = "Cancel"
            CloseButton.Enabled = False
            BrowseButton.Enabled = False

            Importer.StatusCallback = New IntegratorImporters.CSVMergeImporter.StatusDelegate(AddressOf ImportStatusHandler)
            Importer.Filename = FileText.Text

            Dim t As New Threading.Thread(New Threading.ThreadStart(AddressOf Importer.StartImport))
            t.Start()

        End If

    End Sub

    Private Sub UpdateStatus()
        ProgressBar1.Value = Progress
        ProgressBar1.Update()
        If Message.Length > 0 Then
            MessagesText.Text += Message + Environment.NewLine
            MessagesText.Update()
        End If

        If Importer.Complete Then
            ImportButton.Text = "Import"
            CloseButton.Enabled = True
            BrowseButton.Enabled = True
            
            Cursor = Cursors.Default

            If Importer.Success Then
                MsgBox("Successfully imported file " + FileText.Text)
            Else
                MsgBox("Failed to import file " + FileText.Text)
            End If
        End If
    End Sub

    Public Sub ImportStatusHandler(ByVal perComplete As Integer, ByVal msg As String)
        Progress = perComplete
        Message = msg
        Dim mi As New MethodInvoker(AddressOf UpdateStatus)
        Me.Invoke(mi)
    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub
End Class