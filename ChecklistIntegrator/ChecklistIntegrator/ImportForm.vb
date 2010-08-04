Imports ChecklistObjects

Public Class ImportForm

    Public ImportObjectType As String

    Private Importer As IntegratorImporters.BaseImporter
    Private Progress As Integer = 0
    Private Message As String = ""

    Private Sub ImportForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If Not CloseButton.Enabled Then
            e.Cancel = True
        End If
    End Sub


    Private Sub ImportForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Dim provs As Provider() = ChecklistDataAccess.ProviderData.GetProviders()
            For Each p As Provider In provs
                ProviderCombo.Items.Add(p)
            Next

            DataToImportCombo.Items.Add("All")
            DataToImportCombo.Items.Add(ImportType.ObjectTypeName)
            DataToImportCombo.Items.Add(ImportType.ObjectTypeReference)
            DataToImportCombo.Items.Add(ImportType.ObjectTypeOtherData)
            DataToImportCombo.SelectedIndex = 0

        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try

    End Sub

    Private Sub LoadTypes()
        ImportTypeCombo.Items.Clear()
        Dim impObjType As String = DataToImportCombo.SelectedItem
        Dim its As ImportType() = ChecklistDataAccess.ImportData.GetImportTypes()
        For Each it As ImportType In its
            If impObjType Is Nothing OrElse impObjType = it.ObjectType Then
                ImportTypeCombo.Items.Add(it)
            End If
        Next
    End Sub

    Private Sub CloseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CloseButton.Click
        Me.Close()
    End Sub

    Private Sub AddButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddButton.Click
        Dim pf As New ProviderForm
        pf.AllProviders = ChecklistDataAccess.ProviderData.GetProvidersDs()
        If pf.ShowDialog() = Windows.Forms.DialogResult.OK Then
            Try
                ChecklistDataAccess.ProviderData.InsertUpdateProvider(pf.TheProvider, SessionState.CurrentUser.Login)

                ProviderCombo.Items.Add(pf.TheProvider)
                ProviderCombo.SelectedItem = pf.TheProvider
            Catch ex As Exception
                MsgBox("Failed to create provider")
                ChecklistException.LogError(ex)
            End Try

        End If

    End Sub

    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        Dim imp As ImportType = ImportTypeCombo.SelectedItem

        Dim bf As New OpenFileDialog
        bf.InitialDirectory = Application.StartupPath
        bf.Filter = "All files(*.*)|*.*"
        If Not imp Is Nothing Then bf.Filter = imp.FileType + " files (*." + imp.FileExtension + ")|*." + imp.FileExtension
        bf.FilterIndex = 0
        bf.Title = "Select DB file to import from"
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
            If ImportTypeCombo.SelectedIndex = -1 Or FileText.Text.Length = 0 Or ProviderCombo.SelectedIndex = -1 Then
                MsgBox("Import type, provider and file name must all be specified")
            Else
                'clear
                ProgressBar1.Value = 0
                ProgressBar1.Update()
                MessagesText.Text = ""

                'import
                ImportButton.Text = "Cancel"
                CloseButton.Enabled = False
                AddButton.Enabled = False
                BrowseButton.Enabled = False

                Dim impType As ImportType = ImportTypeCombo.SelectedItem
                
                If impType.FileType = ImportType.FileTypeMDB Then
                    Importer = New IntegratorImporters.MDBImporter
                Else
                    Importer = New IntegratorImporters.XMLImporter
                End If

                Importer.StatusCallback = New IntegratorImporters.BaseImporter.StatusDelegate(AddressOf ImportStatusHandler)

                Importer.ImportType = impType
                Importer.Provider = ProviderCombo.SelectedItem

                Importer.TreatFalseAsNull = IntegratorImporters.BaseImporter.ETreatFalseAsNull.None
                If TreatNullsChecklist.GetItemChecked(0) Then Importer.TreatFalseAsNull = Importer.TreatFalseAsNull Or IntegratorImporters.BaseImporter.ETreatFalseAsNull.NameInvalid
                If TreatNullsChecklist.GetItemChecked(1) Then Importer.TreatFalseAsNull = Importer.TreatFalseAsNull Or IntegratorImporters.BaseImporter.ETreatFalseAsNull.NameIllegitimate
                If TreatNullsChecklist.GetItemChecked(2) Then Importer.TreatFalseAsNull = Importer.TreatFalseAsNull Or IntegratorImporters.BaseImporter.ETreatFalseAsNull.NameMisapplied
                If TreatNullsChecklist.GetItemChecked(3) Then Importer.TreatFalseAsNull = Importer.TreatFalseAsNull Or IntegratorImporters.BaseImporter.ETreatFalseAsNull.NameProParte
                If TreatNullsChecklist.GetItemChecked(4) Then Importer.TreatFalseAsNull = Importer.TreatFalseAsNull Or IntegratorImporters.BaseImporter.ETreatFalseAsNull.NameInCitation

                Dim pi As New ProviderImport
                pi.ProviderImportProviderFk = Importer.Provider.IdAsInt
                pi.ProviderImportDate = DateTime.Now
                pi.ProviderImportStatus = "New" '??
                pi.ProviderImportImportTypeFk = impType.IdAsInt
                pi.ProviderImportFileName = FileText.Text
                pi.ProviderImportNotes = notesText.Text

                Importer.ProvImport = pi

                Dim t As New Threading.Thread(New Threading.ThreadStart(AddressOf Importer.ImportFile))
                t.Start()

            End If
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
            AddButton.Enabled = True
            BrowseButton.Enabled = True
            IntegrationButton.Enabled = True

            Cursor = Cursors.Default

            If Importer.Success Then
                MsgBox("Successfully imported file " + FileText.Text)

                'set def parent name ids
                Dim defParForm As New DefParentsForm
                defParForm.Import = Importer.ProvImport
                defParForm.ShowDialog()
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

    Private Sub IntegrationButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles IntegrationButton.Click
        Dim ipf As New IntegratorControls.IntegrationProcessForm
        ipf.ShowDialog()
    End Sub

    Private Sub DataToImportCombo_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DataToImportCombo.SelectedIndexChanged
        LoadTypes()
    End Sub

    Private Sub Label2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Label2.Click

    End Sub

    Private Sub FileText_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FileText.TextChanged

    End Sub
End Class